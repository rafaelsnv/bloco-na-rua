import 'package:flutter/foundation.dart';

@immutable
class MeetingEntity {
  final String address;
  final List<Map<String,dynamic>> attendances;
  final String dateTime;
  final String meetingCode;
  final String name;

  @override
  bool operator ==(Object other) {
    return other is MeetingEntity && other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(meetingCode, name);

  const MeetingEntity({
    required this.address,
    required this.dateTime,
    required this.meetingCode,
    required this.name,
    required this.attendances,
  });
}
