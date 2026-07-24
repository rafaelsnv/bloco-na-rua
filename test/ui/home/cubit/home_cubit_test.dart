import "package:bloc_test/bloc_test.dart";
import "package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart";
import "package:bloco_na_rua/domain/entities/meetings/meetings_entity.dart";
import "package:bloco_na_rua/domain/use_cases/home/get_home_data_use_case.dart";
import "package:bloco_na_rua/ui/home/cubit/home_cubit.dart";
import "package:bloco_na_rua/ui/home/cubit/home_state.dart";
import "package:mocktail/mocktail.dart";
import "package:result_dart/result_dart.dart";
import "package:test/test.dart";

class MockGetHomeDataUseCase extends Mock implements GetHomeDataUseCase {}

void main() {
  late HomeCubit homeCubit;
  late MockGetHomeDataUseCase mockGetHomeDataUseCase;

  setUp(() {
    mockGetHomeDataUseCase = MockGetHomeDataUseCase();
    homeCubit = HomeCubit(getHomeDataUseCase: mockGetHomeDataUseCase);
  });

  tearDown(() {
    homeCubit.close();
  });

  group("HomeCubit", () {
    test("initial state is correct", () {
      expect(homeCubit.state, const HomeState());
      expect(homeCubit.state.status, HomeStatus.initial);
      expect(homeCubit.state.blocks, isEmpty);
      expect(homeCubit.state.meetings, isEmpty);
    });

    blocTest<HomeCubit, HomeState>(
      "emits loading then success with blocks and meetings",
      build: () {
        final blocks = [
          CarnivalBlocksEntity(
            id: 1,
            ownerId: 1,
            name: "Block 1",
            inviteCode: "ABC123",
            managersInviteCode: "MANAGER123",
            carnivalBlockImage: "image.png",
          ),
        ];

        final meetings = [
          MeetingsEntity(
            id: 1,
            name: "Meeting 1",
            description: "Description",
            location: "Location",
            meetingDateTime: "2026-12-25T14:00:00Z",
            carnivalBlockId: 1,
          ),
        ];

        when(
          () => mockGetHomeDataUseCase.getCarnivalBlocks(),
        ).thenAnswer((_) async => Success(blocks));
        when(
          () => mockGetHomeDataUseCase.getMeetings(),
        ).thenAnswer((_) async => Success(meetings));

        return homeCubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, "status", HomeStatus.success)
            .having((s) => s.blocks.length, "blocks length", 1)
            .having((s) => s.meetings.length, "meetings length", 1),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      "emits failure when blocks fail",
      build: () {
        when(
          () => mockGetHomeDataUseCase.getCarnivalBlocks(),
        ).thenAnswer((_) async => Failure(Exception("Network error")));
        when(
          () => mockGetHomeDataUseCase.getMeetings(),
        ).thenAnswer((_) async => Success([]));

        return homeCubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, "status", HomeStatus.failure)
            .having((s) => s.errorMessage, "errorMessage", isNotNull),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      "skips meetings with malformed date without crashing",
      build: () {
        final blocks = <CarnivalBlocksEntity>[];

        // Meeting with malformed date should be skipped
        final meetingsWithMalformedDate = [
          MeetingsEntity(
            id: 1,
            name: "Meeting 1",
            description: "Description 1",
            location: "Location 1",
            meetingDateTime: "not-a-valid-date",
            carnivalBlockId: 1,
          ),
          // Valid meeting
          MeetingsEntity(
            id: 2,
            name: "Meeting 2",
            description: "Description 2",
            location: "Location 2",
            meetingDateTime: "2026-12-25T14:00:00Z",
            carnivalBlockId: 1,
          ),
        ];

        when(
          () => mockGetHomeDataUseCase.getCarnivalBlocks(),
        ).thenAnswer((_) async => Success(blocks));
        when(
          () => mockGetHomeDataUseCase.getMeetings(),
        ).thenAnswer((_) async => Success(meetingsWithMalformedDate));

        return homeCubit;
      },
      act: (cubit) => cubit.loadHomeData(),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        isA<HomeState>()
            .having((s) => s.status, "status", HomeStatus.success)
            .having(
              (s) => s.meetings.length,
              "filtered meetings length",
              1, // Only the valid meeting should be included
            ),
      ],
    );
  });
}
