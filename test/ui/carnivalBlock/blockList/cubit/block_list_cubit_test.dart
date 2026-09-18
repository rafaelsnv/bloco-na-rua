import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/home/get_home_data_use_case.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/blockList/cubit/block_list_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockGetHomeDataUseCase extends Mock implements GetHomeDataUseCase {}

void main() {
  late MockGetHomeDataUseCase mockGetHomeDataUseCase;
  late BlockListCubit blockListCubit;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockGetHomeDataUseCase = MockGetHomeDataUseCase();
    blockListCubit = BlockListCubit(getHomeDataUseCase: mockGetHomeDataUseCase);
  });

  tearDown(() {
    blockListCubit.close();
  });

  group('BlockListCubit', () {
    test('initial state is correct', () {
      expect(blockListCubit.state, BlockListState.initial());
      expect(blockListCubit.state.status, BlockListStatus.initial);
      expect(blockListCubit.state.blocks, isEmpty);
      expect(blockListCubit.state.errorMessage, isNull);
    });

    blocTest<BlockListCubit, BlockListState>(
      'emits loading then success with blocks on loadBlocks success',
      build: () {
        final blocks = [
          CarnivalBlocksEntity(
            id: 1,
            ownerId: 1,
            name: 'Block 1',
            inviteCode: 'ABC123',
            managersInviteCode: 'MANAGER123',
            carnivalBlockImage: 'image.png',
          ),
          CarnivalBlocksEntity(
            id: 2,
            ownerId: 1,
            name: 'Block 2',
            inviteCode: 'DEF456',
            managersInviteCode: 'MANAGER456',
            carnivalBlockImage: 'image2.png',
          ),
        ];

        when(() => mockGetHomeDataUseCase.getCarnivalBlocks())
            .thenAnswer((_) async => Success(blocks));
        return blockListCubit;
      },
      act: (cubit) => cubit.loadBlocks(),
      expect: () => [
        isA<BlockListState>()
            .having((s) => s.status, 'status', BlockListStatus.loading),
        isA<BlockListState>()
            .having((s) => s.status, 'status', BlockListStatus.success)
            .having((s) => s.blocks.length, 'blocks length', 2)
            .having((s) => s.blocks[0].name, 'first block name', 'Block 1'),
      ],
    );

    blocTest<BlockListCubit, BlockListState>(
      'emits loading then failure with error message on loadBlocks error',
      build: () {
        when(() => mockGetHomeDataUseCase.getCarnivalBlocks())
            .thenAnswer((_) async => Failure(Exception('Network error')));
        return blockListCubit;
      },
      act: (cubit) => cubit.loadBlocks(),
      expect: () => [
        isA<BlockListState>()
            .having((s) => s.status, 'status', BlockListStatus.loading),
        isA<BlockListState>()
            .having((s) => s.status, 'status', BlockListStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Network error'),
      ],
    );

    blocTest<BlockListCubit, BlockListState>(
      'emits empty list on success with no blocks',
      build: () {
        when(() => mockGetHomeDataUseCase.getCarnivalBlocks())
            .thenAnswer((_) async => const Success([]));
        return blockListCubit;
      },
      act: (cubit) => cubit.loadBlocks(),
      expect: () => [
        isA<BlockListState>()
            .having((s) => s.status, 'status', BlockListStatus.loading),
        isA<BlockListState>()
            .having((s) => s.status, 'status', BlockListStatus.success)
            .having((s) => s.blocks, 'blocks', isEmpty),
      ],
    );
  });
}
