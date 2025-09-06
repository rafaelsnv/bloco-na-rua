import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'members_entity.freezed.dart';
part 'members_entity.g.dart';

@freezed
sealed class MembersEntity extends EntityBase with _$MembersEntity {
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? profileImage;

  MembersEntity._({
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    required super.id,
    super.createdAt,
    super.updatedAt,
  }) : super();

  factory MembersEntity({
    required int id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MembersEntity;

  factory MembersEntity.fromJson(Map<String, dynamic> json) =>
      _$MembersEntityFromJson(json);
}
