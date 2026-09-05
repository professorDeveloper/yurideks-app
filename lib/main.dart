import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'app/bloc_observer.dart';
import 'core/di/injector.dart';
import 'core/usecase/usecase.dart';
import 'features/profile/domain/usecases/read_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  Bloc.observer = const AppBlocObserver();
  await configureDependencies();
  await injector<ReadSettings>()(const NoParams());

  runApp(const YurideksApp());
}
