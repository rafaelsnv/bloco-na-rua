import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _tokenKey = 'TOKEN';
  static const _uuidKey = 'UUID';
  final _logger = Logger('SharedPreferencesService');

  AsyncResult<String> fetchToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(_tokenKey);
      if (token == null) {
        _logger.info('Token not found');
        return Failure(Exception('Token not found'));
      }
      _logger.info('Got token from SharedPreferences');
      return Success(token);
    } on Exception catch (e) {
      _logger.warning('Failed to get token', e);
      return Failure(e);
    }
  }

  AsyncResult<String> fetchUuid() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final uuid = sharedPreferences.getString(_uuidKey);
      if (uuid == null) {
        _logger.info('User UUID not found');
        return Failure(Exception('User UUID not found'));
      }
      _logger.info('Got User UUID from SharedPreferences');
      return Success(uuid);
    } on Exception catch (e) {
      _logger.warning('Failed to get User UUID', e);
      return Failure(e);
    }
  }

  AsyncResult<bool> saveToken(String? token) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      if (token == null || token.isEmpty) {
        final removed = await sharedPreferences.remove(_tokenKey);
        if (removed == false) {
          _logger.warning('Failed to remove token');
          return Failure(Exception('Failed to remove token'));
        }
        _logger.info('Removed token');
        return Success(true);
      }

      final replaced = await sharedPreferences.setString(_tokenKey, token);
      if (replaced == false) {
        _logger.warning('Failed to replace token');
        return Failure(Exception('Failed to replace token'));
      }

      _logger.info('Replaced token');
      return Success(true);
    } on Exception catch (e) {
      _logger.warning('Failed to set token', e);
      return Failure(e);
    }
  }

  AsyncResult<bool> saveUuid(String? uuid) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      if (uuid == null || uuid.isEmpty) {
        final removed = await sharedPreferences.remove(_uuidKey);
        if (removed == false) {
          _logger.warning('Failed to remove User UUID');
          return Failure(Exception('Failed to remove User UUID'));
        }
        _logger.info('Removed User UUID');
        return Success(true);
      }

      final replaced = await sharedPreferences.setString(_uuidKey, uuid);
      if (replaced == false) {
        _logger.warning('Failed to replace User UUID');
        return Failure(Exception('Failed to replace User UUID'));
      }

      _logger.info('Replaced User UUID');
      return Success(true);
    } on Exception catch (e) {
      _logger.warning('Failed to set User UUID', e);
      return Failure(e);
    }
  }
}
