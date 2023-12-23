import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

import '../../../Components/Components.dart';
import '../../../Cubit/AppDataCubit/app_cubit.dart';
import '../../../Cubit/BaB BloC/ba_b_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  late String emailData, passData;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _validateKey = GlobalKey<FormState>();


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _validateKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            "تسجيل الدخول",
            style: TextStyle(fontSize: getWidth(10, context), fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          getCube(3, context),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      showToast("الايميل غير صحيح!", SnackBarType.fail,
                          context);
                      return "الايميل غير صحيح";
                    }
                    return null;
                  },
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "الايميل",
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 4) {
                      showToast("كلمة المرور الايميل غير صحيحة", SnackBarType.fail, context);
                      return "كلمة المرور الايميل غير صحيحة";
                    }
                    return null;
                  },
                  controller: pass,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Text(
                      "لم تسجل بعد؟",
                      softWrap: true,
                      style: TextStyle(color: Colors.grey.withOpacity(0.6)),
                      textAlign: TextAlign.right,
                    ),
                    onTap: () {
                      BlocProvider.of<RegisterBabBloc>(context).add(TabChange(1));
                    },
                  ),
                ),
              ],
            ),
          ),
          Center(
              child: loadButton(
                  buttonText: "التسجيل",
                  onPressed: () {
                    if (validateForm(_validateKey)) {
                      AppCubit.get(context)
                          .userLogin(email.text, pass.text, context);
                    }
                  })),
        ],
      ),
    );
  }
}
