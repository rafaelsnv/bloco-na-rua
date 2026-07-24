import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_blocks_entity.freezed.dart';
part 'carnival_blocks_entity.g.dart';

@freezed
sealed class CarnivalBlocksEntity extends EntityBase
    with _$CarnivalBlocksEntity {
  @override
  final int ownerId;
  @override
  final String name;
  @override
  final String inviteCode;
  @override
  final String managersInviteCode;
  @override
  final String carnivalBlockImage;

  CarnivalBlocksEntity._({
    required this.ownerId,
    required this.name,
    required this.inviteCode,
    required this.managersInviteCode,
    required this.carnivalBlockImage,
    required super.id,
  }) : super();

  factory CarnivalBlocksEntity({
    required int id,
    required int ownerId,
    required String name,
    required String managersInviteCode,
    required String carnivalBlockImage,
    required String inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CarnivalBlocksEntity;

  factory CarnivalBlocksEntity.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlocksEntityFromJson(json);
}
