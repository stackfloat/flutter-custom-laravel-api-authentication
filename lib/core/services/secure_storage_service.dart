import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ISecureStorageService {
  Future<void> init();
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clearAll();

  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> deleteAccessToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();

  Future<void> saveUser(String userJson);
  Future<String?> getUser();
  Future<void> deleteUser();

  Future<void> saveFcmToken(String token);
  Future<String?> getFcmToken();
  Future<void> deleteFcmToken();
}

class SecureStorageService implements ISecureStorageService {
  static const _logTag = 'SecureStorage';

  // ✅ Centralized keys
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kUser = 'user';
  static const _kFcmToken = 'fcm_token';
  static const _kFirstRun = 'is_first_run';

  final FlutterSecureStorage _storage;
  bool _initialized = false;

  SecureStorageService(this._storage);

  /// ✅ Factory for production use
  factory SecureStorageService.create() {
    return SecureStorageService(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      ),
    );
  }

  /// ✅ Call at app startup
  @override
  Future<void> init() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool(_kFirstRun) ?? true;

    if (isFirstRun) {
      _log('First run detected, clearing secure storage.');
      await _safeClear();
      await prefs.setBool(_kFirstRun, false);
    }

    _initialized = true;
  }

  // ---------------------------------------------------------------------------
  // Core Safe Operations
  // ---------------------------------------------------------------------------

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException catch (e) {
      if (_isBadDecrypt(e)) {
        _log('BAD_DECRYPT for key: $key. Deleting corrupted key.');
        await _safeDelete(key);
      } else {
        _logError('PlatformException during read for $key', e);
      }
      return null;
    } catch (e, s) {
      _logError('Unknown error during read for $key', e, s);
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, s) {
      _logError('Write failed for key $key', e, s);
      rethrow;
    }
  }

  @override
  Future<void> delete(String key) async {
    await _safeDelete(key);
  }

  @override
  Future<void> clearAll() async {
    await _safeClear();
  }

  // ---------------------------------------------------------------------------
  // Token Management
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveAccessToken(String token) async {
    await write(_kAccessToken, token);
  }

  @override
  Future<String?> getAccessToken() async {
    return read(_kAccessToken);
  }

  @override
  Future<void> deleteAccessToken() async {
    await delete(_kAccessToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await write(_kRefreshToken, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return read(_kRefreshToken);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await delete(_kRefreshToken);
  }

  // ---------------------------------------------------------------------------
  // User
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveUser(String userJson) async {
    await write(_kUser, userJson);
  }

  @override
  Future<String?> getUser() async {
    return read(_kUser);
  }

  @override
  Future<void> deleteUser() async {
    await delete(_kUser);
  }

  // ---------------------------------------------------------------------------
  // FCM Token
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveFcmToken(String token) async {
    await write(_kFcmToken, token);
  }

  @override
  Future<String?> getFcmToken() async {
    return read(_kFcmToken);
  }

  @override
  Future<void> deleteFcmToken() async {
    await delete(_kFcmToken);
  }

  // ---------------------------------------------------------------------------
  // Internal Helpers
  // ---------------------------------------------------------------------------

  bool _isBadDecrypt(PlatformException e) {
    return e.message?.toUpperCase().contains('BAD_DECRYPT') == true;
  }

  Future<void> _safeDelete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, s) {
      _logError('Delete failed for key $key', e, s);
    }
  }

  Future<void> _safeClear() async {
    try {
      await _storage.deleteAll();
    } catch (e, s) {
      _logError('DeleteAll failed', e, s);
    }
  }

  void _log(String message) {
    log(message, name: _logTag);
  }

  void _logError(String message, Object error, [StackTrace? stack]) {
    log(message, name: _logTag, error: error, stackTrace: stack);
  }
}
