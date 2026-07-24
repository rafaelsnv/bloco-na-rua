import 'package:bloco_na_rua/core/entity_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_presences_entity.freezed.dart';
part 'meeting_presences_entity.g.dart';

@freezed
sealed class MeetingPresencesEntity extends EntityBase
    with _$MeetingPresencesEntity {
  MeetingPresencesEntity._() : super(id: 0);

  factory MeetingPresencesEntity({
    required int id,
    required int meetingId,
    required int memberId,
    required bool isPresent,
    int? carnivalBlockId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MeetingPresencesEntity;

  factory MeetingPresencesEntity.fromJson(Map<String, dynamic> json) =>
      _$MeetingPresencesEntityFromJson(json);
}
