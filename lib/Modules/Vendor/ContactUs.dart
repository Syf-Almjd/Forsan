import 'package:flutter/material.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Modules/Vendor/OurServiceText.dart';

import '../../API/Data/inAppData.dart';
import '../../Components/Components.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تواصل "),
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
              decoration: const InputDecoration(
                labelText: "الاسم",
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: "الرسالة",
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 60.0,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () async {
              },
              child: Text("إرسال",
                style: fontAlmarai(
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white),
              ),
            ),
        ),
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
                            img: socialMediaList.keys.toList()[index], onTap: (index) {
                          openUrl(socialMediaList.values.toList()[index]);
                        });
                      }),
                ),
              ],
            ),
            getCube(2, context),
            const Divider(),
            getCube(2, context),
            Container(
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                onPressed: () async {
                  NaviCubit.get(context).navigate(context, const OurPolicies());
                },
                child: Text("السياسات والتوصيل",
                  style: fontAlmarai(
                      fontWeight: FontWeight.normal,
                      textColor: Colors.white),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
