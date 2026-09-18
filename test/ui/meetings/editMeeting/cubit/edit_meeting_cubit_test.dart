import 'package:bloc_test/bloc_test.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/editMeeting/cubit/edit_meeting_state.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockIMeetingsRepository extends Mock implements IMeetingsRepository {}

void main() {
  late EditMeetingCubit editMeetingCubit;
  late MockIMeetingsRepository mockMeetingsRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockMeetingsRepository = MockIMeetingsRepository();
    editMeetingCubit = EditMeetingCubit(meetingsRepository: mockMeetingsRepository);
  });

  tearDown(() {
    editMeetingCubit.close();
  });

  group('EditMeetingCubit', () {
    test('initial state is correct', () {
      expect(editMeetingCubit.state, const EditMeetingState());
      expect(editMeetingCubit.state.status, EditMeetingStatus.initial);
      expect(editMeetingCubit.state.meeting, isNull);
      expect(editMeetingCubit.state.errorMessage, isNull);
    });

    blocTest<EditMeetingCubit, EditMeetingState>(
      'emits loading then loaded when loadMeeting succeeds',
      build: () {
        final meeting = MeetingsEntity(
          id: 1,
          name: 'Meeting 1',
          description: 'Description',
          location: 'Location',
          meetingDateTime: DateTime.parse('2026-12-25T14:00:00Z'),
          carnivalBlockId: 1,
        );

        when(() => mockMeetingsRepository.getByIdAsync(1))
            .thenAnswer((_) async => Success(meeting));

        return editMeetingCubit;
      },
      act: (cubit) => cubit.loadMeeting(1),
      expect: () => [
        const EditMeetingState(status: EditMeetingStatus.loading),
        isA<EditMeetingState>()
            .having((s) => s.status, 'status', EditMeetingStatus.loaded)
            .having((s) => s.meeting?.id, 'meeting id', 1)
            .having((s) => s.meeting?.name, 'meeting name', 'Meeting 1'),
      ],
    );

    blocTest<EditMeetingCubit, EditMeetingState>(
      'emits loading then failure when loadMeeting fails',
      build: () {
        when(() => mockMeetingsRepository.getByIdAsync(1))
            .thenAnswer((_) async => Failure(Exception('Network error')));

        return editMeetingCubit;
      },
      act: (cubit) => cubit.loadMeeting(1),
      expect: () => [
        const EditMeetingState(status: EditMeetingStatus.loading),
        isA<EditMeetingState>()
            .having((s) => s.status, 'status', EditMeetingStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );

    blocTest<EditMeetingCubit, EditMeetingState>(
      'emits saving then success when updateMeeting succeeds',
      build: () {
        final updatedMeeting = MeetingsEntity(
          id: 1,
          name: 'Updated Meeting',
          description: 'Updated Description',
          location: 'Updated Location',
          meetingDateTime: DateTime.parse('2026-12-26T15:00:00Z'),
          carnivalBlockId: 1,
        );

        when(() => mockMeetingsRepository.update(1, any()))
            .thenAnswer((_) async => Success(updatedMeeting));

        return editMeetingCubit;
      },
      act: (cubit) => cubit.updateMeeting(1, {'name': 'Updated Meeting'}),
      expect: () => [
        const EditMeetingState(status: EditMeetingStatus.saving),
        isA<EditMeetingState>()
            .having((s) => s.status, 'status', EditMeetingStatus.success)
            .having((s) => s.meeting?.name, 'meeting name', 'Updated Meeting'),
      ],
    );

    blocTest<EditMeetingCubit, EditMeetingState>(
      'emits saving then failure when updateMeeting fails',
      build: () {
        when(() => mockMeetingsRepository.update(1, any()))
            .thenAnswer((_) async => Failure(Exception('Update failed')));

        return editMeetingCubit;
      },
      act: (cubit) => cubit.updateMeeting(1, {'name': 'Updated Meeting'}),
      expect: () => [
        const EditMeetingState(status: EditMeetingStatus.saving),
        isA<EditMeetingState>()
            .having((s) => s.status, 'status', EditMeetingStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );
  });
}
