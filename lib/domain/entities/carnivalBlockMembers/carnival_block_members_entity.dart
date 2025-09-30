import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_block_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_block_members_entity.freezed.dart';
part 'carnival_block_members_entity.g.dart';

@freezed
sealed class CarnivalBlockMembersEntity extends EntityBase
    with _$CarnivalBlockMembersEntity {
  @override
  final int carnivalBlockId;
  @override
  final int memberId;
  @override
  final int role;
  @override
  final CarnivalBlockEntity? carnivalBlock;

  CarnivalBlockMembersEntity._({
    required this.carnivalBlockId,
    required this.memberId,
    required this.role,
    required super.id,
    this.carnivalBlock,
    super.createdAt,
    super.updatedAt,
  }) : super();

  factory CarnivalBlockMembersEntity({
    required int id,
    required int carnivalBlockId,
    required int memberId,
    required int role,
    CarnivalBlockEntity? carnivalBlock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CarnivalBlockMembersEntity;

  factory CarnivalBlockMembersEntity.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockMembersEntityFromJson(json);
}
