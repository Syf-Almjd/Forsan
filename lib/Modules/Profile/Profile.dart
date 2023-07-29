import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/generated/assets.dart';

import 'ProfileMenuList.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: getHeight(20, context),
              width: getWidth(100, context),
              decoration: const BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              child: Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child:
                              const Image(image: AssetImage(Assets.assetsMe))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black12),
                        child: const Icon(
                          Icons.mode_edit_outline_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text("سيف المجد", style: fontAlmarai()),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("جامعة البخاري ,ماليزيا", style: fontAlmarai()),
                        Icon(Icons.location_on_outlined),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// -- BUTTON
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("تعديل",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                        title: "الاعدادت",
                        icon: Icons.settings,
                        onPress: () {}),
                    ProfileMenuWidget(
                        title: "الخصوصية والامان",
                        icon: Icons.wallet,
                        onPress: () {}),
                    ProfileMenuWidget(
                        title: "معلومات المستخدم",
                        icon: Icons.verified_user,
                        onPress: () {}),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                        title: "معلومات التطبيق",
                        icon: Icons.info,
                        onPress: () {}),
                    ProfileMenuWidget(
                        title: "تسجيل الخروج",
                        icon: Icons.sign_language_rounded,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          // Get.defaultDialog(
                          //   title: "LOGOUT",
                          //   titleStyle: const TextStyle(fontSize: 20),
                          //   content: const Padding(
                          //     padding: EdgeInsets.symmetric(vertical: 15.0),
                          //     child: Text("Are you sure, you want to Logout?"),
                          //   ),
                          //   confirm: Expanded(
                          //     child: ElevatedButton(
                          //       onPressed: () => AuthenticationRepository.instance.logout(),
                          //       style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                          //       child: const Text("Yes"),
                          //     ),
                          //   ),
                          //   cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
                          // );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
