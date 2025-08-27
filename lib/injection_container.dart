import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/authentication/data/datasources/auth_remote_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/get_current_user.dart';
import 'features/authentication/domain/usecases/register_with_email_password.dart';
import 'features/authentication/domain/usecases/sign_in_with_email_password.dart';
import 'features/authentication/domain/usecases/sign_out.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/currency_conversion/data/datasources/currency_local_data_source.dart';
import 'features/currency_conversion/data/datasources/currency_remote_data_source.dart';
import 'features/currency_conversion/data/repositories/currency_repository_impl.dart';
import 'features/currency_conversion/domain/repositories/currency_repository.dart';
import 'features/currency_conversion/domain/usecases/convert_currency.dart';
import 'features/currency_conversion/domain/usecases/get_all_currencies.dart';
import 'features/currency_conversion/presentation/bloc/currency_conversion_bloc.dart';
final sl = GetIt.instance;
Future<void> init() async {
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmailPassword: sl(),
      registerWithEmailPassword: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton(() => SignInWithEmailPassword(sl()));
  sl.registerLazySingleton(() => RegisterWithEmailPassword(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerFactory(
    () => CurrencyConversionBloc(
      getAllCurrencies: sl(),
      convertCurrency: sl(),
      inputConverter: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetAllCurrencies(sl()));
  sl.registerLazySingleton(() => ConvertCurrency(sl()));
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<CurrencyLocalDataSource>(
    () => CurrencyLocalDataSourceImpl(),
  );
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
} 