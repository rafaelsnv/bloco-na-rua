import 'package:bloc_test/bloc_test.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_cubit.dart';
import 'package:bloco_na_rua/ui/members/cubit/members_state.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:test/test.dart';

class MockIMembersRepository extends Mock implements IMembersRepository {}

void main() {
  late MembersCubit membersCubit;
  late MockIMembersRepository mockMembersRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockMembersRepository = MockIMembersRepository();
    membersCubit = MembersCubit(membersRepository: mockMembersRepository);
  });

  tearDown(() {
    membersCubit.close();
  });

  group("MembersCubit", () {
    test("initial state is correct", () {
      expect(membersCubit.state, const MembersState());
      expect(membersCubit.state.status, MembersStatus.initial);
      expect(membersCubit.state.members, isEmpty);
      expect(membersCubit.state.errorMessage, isNull);
    });

    blocTest<MembersCubit, MembersState>(
      "emits loading then success with members",
      build: () {
        final members = [
          MembersEntity(
            id: 1,
            name: "Member 1",
            email: "member1@test.com",
            phone: "123456789",
            uuid: "uuid-1",
          ),
          MembersEntity(
            id: 2,
            name: "Member 2",
            email: "member2@test.com",
            phone: "987654321",
            uuid: "uuid-2",
          ),
        ];

        when(
          () => mockMembersRepository.getAllAsync(),
        ).thenAnswer((_) async => Success(members));

        return membersCubit;
      },
      act: (cubit) => cubit.loadMembers(),
      expect: () => [
        const MembersState(status: MembersStatus.loading),
        isA<MembersState>()
            .having((s) => s.status, "status", MembersStatus.success)
            .having((s) => s.members.length, "members length", 2)
            .having((s) => s.errorMessage, "errorMessage", isNull),
      ],
    );

    blocTest<MembersCubit, MembersState>(
      "emits loading then error with message",
      build: () {
        when(
          () => mockMembersRepository.getAllAsync(),
        ).thenAnswer(
          (_) async => Failure(Exception("Network error")),
        );

        return membersCubit;
      },
      act: (cubit) => cubit.loadMembers(),
      expect: () => [
        const MembersState(status: MembersStatus.loading),
        isA<MembersState>()
            .having((s) => s.status, "status", MembersStatus.error)
            .having((s) => s.members, "members", isEmpty)
            .having(
              (s) => s.errorMessage,
              "errorMessage",
              'Membros devem ser carregados por bloco. '
              'Contate o suporte se o problema persistir.',
            ),
      ],
    );
  });
}
