import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forsan/core/shared/components.dart';
import 'package:forsan/domain/models/user_model.dart';
import 'package:forsan/features/profile/screens/user_profile_settings.dart';
import 'package:forsan/features/profile/widgets/profile_menu_item_widget.dart';
import 'package:forsan/features/vendor/vendor_service_text.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

import '../vendor/contact_vendor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel currentUser = UserModel.loadingUser();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserModel userData = UserModel.fromJson(
        await AppCubit.get(context).getSharedMap('currentuser'));
    if (userData.photoID == "NO_PHOTO") {
      currentUser.photoID = UserModel.loadingUser().photoID;
    }
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
    return Column(
      children: [
        Container(
          height: getHeight(20, context),
          width: getWidth(100, context),
          decoration: const BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          child: Center(
            child: CircleAvatar(
              radius: getWidth(20, context),
              child: InkWell(
                  onTap: () {
                    NaviCubit.get(context).navigate(
                        context, SettingsPage(currentUser: currentUser));
                  },
                  child: previewImage(currentUser.photoID, context)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(currentUser.name),
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
              const Icon(Icons.card_giftcard_outlined, color: Colors.white),
              getCube(1, context),
              Text(
                "نقاطك: ${currentUser.points}",
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "الاعدادت",
                  icon: Icons.settings,
                  onPress: () {
                    NaviCubit.get(context).navigate(
                        context,
                        SettingsPage(
                          currentUser: currentUser,
                        ));
                  }),
              ProfileMenuWidget(
                  title: "الخصوصية والامان",
                  icon: Icons.wallet,
                  onPress: () {
                    NaviCubit.get(context)
                        .navigate(context, const OurPolicies());
                  }),
              ProfileMenuWidget(
                  title: "سياسات البرنامج",
                  icon: Icons.verified_user,
                  onPress: () {
                    NaviCubit.get(context)
                        .navigate(context, const OurPolicies());
                  }),
              ProfileMenuWidget(
                  title: "حدف معلومات الخصوصية",
                  icon: Icons.privacy_tip_outlined,
                  onPress: () {
                    NaviCubit.get(context)
                        .navigate(context, const ContactUsPage());
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "تواصل معنا",
                  icon: Icons.info,
                  onPress: () {
                    NaviCubit.get(context)
                        .navigate(context, const ContactUsPage());
                  }),
              ProfileMenuWidget(
                  title: "تقييم البرنامج",
                  icon: Icons.star_rate,
                  onPress: () {
                    checkNOpenUrl(
                        "https://play.google.com/store/apps/details?id=com.mjd.forsan.forsan",
                        context);
                  }),
              ProfileMenuWidget(
                  title: "مشاركة التطبيق",
                  icon: Icons.ios_share_outlined,
                  onPress: () {
                    checkNOpenUrl(
                        "https://play.google.com/store/apps/details?id=com.mjd.forsan.forsan",
                        context);
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
                                  NaviCubit.get(context).pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('نعم'),
                                onPressed: () {
                                  NaviCubit.get(context)
                                      .navigateToSliderLogout(context);
                                },
                              ),
                            ],
                          );
                        }));
                  }),
              getCube(5, context)
            ],
          ),
        ),
      ],
    );
  }
}
