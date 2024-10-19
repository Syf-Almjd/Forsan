// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/core/utils/managers/app_assets.dart';
import 'package:forsan/features/home_screen/screens/other_services_screen.dart';
import 'package:forsan/features/vendor/contact_vendor.dart';

import 'package:forsan/core/shared/components.dart';
import 'package:forsan/state/bottom_navi_bloc/ba_b_bloc.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';
import '../../data/local/local_app_data.dart';
import 'screens/print_now_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController searchTF = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            NaviCubit.get(context)
                                .navigate(context, const ContactUsPage());
                          },
                          child: Column(
                            children: [
                              const Icon(
                                Icons.contact_support_outlined,
                                size: 30,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "تواصل",
                                style: fontAlmarai(
                                    size: 9, textColor: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                      getCube(3, context),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<BaBBloc>(context).add(TabChange(1));
                          },
                          child: Column(
                            children: [
                              const Stack(children: [
                                Icon(
                                  size: 30,
                                  Icons.shopping_bag_outlined,
                                  color: Colors.green,
                                ),
                                Positioned(
                                    width: 10,
                                    height: 10,
                                    right: 1,
                                    top: 5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white60),
                                    ))
                              ]),
                              const SizedBox(height: 3),
                              Text(
                                "السلة",
                                style: fontAlmarai(
                                    size: 10, textColor: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const Spacer(),
                      getCube(3, context),
                      SizedBox(
                        width: getWidth(70, context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "!مرحبا بك في فرسان",
                                style: fontAlmarai(
                                    size: 25,
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.w900),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            getCube(1, context),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "..نجعل أمر الطباعة أمراً سهل المنال وقريباً منك",
                                style: fontAlmarai(
                                    size: 11, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  getCube(1, context)
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.8), BlendMode.lighten),
                      image: const AssetImage(AppAssets.assetsHomebg),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                  child: Column(children: [
                    getCube(5, context),
                    Container(
                        width: getWidth(80, context),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.amberAccent, width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Center(
                                child: Text(
                              "فرسان للطباعة ",
                              style: fontAlmarai(
                                  size: 50, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                          ],
                        )),
                    getCube(3, context),
                    Center(
                        child: Text(
                      "لجميع خدمات الطباعة والخدمات الطلابية",
                      style: fontAlmarai(size: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),

                    InkWell(
                      onTap: () {
                        BlocProvider.of<NaviCubit>(context)
                            .navigate(context, const PrintNowScreen("الطباعة"));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(getWidth(15, context)),
                        child: Container(
                          height: getHeight(10, context),
                          width: getWidth(50, context),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                // colorFilter: ColorFilter.mode(Colors.redAccent.withOpacity(1.0), BlendMode.softLight),
                                image: AssetImage(AppAssets.assetsPrint),
                              )),
                          child: Center(
                              child: Text(
                            "اطبع الان",
                            style: fontAlmarai(
                                size: getWidth(6, context),
                                fontWeight: FontWeight.w900,
                                textColor: Colors.white),
                          )),
                        ),
                      ),
                    ),
                    // getCube(5, context),
                  ]),
                ),
                getCube(3, context),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "-خدماتنا-",
                      style: fontAlmarai(
                          size: getWidth(12, context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      ":الخدمات الطلابية",
                      style: fontAlmarai(size: getWidth(7, context)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.2),
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(30)),
                    ),
                    child: SizedBox(
                      height: 180,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: studentServicesList.length,
                          itemBuilder: (context, index) {
                            return rowHomeItems(
                              name: studentServicesList[index],
                              img: studentServicesImgs[index],
                              onTap: (title) {
                                NaviCubit.get(context).navigate(
                                    context, OtherServicesScreen(title));
                              },
                            );
                          }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      ":خدمات الطباعة الطلابية",
                      style: fontAlmarai(size: getWidth(7, context)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.2),
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(30)),
                    ),
                    child: SizedBox(
                      height: 180,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: studentPrintingList.length,
                          itemBuilder: (context, index) {
                            return rowHomeItems(
                              name: studentPrintingList[index],
                              img: studentPrintingImgs[index],
                              onTap: (title) {
                                NaviCubit.get(context)
                                    .navigate(context, PrintNowScreen(title));
                              },
                            );
                          }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      ":خدمات التصاميم",
                      // (دعاية واعلان)
                      style: fontAlmarai(size: getWidth(7, context)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.15),
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(30)),
                    ),
                    child: SizedBox(
                      height: 180,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: advServicesList.length,
                          itemBuilder: (context, index) {
                            List<String> advList =
                                advServiceImgs.reversed.toList();
                            return rowHomeItems(
                              name: advServicesList[index],
                              img: advList[index],
                              onTap: (title) {
                                NaviCubit.get(context).navigate(
                                    context, OtherServicesScreen(title));
                              },
                            );
                          }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 15, 15, 20),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //for FUTURE Implementation
                        // Text( /
                        //   "المزيد",
                        //   style: fontAlmarai(
                        //       size: getWidth(5, context),
                        //       textColor: Colors.blue),
                        // ),
                        // const Spacer(),
                        Text(
                          ":خدمات أخرى",
                          style: fontAlmarai(size: getWidth(7, context)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(30)),
                    ),
                    child: SizedBox(
                      height: 180,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: moreServicesList.length,
                          itemBuilder: (context, index) {
                            return rowHomeItems(
                              name: moreServicesList[index],
                              img: moreServiceImge[index],
                              onTap: (title) {
                                NaviCubit.get(context).navigate(
                                    context, OtherServicesScreen(title));
                              },
                            );
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 7),
                  child: Column(
                    children: [
                      Text(
                        "شكراً جزيلاً لك على التحقق من خدماتنا إن أي استفسارات أخرى فلا تتردد في",
                        style: fontAlmarai(size: 8),
                        textAlign: TextAlign.center,
                      ),
                      InkWell(
                        onTap: () {
                          NaviCubit.get(context)
                              .navigate(context, const ContactUsPage());
                        },
                        child: Text(
                          "الاتصال بنا",
                          style: fontAlmarai(size: 8, textColor: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  ":او التواصل معنا عن طريق",
                  style: fontAlmarai(size: 8),
                  textAlign: TextAlign.center,
                ),
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
                              checkNOpenUrl(
                                  socialMediaList.values.toList()[index],
                                  context);
                            });
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
