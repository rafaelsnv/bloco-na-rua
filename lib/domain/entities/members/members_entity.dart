import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'members_entity.freezed.dart';
part 'members_entity.g.dart';

@freezed
sealed class MembersEntity extends EntityBase with _$MembersEntity {
  MembersEntity._() : super(id: 0);
  factory MembersEntity({
    required int id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? uuid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MembersEntity;

  factory MembersEntity.fromJson(Map<String, dynamic> json) =>
      _$MembersEntityFromJson(json);
}
