import 'package:bloc_test/bloc_test.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetingPresences/imeeting_presences_repository.dart';
import 'package:bloco_na_rua/data/repositories/meetings/imeetings_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetingPresences/meeting_presences_entity.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/meetingDetails/cubit/meeting_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockIMeetingsRepository extends Mock implements IMeetingsRepository {}

class MockIMeetingPresencesRepository extends Mock
    implements IMeetingPresencesRepository {}

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockICarnivalBlocksRepository extends Mock
    implements ICarnivalBlocksRepository {}

void main() {
  late MeetingDetailsCubit cubit;
  late MockIMeetingsRepository mockMeetingsRepository;
  late MockIMeetingPresencesRepository mockMeetingPresencesRepository;
  late MockIAuthRepository mockAuthRepository;
  late MockICarnivalBlocksRepository mockCarnivalBlocksRepository;

  const meetingId = '1';

  final testMeeting = MeetingsEntity(
    id: 1,
    name: 'Test Meeting',
    description: 'Test Description',
    location: 'Test Location',
    meetingDateTime: DateTime.parse('2026-12-25T14:00:00Z'),
    carnivalBlockId: 1,
  );

  final testBlock = CarnivalBlocksEntity(
    id: 1,
    ownerId: 1,
    name: 'Test Block',
    inviteCode: 'ABC123',
    managersInviteCode: 'MANAGER123',
    carnivalBlockImage: 'image.png',
  );

  final testPresences = [
    MeetingPresencesEntity(
      id: 1,
      meetingId: 1,
      memberId: 1,
      isPresent: true,
      carnivalBlockId: 1,
    ),
    MeetingPresencesEntity(
      id: 2,
      meetingId: 1,
      memberId: 2,
      isPresent: false,
      carnivalBlockId: 1,
    ),
  ];

  setUp(() {
    mockMeetingsRepository = MockIMeetingsRepository();
    mockMeetingPresencesRepository = MockIMeetingPresencesRepository();
    mockAuthRepository = MockIAuthRepository();
    mockCarnivalBlocksRepository = MockICarnivalBlocksRepository();

    cubit = MeetingDetailsCubit(
      meetingsRepository: mockMeetingsRepository,
      meetingPresencesRepository: mockMeetingPresencesRepository,
      authRepository: mockAuthRepository,
      carnivalBlocksRepository: mockCarnivalBlocksRepository,
      meetingId: meetingId,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('MeetingDetailsCubit', () {
    test('initial state is MeetingDetailsInitial', () {
      expect(cubit.state, const MeetingDetailsInitial());
    });

    group('loadMeeting', () {
      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits loading then loaded when meeting fetch succeeds',
        build: () {
          when(() => mockMeetingsRepository.getByIdAsync(1))
              .thenAnswer((_) async => Success(testMeeting));
          when(() => mockAuthRepository.currentUuid)
              .thenAnswer((_) async => '1');
          when(() => mockCarnivalBlocksRepository.getByIdAsync(1))
              .thenAnswer((_) async => Success(testBlock));

          return cubit;
        },
        act: (cubit) => cubit.loadMeeting(),
        expect: () => [
          const MeetingDetailsLoading(),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.meeting, 'meeting', testMeeting)
              .having((s) => s.canDeleteMeeting, 'canDeleteMeeting', true),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits loading then error when meeting fetch fails',
        build: () {
          when(() => mockMeetingsRepository.getByIdAsync(1))
              .thenAnswer((_) async => Failure(Exception('Network error')));

          return cubit;
        },
        act: (cubit) => cubit.loadMeeting(),
        expect: () => [
          const MeetingDetailsLoading(),
          isA<MeetingDetailsError>(),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits error when meeting ID is invalid',
        build: () {
          final invalidCubit = MeetingDetailsCubit(
            meetingsRepository: mockMeetingsRepository,
            meetingPresencesRepository: mockMeetingPresencesRepository,
            authRepository: mockAuthRepository,
            carnivalBlocksRepository: mockCarnivalBlocksRepository,
            meetingId: 'invalid',
          );
          return invalidCubit;
        },
        act: (cubit) => cubit.loadMeeting(),
        expect: () => [
          const MeetingDetailsLoading(),
          isA<MeetingDetailsError>(),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits loaded with canDeleteMeeting false when user is not owner',
        build: () {
          when(() => mockMeetingsRepository.getByIdAsync(1))
              .thenAnswer((_) async => Success(testMeeting));
          when(() => mockAuthRepository.currentUuid)
              .thenAnswer((_) async => '999'); // Different user
          when(() => mockCarnivalBlocksRepository.getByIdAsync(1))
              .thenAnswer((_) async => Success(testBlock));

          return cubit;
        },
        act: (cubit) => cubit.loadMeeting(),
        expect: () => [
          const MeetingDetailsLoading(),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.canDeleteMeeting, 'canDeleteMeeting', false),
        ],
      );
    });

    group('loadPresences', () {
      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits loaded with presences when fetch succeeds',
        build: () {
          when(() => mockMeetingPresencesRepository.getByMeetingId(1))
              .thenAnswer((_) async => Success(testPresences));

          return cubit;
        },
        seed: () => MeetingDetailsLoaded(meeting: testMeeting),
        act: (cubit) => cubit.loadPresences(),
        expect: () => [
          isA<MeetingDetailsLoaded>()
              .having((s) => s.presencesStatus, 'presencesStatus',
                  PresencesStatus.loading),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.presences.length, 'presences length', 2)
              .having(
                  (s) => s.presencesStatus, 'presencesStatus', PresencesStatus.loaded),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits loaded with empty presences when fetch fails',
        build: () {
          when(() => mockMeetingPresencesRepository.getByMeetingId(1))
              .thenAnswer(
                  (_) async => Failure(Exception('Failed to load presences')));

          return cubit;
        },
        seed: () => MeetingDetailsLoaded(meeting: testMeeting),
        act: (cubit) => cubit.loadPresences(),
        expect: () => [
          isA<MeetingDetailsLoaded>()
              .having((s) => s.presencesStatus, 'presencesStatus',
                  PresencesStatus.loading),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.presences, 'presences', isEmpty)
              .having(
                  (s) => s.presencesStatus, 'presencesStatus', PresencesStatus.loaded),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'does nothing when state is not MeetingDetailsLoaded',
        build: () => cubit,
        act: (cubit) => cubit.loadPresences(),
        expect: () => [],
      );
    });

    group('markPresence', () {
      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits success when mark presence succeeds',
        build: () {
          when(() => mockAuthRepository.currentUuid)
              .thenAnswer((_) async => '1');
          when(() => mockMeetingPresencesRepository.createAsync(any()))
              .thenAnswer(
                  (_) async => Success(testPresences[0]));
          when(() => mockMeetingPresencesRepository.getByMeetingId(any()))
              .thenAnswer((_) async => Success(testPresences));

          return cubit;
        },
        seed: () => MeetingDetailsLoaded(meeting: testMeeting),
        act: (cubit) => cubit.markPresence(isPresent: true),
        expect: () => [
          isA<MeetingDetailsLoaded>().having(
              (s) => s.markingPresenceStatus,
              'markingPresenceStatus',
              MarkingPresenceStatus.loading),
          isA<MeetingDetailsLoaded>().having(
              (s) => s.markingPresenceStatus,
              'markingPresenceStatus',
              MarkingPresenceStatus.success),
          isA<MeetingDetailsLoaded>().having(
              (s) => s.presencesStatus,
              'presencesStatus',
              PresencesStatus.loading),
          isA<MeetingDetailsLoaded>().having(
              (s) => s.presencesStatus,
              'presencesStatus',
              PresencesStatus.loaded),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits error when user is not authenticated',
        build: () {
          when(() => mockAuthRepository.currentUuid)
              .thenAnswer((_) async => null);

          return cubit;
        },
        seed: () => MeetingDetailsLoaded(meeting: testMeeting),
        act: (cubit) => cubit.markPresence(isPresent: true),
        expect: () => [
          isA<MeetingDetailsLoaded>().having(
              (s) => s.markingPresenceStatus,
              'markingPresenceStatus',
              MarkingPresenceStatus.loading),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.markingPresenceStatus,
                  'markingPresenceStatus', MarkingPresenceStatus.error)
              .having((s) => s.markingPresenceError,
                  'markingPresenceError', 'Usuário não autenticado'),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits error when mark presence fails',
        build: () {
          when(() => mockAuthRepository.currentUuid)
              .thenAnswer((_) async => '1');
          when(() => mockMeetingPresencesRepository.createAsync(any()))
              .thenAnswer(
                  (_) async => Failure(Exception('Failed to mark presence')));

          return cubit;
        },
        seed: () => MeetingDetailsLoaded(meeting: testMeeting),
        act: (cubit) => cubit.markPresence(isPresent: true),
        expect: () => [
          isA<MeetingDetailsLoaded>().having(
              (s) => s.markingPresenceStatus,
              'markingPresenceStatus',
              MarkingPresenceStatus.loading),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.markingPresenceStatus,
                  'markingPresenceStatus', MarkingPresenceStatus.error)
              .having((s) => s.markingPresenceError,
                  'markingPresenceError', isNotNull),
        ],
      );

      // Note: "does nothing when already marking presence" is not testable
      // because _isMarkingPresence is a private instance field that starts false.
      // The guard only works for concurrent calls within the same cubit instance.

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'does nothing when state is not MeetingDetailsLoaded',
        build: () => cubit,
        act: (cubit) => cubit.markPresence(isPresent: true),
        expect: () => [],
      );
    });

    group('deleteMeeting', () {
      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits deleting then success when delete succeeds',
        build: () {
          when(() => mockMeetingsRepository.delete(1))
              .thenAnswer((_) async => Success(true));

          return cubit;
        },
        seed: () => MeetingDetailsLoaded(meeting: testMeeting),
        act: (cubit) => cubit.deleteMeeting(),
        expect: () => [
          isA<MeetingDetailsLoaded>()
              .having((s) => s.deleteStatus, 'deleteStatus', DeleteStatus.deleting),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.deleteStatus, 'deleteStatus', DeleteStatus.success),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'emits deleting then failure when delete fails',
        build: () {
          when(() => mockMeetingsRepository.delete(1))
              .thenAnswer((_) async => Failure(Exception('Delete failed')));

          return cubit;
        },
        seed: () => MeetingDetailsLoaded(meeting: testMeeting),
        act: (cubit) => cubit.deleteMeeting(),
        expect: () => [
          isA<MeetingDetailsLoaded>()
              .having((s) => s.deleteStatus, 'deleteStatus', DeleteStatus.deleting),
          isA<MeetingDetailsLoaded>()
              .having((s) => s.deleteStatus, 'deleteStatus', DeleteStatus.failure),
        ],
      );

      blocTest<MeetingDetailsCubit, MeetingDetailsState>(
        'does nothing when state is not MeetingDetailsLoaded',
        build: () => cubit,
        act: (cubit) => cubit.deleteMeeting(),
        expect: () => [],
      );
    });
  });
}
