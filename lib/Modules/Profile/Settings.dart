import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Cubit/AppDataCubit/app_cubit.dart';
import 'package:image_picker/image_picker.dart';

import '../../Cubit/Navigation/navi_cubit.dart';
import '../../Models/UserModel.dart';

class SettingsPage extends StatefulWidget {
  final UserModel currentUser;
  const SettingsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isObscure = true;
  bool changePassBtn = false;
  String? _imageBytes;
  final textForm = GlobalKey<FormState>();

  late UserModel userData;
  TextEditingController name = TextEditingController();
  // TextEditingController email = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appCustomBar("الاعدادات", context),
      body: ListView(
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
              child: Center(
                child: SizedBox(
                  width: getWidth(40, context),
                  height: getHeight(18, context),
                  child: InkWell(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Center(
                          child: (_imageBytes != null)
                              ? previewImage(_imageBytes, context)
                              : previewImage(
                                  widget.currentUser.photoID, context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: textForm,
              child: Column(
                children: [
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: widget.currentUser.name,
                      prefixIcon: const Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        name.text = widget.currentUser.name;
                        return null;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // TextFormField(
                  //   controller: email,
                  //   decoration: InputDecoration(
                  //     labelText: widget.currentUser.email,
                  //     prefixIcon: const Icon(Icons.email_outlined),
                  //   ),
                  //   keyboardType: TextInputType.emailAddress,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       email.text = widget.currentUser.email;
                  //       return null;
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                      labelText: widget.currentUser.address,
                      prefixIcon: const Icon(Icons.home),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        address.text = widget.currentUser.address;
                        return null;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phoneNumber,
                    decoration: InputDecoration(
                      labelText: widget.currentUser.phoneNumber,
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        phoneNumber.text = widget.currentUser.phoneNumber;
                        return null;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
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
                        }),
                      ),
                      const Text('تغير كلمة المرور ايضا؟'),
                    ],
                  ),
                  if (changePassBtn)
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 4) {
                          return "كلمة السر الجديدة قصيرة";
                        }
                        return null;
                      },
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: loadButton(
                textSize: getWidth(5, context),
                textColor: Colors.black,
                buttonElevation: 2.0,
                buttonWidth: getWidth(50, context),
                onPressed: () {
                  checkUserInput();
                },
                buttonText: "تعديل"),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Future<void> checkUserInput() async {
    if (validateForm(textForm)) {
      if (name.text.isEmpty) {}
      if (address.text.isEmpty) {
        address.text = widget.currentUser.address;
      }
      if (phoneNumber.text.isEmpty) {
        phoneNumber.text = widget.currentUser.phoneNumber;
      }
      // if (email.text.isEmpty) {
      //   email.text = widget.currentUser.email;
      // }
      if (changePassBtn == true &&
          (newPass.text.isEmpty || newPass.text.length <= 4)) {
        widget.currentUser.password = newPass.text;
        AppCubit.get(context).changePassword(newPass.text);
      }
      userData = UserModel(
          email: widget.currentUser.email,
          password: widget.currentUser.password,
          name: name.text,
          address: address.text,
          points: widget.currentUser.points,
          phoneNumber: phoneNumber.text,
          photoID: _imageBytes ?? widget.currentUser.photoID,
          userID: FirebaseAuth.instance.currentUser!.uid);
      await AppCubit.get(context).updateUserFBData(userData, context);
      NaviCubit.get(context).pop(context);
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      Uint8List bytesUint8List = Uint8List.fromList(bytes);
      setState(() {
        _imageBytes = base64Encode(bytesUint8List);
      });
    }
  }
}
