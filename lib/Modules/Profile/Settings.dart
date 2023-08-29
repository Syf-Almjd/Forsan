import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Cubit/AppDataCubit/app_cubit.dart';
import 'package:forsan/generated/assets.dart';

import '../../Models/UserModel.dart';

class settingsPage extends StatefulWidget {
  final UserModel currentUser;
  const settingsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  bool _isObscure = true;
  bool _isLoading = false;
  bool changePassBtn = false;

  late UserModel userData;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.currentUser.userID=="") {
      loadingAnimation();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الاعدادات"),
        centerTitle: true,),
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          // mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                width: getWidth(50, context),
                height: getHeight(20, context),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.yellow),
                ),
                child: const Image(
                    image: AssetImage(Assets.assetsProfilePicture),
                    fit: BoxFit.contain),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: widget.currentUser.name,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: widget.currentUser.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: address,
                    decoration: InputDecoration(
                      labelText: widget.currentUser.address,
                      prefixIcon: const Icon(Icons.home),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: phoneNumber,
                    decoration: InputDecoration(
                      labelText: widget.currentUser.phoneNumber,
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: pass,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        labelText: 'كلمة المرور الحالية',
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoSwitch(
                        applyTheme: true,
                        value: changePassBtn,
                        onChanged: (value) => setState(() {
                          changePassBtn = value;
                          print(value);
                        }),
                      ),
                      const Text('تغير كلمة المرور ايضا؟'),
                    ],
                  ),
                  if(changePassBtn)
                      TextField(
                          controller: newPass,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              labelText: 'كلمة المرور الجديدة',
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
                        )
                ],
              ),
            ),
            Center(
              child: _isLoading
                  ? loadingAnimation()
                  : Container(
                      width: double.infinity,
                      height: 60.0,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: () async {
                          if (name.text.isEmpty) {
                            showToast(
                                "الاسم غير معرف", SnackBarType.fail, context);
                          } else if (address.text.isEmpty) {
                            showToast(
                                "العنوان غير معرف", SnackBarType.fail, context);
                          } else if (phoneNumber.text.isEmpty) {
                            showToast(
                                "الرقم غير معرف", SnackBarType.fail, context);
                          } else if (email.text.isEmpty ||
                              !email.text.contains('@')) {
                            showToast(
                                "الايميل غير صحيح", SnackBarType.fail, context);
                          } else if (widget.currentUser.password != pass.text) {
                            showToast("كلمة السر غير صحيحة", SnackBarType.fail,
                                context);
                          } else if (changePassBtn && newPass.text.isEmpty ||
                              newPass.text.length <= 4) {
                            showToast(
                                "كلمة السر قصيرة", SnackBarType.fail, context);
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email.text, password: pass.text);
                            } on FirebaseAuthException {
                              IconSnackBar.show(
                                  context: context,
                                  snackBarType: SnackBarType.fail,
                                  label: '!اعد المحاولة');
                              AppCubit.get(context).stopLoading();
                            }
                            userData = UserModel(
                                email: email.text,
                                password: widget.currentUser.password,
                                name: name.text,
                                address: address.text,
                                points: widget.currentUser.points,
                                phoneNumber: phoneNumber.text,
                                photoID: FirebaseAuth.instance.currentUser!.uid,
                                userID: FirebaseAuth.instance.currentUser!.uid);
                            AppCubit.get(context)
                                .userRegister(userData, context);
                          }
                        },
                        child: Text(
                          "تعديل",
                          style: fontAlmarai(
                              fontWeight: FontWeight.bold,
                              textColor: Colors.black),
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
