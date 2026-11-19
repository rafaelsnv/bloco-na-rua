import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:dio/dio.dart';

class BaseApiClient implements IBaseApiClient {
  BaseApiClient({this.options, this.clientFactory}) {
    client = (clientFactory ?? Dio.new)(options);
  }

  @override
  final Dio Function(BaseOptions?)? clientFactory;
  @override
  final BaseOptions? options;
  @override
  late final Dio client;
  @override
  final String basePath = '/api/v1/';

  @override
  void Function(ApiError error)? onSessionRevoked;

  @override
  ApiError formatError(Response response) {
    final error = ApiError.fromResponse(response);
    // Every non-success response of every API client goes through here, so
    // this is the single place where a revoked session can be detected.
    if (error.isAuthFailure) {
      onSessionRevoked?.call(error);
    }
    return error;
  }
}
