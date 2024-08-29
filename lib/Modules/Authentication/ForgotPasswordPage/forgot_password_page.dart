import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

import '../../../Components/Components.dart';
import '../../../Cubit/AppDataCubit/app_cubit.dart';
import '../../../Cubit/Navigation/navi_cubit.dart';
import '../Login/LoginUser.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late String emailData;
  TextEditingController email = TextEditingController();
  final _validateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نسيت كلمة المرور"),
        centerTitle: true,
      ),
      body: Form(
        key: _validateKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "استعادة كلمة المرور",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            getCube(3, context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: getHeight(40, context),
                width: getWidth(80, context),
                child: Image.network(
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return loadingAnimation();
                  },
                  'https://liteb.smeclabs.com/assets/frontend/default-new/image/cloud-security.gif', // Replace with your image URL
                ),
              ),
            ),
            getCube(5, context),
            const Text(
              "يرجى ادخال بريدك الالكتروني",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            getCube(3, context),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  showToast("الايميل غير صحيح!", SnackBarType.fail, context);
                  return "الايميل غير صحيح";
                }
                return null;
              },
              controller: email,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: "الايميل",
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            getCube(3, context),
            Center(
                child: loadButton(
                    buttonText: "ارسال",
                    onPressed: () {
                      if (validateForm(_validateKey)) {
                        AppCubit.get(context)
                            .resetPassword(email.text, context);
                      }
                    })),
            getCube(3, context),
            TextButton(
              child: const Text(
                "العودة لتسجيل الدخول",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                NaviCubit.get(context).navigate(context, const Login());
              },
            ),
            getCube(3, context),
          ],
        ),
      ),
    );
  }
}
