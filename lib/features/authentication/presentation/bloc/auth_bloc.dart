import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/session_manager.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/register_with_email_password.dart';
import '../../domain/usecases/sign_in_with_email_password.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailPassword signInWithEmailPassword;
  final RegisterWithEmailPassword registerWithEmailPassword;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final AuthRepository authRepository;

  late StreamSubscription _authStateSubscription;

  AuthBloc({
    required this.signInWithEmailPassword,
    required this.registerWithEmailPassword,
    required this.signOut,
    required this.getCurrentUser,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);

    // Listen to auth state changes
    _authStateSubscription = authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUser(const NoParams());

    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signInWithEmailPassword(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    await result.fold(
      (failure) async => emit(AuthError(message: _getFailureMessage(failure))),
      (user) async {
        await SessionManager.setLoggedIn(true);
        if (!emit.isDone) {
          emit(AuthAuthenticated(user: user));
        }
      },
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerWithEmailPassword(
      RegisterParams(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      ),
    );

    await result.fold(
      (failure) async => emit(AuthError(message: _getFailureMessage(failure))),
      (user) async {
        await SessionManager.setLoggedIn(true);
        if (!emit.isDone) {
          emit(AuthAuthenticated(user: user));
        }
      },
    );
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signOut(const NoParams());

    await result.fold(
      (failure) async => emit(AuthError(message: _getFailureMessage(failure))),
      (_) async {
        await SessionManager.logout();
        if (!emit.isDone) {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.sendPasswordResetEmail(email: event.email);

    result.fold(
      (failure) => emit(AuthError(message: _getFailureMessage(failure))),
      (_) {
        if (!emit.isDone) {
          emit(AuthPasswordResetEmailSent(email: event.email));
        }
      },
    );
  }

  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred';
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
} 