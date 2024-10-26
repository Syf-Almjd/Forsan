import 'package:flutter/material.dart';
import 'package:forsan/features/shared/components.dart';

import '../../data/local/local_app_data.dart';

class OurPolicies extends StatelessWidget {
  const OurPolicies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appCustomBar("سياسات البرنامج", context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            const Text(
              "فرسان تقدم خدمات طباعة اوراقك وملفاتك اونلاين بجودة عالية و بأفضل الاسعار المنافسة مع توفير خدمة التوصيل لجميع مناطق المملكة",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            getCube(2, context),
            const Text(
              "سياسة الاستلام والتوصيل (يتم تحديثها بشكل دوري)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
            getCube(2, context),
            const Text(
              "سياسة الاستلام من الفرع : الطلبات المدفوعة سيتم العمل عليها خلال 24 ساعة عمل مع العلم ان يوم الجمعة لايتم احتسابه ضمن اوقات العمل",
              textAlign: TextAlign.right,
            ),
            const Text(
              "طلبات الدفع عند الاستلام سيتم طباعتها فور وصولك للفرع والدفع",
              textAlign: TextAlign.right,
            ),
            getCube(5, context),
            const Text(
              "سياسة التوصيل داخل جدة : في حال تم الطلب عن طريق الموقع بنفسك فان الطلب لن يتأخر وسيتم طباعته وتوصيله خلال 24 الى 48 ساعه عمل  مع العلم ان يوم الجمعة لايتم احتسابه ضمن اوقات العمل",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
            getCube(2, context),
            const Text(
              "في حال الطلب عبر الواتس اب، فسوف يحتاج مننا رفع طلبك خلال ٢٤ ساعة وإرسال لك رقم طلب، و من بعد الحصول على رقم الطلب سيتم طباعة طلبك خلال 24 الى 48 ساعه مع العلم ان يوم الجمعة لايتم احتسابه ضمن اوقات العمل",
              textAlign: TextAlign.right,
            ),
            getCube(5, context),
            const Text(
              "سياسة التوصيل خارج جدة : في حال تم الطلب عن طريق الموقع بنفسك فان الطلب لن يتأخر سيتم طباعة طلبك خلال 24-48 ساعة ثم سيتم شحن طلبك عبر شركة الشحن ارامكس ويتم تطبيق مدة التوصيل حسب سياسة شركة الشحن مع العلم ان يوم الجمعة لايتم احتسابه ضمن اوقات العمل ولاتتوفر خدمة الدفع عند الاستلام",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
            getCube(2, context),
            const Text(
              "في حال الطلب عبر الواتس اب، ف يحتاج مننا رفع طلبك خلال ٢٤ ساعة وإرسال لك رقم طلب، و من بعد الحصول على رقم الطلب سيتم طباعة طلبك خلال 24-48 ساعة ثم سيتم شحن طلبك عبر شركة الشحن ارامكس ويتم تطبيق مدة التوصيل حسب سياسة شركة الشحن مع العلم ان يوم الجمعة لايتم احتسابه ضمن اوقات العمل",
              textAlign: TextAlign.right,
            ),
            getCube(2, context),
            const Text(
              "يلزم دفع المبلغ مسبقا,"
              "للدعم الفني أو الشكاوى، يمكنك التواصل معنا\n\nForsan.printing@gmail.com \n 0501510093",
              textAlign: TextAlign.right,
            ),
            getCube(5, context),
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
                              checkNOpenUrl(
                                  socialMediaList.values.toList()[index],
                                  context);
                            });
                      }),
                ),
              ],
            ),
            getCube(5, context),
          ],
        ),
      ),
    );
  }
}
