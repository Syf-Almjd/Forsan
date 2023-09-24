import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Cubit/AppDataCubit/app_cubit.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Modules/Profile/Settings.dart';
import 'package:forsan/Modules/Vendor/OurServiceText.dart';
import 'package:forsan/generated/assets.dart';

import '../../Models/UserModel.dart';
import '../Vendor/ContactUs.dart';
import 'ProfileMenuList.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  UserModel currentUser = UserModel.loadingUser();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserModel userData = await AppCubit.get(context).getUserData();
    setState(() {
      currentUser = userData;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
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
                            child: const Image(
                              image: AssetImage(Assets.assetsProfilePicture),
                              fit: BoxFit.fill,
                            )),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            NaviCubit.get(context).navigate(context, settingsPage(currentUser: currentUser));
                          },
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
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(currentUser!.name),
                      getCube(1, context),
                      Container(
                        width: getWidth(50, context),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // width: getWidth(70, context),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.card_giftcard_outlined,
                                color: Colors.white),
                            getCube(1, context),
                            Text(
                              // currentUser!.address,
                              "نقاطك: ${currentUser.points}",
                              // overflow: TextOverflow
                              //     .ellipsis, // Set the overflow property
                              // maxLines: 1, softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// -- BUTTON
                      // SizedBox(
                      //   width: 200,
                      //   child: ElevatedButton(
                      //     onPressed: () {},
                      //     style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.amberAccent,
                      //         side: BorderSide.none,
                      //         shape: const StadiumBorder()),
                      //     child: const Text("تعديل",
                      //         style: TextStyle(color: Colors.black)),
                      //   ),
                      // ),
                      // const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "الاعدادت",
                          icon: Icons.settings,
                          onPress: () {
                            NaviCubit.get(context).navigate(
                                context,
                                settingsPage(
                                  currentUser: currentUser,
                                ));
                          }),
                      ProfileMenuWidget(
                          title: "الخصوصية والامان",
                          icon: Icons.wallet,
                          onPress: () {
                            NaviCubit.get(context)
                                .navigate(context, OurPolicies());
                          }),

                      ProfileMenuWidget(
                          title: "سياسات البرنامج",
                          icon: Icons.verified_user,
                          onPress: () {
                            NaviCubit.get(context)
                                .navigate(context, OurPolicies());
                          }),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "تواصل معنا",
                          icon: Icons.info,
                          onPress: () {
                            NaviCubit.get(context)
                                .navigate(context, ContactUsPage());
                          }),
                      ProfileMenuWidget(
                          title: "تسجيل الخروج",
                          icon: Icons.sign_language_rounded,
                          textColor: Colors.red,
                          endIcon: false,
                          onPress: () {
                            (showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("تسجيل الخروج "),
                                    titleTextStyle: const TextStyle(fontSize: 20),
                                    content: const Text(
                                        "هل أنت متأكد أنك تريد تسجيل الخروج؟"),
                                    actions: [
                                      TextButton(
                                        child: const Text('لا'),
                                        onPressed: () {
                                          NaviCubit.get(context).pop(context, const Text("SingOut"));
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('نعم'),
                                        onPressed: () {
                                          NaviCubit.get(context).navigateToSliderLogout(context);
                                        },
                                      ),
                                    ],
                                  );
                                }));
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
