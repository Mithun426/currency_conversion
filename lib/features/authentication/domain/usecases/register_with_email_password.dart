import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
class RegisterWithEmailPassword implements UseCase<User, RegisterParams> {
  final AuthRepository repository;
  RegisterWithEmailPassword(this.repository);
  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.registerWithEmailAndPassword(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String? displayName;
  const RegisterParams({
    required this.email,
    required this.password,
    this.displayName,
  });
  @override
  List<Object?> get props => [email, password, displayName];
} 