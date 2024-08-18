import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/AppDataCubit/app_cubit.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/UserContactModel.dart';
import 'package:forsan/Modules/Vendor/OurServiceText.dart';

import '../../API/Data/inAppData.dart';
import '../../Components/Components.dart';
import '../../Models/UserModel.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  late UserModel userModel;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocalUser();
  }

  @override
  dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
  }

  getLocalUser() async {
    userModel = await AppCubit.get(context).getLocalUserData();
    setState(() {
      _nameController.text = userModel.name;
      _emailController.text = userModel.email;
      _phoneController.text = userModel.phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تواصل"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              "تواصل معنا",
              style: fontAlmarai(size: getWidth(10, context)),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "الاسم",
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "رقم الهاتف",
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _messageController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: "الرسالة",
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
            loadButton(
                textSize: getWidth(5, context),
                textColor: Colors.black,
                buttonElevation: 2.0,
                buttonWidth: getWidth(50, context),
                onPressed: () {
                  checkUserInput();
                },
                buttonText: "إرسال"),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              "طرق التواصل الأخرى",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: socialMediaList.length,
                    itemBuilder: (context, index) {
                      return socialMediaItem(
                        index: index,
                        img: socialMediaList.keys.toList()[index],
                        onTap: (index) {
                          openUrl(socialMediaList.values.toList()[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            getCube(2, context),
            const Divider(),
            getCube(2, context),
            SizedBox(
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  NaviCubit.get(context).navigate(context, const OurPolicies());
                },
                child: Text(
                  "السياسات والتوصيل",
                  style: fontAlmarai(
                      fontWeight: FontWeight.normal, textColor: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkUserInput() async {
    if (_nameController.text.isEmpty) {
      return showToast("الرجاء ادخال الاسم", SnackBarType.alert, context);
    } else if (_emailController.text.isEmpty) {
      return showToast(
          "الرجاء ادخال البريد الإلكتروني", SnackBarType.alert, context);
    } else if (_phoneController.text.isEmpty) {
      return showToast("الرجاء ادخال رقم الهاتف", SnackBarType.alert, context);
    } else if (_messageController.text.isEmpty) {
      return showToast("الرجاء ادخال الرسالة", SnackBarType.alert, context);
    } else {
      var userMessage = UserContactModel(
          userID: userModel.userID,
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          message: _messageController.text,
          timestamp: DateTime.now());

      await AppCubit.get(context).sendUserContactMessage(userMessage);
      showToast("تم الارسال بنجاح", SnackBarType.success, context);
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
      NaviCubit.get(context).pop(context);
    }
  }
}
