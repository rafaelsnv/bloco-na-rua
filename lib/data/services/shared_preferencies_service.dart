import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _tokenKey = 'TOKEN';
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
}
