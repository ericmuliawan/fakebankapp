import 'package:equatable/equatable.dart';

import 'api_error.dart';

sealed class ApiResult<T> extends Equatable {
  const ApiResult();

  factory ApiResult.success(T data) => Success<T>(response: data);

  factory ApiResult.error(ApiError error) => Error<T>(error: error);

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final response) => response,
        _ => null,
      };

  ApiError? get errorOrNull => switch (this) {
        Error<T>(:final error) => error,
        _ => null,
      };
}

class Success<T> extends ApiResult<T> {
  const Success({required this.response});

  final T response;

  @override
  List<Object?> get props => [response];
}

class Error<T> extends ApiResult<T> {
  const Error({required this.error});

  final ApiError error;

  @override
  List<Object?> get props => [error];
}
