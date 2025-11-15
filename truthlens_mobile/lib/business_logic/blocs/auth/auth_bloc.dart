import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:truthlens_mobile/data/model/auth/login_request.dart';
import 'package:truthlens_mobile/data/model/user_model.dart';
import 'package:truthlens_mobile/data/model/auth/signup_request.dart';
import 'package:truthlens_mobile/data/repositories/auth_repo.dart';
import '../../../core/errors/exceptions.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial()) {
    // Register event handlers
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<AutoLoginRequested>(_onAutoLoginRequested);
    on<RefreshTokenRequested>(_onRefreshTokenRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
  }

  // Login Handler
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Validate input
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError(message: 'Email and password are required'));
        return;
      }

      if (!_isValidEmail(event.email)) {
        emit(const AuthError(message: 'Please enter a valid email'));
        return;
      }

      // Create login request
      final request = LoginRequest(
        email: event.email.trim(),
        password: event.password,
      );

      // Call repository
      final response = await _authRepository.login(request);

      if (response.success && response.data != null) {
        // Save token
        await _authRepository.saveToken(response.data!.token);
        if (response.data!.refreshToken != null) {
          await _authRepository.saveRefreshToken(response.data!.refreshToken!);
        }

        // Convert API user to domain UserModel then emit authenticated state
        final apiUser = response.data!.user;
        final userModel = UserModel(
          id: apiUser.id,
          email: apiUser.email,
          fullName: apiUser.fullName,
          profilePicture: apiUser.profilePicture,
          createdAt: apiUser.createdAt,
        );

        emit(Authenticated(user: userModel, token: response.data!.token));
      } else {
        emit(AuthError(message: response.message));
      }
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError(message: e.message));
    } on TimeoutException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Signup Handler
  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Validate input
      if (event.fullName.isEmpty ||
          event.email.isEmpty ||
          event.password.isEmpty ||
          event.confirmPassword.isEmpty) {
        emit(const AuthError(message: 'All fields are required'));
        return;
      }

      if (!_isValidEmail(event.email)) {
        emit(const AuthError(message: 'Please enter a valid email'));
        return;
      }

      if (event.password.length < 8) {
        emit(
          const AuthError(message: 'Password must be at least 8 characters'),
        );
        return;
      }

      if (event.password != event.confirmPassword) {
        emit(const AuthError(message: 'Passwords do not match'));
        return;
      }

      // Create signup request
      final request = SignupRequest(
        fullName: event.fullName.trim(),
        email: event.email.trim(),
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      // Call repository
      final response = await _authRepository.signup(request);

      if (response.success && response.data != null) {
        // Save token
        await _authRepository.saveToken(response.data!.token);
        if (response.data!.refreshToken != null) {
          await _authRepository.saveRefreshToken(response.data!.refreshToken!);
        }

        // Convert API user to domain UserModel then emit authenticated state
        final apiUser = response.data!.user;
        final userModel = UserModel(
          id: apiUser.id,
          email: apiUser.email,
          fullName: apiUser.fullName,
          profilePicture: apiUser.profilePicture,
          createdAt: apiUser.createdAt,
        );

        emit(Authenticated(user: userModel, token: response.data!.token));
      } else {
        emit(AuthError(message: response.message));
      }
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError(message: e.message));
    } on TimeoutException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  // Logout Handler
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Call repository to logout (optional API call)
      await _authRepository.logout();

      // Emit unauthenticated state
      emit(const Unauthenticated(message: 'Logged out successfully'));
    } catch (e) {
      // Even if logout fails, clear local data
      await _authRepository.clearLocalData();
      emit(const Unauthenticated(message: 'Logged out'));
    }
  }

  // Check Auth Status Handler
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // Get stored user data
        final token = await _authRepository.getToken();
        final user = await _authRepository.getCurrentUser();

        if (token != null && user != null) {
          emit(Authenticated(user: user, token: token));
        } else {
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  // Auto Login Handler
  Future<void> _onAutoLoginRequested(
    AutoLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        final token = await _authRepository.getToken();
        final user = await _authRepository.getCurrentUser();

        if (token != null && user != null) {
          emit(Authenticated(user: user, token: token));
        } else {
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  // Refresh Token Handler
  Future<void> _onRefreshTokenRequested(
    RefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final refreshToken = await _authRepository.getRefreshToken();
      if (refreshToken == null) {
        emit(const Unauthenticated(message: 'Session expired'));
        return;
      }

      // TODO: Call refresh token API
      // final newToken = await _authRepository.refreshToken(refreshToken);
      // await _authRepository.saveToken(newToken);

      // For now, just check current state
      final token = await _authRepository.getToken();
      final user = await _authRepository.getCurrentUser();

      if (token != null && user != null) {
        emit(Authenticated(user: user, token: token));
      } else {
        emit(const Unauthenticated(message: 'Session expired'));
      }
    } catch (e) {
      emit(const Unauthenticated(message: 'Session expired'));
    }
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Google Login Handler
  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authRepository.loginWithGoogle();

      // If response is null or failed
      if (!response.success) {
        emit(AuthError(message: response.message));
        return;
      }

      final data = response.data;
      if (data == null) {
        emit(const AuthError(message: "Missing login data from server"));
        return;
      }

      final token = data.token;
      final apiUser = data.user;

      // Save token
      await _authRepository.saveToken(token);
      if (data.refreshToken != null) {
        await _authRepository.saveRefreshToken(data.refreshToken!);
      }

      // Convert API user to domain UserModel
      final userModel = UserModel(
        id: apiUser.id,
        email: apiUser.email,
        fullName: apiUser.fullName,
        profilePicture: apiUser.profilePicture ?? '',
        createdAt: apiUser.createdAt ?? DateTime.now(),
      );

      emit(Authenticated(user: userModel, token: token));
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError(message: e.message));
    } on TimeoutException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e, st) {
      // catch any unexpected error
      debugPrint('Google Login Error: $e');
      debugPrintStack(stackTrace: st);
      emit(AuthError(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
