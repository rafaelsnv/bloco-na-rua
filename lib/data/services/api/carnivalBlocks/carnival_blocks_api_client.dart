import 'package:bloco_na_rua/data/services/api/base/ibase_api_client.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlocks/icarnival_blocks_api_client.dart';

class CarnivalBlocksApiClient implements ICarnivalBlocksApiClient {
  final IBaseApiClient baseApiClient;

  // ignore: unused_field
  late final String _basePath;

  CarnivalBlocksApiClient(this.baseApiClient) {
    _basePath = '${baseApiClient.basePath}CarnivalBlocks';
  }

  @override
  IBaseApiClient get client => baseApiClient;
}
