import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/core/shared/components.dart';
import 'package:forsan/domain/auth_router.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';

import '../bottom_navi_bloc/ba_b_bloc.dart';

part 'navi_state.dart';

class NaviCubit extends Cubit<NaviState> {
  NaviCubit() : super(InitialNaviState());

  static NaviCubit get(context) => BlocProvider.of(context);

  List guestModeWidgets = [HomeMain];

  navigate(context, Widget widget) async {
    if (isGuestMode &&
        !guestModeWidgets.contains(widget.runtimeType.toString())) {
      return showChoiceDialog(
          context: context,
          title: "الرجاء التسجيل ",
          content: "هل تريد تسجيل الدخول؟",
          onYes: () {
            navigateToSliderLogout(context);
          });
    } else {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => widget));
      emit(PagePushed(pageName: widget.toString()));
    }
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
    isGuestMode = false;
    FirebaseAuth.instance.signOut();
    AppCubit.get(context).clearSharedAll();
    BlocProvider.of<RegisterBabBloc>(context).add(TabChange(0));
    BlocProvider.of<BaBBloc>(context).add(TabChange(3));

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeMain()));
    emit(IntoPageState());
  }

  void pop(context, {bool forced = false}) {
    final currentRoute = ModalRoute.of(context);
    // Check if there is a previous route in the navigation stack
    if ((currentRoute != null && currentRoute.canPop) || forced) {
      Navigator.pop(context);
    }
    emit(PagePopped(pageName: currentRoute.toString()));
  }
}
