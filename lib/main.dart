import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/Cubit/BaB%20BloC/ba_b_bloc.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:google_fonts/google_fonts.dart';

import 'API/firebase_options.dart';
import 'Cubit/AppDataCubit/app_cubit.dart';
import 'Cubit/Observer.dart';
import 'Modules/HomeMain.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.amberAccent, // navigation bar color
    statusBarColor: Colors.amberAccent, // status bar color
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAuth.instance.signInAnonymously();// REMOVE later
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit(),
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
        title: "فرسان للطباعة",
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          fontFamily: 'Almarai',
        ).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.amberAccent,
              ),
        ),
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: const HomeMain(),
      ),
    );
  }
}

// alt r  - reload
// alt shft r   - run
// alt shft q   - culomnSelect
// alt f1   - Project
// alt f2  -  log
// alt e   - emulor
// cntl g   - go to line
// cntl shft i   - info
//cntl w   - selectwidget
//alt f12 terminal
// alt sht e top menu
