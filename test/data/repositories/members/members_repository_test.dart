import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart';
import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/repositories/members/members_repository.dart';
import 'package:bloco_na_rua/data/services/api/members/imembers_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockIMembersApiClient extends Mock implements IMembersApiClient {}

void main() {
  late MembersRepository membersRepository;
  late MockIMembersApiClient mockMembersApiClient;

  setUp(() {
    mockMembersApiClient = MockIMembersApiClient();
    membersRepository = MembersRepository(membersApiClient: mockMembersApiClient);
  });

  setUpAll(() {
    registerFallbackValue(MemberCreate(
      uuid: 'fallback-uuid',
      name: 'fallback',
      email: 'fallback@test.com',
      phone: '000000000',
    ));
    registerFallbackValue(<String, dynamic>{});
  });

  group('MembersRepository.createAsync', () {
    test('returns Success with MembersEntity when API call succeeds', () async {
      // Arrange
      final memberCreate = MemberCreate(
        uuid: 'uuid-123',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '123456789',
      );
      final expectedMember = MembersEntity(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        phone: '123456789',
        uuid: 'uuid-123',
      );

      when(() => mockMembersApiClient.createAsync(memberCreate))
          .thenAnswer((_) async => Success(expectedMember));

      // Act
      final result = await membersRepository.createAsync(memberCreate);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMember));
      verify(() => mockMembersApiClient.createAsync(memberCreate)).called(1);
    });

    test('returns Failure when API call fails with DioException', () async {
      // Arrange
      final memberCreate = MemberCreate(
        uuid: 'uuid-123',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '123456789',
      );
      final apiError = ApiError(
        type: ApiErrorType.network,
        userMessage: 'No internet connection.',
        technicalMessage: 'Connection failed',
      );

      when(() => mockMembersApiClient.createAsync(memberCreate))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.createAsync(memberCreate);

      // Assert
      expect(result.isError(), isTrue);
      expect(result.getOrNull(), isNull);
      verify(() => mockMembersApiClient.createAsync(memberCreate)).called(1);
    });
  });

  group('MembersRepository.getByUuidAsync', () {
    test('returns Success with MembersEntity when member found', () async {
      // Arrange
      const uuid = 'uuid-123';
      final expectedMember = MembersEntity(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        uuid: uuid,
      );

      when(() => mockMembersApiClient.getByUuidAsync(uuid))
          .thenAnswer((_) async => Success(expectedMember));

      // Act
      final result = await membersRepository.getByUuidAsync(uuid);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMember));
      verify(() => mockMembersApiClient.getByUuidAsync(uuid)).called(1);
    });

    test('returns Failure when member not found', () async {
      // Arrange
      const uuid = 'non-existent-uuid';
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Member not found',
        technicalMessage: 'Member not found',
      );

      when(() => mockMembersApiClient.getByUuidAsync(uuid))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.getByUuidAsync(uuid);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.getByUuidAsync(uuid)).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      const uuid = 'uuid-123';
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockMembersApiClient.getByUuidAsync(uuid))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.getByUuidAsync(uuid);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.getByUuidAsync(uuid)).called(1);
    });
  });

  group('MembersRepository.getBlocksByMemberId', () {
    test('returns Success with blocks list when API call succeeds', () async {
      // Arrange
      const memberId = 1;
      final expectedBlocks = [
        CarnivalBlocksEntity(
          id: 1,
          ownerId: memberId,
          name: 'Block A',
          inviteCode: 'INVITE-A',
          managersInviteCode: 'MGMT-A',
          carnivalBlockImage: 'image_a.png',
        ),
      ];

      when(() => mockMembersApiClient.getBlocksByMemberId(memberId))
          .thenAnswer((_) async => Success(expectedBlocks));

      // Act
      final result = await membersRepository.getBlocksByMemberId(memberId);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedBlocks));
      verify(() => mockMembersApiClient.getBlocksByMemberId(memberId)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      const memberId = 1;
      final apiError = ApiError(
        type: ApiErrorType.server,
        userMessage: 'Server error',
        technicalMessage: 'Server error',
      );

      when(() => mockMembersApiClient.getBlocksByMemberId(memberId))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.getBlocksByMemberId(memberId);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.getBlocksByMemberId(memberId)).called(1);
    });
  });

  group('MembersRepository.getMeetingsByMemberId', () {
    test('returns Success with meetings list when API call succeeds', () async {
      // Arrange
      const memberId = 1;
      final expectedMeetings = [
        MeetingsEntity(
          id: 1,
          name: 'Meeting A',
          location: 'Location A',
          carnivalBlockId: 1,
        ),
      ];

      when(() => mockMembersApiClient.getMeetingsByMemberId(memberId))
          .thenAnswer((_) async => Success(expectedMeetings));

      // Act
      final result = await membersRepository.getMeetingsByMemberId(memberId);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMeetings));
      verify(() => mockMembersApiClient.getMeetingsByMemberId(memberId)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      const memberId = 1;
      final apiError = ApiError(
        type: ApiErrorType.server,
        userMessage: 'Server error',
        technicalMessage: 'Server error',
      );

      when(() => mockMembersApiClient.getMeetingsByMemberId(memberId))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.getMeetingsByMemberId(memberId);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.getMeetingsByMemberId(memberId)).called(1);
    });
  });

  group('MembersRepository.getAllAsync', () {
    test('returns Success with members list when API call succeeds', () async {
      // Arrange
      final expectedMembers = [
        MembersEntity(id: 1, name: 'John Doe', email: 'john@example.com'),
        MembersEntity(id: 2, name: 'Jane Doe', email: 'jane@example.com'),
      ];

      when(() => mockMembersApiClient.getAllAsync())
          .thenAnswer((_) async => Success(expectedMembers));

      // Act
      final result = await membersRepository.getAllAsync();

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMembers));
      verify(() => mockMembersApiClient.getAllAsync()).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      final apiError = ApiError(
        type: ApiErrorType.network,
        userMessage: 'No internet connection',
        technicalMessage: 'Network error',
      );

      when(() => mockMembersApiClient.getAllAsync())
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.getAllAsync();

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.getAllAsync()).called(1);
    });
  });

  group('MembersRepository.getByIdAsync', () {
    test('returns Success with MembersEntity when member found', () async {
      // Arrange
      const id = 1;
      final expectedMember = MembersEntity(
        id: id,
        name: 'John Doe',
        email: 'john@example.com',
      );

      when(() => mockMembersApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Success(expectedMember));

      // Act
      final result = await membersRepository.getByIdAsync(id);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMember));
      verify(() => mockMembersApiClient.getByIdAsync(id)).called(1);
    });

    test('returns Failure when member not found', () async {
      // Arrange
      const id = 999;
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Member not found',
        technicalMessage: 'Member with id 999 not found',
      );

      when(() => mockMembersApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.getByIdAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.getByIdAsync(id)).called(1);
    });
  });

  group('MembersRepository.updateAsync', () {
    test('returns Success with updated MembersEntity when API call succeeds', () async {
      // Arrange
      const id = 1;
      final updateData = <String, dynamic>{'name': 'Updated Name'};
      final expectedMember = MembersEntity(
        id: id,
        name: 'Updated Name',
        email: 'john@example.com',
      );

      when(() => mockMembersApiClient.updateAsync(id, updateData))
          .thenAnswer((_) async => Success(expectedMember));

      // Act
      final result = await membersRepository.updateAsync(id, updateData);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMember));
      verify(() => mockMembersApiClient.updateAsync(id, updateData)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      const id = 1;
      final updateData = <String, dynamic>{'name': 'Updated Name'};
      final apiError = ApiError(
        type: ApiErrorType.validation,
        userMessage: 'Invalid data',
        technicalMessage: 'Validation error',
      );

      when(() => mockMembersApiClient.updateAsync(id, updateData))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.updateAsync(id, updateData);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.updateAsync(id, updateData)).called(1);
    });
  });

  group('MembersRepository.deleteAsync', () {
    test('returns Success when API call succeeds', () async {
      // Arrange
      const id = 1;

      when(() => mockMembersApiClient.deleteAsync(id))
          .thenAnswer((_) async => Success(200));

      // Act
      final result = await membersRepository.deleteAsync(id);

      // Assert
      expect(result.isSuccess(), isTrue);
      verify(() => mockMembersApiClient.deleteAsync(id)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      const id = 1;
      final apiError = ApiError(
        type: ApiErrorType.server,
        userMessage: 'Server error',
        technicalMessage: 'Server error',
      );

      when(() => mockMembersApiClient.deleteAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await membersRepository.deleteAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMembersApiClient.deleteAsync(id)).called(1);
    });
  });
}
