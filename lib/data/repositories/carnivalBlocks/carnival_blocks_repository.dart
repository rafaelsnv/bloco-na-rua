import 'package:bloco_na_rua/data/repositories/base/repository_base.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlocks/icarnival_blocks_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';

class CarnivalBlocksRepository extends RepositoryBase<CarnivalBlocksEntity>
    implements ICarnivalBlocksRepository {
  CarnivalBlocksRepository({required this.carnivalBlockApiClient})
    : super(
        client: carnivalBlockApiClient.client,
        fromJsonFactory: CarnivalBlocksEntity.fromJson,
      );

  final ICarnivalBlocksApiClient carnivalBlockApiClient;
}
