import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/meeting_presences_repository.dart';
import 'package:bloco_na_rua/data/services/api/meetingPresences/imeeting_presences_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockIMeetingPresencesApiClient extends Mock
    implements IMeetingPresencesApiClient {}

void main() {
  late MeetingPresencesRepository repository;
  late MockIMeetingPresencesApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockIMeetingPresencesApiClient();
    repository = MeetingPresencesRepository(
      meetingPresencesApiClient: mockApiClient,
    );
  });

  group('MeetingPresencesRepository', () {
    group('getAllAsync', () {
      test('returns Failure as not implemented', () async {
        // Act
        final result = await repository.getAllAsync();

        // Assert
        expect(result.isError(), isTrue);
        final error = result.fold((v) => v, (e) => e);
        expect(error, isA<Exception>());
        expect(error.toString(), contains('not implemented'));
      });
    });

    group('getByIdAsync', () {
      test('returns Failure as not implemented', () async {
        // Act
        const id = 1;
        final result = await repository.getByIdAsync(id);

        // Assert
        expect(result.isError(), isTrue);
        final error = result.fold((v) => v, (e) => e);
        expect(error, isA<Exception>());
        expect(error.toString(), contains('Not implemented'));
      });
    });

    group('deleteByIdAsync', () {
      test('returns Success when API call succeeds', () async {
        // Arrange
        const id = 1;
        when(() => mockApiClient.deleteAsync(id))
            .thenAnswer((_) async => const Success('204'));

        // Act
        final result = await repository.deleteByIdAsync(id);

        // Assert
        expect(result.isSuccess(), isTrue);
        verify(() => mockApiClient.deleteAsync(id)).called(1);
      });

      test('returns Failure when API call fails with ApiError', () async {
        // Arrange
        const id = 1;
        final apiError = ApiError(
          type: ApiErrorType.notFound,
          userMessage: 'Resource not found.',
          technicalMessage: 'Not found',
          statusCode: 404,
        );
        when(() => mockApiClient.deleteAsync(id))
            .thenAnswer((_) async => Failure(apiError));

        // Act
        final result = await repository.deleteByIdAsync(id);

        // Assert
        expect(result.isError(), isTrue);
        final error = result.fold((v) => null, (e) => e) as ApiError?;
        expect(error, isA<ApiError>());
        expect(error!.type, equals(ApiErrorType.notFound));
        expect(error.statusCode, equals(404));
      });

      test('returns Failure when unexpected error occurs', () async {
        // Arrange
        const id = 1;
        when(() => mockApiClient.deleteAsync(id))
            .thenAnswer((_) async => Failure(Exception('Unexpected')));

        // Act
        final result = await repository.deleteByIdAsync(id);

        // Assert
        expect(result.isError(), isTrue);
      });
    });

    group('createAsync', () {
      test('returns Success with created entity when API call succeeds',
          () async {
        // Arrange
        final data = {
          'meetingId': 1,
          'memberId': 10,
          'isPresent': true,
        };
        final created = MeetingPresencesEntity(
          id: 1,
          meetingId: 1,
          memberId: 10,
          isPresent: true,
        );
        when(() => mockApiClient.createAsync(data))
            .thenAnswer((_) async => Success(created));

        // Act
        final result = await repository.createAsync(data);

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(created));
        verify(() => mockApiClient.createAsync(data)).called(1);
      });

      test('returns Failure when API call fails with ApiError', () async {
        // Arrange
        final data = {
          'meetingId': 1,
          'memberId': 10,
          'isPresent': true,
        };
        final apiError = ApiError(
          type: ApiErrorType.validation,
          userMessage: 'Invalid data. Check the information.',
          technicalMessage: 'Bad request',
          statusCode: 400,
        );
        when(() => mockApiClient.createAsync(data))
            .thenAnswer((_) async => Failure(apiError));

        // Act
        final result = await repository.createAsync(data);

        // Assert
        expect(result.isError(), isTrue);
        final error = result.fold((v) => null, (e) => e) as ApiError?;
        expect(error, isA<ApiError>());
        expect(error!.type, equals(ApiErrorType.validation));
        expect(error.statusCode, equals(400));
      });

      test('returns Failure when unexpected error occurs', () async {
        // Arrange
        final data = {
          'meetingId': 1,
          'memberId': 10,
          'isPresent': true,
        };
        when(() => mockApiClient.createAsync(data))
            .thenAnswer((_) async => Failure(Exception('Unexpected')));

        // Act
        final result = await repository.createAsync(data);

        // Assert
        expect(result.isError(), isTrue);
      });
    });

    group('getByMeetingId', () {
      test('returns Success with list when API call succeeds', () async {
        // Arrange
        const meetingId = 1;
        final presences = [
          MeetingPresencesEntity(
            id: 1,
            meetingId: meetingId,
            memberId: 10,
            isPresent: true,
          ),
          MeetingPresencesEntity(
            id: 2,
            meetingId: meetingId,
            memberId: 20,
            isPresent: false,
          ),
        ];
        when(() => mockApiClient.getByMeetingId(meetingId))
            .thenAnswer((_) async => Success(presences));

        // Act
        final result = await repository.getByMeetingId(meetingId);

        // Assert
        expect(result.isSuccess(), isTrue);
        expect(result.getOrNull(), equals(presences));
        verify(() => mockApiClient.getByMeetingId(meetingId)).called(1);
      });

      test('returns Failure when API call fails with ApiError', () async {
        // Arrange
        const meetingId = 1;
        final apiError = ApiError(
          type: ApiErrorType.network,
          userMessage: 'No internet connection. Check your Wi-Fi.',
          technicalMessage: 'Connection failed',
        );
        when(() => mockApiClient.getByMeetingId(meetingId))
            .thenAnswer((_) async => Failure(apiError));

        // Act
        final result = await repository.getByMeetingId(meetingId);

        // Assert
        expect(result.isError(), isTrue);
        expect(result.getOrNull(), isNull);
        final error = result.fold((v) => v, (e) => e);
        expect(error, equals(apiError));
      });

      test('returns Failure when unexpected error occurs', () async {
        // Arrange
        const meetingId = 1;
        when(() => mockApiClient.getByMeetingId(meetingId))
            .thenAnswer((_) async => Failure(Exception('Unexpected error')));

        // Act
        final result = await repository.getByMeetingId(meetingId);

        // Assert
        expect(result.isError(), isTrue);
      });
    });
  });
}
