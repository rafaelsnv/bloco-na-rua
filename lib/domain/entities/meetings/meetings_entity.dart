import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meetings_entity.freezed.dart';
part 'meetings_entity.g.dart';

@freezed
sealed class MeetingsEntity extends EntityBase with _$MeetingsEntity {
  MeetingsEntity._() : super(id: 0);

  factory MeetingsEntity({
    required int id,
    String? name,
    String? description,
    String? location,
    String? meetingCode,
    DateTime? meetingDateTime,
    int? carnivalBlockId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MeetingsEntity;

  factory MeetingsEntity.fromJson(Map<String, dynamic> json) =>
      _$MeetingsEntityFromJson(json);
}
