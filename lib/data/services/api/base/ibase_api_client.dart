import 'package:bloco_na_rua/core/api_error.dart';
import 'package:dio/dio.dart';

abstract class IBaseApiClient {
  Dio get client;
  String get basePath;
  BaseOptions? get options;
  Dio Function(BaseOptions?)? get clientFactory;

  ApiError formatError(Response<dynamic> response);

  /// Called when a response maps to an auth failure.
  void Function(ApiError error)? get onSessionRevoked;
  set onSessionRevoked(void Function(ApiError error)? handler);
}
