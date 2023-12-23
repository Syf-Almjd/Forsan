import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/Cubit/AppDataCubit/app_cubit.dart';
import 'package:forsan/Modules/HomeMain.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'navi_state.dart';

class NaviCubit extends Cubit<NaviState> {
  NaviCubit() : super(InitialNaviState());

  static NaviCubit get(context) => BlocProvider.of(context);

  void navigate(context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
    emit(PagePushed(pageName: widget.toString()));
  }

  void navigateOff(context, Widget widget) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget));
    emit(PagePushedOff(pageName: widget.toString()));
  }

  void navigateToHome(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeMain()));
    emit(HomeState());
  }

  void navigateToAdmin(context) {
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const LoginPage()));
    emit(AdminState());
  }

  void navigateToSliderLogout(context) {
    FirebaseAuth.instance.signOut();
    AppCubit.get(context).clearSharedAll();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeMain()));
    emit(IntoPageState());
  }

  void pop(context) {
    final currentRoute = ModalRoute.of(context);
    // Check if there is a previous route in the navigation stack
    if (currentRoute != null && currentRoute.canPop) {
      Navigator.pop(context);
    }
    emit(PagePopped(pageName: currentRoute.toString()));
  }
}
