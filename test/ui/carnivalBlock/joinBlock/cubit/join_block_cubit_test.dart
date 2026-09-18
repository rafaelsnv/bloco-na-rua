import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/carnivalBlocks/icarnival_blocks_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlock/carnival_blocks_entity.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/domain/use_cases/auth/get_current_user_data.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/joinBlock/cubit/join_block_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockICarnivalBlocksRepository extends Mock
    implements ICarnivalBlocksRepository {}

class MockICarnivalBlockMembersRepository extends Mock
    implements ICarnivalBlockMembersRepository {}

class MockGetCurrentUserData extends Mock implements GetCurrentUserData {}

void main() {
  late MockICarnivalBlocksRepository mockBlocksRepo;
  late MockICarnivalBlockMembersRepository mockMembersRepo;
  late MockGetCurrentUserData mockGetCurrentUserData;

  setUp(() {
    mockBlocksRepo = MockICarnivalBlocksRepository();
    mockMembersRepo = MockICarnivalBlockMembersRepository();
    mockGetCurrentUserData = MockGetCurrentUserData();
  });

  JoinBlockCubit buildCubit() => JoinBlockCubit(
        carnivalBlocksRepository: mockBlocksRepo,
        carnivalBlockMembersRepository: mockMembersRepo,
        getCurrentUserData: mockGetCurrentUserData,
      );

  group('JoinBlockCubit', () {
    test('initial state is JoinBlockInitial', () {
      expect(buildCubit().state, isA<JoinBlockInitial>());
    });

    blocTest<JoinBlockCubit, JoinBlockState>(
      'emits loading then success when join with valid invite code',
      build: () {
        final member = MembersEntity(
          id: 1,
          uuid: 'uuid-123',
          name: 'Test User',
          email: 'test@example.com',
        );
        final block = CarnivalBlocksEntity(
          id: 1,
          ownerId: 2,
          name: 'Test Block',
          inviteCode: 'ABC123',
          managersInviteCode: 'MGR123',
          carnivalBlockImage: '',
        );
        final presence = CarnivalBlockMembersEntity(
          id: 1,
          carnivalBlockId: 1,
          memberId: 1,
          role: 0,
        );

        when(() => mockGetCurrentUserData())
            .thenAnswer((_) async => Success(member));
        when(() => mockBlocksRepo.getByInviteCodeAsync(any()))
            .thenAnswer((_) async => Success(block));
        when(() => mockMembersRepo.createAsync(any(), any(), any()))
            .thenAnswer((_) async => Success(presence));

        return buildCubit();
      },
      act: (cubit) => cubit.joinBlock('ABC123'),
      expect: () => [
        isA<JoinBlockLoading>(),
        isA<JoinBlockSuccess>(),
      ],
    );

    blocTest<JoinBlockCubit, JoinBlockState>(
      'emits error when invite code is empty',
      build: () => buildCubit(),
      act: (cubit) => cubit.joinBlock(''),
      expect: () => [
        isA<JoinBlockError>()
            .having((s) => s.message, 'message', contains('não pode estar vazio')),
      ],
    );

    blocTest<JoinBlockCubit, JoinBlockState>(
      'emits error when getCurrentUserData fails',
      build: () {
        when(() => mockGetCurrentUserData())
            .thenAnswer((_) async => Failure(Exception('User not found')));
        return buildCubit();
      },
      act: (cubit) => cubit.joinBlock('ABC123'),
      expect: () => [
        isA<JoinBlockLoading>(),
        isA<JoinBlockError>().having(
            (s) => s.message, 'message', contains('dados do usuário')),
      ],
    );

    blocTest<JoinBlockCubit, JoinBlockState>(
      'emits error when getByInviteCodeAsync fails',
      build: () {
        final member = MembersEntity(
          id: 1,
          uuid: 'uuid-123',
          name: 'Test User',
          email: 'test@example.com',
        );

        when(() => mockGetCurrentUserData())
            .thenAnswer((_) async => Success(member));
        when(() => mockBlocksRepo.getByInviteCodeAsync(any()))
            .thenAnswer((_) async => Failure(Exception('Block not found')));

        return buildCubit();
      },
      act: (cubit) => cubit.joinBlock('INVALID'),
      expect: () => [
        isA<JoinBlockLoading>(),
        isA<JoinBlockError>()
            .having((s) => s.message, 'message', contains('buscar bloco')),
      ],
    );

    blocTest<JoinBlockCubit, JoinBlockState>(
      'emits error when createAsync fails',
      build: () {
        final member = MembersEntity(
          id: 1,
          uuid: 'uuid-123',
          name: 'Test User',
          email: 'test@example.com',
        );
        final block = CarnivalBlocksEntity(
          id: 1,
          ownerId: 2,
          name: 'Test Block',
          inviteCode: 'ABC123',
          managersInviteCode: 'MGR123',
          carnivalBlockImage: '',
        );

        when(() => mockGetCurrentUserData())
            .thenAnswer((_) async => Success(member));
        when(() => mockBlocksRepo.getByInviteCodeAsync(any()))
            .thenAnswer((_) async => Success(block));
        when(() => mockMembersRepo.createAsync(any(), any(), any()))
            .thenAnswer((_) async => Failure(Exception('Already a member')));

        return buildCubit();
      },
      act: (cubit) => cubit.joinBlock('ABC123'),
      expect: () => [
        isA<JoinBlockLoading>(),
        isA<JoinBlockError>()
            .having((s) => s.message, 'message', contains('entrar no bloco')),
      ],
    );
  });
}
