import 'package:bloc_test/bloc_test.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/repositories/members/imembers_repository.dart';
import 'package:bloco_na_rua/domain/entities/members/members_entity.dart';
import 'package:bloco_na_rua/ui/profile/cubit/profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockIMembersRepository extends Mock implements IMembersRepository {}

void main() {
  late ProfileCubit profileCubit;
  late MockIAuthRepository mockAuthRepository;
  late MockIMembersRepository mockMembersRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockAuthRepository = MockIAuthRepository();
    mockMembersRepository = MockIMembersRepository();
    profileCubit = ProfileCubit(
      authRepository: mockAuthRepository,
      membersRepository: mockMembersRepository,
    );
  });

  tearDown(() {
    profileCubit.close();
  });

  group('ProfileCubit', () {
    test('initial state is ProfileState.initial', () {
      expect(profileCubit.state, const ProfileState.initial());
    });

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then loaded when loadProfile succeeds',
      build: () {
        final member = MembersEntity(
          id: 1,
          name: 'John Doe',
          email: 'john@example.com',
          phone: '+1234567890',
          uuid: 'test-uuid-123',
        );

        when(() => mockAuthRepository.currentUuid)
            .thenAnswer((_) async => 'test-uuid-123');
        when(() => mockMembersRepository.getByUuidAsync('test-uuid-123'))
            .thenAnswer((_) async => Success(member));

        return profileCubit;
      },
      act: (cubit) => cubit.loadProfile(),
      expect: () => [
        const ProfileState.loading(),
        isA<ProfileState>().having(
          (s) => s.maybeWhen(
            loaded: (v) => v.name,
            orElse: () => null,
          ),
          'loaded member name',
          'John Doe',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits error when uuid is null',
      build: () {
        when(() => mockAuthRepository.currentUuid)
            .thenAnswer((_) async => null);
        return profileCubit;
      },
      act: (cubit) => cubit.loadProfile(),
      expect: () => [
        const ProfileState.loading(),
        isA<ProfileState>().having(
          (s) => s.maybeWhen(
            error: (v) => v,
            orElse: () => null,
          ),
          'error message',
          'Usuário não autenticado',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then error when loadProfile fails',
      build: () {
        when(() => mockAuthRepository.currentUuid)
            .thenAnswer((_) async => 'test-uuid-123');
        when(() => mockMembersRepository.getByUuidAsync('test-uuid-123'))
            .thenAnswer((_) async => Failure(Exception('Network error')));

        return profileCubit;
      },
      act: (cubit) => cubit.loadProfile(),
      expect: () => [
        const ProfileState.loading(),
        isA<ProfileState>().having(
          (s) => s.maybeWhen(
            error: (v) => v,
            orElse: () => null,
          ),
          'error message',
          'Network error',
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then initial when logout succeeds',
      build: () {
        when(() => mockAuthRepository.logout())
            .thenAnswer((_) async => const Success(unit));
        return profileCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const ProfileState.loading(),
        const ProfileState.initial(),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits loading then error when logout fails',
      build: () {
        when(() => mockAuthRepository.logout())
            .thenAnswer((_) async => Failure(Exception('Logout failed')));

        return profileCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const ProfileState.loading(),
        isA<ProfileState>().having(
          (s) => s.maybeWhen(
            error: (v) => v,
            orElse: () => null,
          ),
          'error message',
          'Logout failed',
        ),
      ],
    );
  });
}
