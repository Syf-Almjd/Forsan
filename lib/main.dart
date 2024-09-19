import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/core/theme/app_theme.dart';
import 'package:forsan/core/utils/managers/app_constants.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/bloc_observer.dart';
import 'package:forsan/state/bottom_navi_bloc/ba_b_bloc.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

import 'data/remote/firebase_options.dart';
import 'domain/auth_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      // DevicePreview(
      //     enabled: !kReleaseMode,
      //     builder: (context) =>
      const ForsanApp() // Wrap your app
      // ),
      );
}

class ForsanApp extends StatelessWidget {
  const ForsanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit()..updateSharedUser(),
        ),
        BlocProvider<BaBBloc>(
          create: (context) => BaBBloc(),
        ),
        BlocProvider<RegisterBabBloc>(
          create: (context) => RegisterBabBloc(),
        ),
        BlocProvider<NaviCubit>(
          create: (context) => NaviCubit(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getAppLightTheme(),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: const HomeMain(),
      ),
    );
  }
}
