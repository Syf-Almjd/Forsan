import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/BaB%20BloC/ba_b_bloc.dart';

import '../../../Components/Components.dart';
import '../../../Components/Shared/Singleton.dart';
import '../../../Cubit/Navigation/navi_cubit.dart';
import '../../../Models/UserModel.dart';
import '../Login/LoginUser.dart';

class RegisterSecondPage extends StatefulWidget {
  final UserModel previousUserData;

  const RegisterSecondPage({super.key, required this.previousUserData});

  @override
  State<RegisterSecondPage> createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  bool _isObscure = true;
  late UserModel userData;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();
  final _validateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _validateKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: getWidth(10, context),
                  ),
                  onTap: () {
                    BlocProvider.of<RegisterBabBloc>(context).add(TabChange(1));
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                getCube(2, context),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      showToast("الايميل غير صحيح!", SnackBarType.fail,
                          context);
                      return 'الايميل غير صحيح';
                    } else {
                      return null;
                    }
                  },
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "الايميل",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                getCube(2, context),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 8) {
                      showToast("كلمة السر ضعيفة!", SnackBarType.fail,
                          context);
                      return 'كلمة السر ضعيفة';
                    } else {
                      return null;
                    }
                  },
                  controller: password,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: 'كلمة السر',
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                ),
                getCube(2, context),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !(value == password.text)) {
                      showToast("كلمة السر غير متطابقة!",
                          SnackBarType.fail, context);
                      return "كلمة السر غير متطابقة";
                    } else {
                      return null;
                    }
                  },
                  controller: passwordConfirmation,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: 'تاكيد كلمة السر ',
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                ),
              ],
            ),
          ),
          Center(
              child: loadButton(
                  buttonText: "التالي..",
                  onPressed: () {
                    if (validateForm(_validateKey)) {
                      userData = UserModel(
                          email: email.text,
                          password: password.text,
                          name: widget.previousUserData.name,
                          phoneNumber: widget.previousUserData.name,
                          photoID: "",
                          userID: "",
                          address: widget.previousUserData.address,
                          points: '10.00');
                      Singleton().userDataToBeUploaded=userData;
                      BlocProvider.of<RegisterBabBloc>(context).add(TabChange(3));
                    }
                  })),
          getCube(5, context),
        ],
      ),
    );
  }
}
