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

  // В методе _signInWithEmailAndPassword измените обработку ошибок:
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
        ),
      );
    } on FirebaseAuthException catch (e) {
      final errorType = FirebaseErrorHandler.fromCode(e.code);
      final errorMessage = FirebaseErrorHandler.getErrorKey(errorType);
      print("USER NOT FOUND ----->>>> ${e.code}");
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
          isNewUser: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: LocaleKeys.loginError.tr(),
          isNewUser: false,
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
      add(UpdateProfile(user)); // ✅ Просто отправляем, даже если user == null
    });

    emit(state.copyWith(user: _auth.currentUser));
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(user: event.user, isLoading: false));
  }

  Future<void> _signOut(SignOut event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _auth.signOut();
      emit(state.copyWith(user: null, isLoading: false, errorMessage: null));
    } catch (_) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Logout failed'));
    }
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

      // Сохраняем данные пользователя в Firestore
      await firebaseStore.collection('users').doc(userCredential.user?.uid).set(
        {'email': event.email, 'createdAt': FieldValue.serverTimestamp()},
      );

      emit(
        state.copyWith(
          user: userCredential.user,
          isLoading: false,
          isNewUser: true, // Явно указываем, что это новый пользователь
        ),
      );
    } on FirebaseAuthException catch (e) {
      final isEmailInUse = e.code == 'email-already-in-use';
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message ?? 'Sign up failed',
          isNewUser: !isEmailInUse,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'An unexpected error occurred',
          isNewUser: true,
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

      // Save user data to Firestore if new user
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
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message ?? 'Google sign in failed',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'An unexpected error occurred',
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

        // Save user data to Firestore if new user
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
            errorMessage: 'Apple sign in is only available on iOS',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message ?? 'Apple sign in failed',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'An unexpected error occurred',
        ),
      );
    }
  }
}
