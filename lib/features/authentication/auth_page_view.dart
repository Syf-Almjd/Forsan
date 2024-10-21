import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/domain/singletons/user_singleton.dart';
import 'package:forsan/features/authentication/registration/register_first_page.dart';
import 'package:forsan/features/authentication/registration/register_second_page.dart';
import 'package:forsan/features/authentication/registration/register_third_page.dart';
import 'package:forsan/state/bottom_navi_bloc/ba_b_bloc.dart';
import 'login/login_user.dart';

class AuthPageView extends StatefulWidget {
  const AuthPageView({super.key});

  @override
  State<AuthPageView> createState() => _AuthPageViewState();
}

class _AuthPageViewState extends State<AuthPageView> {
  var userSingleton = UserSingleton();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.amberAccent),
        child: Column(
          children: [
            getCube(2, context),
            logoContainer(context),
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(20)),
                      color: Colors.white),
                  child: BlocBuilder<RegisterBabBloc, RegisterPagesState>(
                      builder: (context, state) {
                    if (state is LoginScreen) {
                      return const Login();
                    }
                    if (state is RegisterScreenOne) {
                      return const RegisterFirstPage();
                    }
                    if (state is RegisterScreenTwo) {
                      return RegisterSecondPage(
                          userData: userSingleton.userDataToBeUploaded);
                    }
                    if (state is RegisterScreenThree) {
                      return RegisterThirdPage(
                          userData: userSingleton.userDataToBeUploaded);
                    } else {
                      return const Login();
                    }
                  })),
            )
          ],
        ),
      ),
    );
  }
}
