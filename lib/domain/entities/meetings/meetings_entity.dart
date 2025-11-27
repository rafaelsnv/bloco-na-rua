import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meetings_entity.freezed.dart';
part 'meetings_entity.g.dart';

@freezed
sealed class MeetingsEntity extends EntityBase with _$MeetingsEntity {
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

  MeetingsEntity._({
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

  factory MeetingsEntity({
    required int id,
    String? name,
    String? description,
    String? location,
    String? meetingCode,
    String? meetingDateTime,
    int? carnivalBlockId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MeetingsEntity;

  factory MeetingsEntity.fromJson(Map<String, dynamic> json) =>
      _$MeetingsEntityFromJson(json);
}
