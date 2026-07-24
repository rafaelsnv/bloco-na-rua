import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

// ponytail: Minimal wrapper - interface matches SharedPreferencesService for easy migration
class SecureStorageService {
  static const _tokenKey = 'TOKEN';
  static const _uuidKey = 'UUID';
  final _logger = Logger('SecureStorageService');
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  AsyncResult<String> fetchToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null) {
        _logger.info('Token not found');
        return Failure(Exception('Token not found'));
      }
      _logger.info('Got token from SecureStorage');
      return Success(token);
    } on Exception catch (e) {
      _logger.warning('Failed to get token', e);
      return Failure(e);
    }
  }

  AsyncResult<String> fetchUuid() async {
    try {
      final uuid = await _storage.read(key: _uuidKey);
      if (uuid == null) {
        _logger.info('User UUID not found');
        return Failure(Exception('User UUID not found'));
      }
      _logger.info('Got User UUID from SecureStorage');
      return Success(uuid);
    } on Exception catch (e) {
      _logger.warning('Failed to get User UUID', e);
      return Failure(e);
    }
  }

  AsyncResult<bool> saveToken(String? token) async {
    try {
      if (token == null || token.isEmpty) {
        await _storage.delete(key: _tokenKey);
        _logger.info('Removed token');
        return const Success(true);
      }

      await _storage.write(key: _tokenKey, value: token);
      _logger.info('Saved token');
      return const Success(true);
    } on Exception catch (e) {
      _logger.warning('Failed to set token', e);
      return Failure(e);
    }
  }

  AsyncResult<bool> saveUuid(String? uuid) async {
    try {
      if (uuid == null || uuid.isEmpty) {
        await _storage.delete(key: _uuidKey);
        _logger.info('Removed User UUID');
        return const Success(true);
      }

      await _storage.write(key: _uuidKey, value: uuid);
      _logger.info('Saved User UUID');
      return const Success(true);
    } on Exception catch (e) {
      _logger.warning('Failed to set User UUID', e);
      return Failure(e);
    }
  }
}
