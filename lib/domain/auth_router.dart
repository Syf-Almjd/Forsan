import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/features/authentication/intro_splash/intro_splash_page.dart';
import 'package:forsan/features/cart/cart_page.dart';
import 'package:forsan/features/product/product_page.dart';
import 'package:forsan/features/profile/profile_page.dart';
import 'package:forsan/state/bottom_navi_bloc/ba_b_bloc.dart';

import '../data/local/bottom_bar_data.dart';
import '../features/home_screen/HomePage.dart';

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
                    return const ProductsPage();
                  }
                  if (state is CartScreen) {
                    return const CartPage();
                  }
                  if (state is ProfileScreen) {
                    return const ProfilePage();
                  }
                  if (state is HomeScreen) {
                    return const HomePage();
                  } else {
                    return const HomePage();
                  }
                },
              ),
              bottomNavigationBar: buttomNavigationWidget(),
            );
          } else {
            return const IntroSplashPage();
          }
        },
      ),
    );
  }

  buttomNavigationWidget() {
    return BlocBuilder<BaBBloc, BaBState>(
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
    );
  }
}
