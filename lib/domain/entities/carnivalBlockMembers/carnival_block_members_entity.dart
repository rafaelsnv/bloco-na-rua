import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_block_members_entity.freezed.dart';
part 'carnival_block_members_entity.g.dart';

@freezed
sealed class CarnivalBlockMembersEntity extends EntityBase
    with _$CarnivalBlockMembersEntity {
  CarnivalBlockMembersEntity._() : super(id: 0);

  factory CarnivalBlockMembersEntity({
    required int id,
    required int carnivalBlockId,
    required int memberId,
    required int role,
    CarnivalBlocksEntity? carnivalBlock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CarnivalBlockMembersEntity;

  factory CarnivalBlockMembersEntity.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockMembersEntityFromJson(json);
}
