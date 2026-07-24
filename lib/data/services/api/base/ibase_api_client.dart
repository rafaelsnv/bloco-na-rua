import 'package:bloco_na_rua/core/api_error.dart';
import 'package:dio/dio.dart';

abstract class IBaseApiClient {
  Dio get client;
  String get basePath;
  BaseOptions? get options;
  Dio Function(BaseOptions?)? get clientFactory;

  ApiError formatError(Response<dynamic> response);
}
