import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/carnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlocks/icarnival_blocks_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockICarnivalBlocksApiClient extends Mock
    implements ICarnivalBlocksApiClient {}

void main() {
  late CarnivalBlocksRepository carnivalBlocksRepository;
  late MockICarnivalBlocksApiClient mockCarnivalBlocksApiClient;

  setUp(() {
    mockCarnivalBlocksApiClient = MockICarnivalBlocksApiClient();
    carnivalBlocksRepository = CarnivalBlocksRepository(
      carnivalBlockApiClient: mockCarnivalBlocksApiClient,
    );
  });

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('CarnivalBlocksRepository.getAllAsync', () {
    test('returns Success with blocks list when API call succeeds', () async {
      // Arrange
      final expectedBlocks = [
        CarnivalBlocksEntity(
          id: 1,
          ownerId: 1,
          name: 'Block A',
          inviteCode: 'INVITE-A',
          managersInviteCode: 'MGMT-A',
          carnivalBlockImage: 'image_a.png',
        ),
        CarnivalBlocksEntity(
          id: 2,
          ownerId: 2,
          name: 'Block B',
          inviteCode: 'INVITE-B',
          managersInviteCode: 'MGMT-B',
          carnivalBlockImage: 'image_b.png',
        ),
      ];

      when(() => mockCarnivalBlocksApiClient.getAllAsync())
          .thenAnswer((_) async => Success(expectedBlocks));

      // Act
      final result = await carnivalBlocksRepository.getAllAsync();

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedBlocks));
      verify(() => mockCarnivalBlocksApiClient.getAllAsync()).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      final apiError = ApiError(
        type: ApiErrorType.server,
        userMessage: 'Server error',
        technicalMessage: 'Server error',
      );

      when(() => mockCarnivalBlocksApiClient.getAllAsync())
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.getAllAsync();

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.getAllAsync()).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockCarnivalBlocksApiClient.getAllAsync())
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.getAllAsync();

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.getAllAsync()).called(1);
    });
  });

  group('CarnivalBlocksRepository.getByIdAsync', () {
    test('returns Success with CarnivalBlocksEntity when block found', () async {
      // Arrange
      const id = 1;
      final expectedBlock = CarnivalBlocksEntity(
        id: id,
        ownerId: 1,
        name: 'Block A',
        inviteCode: 'INVITE-A',
        managersInviteCode: 'MGMT-A',
        carnivalBlockImage: 'image_a.png',
      );

      when(() => mockCarnivalBlocksApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Success(expectedBlock));

      // Act
      final result = await carnivalBlocksRepository.getByIdAsync(id);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedBlock));
      verify(() => mockCarnivalBlocksApiClient.getByIdAsync(id)).called(1);
    });

    test('returns Failure when block not found', () async {
      // Arrange
      const id = 999;
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Block with id 999 not found',
      );

      when(() => mockCarnivalBlocksApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.getByIdAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.getByIdAsync(id)).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      const id = 1;
      final dioException = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockCarnivalBlocksApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.getByIdAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.getByIdAsync(id)).called(1);
    });
  });

  group('CarnivalBlocksRepository.deleteByIdAsync', () {
    test('returns Success when delete succeeds', () async {
      // Arrange
      const id = 1;

      when(() => mockCarnivalBlocksApiClient.deleteAsync(id))
          .thenAnswer((_) async => const Success('204'));

      // Act
      final result = await carnivalBlocksRepository.deleteByIdAsync(id);

      // Assert
      expect(result.isSuccess(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.deleteAsync(id)).called(1);
    });

    test('returns Failure when delete fails', () async {
      // Arrange
      const id = 1;
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Block with id 1 not found',
      );

      when(() => mockCarnivalBlocksApiClient.deleteAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.deleteByIdAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.deleteAsync(id)).called(1);
    });
  });

  group('CarnivalBlocksRepository.createAsync', () {
    test('returns Success with CarnivalBlocksEntity when API call succeeds',
        () async {
      // Arrange
      final data = <String, dynamic>{
        'name': 'New Block',
        'ownerId': 1,
        'inviteCode': 'NEW123',
        'managersInviteCode': 'MGR123',
        'carnivalBlockImage': 'new_image.png',
      };
      final expectedBlock = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'New Block',
        inviteCode: 'NEW123',
        managersInviteCode: 'MGR123',
        carnivalBlockImage: 'new_image.png',
      );

      when(() => mockCarnivalBlocksApiClient.createAsync<CarnivalBlocksEntity>(
            data,
            CarnivalBlocksEntity.fromJson,
          )).thenAnswer((_) async => Success(expectedBlock));

      // Act
      final result = await carnivalBlocksRepository.createAsync(data);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedBlock));
      verify(() => mockCarnivalBlocksApiClient.createAsync<CarnivalBlocksEntity>(
            data,
            CarnivalBlocksEntity.fromJson,
          )).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      final data = <String, dynamic>{'name': 'New Block'};
      final apiError = ApiError(
        type: ApiErrorType.validation,
        userMessage: 'Invalid data',
        technicalMessage: 'Validation error',
      );

      when(() => mockCarnivalBlocksApiClient.createAsync<CarnivalBlocksEntity>(
            data,
            CarnivalBlocksEntity.fromJson,
          )).thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.createAsync(data);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.createAsync<CarnivalBlocksEntity>(
            data,
            CarnivalBlocksEntity.fromJson,
          )).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      final data = <String, dynamic>{'name': 'New Block'};
      final dioException = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockCarnivalBlocksApiClient.createAsync<CarnivalBlocksEntity>(
            data,
            CarnivalBlocksEntity.fromJson,
          )).thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.createAsync(data);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.createAsync<CarnivalBlocksEntity>(
            data,
            CarnivalBlocksEntity.fromJson,
          )).called(1);
    });
  });

  group('CarnivalBlocksRepository.updateAsync', () {
    test('returns Success with updated CarnivalBlocksEntity when API call succeeds',
        () async {
      // Arrange
      const id = 1;
      final data = <String, dynamic>{'name': 'Updated Block'};
      final expectedBlock = CarnivalBlocksEntity(
        id: id,
        ownerId: 1,
        name: 'Updated Block',
        inviteCode: 'INVITE-A',
        managersInviteCode: 'MGMT-A',
        carnivalBlockImage: 'image_a.png',
      );

      when(() => mockCarnivalBlocksApiClient.updateAsync(id, data))
          .thenAnswer((_) async => Success(expectedBlock));

      // Act
      final result = await carnivalBlocksRepository.updateAsync(id, data);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedBlock));
      verify(() => mockCarnivalBlocksApiClient.updateAsync(id, data)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      const id = 1;
      final data = <String, dynamic>{'name': 'Updated Block'};
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Block with id 1 not found',
      );

      when(() => mockCarnivalBlocksApiClient.updateAsync(id, data))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.updateAsync(id, data);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.updateAsync(id, data)).called(1);
    });
  });

  group('CarnivalBlocksRepository.getByInviteCodeAsync', () {
    test(
        'returns Success with CarnivalBlocksEntity when invite code is valid',
        () async {
      // Arrange
      const inviteCode = 'VALID123';
      final expectedBlock = CarnivalBlocksEntity(
        id: 1,
        ownerId: 1,
        name: 'Block A',
        inviteCode: inviteCode,
        managersInviteCode: 'MGMT-A',
        carnivalBlockImage: 'image_a.png',
      );

      when(() => mockCarnivalBlocksApiClient.getByInviteCodeAsync(inviteCode))
          .thenAnswer((_) async => Success(expectedBlock));

      // Act
      final result = await carnivalBlocksRepository.getByInviteCodeAsync(inviteCode);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedBlock));
      verify(() => mockCarnivalBlocksApiClient.getByInviteCodeAsync(inviteCode))
          .called(1);
    });

    test('returns Failure when invite code not found', () async {
      // Arrange
      const inviteCode = 'INVALID123';
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Invite code INVALID123 not found',
      );

      when(() => mockCarnivalBlocksApiClient.getByInviteCodeAsync(inviteCode))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.getByInviteCodeAsync(inviteCode);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.getByInviteCodeAsync(inviteCode))
          .called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      const inviteCode = 'VALID123';
      final dioException = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockCarnivalBlocksApiClient.getByInviteCodeAsync(inviteCode))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await carnivalBlocksRepository.getByInviteCodeAsync(inviteCode);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockCarnivalBlocksApiClient.getByInviteCodeAsync(inviteCode))
          .called(1);
    });
  });
}
