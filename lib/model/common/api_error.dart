import 'package:equatable/equatable.dart';

class ApiError extends Equatable {
  const ApiError({
    this.code,
    this.message,
  });

  final int? code;
  final String? message;

  @override
  List<Object?> get props => [code, message];
}
