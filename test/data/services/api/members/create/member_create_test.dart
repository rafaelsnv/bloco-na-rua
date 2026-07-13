import "package:bloco_na_rua/data/services/api/members/create/member_create.dart";
import "package:test/test.dart";

void main() {
  group("MemberCreate", () {
    test("can be created without profileImage (null)", () {
      // Act
      final memberCreate = MemberCreate(
        name: "John Doe",
        email: "john@example.com",
        phone: "123456789",
        uuid: "test-uuid-123",
      );

      // Assert
      expect(memberCreate.name, equals("John Doe"));
      expect(memberCreate.email, equals("john@example.com"));
      expect(memberCreate.phone, equals("123456789"));
      expect(memberCreate.uuid, equals("test-uuid-123"));
      expect(memberCreate.profileImage, isNull);
    });

    test("can be created with profileImage", () {
      // Act
      final memberCreate = MemberCreate(
        name: "John Doe",
        email: "john@example.com",
        phone: "123456789",
        uuid: "test-uuid-123",
        profileImage: "https://example.com/avatar.png",
      );

      // Assert
      expect(memberCreate.name, equals("John Doe"));
      expect(memberCreate.email, equals("john@example.com"));
      expect(memberCreate.phone, equals("123456789"));
      expect(memberCreate.uuid, equals("test-uuid-123"));
      expect(memberCreate.profileImage, equals("https://example.com/avatar.png"));
    });

    test("JSON serialization/deserialization works without profileImage", () {
      // Arrange
      final original = MemberCreate(
        name: "John Doe",
        email: "john@example.com",
        phone: "123456789",
        uuid: "test-uuid-123",
      );

      // Act: Serialize to JSON
      final json = original.toJson();

      // Assert: JSON contains all required fields
      expect(json["name"], equals("John Doe"));
      expect(json["email"], equals("john@example.com"));
      expect(json["phone"], equals("123456789"));
      expect(json["uuid"], equals("test-uuid-123"));
      expect(json.containsKey("profileImage"), isTrue);
      expect(json["profileImage"], isNull);

      // Act: Deserialize from JSON
      final deserialized = MemberCreate.fromJson(json);

      // Assert: Deserialized object matches original
      expect(deserialized.name, equals(original.name));
      expect(deserialized.email, equals(original.email));
      expect(deserialized.phone, equals(original.phone));
      expect(deserialized.uuid, equals(original.uuid));
      expect(deserialized.profileImage, equals(original.profileImage));
    });

    test("JSON serialization/deserialization works with profileImage", () {
      // Arrange
      final original = MemberCreate(
        name: "John Doe",
        email: "john@example.com",
        phone: "123456789",
        uuid: "test-uuid-123",
        profileImage: "https://example.com/avatar.png",
      );

      // Act: Serialize to JSON
      final json = original.toJson();

      // Assert: JSON contains all required fields
      expect(json["name"], equals("John Doe"));
      expect(json["email"], equals("john@example.com"));
      expect(json["phone"], equals("123456789"));
      expect(json["uuid"], equals("test-uuid-123"));
      expect(json["profileImage"], equals("https://example.com/avatar.png"));

      // Act: Deserialize from JSON
      final deserialized = MemberCreate.fromJson(json);

      // Assert: Deserialized object matches original
      expect(deserialized.name, equals(original.name));
      expect(deserialized.email, equals(original.email));
      expect(deserialized.phone, equals(original.phone));
      expect(deserialized.uuid, equals(original.uuid));
      expect(deserialized.profileImage, equals(original.profileImage));
    });
  });
}
