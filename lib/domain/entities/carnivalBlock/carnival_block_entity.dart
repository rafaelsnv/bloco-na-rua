import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'carnival_block_entity.freezed.dart';
part 'carnival_block_entity.g.dart';

@freezed
sealed class CarnivalBlockEntity extends EntityBase with _$CarnivalBlockEntity {
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

  CarnivalBlockEntity._({
    required this.ownerId,
    required this.name,
    required this.inviteCode,
    required this.managersInviteCode,
    required this.carnivalBlockImage,
    required super.id,
    super.createdAt,
    super.updatedAt,
  }) : super();

  factory CarnivalBlockEntity({
    required int id,
    required int ownerId,
    required String name,
    required String managersInviteCode,
    required String carnivalBlockImage,
    required String inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CarnivalBlockEntity;

  factory CarnivalBlockEntity.fromJson(Map<String, dynamic> json) =>
      _$CarnivalBlockEntityFromJson(json);
}
