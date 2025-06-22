// lib/data/repositories/user_repository_impl.dart
import 'package:cdl_pro/domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl implements AbstractUserRepo {
  final FirebaseAuth _auth;
  
  UserRepositoryImpl(this._auth);
  
  @override
  String? get currentUid => _auth.currentUser?.uid;
}