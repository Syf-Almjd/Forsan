import 'package:flutter/material.dart';
import 'package:forsan/core/shared/components.dart';
import 'package:forsan/data/local/bottom_bar_data.dart';
import 'package:forsan/features/authentication/auth_page_view.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroSplashPage extends StatelessWidget {
  const IntroSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: listPagesViewModel(context),
        showSkipButton: false,
        skip: Text(
          "تخطي",
          style: fontAlmarai(textColor: Colors.amberAccent),
        ),
        next: Text(
          "التالي",
          style: fontAlmarai(textColor: Colors.amberAccent),
        ),
        done: const Icon(
          Icons.not_started_outlined,
          size: 50,
        ),
        onDone: () {
          NaviCubit.get(context).navigate(context, const AuthPageView());
        },
        onSkip: () {
          NaviCubit.get(context).navigate(context, const AuthPageView());
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.amberAccent,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
