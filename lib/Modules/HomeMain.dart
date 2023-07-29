import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/Cubit/BaB%20BloC/ba_b_bloc.dart';
import 'package:forsan/Modules/Cart/CartPage.dart';
import 'package:forsan/Modules/Product/ProductsPage.dart';
import 'package:forsan/Modules/Profile/Profile.dart';

import '../API/Data/BabData.dart';
import '../page.dart';
import 'HomeScreen/HomePage.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    // when should i build a new context
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser!.uid ==
                '5DFCmjNqM0SQenH27prKEjE1FL63') {
              return const page();
            }
            return Scaffold(
              body: BlocBuilder<BaBBloc, BaBState>(
                builder: (context, state) {
                  if (state is ProductScreen) {
                    return const productsPage();
                  }
                  if (state is CartScreen) {
                    return const cartPage();
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
            return const homePage();
          }
        },
      ),
    );
  }
}
