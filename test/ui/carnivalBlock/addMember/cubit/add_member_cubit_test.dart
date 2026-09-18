import 'package:bloco_na_rua/data/repositories/carnivalBlockMembers/icarnival_block_members_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_cubit.dart';
import 'package:bloco_na_rua/ui/carnivalBlock/addMember/cubit/add_member_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockIMembersRepository extends Mock implements IMembersRepository {}

class MockICarnivalBlockMembersRepository extends Mock
    implements ICarnivalBlockMembersRepository {}

void main() {
  late AddMemberCubit addMemberCubit;
  late MockIMembersRepository mockMembersRepository;
  late MockICarnivalBlockMembersRepository mockCarnivalBlockMembersRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockMembersRepository = MockIMembersRepository();
    mockCarnivalBlockMembersRepository = MockICarnivalBlockMembersRepository();
    addMemberCubit = AddMemberCubit(
      membersRepository: mockMembersRepository,
      carnivalBlockMembersRepository: mockCarnivalBlockMembersRepository,
    );
  });

  tearDown(() {
    addMemberCubit.close();
  });

  group('AddMemberCubit', () {
    test('initial state is correct', () {
      expect(addMemberCubit.state.status, AddMemberStatus.initial);
      expect(addMemberCubit.state.allMembers, isEmpty);
      expect(addMemberCubit.state.filteredMembers, isEmpty);
      expect(addMemberCubit.state.searchQuery, isEmpty);
      expect(addMemberCubit.state.errorMessage, isNull);
    });

    blocTest<AddMemberCubit, AddMemberState>(
      'emits loading then success when loadMembers succeeds',
      build: () {
        final members = [
          MembersEntity(id: 1, name: 'Member 1', email: 'member1@test.com'),
          MembersEntity(id: 2, name: 'Member 2', email: 'member2@test.com'),
        ];

        when(() => mockMembersRepository.getAllAsync())
            .thenAnswer((_) async => Success(members));

        return addMemberCubit;
      },
      act: (cubit) => cubit.loadMembers(),
      expect: () => [
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.loading),
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.initial)
            .having((s) => s.allMembers.length, 'allMembers length', 2)
            .having((s) => s.filteredMembers.length, 'filteredMembers length', 2),
      ],
    );

    blocTest<AddMemberCubit, AddMemberState>(
      'emits loading then error when loadMembers fails',
      build: () {
        when(() => mockMembersRepository.getAllAsync())
            .thenAnswer((_) async => Failure(Exception('Erro ao carregar membros.')));

        return addMemberCubit;
      },
      act: (cubit) => cubit.loadMembers(),
      expect: () => [
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.loading),
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'Erro ao carregar membros.'),
      ],
    );

    blocTest<AddMemberCubit, AddMemberState>(
      'emits loading then success when addMember succeeds',
      build: () {
        when(() => mockCarnivalBlockMembersRepository.createAsync(1, 1, 0))
            .thenAnswer((_) async => Success(CarnivalBlockMembersEntity(
                  id: 1,
                  carnivalBlockId: 1,
                  memberId: 1,
                  role: 0,
                )));

        return addMemberCubit;
      },
      act: (cubit) => cubit.addMember(1, 1),
      expect: () => [
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.loading),
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.success),
      ],
    );

    blocTest<AddMemberCubit, AddMemberState>(
      'emits loading then error when addMember fails',
      build: () {
        when(() => mockCarnivalBlockMembersRepository.createAsync(1, 1, 0))
            .thenAnswer(
                (_) async => Failure(Exception('Membro já existe no bloco.')));

        return addMemberCubit;
      },
      act: (cubit) => cubit.addMember(1, 1),
      expect: () => [
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.loading),
        isA<AddMemberState>()
            .having((s) => s.status, 'status', AddMemberStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'Membro já existe no bloco.'),
      ],
    );

    blocTest<AddMemberCubit, AddMemberState>(
      'searchMembers filters by name and email',
      build: () {
        final members = [
          MembersEntity(id: 1, name: 'Alice', email: 'alice@test.com'),
          MembersEntity(id: 2, name: 'Bob', email: 'bob@test.com'),
        ];

        when(() => mockMembersRepository.getAllAsync())
            .thenAnswer((_) async => Success(members));

        return addMemberCubit;
      },
      seed: () => AddMemberState(
        status: AddMemberStatus.initial,
        allMembers: [
          MembersEntity(id: 1, name: 'Alice', email: 'alice@test.com'),
          MembersEntity(id: 2, name: 'Bob', email: 'bob@test.com'),
        ],
        filteredMembers: [
          MembersEntity(id: 1, name: 'Alice', email: 'alice@test.com'),
          MembersEntity(id: 2, name: 'Bob', email: 'bob@test.com'),
        ],
      ),
      act: (cubit) => cubit.searchMembers('alice'),
      expect: () => [
        isA<AddMemberState>()
            .having((s) => s.searchQuery, 'searchQuery', 'alice')
            .having((s) => s.filteredMembers.length, 'filteredMembers length', 1)
            .having((s) => s.filteredMembers[0].name, 'filtered member name', 'Alice'),
      ],
    );

    blocTest<AddMemberCubit, AddMemberState>(
      'searchMembers with empty query shows all members',
      build: () => addMemberCubit,
      seed: () => AddMemberState(
        status: AddMemberStatus.initial,
        searchQuery: 'alice',
        allMembers: [
          MembersEntity(id: 1, name: 'Alice', email: 'alice@test.com'),
          MembersEntity(id: 2, name: 'Bob', email: 'bob@test.com'),
        ],
        filteredMembers: [
          MembersEntity(id: 1, name: 'Alice', email: 'alice@test.com'),
        ],
      ),
      act: (cubit) => cubit.searchMembers(''),
      expect: () => [
        isA<AddMemberState>()
            .having((s) => s.searchQuery, 'searchQuery', '')
            .having((s) => s.filteredMembers.length, 'filteredMembers length', 2),
      ],
    );
  });
}
