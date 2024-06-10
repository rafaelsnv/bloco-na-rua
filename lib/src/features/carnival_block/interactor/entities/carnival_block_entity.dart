class CarnivalBlockEntity {
  final String inviteCode;
  final String name;
  final String owner;
  final Map<String, dynamic> managers;
  final Map<String, dynamic> percussion;

  CarnivalBlockEntity({
    required this.inviteCode,
    required this.name,
    required this.owner,
    required this.managers,
    required this.percussion,
  });
}
