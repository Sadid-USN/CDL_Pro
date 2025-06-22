import 'dart:io';
import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class ProfileBloc extends Bloc<AbstractProfileEvent, ProfileState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore firebaseStore;
  final SecureStorageService _storage;

  ProfileBloc({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    SecureStorageService? storage,
    bool initializeOnCreate = false,
  }) : _auth = auth ?? FirebaseAuth.instance,
       firebaseStore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? SecureStorageService(),
       super(const ProfileState()) {
    on<SignInWithEmailAndPassword>(_signInWithEmailAndPassword);
    on<InitializeProfile>(_initializeProfile);
    on<UpdateProfile>(_updateProfile);
    on<SignUpWithEmailAndPassword>(_signUpWithEmailAndPassword);
    on<SignInWithGoogle>(_signInWithGoogle);
    on<SignInWithAppleEvent>(_signInWithApple);
    on<SignOut>(_signOut);
    on<DeleteAccount>(_deleteAccount);

    if (initializeOnCreate) {
      add(InitializeProfile());
    }
  }

  Future<void> _initializeProfile(
    InitializeProfile event,
    Emitter<ProfileState> emit,
  ) async {
    User? current = _auth.currentUser;

    if (current == null) {
      final savedToken = await _storage.readToken();
      if (savedToken != null) {
        try {
          await _auth.signInWithCustomToken(savedToken);
          current = _auth.currentUser;
        } catch (_) {
          await _storage.deleteToken();
        }
      }
    }

    _auth.authStateChanges().listen((User? user) {
      add(UpdateProfile(user));
    });

    emit(state.copyWith(user: current));
  }

  Future<void> _signInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final token = await cred.user?.getIdToken();
      if (token != null) await _storage.writeToken(token);

      emit(
        state.copyWith(user: cred.user, isLoading: false, errorMessage: null),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseErrorHandler.fromCode(e.code),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
        ),
      );
    }
  }

  Future<void> _signUpWithEmailAndPassword(
    SignUpWithEmailAndPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await firebaseStore.collection('users').doc(cred.user?.uid).set({
        'email': event.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final token = await cred.user?.getIdToken();
      if (token != null) await _storage.writeToken(token);

      emit(
        state.copyWith(user: cred.user, isLoading: false, errorMessage: null),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseErrorHandler.fromCode(e.code),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
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
    final googleSignIn = GoogleSignIn(
      scopes: ['email'],
      // Remove the clientId parameter if you're using the default configuration
      // Only specify clientId if you have a specific iOS client ID to use
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final googleAuth = await googleUser.authentication;
    final cred = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(cred);

    // Handle new user creation
    if (userCred.additionalUserInfo?.isNewUser ?? false) {
      await firebaseStore.collection('users').doc(userCred.user?.uid).set({
        'email': userCred.user?.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    final token = await userCred.user?.getIdToken();
    if (token != null) await _storage.writeToken(token);

    // Explicitly update the user state
    emit(state.copyWith(
      user: userCred.user, 
      isLoading: false,
      errorMessage: null,
    ));
    
    // Add explicit UpdateProfile event
    add(UpdateProfile(userCred.user));
  } on FirebaseAuthException catch (e) {
    emit(
      state.copyWith(
        isLoading: false,
        errorMessage: FirebaseErrorHandler.fromCode(e.code),
      ),
    );
  } catch (e) {
    debugPrint('Google Sign-In Error: $e');
    emit(
      state.copyWith(
        isLoading: false,
        errorMessage: FirebaseAuthErrorType.unknown,
      ),
    );
  }
}
  Future<void> _signInWithApple(
    SignInWithAppleEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (!Platform.isIOS) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: FirebaseAuthErrorType.unknown,
          ),
        );
        return;
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      if (appleCredential.identityToken == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: FirebaseAuthErrorType.unknown,
          ),
        );
        return;
      }

      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: appleCredential.identityToken);

      final userCred = await _auth.signInWithCredential(oauthCredential);

      if (userCred.additionalUserInfo?.isNewUser ?? false) {
        await firebaseStore.collection('users').doc(userCred.user?.uid).set({
          'email': userCred.user?.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final token = await userCred.user?.getIdToken();
      if (token != null) await _storage.writeToken(token);

      emit(state.copyWith(user: userCred.user, isLoading: false));
    } on SignInWithAppleAuthorizationException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
              e.code == AuthorizationErrorCode.canceled
                  ? null
                  : FirebaseAuthErrorType.unknown,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
        ),
      );
    }
  }

Future<void> _updateProfile(
  UpdateProfile event,
  Emitter<ProfileState> emit,
) async {
  emit(state.copyWith(
    user: event.user,
    isLoading: false,
  ));
}
 Future<void> _signOut(SignOut event, Emitter<ProfileState> emit) async {
  emit(state.copyWith(isLoading: true));
  
  try {
    await _auth.signOut();
    await _storage.deleteToken();
    
    // Явно устанавливаем user в null
    emit(ProfileState(
      user: null,
      isLoading: false,
      errorMessage: null,
      isNewUser: false,
    ));
    
    // Добавляем явный вызов UpdateProfile(null)
    add(UpdateProfile(null));
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      errorMessage: FirebaseAuthErrorType.unknown,
    ));
  }
}
  Future<void> _deleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await firebaseStore.collection('users').doc(user.uid).delete();
        await user.delete();
        await _storage.deleteToken();
        emit(state.copyWith(
          lastEvent: event,
          user: null, 
          isLoading: false));
      }
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
