import 'dart:io';
import 'package:cdl_pro/core/errors/error.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ProfileBloc extends Bloc<AbstractProfileEvent, ProfileState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore firebaseStore;
  final SecureStorageService _storage;
  late SharedPreferences prefs;

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

    if (initializeOnCreate) {
      add(InitializeProfile()); // 👈 вызывается автоматически
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              INITIALIZATION                                */
  /* -------------------------------------------------------------------------- */

  Future<void> _initializeProfile(
    InitializeProfile event,
    Emitter<ProfileState> emit,
  ) async {
    prefs = await SharedPreferences.getInstance();

    // 1. Пытаемся восстановить пользователя из Firebase SDK
    User? current = _auth.currentUser;

    // 2. Если пользователя нет, читаем сохранённый токен и пробуем залогиниться
    if (current == null) {
      final savedToken = await _storage.readToken();
      if (savedToken != null) {
        try {
          // Custom-token flow: ID-токен сюда не подойдёт, но демонстрация логики:
          await _auth.signInWithCustomToken(savedToken);
          current = _auth.currentUser; // после успешного входа
        } catch (_) {
          await _storage.deleteToken(); // токен битый → чистим
        }
      }
    }

    // 3. Подписываемся на любые изменения профиля
    _auth.authStateChanges().listen((User? user) {
      add(UpdateProfile(user));
    });

    emit(state.copyWith(user: current));
  }

  /* -------------------------------------------------------------------------- */
  /*                           EMAIL / PASSWORD LOGIN                           */
  /* -------------------------------------------------------------------------- */

  Future<void> _signInWithEmailAndPassword(
    SignInWithEmailAndPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Сохраняем токен — он понадобится при следующем запуске
      final token = await cred.user?.getIdToken();
      if (token != null) await _storage.writeToken(token); // NEW

      emit(
        state.copyWith(
          user: cred.user,
          isLoading: false,
          isNewUser: false,
          errorMessage: null,
          lastEvent: event,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseErrorHandler.fromCode(e.code),
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

  /* -------------------------------------------------------------------------- */
  /*                               REGISTRATION                                 */
  /* -------------------------------------------------------------------------- */

  Future<void> _signUpWithEmailAndPassword(
    SignUpWithEmailAndPassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isNewUser: true));

    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await firebaseStore.collection('users').doc(cred.user?.uid).set({
        'email': event.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final token = await cred.user?.getIdToken();
      if (token != null) await _storage.writeToken(token); // NEW

      emit(
        state.copyWith(
          user: cred.user,
          isLoading: false,
          errorMessage: null,
          isNewUser: true,
          lastEvent: event,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseErrorHandler.fromCode(e.code),
          isNewUser: e.code != 'email-already-in-use',
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

  /* -------------------------------------------------------------------------- */
  /*                                 GOOGLE                                     */
  /* -------------------------------------------------------------------------- */

  Future<void> _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      GoogleSignIn googleSignIn;

      if (Platform.isIOS) {
        // ✅ Только для iOS указываем clientId и scopes
        googleSignIn = GoogleSignIn(
          scopes: ['email'],
          clientId:
              '899513564439-m718et85g2avme8nhkbmih5isgllc6tv.apps.googleusercontent.com',
        );
      } else {
        // ✅ На Android — просто без параметров
        googleSignIn = GoogleSignIn();
      }

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCred = await _auth.signInWithCredential(cred);

      if (userCred.additionalUserInfo?.isNewUser ?? false) {
        await firebaseStore.collection('users').doc(userCred.user?.uid).set({
          'email': userCred.user?.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final token = await userCred.user?.getIdToken();
      if (token != null) await _storage.writeToken(token);

      emit(state.copyWith(user: userCred.user, isLoading: false));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseErrorHandler.fromCode(e.code),
        ),
      );
    } catch (e) {
      print('[Google Sign-In] Ошибка: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
        ),
      );
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                   APPLE                                    */
  /* -------------------------------------------------------------------------- */

  Future<void> _signInWithApple(
    SignInWithAppleEvent event,
    Emitter<ProfileState> emit,
  ) async {
    print('[Apple Sign-In] Событие получено в методе');

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      if (!Platform.isIOS) {
        print('[Apple Sign-In] Не iOS — выход');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: FirebaseAuthErrorType.unknown,
          ),
        );
        return;
      }

      print('[Apple Sign-In] Запрашиваем getAppleIDCredential...');
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('[Apple Sign-In] ✅ Credential получен:');
      print(' - identityToken: ${appleCredential.identityToken}');
      print(' - authorizationCode: ${appleCredential.authorizationCode}');

      // ❗ Проверка на null — если токены не получены, выходим
      if (appleCredential.identityToken == null ||
          appleCredential.authorizationCode == null) {
        print('[Apple Sign-In] ❌ Токены не получены, выход');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: FirebaseAuthErrorType.unknown,
          ),
        );
        return;
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCred = await _auth.signInWithCredential(oauthCredential);
      print('[Apple Sign-In] ✅ Firebase логин прошёл');

      if (userCred.additionalUserInfo?.isNewUser ?? false) {
        await firebaseStore.collection('users').doc(userCred.user?.uid).set({
          'email': userCred.user?.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final token = await userCred.user?.getIdToken();
      if (token != null) await _storage.writeToken(token);

      emit(state.copyWith(user: userCred.user, isLoading: false));
      print('[Apple Sign-In] ✅ Вход завершён успешно');
    } on SignInWithAppleAuthorizationException catch (e) {
      print('[Apple Sign-In] AppleAuthException: ${e.code}');
      if (e.code == AuthorizationErrorCode.canceled) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: FirebaseAuthErrorType.unknown,
          ),
        );
      }
    } catch (e, s) {
      print('[Apple Sign-In] ❌ НЕИЗВЕСТНАЯ ОШИБКА: $e\n$s');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: FirebaseAuthErrorType.unknown,
        ),
      );
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                   UPDATE                                   */
  /* -------------------------------------------------------------------------- */

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(user: event.user, isLoading: false));
  }

  /* -------------------------------------------------------------------------- */
  /*                                   LOGOUT                                   */
  /* -------------------------------------------------------------------------- */

  Future<void> _signOut(SignOut event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _auth.signOut();
      await _storage.deleteToken(); // NEW
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
