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

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for auth state
          return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 0.0),
              child: Container(
                color: Colors.amberAccent,
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: BlocBuilder<BaBBloc, BaBState>(
              builder: (context, state) {
                if (state is ProductScreen) {
                  return const ProductsPage();
                } else if (state is CartScreen) {
                  return const CartPage();
                } else if (state is ProfileScreen) {
                  return const ProfilePage();
                } else {
                  return const HomePage(); // Default or fallback
                }
              },
            ),
            bottomNavigationBar: bottomNavigationWidget(context),
          );
        } else {
          // Show the intro splash page if the user is not logged in
          return const IntroSplashPage();
        }
      },
    );
  }

  Widget bottomNavigationWidget(BuildContext context) {
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
        );
      },
    );
  }
}
