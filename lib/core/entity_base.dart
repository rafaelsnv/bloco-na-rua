typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

abstract class EntityBase {
  EntityBase({required this.id, this.createdAt, this.updatedAt});

  final int id;
  DateTime? createdAt;
  DateTime? updatedAt;
}
