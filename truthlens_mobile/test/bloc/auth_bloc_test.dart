
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:truthlens_mobile/business_logic/blocs/auth/auth_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_event.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_state.dart';
import 'package:truthlens_mobile/data/model/auth/login_response.dart';
import 'package:truthlens_mobile/data/model/user_model.dart';
import 'package:truthlens_mobile/data/repositories/auth_repo.dart';

import 'auth_bloc_test.mocks.dart';
@GenerateMocks([AuthRepository])
void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('LoginRequested', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';
      
      final testUser = UserModel(
        id: 1,
        email: testEmail,
        fullName: 'Test User',
      );
      
      final testLoginResponse = LoginResponse(
        success: true,
        message: 'Login successful',
        data: LoginData(
          user: UserInfo(
            id: 1,
            email: testEmail,
            fullName: 'Test User',
          ),
          token: 'test_token',
        ),
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when login succeeds',
        build: () {
          when(mockAuthRepository.login(any))
              .thenAnswer((_) async => testLoginResponse);
          when(mockAuthRepository.saveToken(any))
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const LoginRequested(
            email: testEmail,
            password: testPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          Authenticated(user: testUser, token: 'test_token'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when email is empty',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const LoginRequested(
            email: '',
            password: testPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Email and password are required'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when email is invalid',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const LoginRequested(
            email: 'invalid-email',
            password: testPassword,
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Please enter a valid email'),
        ],
      );
    });

    group('SignupRequested', () {
      const testFullName = 'John Doe';
      const testEmail = 'john@example.com';
      const testPassword = 'password123';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when passwords do not match',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const SignupRequested(
            fullName: testFullName,
            email: testEmail,
            password: testPassword,
            confirmPassword: 'different_password',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Passwords do not match'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when password is too short',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const SignupRequested(
            fullName: testFullName,
            email: testEmail,
            password: '123',
            confirmPassword: '123',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Password must be at least 8 characters'),
        ],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when logout succeeds',
        build: () {
          when(mockAuthRepository.logout())
              .thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutRequested()),
        expect: () => [
          const AuthLoading(),
          const Unauthenticated(message: 'Logged out successfully'),
        ],
      );
    });

    group('CheckAuthStatus', () {
      final testUser = UserModel(
        id: 1,
        email: 'test@example.com',
        fullName: 'Test User',
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when user is logged in',
        build: () {
          when(mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => true);
          when(mockAuthRepository.getToken())
              .thenAnswer((_) async => 'test_token');
          when(mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthLoading(),
          Authenticated(user: testUser, token: 'test_token'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when user is not logged in',
        build: () {
          when(mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => false);
          return authBloc;
        },
        act: (bloc) => bloc.add(const CheckAuthStatus()),
        expect: () => [
          const AuthLoading(),
          const Unauthenticated(),
        ],
      );
    });
  });
}