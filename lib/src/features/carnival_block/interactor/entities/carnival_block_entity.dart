import 'package:flutter/foundation.dart';

@immutable
class CarnivalBlockEntity {
  final String managersCode;
  final String inviteCode;
  final String name;
  final String owner;
  final List<Map<String, dynamic>> meetings;
  final List<Map<String, dynamic>> managers;
  final List<Map<String, dynamic>> percussion;

  @override
  bool operator ==(Object other) {
    return other is CarnivalBlockEntity && other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(name, owner);

  const CarnivalBlockEntity({
    required this.managersCode,
    required this.inviteCode,
    required this.name,
    required this.owner,
    required this.meetings,
    required this.managers,
    required this.percussion,
  });
}
