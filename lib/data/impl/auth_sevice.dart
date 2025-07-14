import 'dart:io';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final SecureStorageService _storage;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    SecureStorageService? storage,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? SecureStorageService();

  Future<User?> initializeUser() async {
    User? current = _auth.currentUser;
    if (current != null) return current;

    final savedToken = await _storage.readToken();
    if (savedToken != null) {
      try {
        await _auth.signInWithCustomToken(savedToken);
        return _auth.currentUser;
      } catch (_) {
        await _storage.deleteToken();
      }
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    late GoogleSignInAccount googleUser;
    try {
      googleUser = await googleSignIn.authenticate();
    } on Exception catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) return null;

    final cred = GoogleAuthProvider.credential(idToken: idToken);
    final userCred = await _auth.signInWithCredential(cred);

    await _handleNewUser(userCred);

    final token = await userCred.user?.getIdToken();
    if (token != null) await _storage.writeToken(token);

    return userCred.user;
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final token = await cred.user?.getIdToken();
    if (token != null) await _storage.writeToken(token);

    return cred.user;
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _handleNewUser(cred);

    final token = await cred.user?.getIdToken();
    if (token != null) await _storage.writeToken(token);

    return cred.user;
  }

  Future<User?> signInWithApple() async {
    if (!Platform.isIOS) throw Exception('Apple Sign-In is only for iOS');

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email],
    );

    final oauthCredential = OAuthProvider(
      'apple.com',
    ).credential(idToken: appleCredential.identityToken);

    final userCred = await _auth.signInWithCredential(oauthCredential);
    await _handleNewUser(userCred);

    final token = await userCred.user?.getIdToken();
    if (token != null) await _storage.writeToken(token);

    return userCred.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _storage.deleteToken();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      await _storage.deleteToken();
    }
  }

  Future<void> _handleNewUser(UserCredential cred) async {
    if (cred.additionalUserInfo?.isNewUser ?? false) {
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'email': cred.user!.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
