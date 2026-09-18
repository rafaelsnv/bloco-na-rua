import "package:bloco_na_rua/data/repositories/auth/iauth_repository.dart";
import "package:bloco_na_rua/data/repositories/members/imembers_repository.dart";
import "package:bloco_na_rua/domain/entities/members/members_entity.dart";
import "package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart";
import "package:mocktail/mocktail.dart";
import "package:result_dart/result_dart.dart";
import "package:test/test.dart";

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockIMembersRepository extends Mock implements IMembersRepository {}

void main() {
  late GetCurrentUserData getCurrentUserData;
  late MockIAuthRepository mockAuthRepository;
  late MockIMembersRepository mockMembersRepository;

  setUpAll(() {
    registerFallbackValue(MembersEntity(id: 0));
  });

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    mockMembersRepository = MockIMembersRepository();
    getCurrentUserData = GetCurrentUserData(
      authRepository: mockAuthRepository,
      memberRepository: mockMembersRepository,
    );
  });

  group("GetCurrentUserData", () {
    group("call", () {
      test(
          "returns member when uuid resolves and membersRepository.getByUuidAsync succeeds",
          () async {
        // Arrange
        const uuid = "valid-uuid-123";
        final member = MembersEntity(
          id: 1,
          name: "Jane Doe",
          uuid: uuid,
          email: "jane@example.com",
        );

        when(() => mockAuthRepository.currentMember).thenReturn(null);
        when(() => mockAuthRepository.currentUuid)
            .thenAnswer((_) async => uuid);
        when(() => mockMembersRepository.getByUuidAsync(uuid))
            .thenAnswer((_) async => Success(member));
        when(() => mockAuthRepository.setCurrentMember(any()))
            .thenReturn(null);

        // Act
        final result = await getCurrentUserData();

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(member));
        verify(() => mockAuthRepository.setCurrentMember(any())).called(1);
      });

      test("returns Failure when uuid is null", () async {
        // Arrange
        when(() => mockAuthRepository.currentMember).thenReturn(null);
        when(() => mockAuthRepository.currentUuid)
            .thenAnswer((_) async => null);

        // Act
        final result = await getCurrentUserData();

        // Assert
        expect(result.isError(), isTrue);
        verifyNever(() => mockMembersRepository.getByUuidAsync(any()));
        verifyNever(() => mockAuthRepository.setCurrentMember(any()));
      });

      test("returns Failure when uuid is empty", () async {
        // Arrange
        when(() => mockAuthRepository.currentMember).thenReturn(null);
        when(() => mockAuthRepository.currentUuid)
            .thenAnswer((_) async => "");

        // Act
        final result = await getCurrentUserData();

        // Assert
        expect(result.isError(), isTrue);
        verifyNever(() => mockMembersRepository.getByUuidAsync(any()));
        verifyNever(() => mockAuthRepository.setCurrentMember(any()));
      });

      test("returns Failure when membersRepository fails", () async {
        // Arrange
        const uuid = "valid-uuid-123";
        when(() => mockAuthRepository.currentMember).thenReturn(null);
        when(() => mockAuthRepository.currentUuid)
            .thenAnswer((_) async => uuid);
        when(() => mockMembersRepository.getByUuidAsync(uuid))
            .thenAnswer((_) async => Failure(Exception("Member not found")));

        // Act
        final result = await getCurrentUserData();

        // Assert
        expect(result.isError(), isTrue);
        verifyNever(() => mockAuthRepository.setCurrentMember(any()));
      });

      test("returns cached member from authRepository without calling memberRepository",
          () async {
        // Arrange
        final cachedMember = MembersEntity(
          id: 1,
          name: "Cached User",
          uuid: "cached-uuid",
          email: "cached@example.com",
        );

        when(() => mockAuthRepository.currentMember).thenReturn(cachedMember);

        // Act
        final result = await getCurrentUserData();

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(cachedMember));
        verifyNever(() => mockAuthRepository.currentUuid);
        verifyNever(() => mockMembersRepository.getByUuidAsync(any()));
      });
    });
  });
}
