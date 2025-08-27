import 'package:equatable/equatable.dart';
class User extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.emailVerified,
  });
  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, emailVerified];
} 