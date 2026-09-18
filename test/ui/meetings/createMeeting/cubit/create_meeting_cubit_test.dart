import 'package:bloc_test/bloc_test.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/createMeeting/cubit/create_meeting_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockIMeetingsRepository extends Mock implements IMeetingsRepository {}

void main() {
  late CreateMeetingCubit createMeetingCubit;
  late MockIMeetingsRepository mockMeetingsRepository;

  setUp(() {
    mockMeetingsRepository = MockIMeetingsRepository();
    createMeetingCubit = CreateMeetingCubit(
      meetingsRepository: mockMeetingsRepository,
    );
  });

  tearDown(() {
    createMeetingCubit.close();
  });

  group('CreateMeetingCubit', () {
    test('initial state is correct', () {
      expect(createMeetingCubit.state, const CreateMeetingState());
      expect(createMeetingCubit.state.status, CreateMeetingStatus.initial);
      expect(createMeetingCubit.state.errorMessage, isNull);
    });

    blocTest<CreateMeetingCubit, CreateMeetingState>(
      'emits loading then success when createMeeting succeeds',
      build: () {
        final meeting = MeetingsEntity(
          id: 1,
          name: 'Meeting 1',
          description: 'Description',
          location: 'Location',
          meetingDateTime: DateTime.parse('2026-12-25T14:00:00Z'),
          carnivalBlockId: 1,
        );

        when(
          () => mockMeetingsRepository.create(any()),
        ).thenAnswer((_) async => Success(meeting));

        return createMeetingCubit;
      },
      act: (cubit) => cubit.createMeeting({}),
      expect: () => [
        isA<CreateMeetingState>()
            .having((s) => s.status, 'status', CreateMeetingStatus.loading),
        isA<CreateMeetingState>()
            .having((s) => s.status, 'status', CreateMeetingStatus.success),
      ],
    );

    blocTest<CreateMeetingCubit, CreateMeetingState>(
      'emits loading then failure when createMeeting fails',
      build: () {
        when(
          () => mockMeetingsRepository.create(any()),
        ).thenAnswer(
          (_) async => Failure(Exception('Network error')),
        );

        return createMeetingCubit;
      },
      act: (cubit) => cubit.createMeeting({}),
      expect: () => [
        isA<CreateMeetingState>()
            .having((s) => s.status, 'status', CreateMeetingStatus.loading),
        isA<CreateMeetingState>()
            .having((s) => s.status, 'status', CreateMeetingStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );
  });
}
