import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Components/Components.dart';
import '../../Components/Shared/Singleton.dart';
import '../../Cubit/BaB BloC/ba_b_bloc.dart';
import '../Authentication/Registration/RegisterSecondPage.dart';
import '../Authentication/Registration/RegisterThirdPage.dart';
import 'Login/LoginUser.dart';
import 'Registration/RegisterFirstPage.dart';

class SignLayout extends StatefulWidget {
  const SignLayout({super.key});

  @override
  State<SignLayout> createState() => _SignLayoutState();
}

class _SignLayoutState extends State<SignLayout> {
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
                          previousUserData: Singleton().userDataToBeUploaded);
                    }
                    if (state is RegisterScreenThree) {
                      return RegisterThirdPage(
                          previousUserData: Singleton().userDataToBeUploaded);
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
