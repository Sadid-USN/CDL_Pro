import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  static const _keyStorageKey = 'secure_encryption_key';
  static const _firebaseTokenKey = 'firebase_auth_token';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Приватный конструктор
  SecureStorageService._internal();

  /// Глобальная точка доступа
  factory SecureStorageService() => _instance;

  /// Получает или создаёт новый 256-битный ключ и сохраняет его в Keychain/Keystore
  Future<SecretKey> _getOrCreateKey() async {
    final existingKeyBase64 = await _secureStorage.read(key: _keyStorageKey);
    if (existingKeyBase64 != null) {
      final keyBytes = base64Decode(existingKeyBase64);
      return SecretKey(keyBytes);
    }

    final randomKeyData = SecretKeyData.random(length: 32); // 256 бит
    final newKeyBytes = await randomKeyData.extractBytes();
    await _secureStorage.write(
      key: _keyStorageKey,
      value: base64Encode(newKeyBytes),
    );

    return SecretKey(newKeyBytes);
  }

  /// Шифрует строку и возвращает JSON
  Future<String> encrypt(String plainText) async {
    final key = await _getOrCreateKey();
    final algorithm = AesGcm.with256bits();

    final secretBox = await algorithm.encrypt(
      utf8.encode(plainText),
      secretKey: key,
    );

    final encryptedMap = {
      'nonce': base64Encode(secretBox.nonce),
      'cipherText': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    return jsonEncode(encryptedMap);
  }

  /// Дешифрует строку обратно в текст
  Future<String> decrypt(String encryptedJson) async {
    final key = await _getOrCreateKey();
    final algorithm = AesGcm.with256bits();

    final Map<String, dynamic> data = jsonDecode(encryptedJson);
    final nonce = base64Decode(data['nonce']);
    final cipherText = base64Decode(data['cipherText']);
    final mac = Mac(base64Decode(data['mac']));

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final clearBytes = await algorithm.decrypt(secretBox, secretKey: key);

    return utf8.decode(clearBytes);
  }

  /// Сохраняет зашифрованный Firebase ID токен
  Future<void> writeToken(String token) async {
    final encrypted = await encrypt(token);
    await _secureStorage.write(key: _firebaseTokenKey, value: encrypted);
  }

  /// Читает и расшифровывает Firebase ID токен
  Future<String?> readToken() async {
    final encrypted = await _secureStorage.read(key: _firebaseTokenKey);
    if (encrypted == null) return null;
    return await decrypt(encrypted);
  }

  /// Удаляет токен
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _firebaseTokenKey);
  }

  /// Удаляет ключ шифрования
  Future<void> clearKey() async {
    await _secureStorage.delete(key: _keyStorageKey);
  }

  /// Удаляет всё (и токен, и ключ)
  Future<void> clearAll() async {
    await _secureStorage.delete(key: _firebaseTokenKey);
    await _secureStorage.delete(key: _keyStorageKey);
  }
}
