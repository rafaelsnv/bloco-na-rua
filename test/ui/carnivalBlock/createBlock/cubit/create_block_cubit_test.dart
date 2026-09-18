import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/createBlock/cubit/create_block_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockICarnivalBlocksRepository extends Mock
    implements ICarnivalBlocksRepository {}

class MockGetCurrentUserData extends Mock implements GetCurrentUserData {}

void main() {
  late CreateBlockCubit createBlockCubit;
  late MockICarnivalBlocksRepository mockRepository;
  late MockGetCurrentUserData mockGetCurrentUserData;

  setUpAll(() {
    // Register fallback values for result types used in mock stubs
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockRepository = MockICarnivalBlocksRepository();
    mockGetCurrentUserData = MockGetCurrentUserData();
    createBlockCubit = CreateBlockCubit(
      carnivalBlocksRepository: mockRepository,
      getCurrentUserData: mockGetCurrentUserData,
    );
  });

  tearDown(() {
    createBlockCubit.close();
  });

  group('CreateBlockCubit', () {
    test('initial state is CreateBlockInitial', () {
      expect(createBlockCubit.state, isA<CreateBlockInitial>());
    });

    blocTest<CreateBlockCubit, CreateBlockState>(
      'emits loading then success when createBlock succeeds',
      build: () {
        final member = MembersEntity(
          id: 1,
          uuid: 'uuid-123',
          name: 'Test User',
          email: 'test@example.com',
        );

        when(() => mockGetCurrentUserData())
            .thenAnswer((_) async => Success(member));
        when(() => mockRepository.createAsync(any())).thenAnswer(
          (_) async => Success(
            CarnivalBlocksEntity(
              id: 42,
              ownerId: 1,
              name: 'Block Name',
              inviteCode: 'INV123',
              managersInviteCode: 'MGR123',
              carnivalBlockImage: '',
            ),
          ),
        );

        return createBlockCubit;
      },
      act: (cubit) => cubit.createBlock('Block Name'),
      expect: () => [
        isA<CreateBlockLoading>(),
        isA<CreateBlockSuccess>().having((s) => s.blockId, 'blockId', 42),
      ],
      verify: (_) {
        verify(() => mockGetCurrentUserData()).called(1);
        verify(() => mockRepository.createAsync(any())).called(1);
      },
    );

    blocTest<CreateBlockCubit, CreateBlockState>(
      'emits loading then error when getCurrentUserData fails',
      build: () {
        when(() => mockGetCurrentUserData())
            .thenAnswer((_) async => Failure(Exception('User not found')));
        return createBlockCubit;
      },
      act: (cubit) => cubit.createBlock('Block Name'),
      expect: () => [
        isA<CreateBlockLoading>(),
        isA<CreateBlockError>(),
      ],
    );

    blocTest<CreateBlockCubit, CreateBlockState>(
      'emits loading then error when createAsync fails',
      build: () {
        final member = MembersEntity(
          id: 1,
          uuid: 'uuid-123',
          name: 'Test User',
          email: 'test@example.com',
        );

        when(() => mockGetCurrentUserData())
            .thenAnswer((_) async => Success(member));
        when(() => mockRepository.createAsync(any()))
            .thenAnswer((_) async => Failure(Exception('Network error')));

        return createBlockCubit;
      },
      act: (cubit) => cubit.createBlock('Block Name'),
      expect: () => [
        isA<CreateBlockLoading>(),
        isA<CreateBlockError>(),
      ],
    );

    blocTest<CreateBlockCubit, CreateBlockState>(
      'does not emit loading when already loading',
      build: () {
        when(() => mockGetCurrentUserData()).thenAnswer(
          (_) => Future.delayed(
            const Duration(seconds: 10),
            () => Success(
              MembersEntity(
                id: 1,
                uuid: 'uuid-123',
                name: 'Test User',
                email: 'test@example.com',
              ),
            ),
          ),
        );
        return createBlockCubit;
      },
      act: (cubit) async {
        cubit.createBlock('Block Name');
        await Future<void>.delayed(const Duration(milliseconds: 50));
        cubit.createBlock('Block Name 2');
      },
      expect: () => [
        isA<CreateBlockLoading>(),
      ],
    );
  });
}
