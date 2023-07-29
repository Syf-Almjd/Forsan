import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';

class cartPage extends StatefulWidget {
  const cartPage({super.key});

  @override
  State<cartPage> createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: getWidth(40, context),
              height: getHeight(8, context),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(100), right: Radius.circular(20)),
                color: Colors.red,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_forever_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "مسح",
                    style: fontAlmarai(size: 8, textColor: Colors.white),
                  ),
                ],
              ),
            ),

            const Spacer(),
            // Text(
            //   "قائمة المشتريات",
            //   style: fontAlmarai(textColor: Colors.white),
            // ),
            // Spacer(),
            Container(
              width: getWidth(40, context),
              height: getHeight(8, context),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20), right: Radius.circular(100)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.payment_outlined,
                    size: 30,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "الدفع والتوصيل",
                    style: fontAlmarai(size: 8, textColor: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: getHeight(10, context),
      ),
      body: Center(
        child: Text(
          "السلة فارغة",
          style: fontAlmarai(),
        ),
      ),

      //TODO list
      // body: Column(
      //   children: [
      //     getCube(3, context),
      //     Expanded(
      //       child: SizedBox(
      //         child: ListView.builder(
      //           physics: const BouncingScrollPhysics(),
      //           itemCount: 3,
      //           shrinkWrap: true,
      //           scrollDirection: Axis.vertical,
      //           itemBuilder: (context, index) => const cartList(),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
