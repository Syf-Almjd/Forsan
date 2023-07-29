// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/generated/assets.dart';

import '../../API/Data/inAppData.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  homePageState createState() => homePageState();
}

class homePageState extends State<homePage> {
  TextEditingController searchTF = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "!فرسان ",
                                    style: fontAlmarai(
                                        size: 20, textColor: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "مرحبا بك في",
                                    style: fontAlmarai(
                                        size: 20, textColor: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "..هدفنا أن نجعل من أمر الطباعة أمراً سهل المنال وقريباً منك",
                                style: fontAlmarai(size: 7),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Handle the main list
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
                                            size: 10, textColor: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    // TODO: Handle the favorite list
                                  },
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: Colors.redAccent,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        "المفضّل",
                                        style: fontAlmarai(
                                            size: 10, textColor: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: textFieldA(
                        controller: searchTF,
                        hintText: "...البحث",
                        textAlign: TextAlign.right,
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.all(getWidth(20, context)),
                    //   child: Container(
                    //     height: getHeight(10, context), width: getWidth(30, context),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     image: DecorationImage(
                    //       fit: BoxFit.cover,
                    //       colorFilter: new ColorFilter.mode(Colors.purple.withOpacity(1.0), BlendMode.softLight),
                    //       image: const NetworkImage(
                    //           "https://i.pinimg.com/originals/e5/89/95/e5899572ecace2b0895b36db7703a001.gif"
                    //       ),
                    //     )
                    //   ),
                    //     child: Center(child: Text("اطبع الان", style: fontAlmarai( fontWeight: FontWeight.bold, textColor: Colors.white),)),
                    //   ),
                    // ),
                    //
                    //
                    
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          ":الخدمات الطلابية",
                          style: fontAlmarai(size: 18),
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
                                  img: studentServiceImgs[index],
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
                          ":خدمات التصاميم (دعاية واعلان)",
                          style: fontAlmarai(size: 18),
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
                                    studentServiceImgs.reversed.toList();
                                return rowHomeItems(
                                  name: advServicesList[index],
                                  img: advList[index],
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
                          children: [
                            Text(
                              "المزيد",
                              style:
                                  fontAlmarai(size: 12, textColor: Colors.blue),
                            ),
                            const Spacer(),
                            Text(
                              ":خدمات أخرى",
                              style: fontAlmarai(size: 20),
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
                            child: Text(
                              "الاتصال بنا",
                              style:
                                  fontAlmarai(size: 8, textColor: Colors.blue),
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
                                img: socialMediaList[index], onTap: () {});
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
        ),
      ),
    );
  }
}
