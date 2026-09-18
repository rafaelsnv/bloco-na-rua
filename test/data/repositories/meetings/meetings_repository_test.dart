import 'package:bloco_na_rua/core/api_error.dart';
import 'package:bloco_na_rua/core/error_types.dart';
import 'package:bloco_na_rua/data/repositories/meetings/meetings_repository.dart';
import 'package:bloco_na_rua/data/services/api/meetings/imeetings_api_client.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockIMeetingsApiClient extends Mock implements IMeetingsApiClient {}

void main() {
  late MeetingsRepository meetingsRepository;
  late MockIMeetingsApiClient mockMeetingsApiClient;

  setUp(() {
    mockMeetingsApiClient = MockIMeetingsApiClient();
    meetingsRepository = MeetingsRepository(meetingsApiClient: mockMeetingsApiClient);
  });

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('MeetingsRepository.getAllAsync', () {
    test('returns Success with meetings list when API call succeeds', () async {
      // Arrange
      final expectedMeetings = [
        MeetingsEntity(
          id: 1,
          name: 'Meeting A',
          location: 'Location A',
          meetingCode: 'CODE-A',
          carnivalBlockId: 1,
        ),
        MeetingsEntity(
          id: 2,
          name: 'Meeting B',
          location: 'Location B',
          meetingCode: 'CODE-B',
          carnivalBlockId: 1,
        ),
      ];

      when(() => mockMeetingsApiClient.getAllAsync())
          .thenAnswer((_) async => Success(expectedMeetings));

      // Act
      final result = await meetingsRepository.getAllAsync();

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMeetings));
      verify(() => mockMeetingsApiClient.getAllAsync()).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      final apiError = ApiError(
        type: ApiErrorType.server,
        userMessage: 'Server error',
        technicalMessage: 'Server error',
      );

      when(() => mockMeetingsApiClient.getAllAsync())
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.getAllAsync();

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.getAllAsync()).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      final dioException = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockMeetingsApiClient.getAllAsync())
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.getAllAsync();

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.getAllAsync()).called(1);
    });
  });

  group('MeetingsRepository.getByIdAsync', () {
    test('returns Success with MeetingsEntity when meeting found', () async {
      // Arrange
      const id = 1;
      final expectedMeeting = MeetingsEntity(
        id: id,
        name: 'Meeting A',
        location: 'Location A',
        meetingCode: 'CODE-A',
        carnivalBlockId: 1,
      );

      when(() => mockMeetingsApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Success(expectedMeeting));

      // Act
      final result = await meetingsRepository.getByIdAsync(id);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMeeting));
      verify(() => mockMeetingsApiClient.getByIdAsync(id)).called(1);
    });

    test('returns Failure when meeting not found', () async {
      // Arrange
      const id = 999;
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Meeting with id 999 not found',
      );

      when(() => mockMeetingsApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.getByIdAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.getByIdAsync(id)).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      const id = 1;
      final dioException = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockMeetingsApiClient.getByIdAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.getByIdAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.getByIdAsync(id)).called(1);
    });
  });

  group('MeetingsRepository.deleteByIdAsync', () {
    test('returns Success when delete succeeds', () async {
      // Arrange
      const id = 1;

      when(() => mockMeetingsApiClient.deleteAsync(id))
          .thenAnswer((_) async => const Success('204'));

      // Act
      final result = await meetingsRepository.deleteByIdAsync(id);

      // Assert
      expect(result.isSuccess(), isTrue);
      verify(() => mockMeetingsApiClient.deleteAsync(id)).called(1);
    });

    test('returns Failure when delete fails', () async {
      // Arrange
      const id = 1;
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Meeting with id 1 not found',
      );

      when(() => mockMeetingsApiClient.deleteAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.deleteByIdAsync(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.deleteAsync(id)).called(1);
    });
  });

  group('MeetingsRepository.createAsync', () {
    test('returns Success with MeetingsEntity when API call succeeds', () async {
      // Arrange
      final data = <String, dynamic>{
        'name': 'New Meeting',
        'location': 'New Location',
        'carnivalBlockId': 1,
      };
      final expectedMeeting = MeetingsEntity(
        id: 1,
        name: 'New Meeting',
        location: 'New Location',
        meetingCode: 'NEW-CODE',
        carnivalBlockId: 1,
      );

      when(() => mockMeetingsApiClient.createAsync(data))
          .thenAnswer((_) async => Success(expectedMeeting));

      // Act
      final result = await meetingsRepository.createAsync(data);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMeeting));
      verify(() => mockMeetingsApiClient.createAsync(data)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      final data = <String, dynamic>{'name': 'New Meeting'};
      final apiError = ApiError(
        type: ApiErrorType.validation,
        userMessage: 'Invalid data',
        technicalMessage: 'Validation error',
      );

      when(() => mockMeetingsApiClient.createAsync(data))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.createAsync(data);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.createAsync(data)).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      final data = <String, dynamic>{'name': 'New Meeting'};
      final dioException = DioException(
        type: DioExceptionType.receiveTimeout,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockMeetingsApiClient.createAsync(data))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.createAsync(data);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.createAsync(data)).called(1);
    });
  });

  group('MeetingsRepository.getAllByBlockId', () {
    test('returns Success with meetings list when API call succeeds', () async {
      // Arrange
      const blockId = 1;
      final expectedMeetings = [
        MeetingsEntity(
          id: 1,
          name: 'Meeting A',
          location: 'Location A',
          carnivalBlockId: blockId,
        ),
        MeetingsEntity(
          id: 2,
          name: 'Meeting B',
          location: 'Location B',
          carnivalBlockId: blockId,
        ),
      ];

      when(() => mockMeetingsApiClient.getAllByBlockId(blockId))
          .thenAnswer((_) async => Success(expectedMeetings));

      // Act
      final result = await meetingsRepository.getAllByBlockId(blockId);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMeetings));
      verify(() => mockMeetingsApiClient.getAllByBlockId(blockId)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      const blockId = 1;
      final apiError = ApiError(
        type: ApiErrorType.server,
        userMessage: 'Server error',
        technicalMessage: 'Server error',
      );

      when(() => mockMeetingsApiClient.getAllByBlockId(blockId))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.getAllByBlockId(blockId);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.getAllByBlockId(blockId)).called(1);
    });

    test('returns Failure when DioException occurs', () async {
      // Arrange
      const blockId = 1;
      final dioException = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(path: ''),
      );
      final apiError = ApiError.fromDioException(dioException);

      when(() => mockMeetingsApiClient.getAllByBlockId(blockId))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.getAllByBlockId(blockId);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.getAllByBlockId(blockId)).called(1);
    });
  });

  group('MeetingsRepository.create', () {
    test('returns Success with MeetingsEntity when API call succeeds', () async {
      // Arrange
      final data = <String, dynamic>{
        'name': 'New Meeting',
        'location': 'New Location',
        'carnivalBlockId': 1,
      };
      final expectedMeeting = MeetingsEntity(
        id: 1,
        name: 'New Meeting',
        location: 'New Location',
        meetingCode: 'NEW-CODE',
        carnivalBlockId: 1,
      );

      when(() => mockMeetingsApiClient.createAsync(data))
          .thenAnswer((_) async => Success(expectedMeeting));

      // Act
      final result = await meetingsRepository.create(data);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMeeting));
      verify(() => mockMeetingsApiClient.createAsync(data)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      final data = <String, dynamic>{'name': 'New Meeting'};
      final apiError = ApiError(
        type: ApiErrorType.validation,
        userMessage: 'Invalid data',
        technicalMessage: 'Validation error',
      );

      when(() => mockMeetingsApiClient.createAsync(data))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.create(data);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.createAsync(data)).called(1);
    });
  });

  group('MeetingsRepository.update', () {
    test('returns Success with updated MeetingsEntity when API call succeeds',
        () async {
      // Arrange
      const id = 1;
      final data = <String, dynamic>{'name': 'Updated Meeting'};
      final expectedMeeting = MeetingsEntity(
        id: id,
        name: 'Updated Meeting',
        location: 'Location A',
        meetingCode: 'CODE-A',
        carnivalBlockId: 1,
      );

      when(() => mockMeetingsApiClient.updateAsync(id, data))
          .thenAnswer((_) async => Success(expectedMeeting));

      // Act
      final result = await meetingsRepository.update(id, data);

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(expectedMeeting));
      verify(() => mockMeetingsApiClient.updateAsync(id, data)).called(1);
    });

    test('returns Failure when API call fails', () async {
      // Arrange
      const id = 1;
      final data = <String, dynamic>{'name': 'Updated Meeting'};
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Meeting with id 1 not found',
      );

      when(() => mockMeetingsApiClient.updateAsync(id, data))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.update(id, data);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.updateAsync(id, data)).called(1);
    });
  });

  group('MeetingsRepository.delete', () {
    test('returns Success when delete succeeds', () async {
      // Arrange
      const id = 1;

      when(() => mockMeetingsApiClient.deleteAsync(id))
          .thenAnswer((_) async => const Success('204'));

      // Act
      final result = await meetingsRepository.delete(id);

      // Assert
      expect(result.isSuccess(), isTrue);
      verify(() => mockMeetingsApiClient.deleteAsync(id)).called(1);
    });

    test('returns Failure when delete fails', () async {
      // Arrange
      const id = 1;
      final apiError = ApiError(
        type: ApiErrorType.notFound,
        userMessage: 'Resource not found',
        technicalMessage: 'Meeting with id 1 not found',
      );

      when(() => mockMeetingsApiClient.deleteAsync(id))
          .thenAnswer((_) async => Failure(apiError));

      // Act
      final result = await meetingsRepository.delete(id);

      // Assert
      expect(result.isError(), isTrue);
      verify(() => mockMeetingsApiClient.deleteAsync(id)).called(1);
    });
  });
}
