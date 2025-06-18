import 'dart:io';
import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<AbstractProfileEvent, ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
  late SharedPreferences prefs;

  ProfileBloc() : super(const ProfileState()) {
    on<SignInWithEmailAndPassword>(_signInWithEmailAndPassword);
    on<InitializeProfile>(_initializeProfile);
    on<UpdateProfile>(_updateProfile);
    on<SignUpWithEmailAndPassword>(_signUpWithEmailAndPassword);
    on<SignInWithGoogle>(_signInWithGoogle);
    on<SignInWithApple>(_signInWithApple);
    on<SignOut>(_signOut);
  }

  Future<void> _signInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

      emit(
        state.copyWith(
          user: userCredential.user,
          isLoading: false,
          isNewUser: false,
          errorMessage: null,
          lastEvent: event,
        ),
      );
    } on FirebaseAuthException catch (e) {
      final errorType = FirebaseErrorHandler.fromCode(e.code);
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: errorType,
          isNewUser: false,
          lastEvent: event,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
          isNewUser: false,
          lastEvent: event,
        ),
      );
    }
  }

  Future<void> _initializeProfile(
    InitializeProfile event,
    Emitter<ProfileState> emit,
  ) async {
    prefs = await SharedPreferences.getInstance();

    _auth.authStateChanges().listen((User? user) {
      add(UpdateProfile(user));
    });

    emit(state.copyWith(user: _auth.currentUser));
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(user: event.user, isLoading: false));
  }

  Future<void> _signUpWithEmailAndPassword(
    SignUpWithEmailAndPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isNewUser: true));

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

      await firebaseStore.collection('users').doc(userCredential.user?.uid).set(
        {'email': event.email, 'createdAt': FieldValue.serverTimestamp()},
      );

      emit(
        state.copyWith(
          user: userCredential.user,
          isLoading: false,
          errorMessage: null,
          isNewUser: true,
          lastEvent: event,
        ),
      );
    } on FirebaseAuthException catch (e) {
      final errorType = FirebaseErrorHandler.fromCode(e.code);
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: errorType,
          isNewUser: errorType != FirebaseAuthErrorType.emailAlreadyInUse,
          lastEvent: event,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
          isNewUser: true,
          lastEvent: event,
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await firebaseStore
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
              'email': userCredential.user?.email,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      emit(state.copyWith(user: userCredential.user, isLoading: false));
    } on FirebaseAuthException catch (e) {
      final errorType = FirebaseErrorHandler.fromCode(e.code);
      emit(state.copyWith(isLoading: false, errorMessage: errorType));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
        ),
      );
    }
  }

  Future<void> _signInWithApple(
    SignInWithApple event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final appleProvider = AppleAuthProvider();
      if (Platform.isIOS) {
        final UserCredential userCredential = await _auth.signInWithProvider(
          appleProvider,
        );

        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await firebaseStore
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
                'email': userCredential.user?.email,
                'createdAt': FieldValue.serverTimestamp(),
              });
        }

        emit(state.copyWith(user: userCredential.user, isLoading: false));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                FirebaseAuthErrorType
                    .unknown, // можно сделать свой enum AppleNotAvailable
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      final errorType = FirebaseErrorHandler.fromCode(e.code);
      emit(state.copyWith(isLoading: false, errorMessage: errorType));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
        ),
      );
    }
  }

  Future<void> _signOut(SignOut event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _auth.signOut();
      emit(state.copyWith(user: null, isLoading: false, errorMessage: null));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
        ),
      );
    }
  }
}
