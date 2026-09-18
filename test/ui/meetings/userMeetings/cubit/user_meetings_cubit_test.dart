import 'package:bloc_test/bloc_test.dart';
import 'package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/meetings/get_user_meetings_use_case.dart';
import 'package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_cubit.dart';
import 'package:bloco_na_rua/ui/meetings/userMeetings/cubit/user_meetings_state.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockGetUserMeetingsUseCase extends Mock
    implements GetUserMeetingsUseCase {}

void main() {
  late UserMeetingsCubit userMeetingsCubit;
  late MockGetUserMeetingsUseCase mockGetUserMeetingsUseCase;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockGetUserMeetingsUseCase = MockGetUserMeetingsUseCase();
    userMeetingsCubit = UserMeetingsCubit(
      getUserMeetingsUseCase: mockGetUserMeetingsUseCase,
    );
  });

  tearDown(() {
    userMeetingsCubit.close();
  });

  group("UserMeetingsCubit", () {
    test("initial state is correct", () {
      expect(userMeetingsCubit.state, const UserMeetingsState());
      expect(userMeetingsCubit.state.status, UserMeetingsStatus.initial);
      expect(userMeetingsCubit.state.meetings, isEmpty);
      expect(userMeetingsCubit.state.errorMessage, isNull);
    });

    blocTest<UserMeetingsCubit, UserMeetingsState>(
      "emits loading then success with meetings",
      build: () {
        final meetings = [
          MeetingsEntity(
            id: 1,
            name: "Meeting 1",
            description: "Description",
            location: "Location",
            meetingDateTime: DateTime.parse("2026-12-25T14:00:00Z"),
            carnivalBlockId: 1,
          ),
        ];

        when(() => mockGetUserMeetingsUseCase())
            .thenAnswer((_) async => Success(meetings));

        return userMeetingsCubit;
      },
      act: (cubit) => cubit.loadMeetings(),
      expect: () => [
        const UserMeetingsState(status: UserMeetingsStatus.loading),
        isA<UserMeetingsState>()
            .having((s) => s.status, "status", UserMeetingsStatus.success)
            .having((s) => s.meetings.length, "meetings length", 1)
            .having((s) => s.meetings.first.name, "meeting name", "Meeting 1"),
      ],
    );

    blocTest<UserMeetingsCubit, UserMeetingsState>(
      "emits loading then failure with error message",
      build: () {
        when(() => mockGetUserMeetingsUseCase())
            .thenAnswer((_) async => Failure(Exception("Network error")));

        return userMeetingsCubit;
      },
      act: (cubit) => cubit.loadMeetings(),
      expect: () => [
        const UserMeetingsState(status: UserMeetingsStatus.loading),
        isA<UserMeetingsState>()
            .having((s) => s.status, "status", UserMeetingsStatus.failure)
            .having((s) => s.errorMessage, "errorMessage", isNotNull),
      ],
    );
  });
}
