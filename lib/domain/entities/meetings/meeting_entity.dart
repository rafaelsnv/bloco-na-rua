import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_entity.freezed.dart';
part 'meeting_entity.g.dart';

@freezed
sealed class MeetingEntity extends EntityBase with _$MeetingEntity {
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final String? meetingCode;
  @override
  final String? meetingDateTime;
  @override
  final int? carnivalBlockId;

  MeetingEntity._({
    this.name,
    this.description,
    this.location,
    this.meetingCode,
    this.meetingDateTime,
    this.carnivalBlockId,
    required super.id,
    super.createdAt,
    super.updatedAt,
  }) : super();

  factory MeetingEntity({
    required int id,
    String? name,
    String? description,
    String? location,
    String? meetingCode,
    String? meetingDateTime,
    int? carnivalBlockId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MeetingEntity;

  factory MeetingEntity.fromJson(Map<String, dynamic> json) =>
      _$MeetingEntityFromJson(json);
}
