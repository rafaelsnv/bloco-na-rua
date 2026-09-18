import 'package:bloco_na_rua/api/bloco_na_rua.models.swagger.dart';
import 'package:bloco_na_rua/data/repositories/auth/auth_listenable.dart';
import 'package:bloco_na_rua/data/repositories/auth/iauth_repository.dart';
import 'package:bloco_na_rua/data/services/auth/models/signup_request/signup_request.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

class MockAuthListenable extends Mock implements AuthListenable {}

const _fallbackSignUpRequest = SignUpRequest(
  name: 'fallback',
  email: 'fallback@test.com',
  phone: '000000000',
  password: 'fallback',
);

void main() {
  late MockIAuthRepository mockIAuthRepository;
  late MockAuthListenable mockAuthListenable;
  late AuthCubit authCubit;

  setUpAll(() {
    registerFallbackValue(_fallbackSignUpRequest);
  });

  setUp(() {
    mockIAuthRepository = MockIAuthRepository();
    mockAuthListenable = MockAuthListenable();
    authCubit = AuthCubit(
      authRepository: mockIAuthRepository,
      authListenable: mockAuthListenable,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, isA<AuthInitial>());
    });

    group('login', () {
      blocTest<AuthCubit, AuthState>(
        'emits loading then authenticated on login success',
        build: () {
          when(() => mockIAuthRepository.login(
                email: any(named: 'email'),
                password: any(named: 'password'),
                phone: any(named: 'phone'),
              )).thenAnswer((_) async => const Success(LoginResponse(
                accessToken: 'token',
                userId: 'uuid',
              )));
          when(() => mockAuthListenable.notify()).thenReturn(null);
          return authCubit;
        },
        act: (cubit) => cubit.login('test@example.com', 'password123'),
        expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
        verify: (_) {
          verify(() => mockAuthListenable.notify()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then failure on login error',
        build: () {
          when(() => mockIAuthRepository.login(
                email: any(named: 'email'),
                password: any(named: 'password'),
                phone: any(named: 'phone'),
              )).thenAnswer(
                  (_) async => Failure(Exception('Invalid credentials')));
          return authCubit;
        },
        act: (cubit) => cubit.login('test@example.com', 'wrongpassword'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having((s) => s.message, 'message', 'Invalid credentials'),
        ],
        verify: (_) {
          verifyNever(() => mockAuthListenable.notify());
        },
      );
    });

    group('signUp', () {
      const signUpRequest = SignUpRequest(
        name: 'John Doe',
        email: 'john@example.com',
        phone: '123456789',
        password: 'password123',
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then email verification sent on signUp success',
        build: () {
          when(() => mockIAuthRepository.signUp(any()))
              .thenAnswer((_) async => const Success(LoginResponse(
                    accessToken: 'token',
                    userId: 'uuid',
                  )));
          when(() => mockAuthListenable.notify()).thenReturn(null);
          return authCubit;
        },
        act: (cubit) => cubit.signUp(signUpRequest),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthEmailVerificationSent>()
              .having((s) => s.email, 'email', signUpRequest.email),
        ],
        verify: (_) {
          verify(() => mockAuthListenable.notify()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then failure on signUp error',
        build: () {
          when(() => mockIAuthRepository.signUp(any()))
              .thenAnswer((_) async => Failure(Exception('Email already exists')));
          return authCubit;
        },
        act: (cubit) => cubit.signUp(signUpRequest),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>()
              .having((s) => s.message, 'message', 'Email already exists'),
        ],
        verify: (_) {
          verifyNever(() => mockAuthListenable.notify());
        },
      );
    });

    group('logout', () {
      blocTest<AuthCubit, AuthState>(
        'emits loading then unauthenticated on logout success',
        build: () {
          when(() => mockIAuthRepository.logout())
              .thenAnswer((_) async => const Success(unit));
          when(() => mockAuthListenable.notify()).thenReturn(null);
          return authCubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
        verify: (_) {
          verify(() => mockAuthListenable.notify()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then failure on logout error',
        build: () {
          when(() => mockIAuthRepository.logout())
              .thenAnswer((_) async => Failure(Exception('Logout failed')));
          return authCubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>()
              .having((s) => s.message, 'message', 'Logout failed'),
        ],
        verify: (_) {
          verifyNever(() => mockAuthListenable.notify());
        },
      );
    });

    group('resendVerification', () {
      blocTest<AuthCubit, AuthState>(
        'emits loading then success with message on resendVerification success',
        build: () {
          when(() => mockIAuthRepository.resendVerification(any()))
              .thenAnswer((_) async => const Success(unit));
          return authCubit;
        },
        act: (cubit) => cubit.resendVerification('test@example.com'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>()
              .having((s) => s.message, 'message', 'E-mail de verificação reenviado!'),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then failure on resendVerification error',
        build: () {
          when(() => mockIAuthRepository.resendVerification(any()))
              .thenAnswer(
                  (_) async => Failure(Exception('Failed to resend')));
          return authCubit;
        },
        act: (cubit) => cubit.resendVerification('test@example.com'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>()
              .having((s) => s.message, 'message', 'Failed to resend'),
        ],
      );
    });

    group('resetPassword', () {
      blocTest<AuthCubit, AuthState>(
        'emits loading then success with message on resetPassword success',
        build: () {
          when(() => mockIAuthRepository.resetPassword(any()))
              .thenAnswer((_) async => const Success(unit));
          when(() => mockAuthListenable.notify()).thenReturn(null);
          return authCubit;
        },
        act: (cubit) => cubit.resetPassword('test@example.com'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>()
              .having((s) => s.message, 'message', 'E-mail de recuperação enviado!'),
        ],
        verify: (_) {
          verify(() => mockAuthListenable.notify()).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits loading then failure on resetPassword error',
        build: () {
          when(() => mockIAuthRepository.resetPassword(any()))
              .thenAnswer(
                  (_) async => Failure(Exception('Failed to reset password')));
          return authCubit;
        },
        act: (cubit) => cubit.resetPassword('test@example.com'),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
              (s) => s.message, 'message', 'Failed to reset password'),
        ],
        verify: (_) {
          verifyNever(() => mockAuthListenable.notify());
        },
      );
    });
  });
}
