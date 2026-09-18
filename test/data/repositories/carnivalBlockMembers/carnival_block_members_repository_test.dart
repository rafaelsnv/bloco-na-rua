import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/carnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/services/api/carnivalBlockMembers/icarnival_block_members_api_client.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockICarnivalBlockMembersApiClient extends Mock
    implements ICarnivalBlockMembersApiClient {}

void main() {
  late CarnivalBlockMembersRepository repository;
  late MockICarnivalBlockMembersApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockICarnivalBlockMembersApiClient();
    repository = CarnivalBlockMembersRepository(
      carnivalBlockMembersApiClient: mockApiClient,
    );
  });

  group('CarnivalBlockMembersRepository', () {
    group('getByBlockIdAsync', () {
      test('returns Success with list when API call succeeds', () async {
        // Arrange
        const blockId = 1;
        final members = [
          CarnivalBlockMembersEntity(
            id: 1,
            carnivalBlockId: blockId,
            memberId: 10,
            role: 1,
          ),
          CarnivalBlockMembersEntity(
            id: 2,
            carnivalBlockId: blockId,
            memberId: 20,
            role: 2,
          ),
        ];
        when(() => mockApiClient.getByBlockIdAsync(blockId))
            .thenAnswer((_) async => Success(members));

        // Act
        final result = await repository.getByBlockIdAsync(blockId);

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(members));
        verify(() => mockApiClient.getByBlockIdAsync(blockId)).called(1);
      });

      test('returns Failure when API call fails with ApiError', () async {
        // Arrange
        const blockId = 1;
        final apiError = ApiError(
          type: ApiErrorType.network,
          userMessage: 'No internet connection. Check your Wi-Fi.',
          technicalMessage: 'Connection failed',
        );
        when(() => mockApiClient.getByBlockIdAsync(blockId))
            .thenAnswer((_) async => Failure(apiError));

        // Act
        final result = await repository.getByBlockIdAsync(blockId);

        // Assert
        expect(result.isError(), isTrue);
        expect(result.getOrNull(), isNull);
        final failure = result.fold((v) => v, (e) => e);
        expect(failure, equals(apiError));
      });

      test('returns Failure when unexpected error occurs', () async {
        // Arrange
        const blockId = 1;
        when(() => mockApiClient.getByBlockIdAsync(blockId))
            .thenAnswer((_) async => Failure(Exception('Unexpected error')));

        // Act
        final result = await repository.getByBlockIdAsync(blockId);

        // Assert
        expect(result.isError(), isTrue);
      });
    });

    group('createAsync', () {
      test('returns Success with created entity when API call succeeds',
          () async {
        // Arrange
        const carnivalBlockId = 1;
        const memberId = 10;
        const role = 1;
        final created = CarnivalBlockMembersEntity(
          id: 1,
          carnivalBlockId: carnivalBlockId,
          memberId: memberId,
          role: role,
        );
        when(() => mockApiClient.createAsync(carnivalBlockId, memberId, role))
            .thenAnswer((_) async => Success(created));

        // Act
        final result =
            await repository.createAsync(carnivalBlockId, memberId, role);

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(created));
        verify(() => mockApiClient.createAsync(carnivalBlockId, memberId, role))
            .called(1);
      });

      test('returns Failure when API call fails with ApiError', () async {
        // Arrange
        const carnivalBlockId = 1;
        const memberId = 10;
        const role = 1;
        final apiError = ApiError(
          type: ApiErrorType.validation,
          userMessage: 'Invalid data. Check the information.',
          technicalMessage: 'Bad request',
          statusCode: 400,
        );
        when(() => mockApiClient.createAsync(carnivalBlockId, memberId, role))
            .thenAnswer((_) async => Failure(apiError));

        // Act
        final result =
            await repository.createAsync(carnivalBlockId, memberId, role);

        // Assert
        expect(result.isError(), isTrue);
        final failure = result.fold((v) => v, (e) => e);
        expect(failure, isA<ApiError>());
        final error = failure as ApiError;
        expect(error.type, equals(ApiErrorType.validation));
        expect(error.statusCode, equals(400));
      });

      test('returns Failure when unexpected error occurs', () async {
        // Arrange
        const carnivalBlockId = 1;
        const memberId = 10;
        const role = 1;
        when(() => mockApiClient.createAsync(carnivalBlockId, memberId, role))
            .thenAnswer((_) async => Failure(Exception('Unexpected')));

        // Act
        final result =
            await repository.createAsync(carnivalBlockId, memberId, role);

        // Assert
        expect(result.isError(), isTrue);
      });
    });

    group('updateAsync', () {
      test('returns Success with updated entity when API call succeeds',
          () async {
        // Arrange
        const id = 1;
        const carnivalBlockId = 1;
        const memberId = 10;
        const role = 2;
        final updated = CarnivalBlockMembersEntity(
          id: id,
          carnivalBlockId: carnivalBlockId,
          memberId: memberId,
          role: role,
        );
        when(() => mockApiClient.updateAsync(id, carnivalBlockId, memberId, role))
            .thenAnswer((_) async => Success(updated));

        // Act
        final result =
            await repository.updateAsync(id, carnivalBlockId, memberId, role);

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(updated));
        verify(() => mockApiClient.updateAsync(id, carnivalBlockId, memberId, role))
            .called(1);
      });

      test('returns Failure when API call fails with ApiError', () async {
        // Arrange
        const id = 1;
        const carnivalBlockId = 1;
        const memberId = 10;
        const role = 2;
        final apiError = ApiError(
          type: ApiErrorType.notFound,
          userMessage: 'Resource not found.',
          technicalMessage: 'Not found',
          statusCode: 404,
        );
        when(() => mockApiClient.updateAsync(id, carnivalBlockId, memberId, role))
            .thenAnswer((_) async => Failure(apiError));

        // Act
        final result =
            await repository.updateAsync(id, carnivalBlockId, memberId, role);

        // Assert
        expect(result.isError(), isTrue);
        final failure = result.fold((v) => v, (e) => e);
        expect(failure, isA<ApiError>());
        final error = failure as ApiError;
        expect(error.type, equals(ApiErrorType.notFound));
      });

      test('returns Failure when unexpected error occurs', () async {
        // Arrange
        const id = 1;
        const carnivalBlockId = 1;
        const memberId = 10;
        const role = 2;
        when(() => mockApiClient.updateAsync(id, carnivalBlockId, memberId, role))
            .thenAnswer((_) async => Failure(Exception('Unexpected')));

        // Act
        final result =
            await repository.updateAsync(id, carnivalBlockId, memberId, role);

        // Assert
        expect(result.isError(), isTrue);
      });
    });

    group('deleteAsync', () {
      test('returns Success when API call succeeds', () async {
        // Arrange
        const id = 1;
        const memberId = 10;
        when(() => mockApiClient.deleteAsync(id, memberId))
            .thenAnswer((_) async => const Success('204'));

        // Act
        final result = await repository.deleteAsync(id, memberId);

        // Assert
        expect(result.isSuccess(), isTrue);
        verify(() => mockApiClient.deleteAsync(id, memberId)).called(1);
      });

      test('returns Failure when API call fails with ApiError', () async {
        // Arrange
        const id = 1;
        const memberId = 10;
        final apiError = ApiError(
          type: ApiErrorType.auth,
          userMessage: "You don't have permission for this action.",
          technicalMessage: 'Forbidden',
          statusCode: 403,
        );
        when(() => mockApiClient.deleteAsync(id, memberId))
            .thenAnswer((_) async => Failure(apiError));

        // Act
        final result = await repository.deleteAsync(id, memberId);

        // Assert
        expect(result.isError(), isTrue);
        final error = result.fold((v) => null, (e) => e) as ApiError?;
        expect(error, isA<ApiError>());
        expect(error!.type, equals(ApiErrorType.auth));
        expect(error.statusCode, equals(403));
      });

      test('returns Failure when unexpected error occurs', () async {
        // Arrange
        const id = 1;
        const memberId = 10;
        when(() => mockApiClient.deleteAsync(id, memberId))
            .thenAnswer((_) async => Failure(Exception('Unexpected')));

        // Act
        final result = await repository.deleteAsync(id, memberId);

        // Assert
        expect(result.isError(), isTrue);
      });
    });
  });
}
