import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rml_fakebank_app/common/local_storage_provider.dart';
import 'package:rml_fakebank_app/common/network/api_header_interceptor.dart';
import 'package:rml_fakebank_app/common/network/api_logger_interceptor.dart';
import 'package:rml_fakebank_app/common/network/auth_interceptor.dart';
import 'package:rml_fakebank_app/common/network/base_provider.dart';
import 'package:rml_fakebank_app/common/realtime/reverb_config_provider.dart';
import 'package:rml_fakebank_app/common/realtime/reverb_service.dart';
import 'package:rml_fakebank_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:rml_fakebank_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:rml_fakebank_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:rml_fakebank_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:rml_fakebank_app/feature/history/data/datasources/history_remote_datasource.dart';
import 'package:rml_fakebank_app/feature/history/data/repositories/history_repository_impl.dart';
import 'package:rml_fakebank_app/feature/history/domain/repositories/history_repository.dart';
import 'package:rml_fakebank_app/feature/transfer/data/datasources/transfer_remote_datasource.dart';
import 'package:rml_fakebank_app/feature/transfer/data/repositories/transfer_repository_impl.dart';
import 'package:rml_fakebank_app/feature/transfer/domain/repositories/transfer_repository.dart';
import 'package:rml_fakebank_app/feature/topup/data/datasources/topup_remote_datasource.dart';
import 'package:rml_fakebank_app/feature/topup/data/repositories/topup_repository_impl.dart';
import 'package:rml_fakebank_app/feature/topup/domain/repositories/topup_repository.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<ILocalStorageProvider>(
    () => LocalStorageProvider(prefs: getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<ApiHeaderInterceptor>(
    () => ApiHeaderInterceptor(
      localStorageProvider: getIt<ILocalStorageProvider>(),
    ),
  );

  getIt.registerLazySingleton<ApiLoggerInterceptor>(ApiLoggerInterceptor.new);

  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      localStorageProvider: getIt<ILocalStorageProvider>(),
    ),
  );

  getIt.registerLazySingleton<BaseProvider>(
    () => BaseProvider(
      apiHeaderInterceptor: getIt<ApiHeaderInterceptor>(),
      apiLoggerInterceptor: getIt<ApiLoggerInterceptor>(),
      authInterceptor: getIt<AuthInterceptor>(),
    ),
  );

  getIt.registerLazySingleton<IReverbConfigProvider>(
    () => ReverbConfigProvider(
      localStorageProvider: getIt<ILocalStorageProvider>(),
    ),
  );

  getIt.registerLazySingleton<IReverbService>(ReverbService.new);

  getIt.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSource(dio: getIt<BaseProvider>().dio),
  );

  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepository(
      remoteDataSource: getIt<IAuthRemoteDataSource>(),
      localStorageProvider: getIt<ILocalStorageProvider>(),
    ),
  );

  getIt.registerLazySingleton<AuthBloc>(AuthBloc.new);

  getIt.registerLazySingleton<ITransferRemoteDataSource>(
    () => TransferRemoteDataSource(dio: getIt<BaseProvider>().dio),
  );

  getIt.registerLazySingleton<ITransferRepository>(
    () => TransferRepository(
      remoteDataSource: getIt<ITransferRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<IHistoryRemoteDataSource>(
    () => HistoryRemoteDataSource(dio: getIt<BaseProvider>().dio),
  );

  getIt.registerLazySingleton<IHistoryRepository>(
    () => HistoryRepository(
      remoteDataSource: getIt<IHistoryRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<ITopUpRemoteDataSource>(
    () => TopUpRemoteDataSource(dio: getIt<BaseProvider>().dio),
  );

  getIt.registerLazySingleton<ITopUpRepository>(
    () => TopUpRepository(
      remoteDataSource: getIt<ITopUpRemoteDataSource>(),
    ),
  );
}