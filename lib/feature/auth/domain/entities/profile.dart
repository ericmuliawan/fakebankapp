import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.email,
    required this.balance,
    required this.fullName,
    required this.accountNumber,
  });

  final int id;
  final String email;
  final double balance;
  final String fullName;
  final String accountNumber;

  String get firstName => fullName.trim().isEmpty
      ? 'there'
      : fullName.trim().split(RegExp(r'\s+')).first;

  String get initials {
    final names = fullName.trim().split(RegExp(r'\s+'));
    if (names.isEmpty) return '?';
    if (names.length == 1) return names.first.substring(0, 1).toUpperCase();
    return (names.first.substring(0, 1) + names.last.substring(0, 1))
        .toUpperCase();
  }

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return accountNumber.substring(accountNumber.length - 4);
  }

  @override
  List<Object?> get props => [id, email, balance, fullName, accountNumber];
}