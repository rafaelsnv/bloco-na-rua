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
  Exception formatError(Response response) {
    return Exception(
      'Request failed: ${response.statusCode} - ${response.statusMessage}',
    );
  }
}
