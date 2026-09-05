import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/read_session.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/presentation/bloc/login/login_bloc.dart';
import '../../features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import '../../features/chat/data/datasources/chat_local_data_source.dart';
import '../../features/chat/data/datasources/chat_remote_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/ask_question.dart';
import '../../features/chat/domain/usecases/load_chat_history.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/daily_law/data/datasources/daily_law_bundle_data_source.dart';
import '../../features/daily_law/data/datasources/daily_law_catalogue_data_source.dart';
import '../../features/daily_law/data/datasources/daily_law_local_data_source.dart';
import '../../features/daily_law/data/datasources/daily_law_remote_data_source.dart';
import '../../features/daily_law/data/repositories/daily_law_repository_impl.dart';
import '../../features/daily_law/domain/repositories/daily_law_repository.dart';
import '../../features/daily_law/domain/usecases/open_today_box.dart';
import '../../features/daily_law/domain/usecases/read_collection.dart';
import '../../features/daily_law/domain/usecases/read_today_box.dart';
import '../../features/daily_law/presentation/bloc/collection_bloc.dart';
import '../../features/daily_law/presentation/bloc/daily_law_bloc.dart';
import '../../features/home/data/datasources/trending_local_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/read_trending_question.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/intro/data/datasources/intro_local_data_source.dart';
import '../../features/intro/data/repositories/intro_repository_impl.dart';
import '../../features/intro/domain/repositories/intro_repository.dart';
import '../../features/intro/domain/usecases/mark_intro_seen.dart';
import '../../features/intro/domain/usecases/read_intro_seen.dart';
import '../../features/intro/presentation/bloc/intro_bloc.dart';
import '../../features/profile/data/datasources/settings_local_data_source.dart';
import '../../features/profile/data/repositories/settings_repository_impl.dart';
import '../../features/profile/domain/repositories/settings_repository.dart';
import '../../features/profile/domain/usecases/read_settings.dart';
import '../../features/profile/domain/usecases/save_settings.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../network/api_client.dart';
import '../network/token_store.dart';

final GetIt injector = GetIt.instance;

Future<void> configureDependencies() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  injector
    ..registerSingleton<SharedPreferences>(preferences)
    ..registerLazySingleton<TokenStore>(
      () => TokenStore(const FlutterSecureStorage()),
    )
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        tokenStore: injector<TokenStore>(),
        onSessionLost: injector<TokenStore>().clear,
      ),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(injector<ApiClient>()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(injector<TokenStore>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        injector<AuthRemoteDataSource>(),
        injector<AuthLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<SignIn>(() => SignIn(injector<AuthRepository>()))
    ..registerLazySingleton<SignUp>(() => SignUp(injector<AuthRepository>()))
    ..registerLazySingleton<SignOut>(() => SignOut(injector<AuthRepository>()))
    ..registerLazySingleton<ReadSession>(
      () => ReadSession(injector<AuthRepository>()),
    )
    ..registerLazySingleton<DailyLawBundleDataSource>(
      () => DailyLawBundleDataSourceImpl(rootBundle),
    )
    ..registerLazySingleton<DailyLawRemoteDataSource>(
      () => DailyLawRemoteDataSourceImpl(injector<ApiClient>()),
    )
    ..registerLazySingleton<DailyLawCatalogueDataSource>(
      () => DailyLawCatalogueDataSourceImpl(
        remote: injector<DailyLawRemoteDataSource>(),
        bundle: injector<DailyLawBundleDataSource>(),
      ),
    )
    ..registerLazySingleton<DailyLawLocalDataSource>(
      () => DailyLawLocalDataSourceImpl(injector<SharedPreferences>()),
    )
    ..registerLazySingleton<DailyLawRepository>(
      () => DailyLawRepositoryImpl(
        injector<DailyLawCatalogueDataSource>(),
        injector<DailyLawLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<ReadTodayBox>(
      () => ReadTodayBox(injector<DailyLawRepository>()),
    )
    ..registerLazySingleton<OpenTodayBox>(
      () => OpenTodayBox(injector<DailyLawRepository>()),
    )
    ..registerLazySingleton<ReadCollection>(
      () => ReadCollection(injector<DailyLawRepository>()),
    )
    ..registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(injector<ApiClient>()),
    )
    ..registerLazySingleton<ChatLocalDataSource>(
      () => ChatLocalDataSourceImpl(injector<SharedPreferences>()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        injector<ChatRemoteDataSource>(),
        injector<ChatLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<AskQuestion>(
      () => AskQuestion(injector<ChatRepository>()),
    )
    ..registerLazySingleton<LoadChatHistory>(
      () => LoadChatHistory(injector<ChatRepository>()),
    )
    ..registerFactory<DailyLawBloc>(
      () => DailyLawBloc(
        readTodayBox: injector<ReadTodayBox>(),
        openTodayBox: injector<OpenTodayBox>(),
      ),
    )
    ..registerFactory<CollectionBloc>(
      () => CollectionBloc(injector<ReadCollection>()),
    )
    ..registerFactory<ChatBloc>(
      () => ChatBloc(injector<AskQuestion>(), injector<LoadChatHistory>()),
    )
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(injector<SharedPreferences>()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(
        injector<SettingsLocalDataSource>(),
        injector<ApiClient>(),
      ),
    )
    ..registerLazySingleton<ReadSettings>(
      () => ReadSettings(injector<SettingsRepository>()),
    )
    ..registerLazySingleton<SaveSettings>(
      () => SaveSettings(injector<SettingsRepository>()),
    )
    ..registerFactory<ProfileBloc>(
      () => ProfileBloc(
        readSession: injector<ReadSession>(),
        signOut: injector<SignOut>(),
        readSettings: injector<ReadSettings>(),
        saveSettings: injector<SaveSettings>(),
        readTodayBox: injector<ReadTodayBox>(),
      ),
    )
    ..registerLazySingleton<IntroLocalDataSource>(
      () => IntroLocalDataSourceImpl(injector<SharedPreferences>()),
    )
    ..registerLazySingleton<IntroRepository>(
      () => IntroRepositoryImpl(injector<IntroLocalDataSource>()),
    )
    ..registerLazySingleton<ReadIntroSeen>(
      () => ReadIntroSeen(injector<IntroRepository>()),
    )
    ..registerLazySingleton<MarkIntroSeen>(
      () => MarkIntroSeen(injector<IntroRepository>()),
    )
    ..registerFactory<IntroBloc>(() => IntroBloc(injector<MarkIntroSeen>()))
    ..registerFactory<SplashBloc>(
      () => SplashBloc(injector<ReadSession>(), injector<ReadIntroSeen>()),
    )
    ..registerLazySingleton<TrendingLocalDataSource>(
      () => TrendingLocalDataSourceImpl(rootBundle),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(injector<TrendingLocalDataSource>()),
    )
    ..registerLazySingleton<ReadTrendingQuestion>(
      () => ReadTrendingQuestion(injector<HomeRepository>()),
    )
    ..registerFactory<HomeBloc>(
      () => HomeBloc(
        readSession: injector<ReadSession>(),
        readTrendingQuestion: injector<ReadTrendingQuestion>(),
      ),
    )
    ..registerFactory<LoginBloc>(() => LoginBloc(injector<SignIn>()))
    ..registerFactory<SignUpBloc>(() => SignUpBloc(injector<SignUp>()));
}
