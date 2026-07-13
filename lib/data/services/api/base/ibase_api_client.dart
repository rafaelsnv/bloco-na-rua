import 'package:dio/dio.dart';

abstract class IBaseApiClient {
  Dio get client;
  String get basePath;
  BaseOptions? get options;
  Dio Function(BaseOptions?)? get clientFactory;

  Exception formatError(Response<dynamic> response);
}
