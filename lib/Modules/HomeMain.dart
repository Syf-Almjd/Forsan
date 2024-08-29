import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/Cubit/BaB%20BloC/ba_b_bloc.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Modules/Cart/CartPage.dart';
import 'package:forsan/Modules/Product/ProductsPage.dart';
import 'package:forsan/Modules/Profile/Profile.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../API/Data/BabData.dart';
import '../Components/Components.dart';
import 'Authentication/SignLayout.dart';
import 'HomeScreen/HomePage.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: BlocBuilder<BaBBloc, BaBState>(
                builder: (context, state) {
                  if (state is ProductScreen) {
                    return const productsPage();
                  }
                  if (state is CartScreen) {
                    return const CartPage();
                  }
                  if (state is ProfileScreen) {
                    return const profilePage();
                  }
                  if (state is HomeScreen) {
                    return const homePage();
                  } else {
                    return const homePage();
                  }
                },
              ),
              bottomNavigationBar: BlocBuilder<BaBBloc, BaBState>(
                builder: (context, state) {
                  return AnimatedBottomNavigationBar(
                    icons: homeMenuIcons,
                    activeIndex: state.defaultIndex,
                    backgroundColor: Colors.amberAccent,
                    leftCornerRadius: 50,
                    iconSize: 28,
                    elevation: 20,
                    gapLocation: GapLocation.none,
                    inactiveColor: Colors.grey,
                    splashColor: Colors.white,
                    borderColor: Colors.cyan,
                    activeColor: Colors.white,
                    rightCornerRadius: 50,
                    onTap: (index) =>
                        BlocProvider.of<BaBBloc>(context).add(TabChange(index)),
                    //other params
                  );
                },
              ),
            );
          } else {
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
                  NaviCubit.get(context).navigate(context, const SignLayout());
                },
                onSkip: () {
                  NaviCubit.get(context).navigate(context, const SignLayout());
                },
                dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(20.0, 10.0),
                  activeColor: Colors.amberAccent,
                  color: Colors.black26,
                  spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
