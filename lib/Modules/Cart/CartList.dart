import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Models/OrderModel.dart';

class cartList extends StatelessWidget {
  final OrderModel order;
  final Function onTap;

  const cartList({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: getWidth(100, context),
        height: getHeight(20, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.6))
        ),
          child: Stack(
            children: [
              Positioned(
                top: 10.0,
                left: 10.0,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: getHeight(4, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue),
                        // color: Colors.lightGreen.withOpacity(0.4),
                      ),
                      child:   InkWell(
                          onTap: () {
                            showToast("اتصال", SnackBarType.save, context);
                            // UrlLauncher.launch('mailto:${widget.email.toString()}');
                          },
                          child: FittedBox(
                            child: Icon(
                              Icons.call_outlined,
                              color: Colors.blue.withOpacity(0.9),
                            ),
                          )),
                    ),
                    getCube(2, context),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: getHeight(4, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.greenAccent),
                        // color: Colors.lightGreen.withOpacity(0.4),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain, // Ensure the text fits within the container
                        child: Text(order.orderStatus, style: TextStyle(color: Colors.green),),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child:  Image.network(
                  height: getHeight(10, context),
                  "https://media3.giphy.com/media/eNjBO84E9vTOucl3pJ/giphy.gif?cid=6c09b952z7ccmhdxm2j3957lezub7uejsd6y564ddmrbivwo&ep=v1_stickers_related&rid=giphy.gif&ct=s"
                  // "https://cdn.pixabay.com/animation/2022/07/29/03/42/03-42-11-849_512.gif"
                  // "https://mir-s3-cdn-cf.behance.net/project_modules/disp/35771931234507.564a1d2403b3a.gif"
                // "https://icaengineeringacademy.com/wp-content/uploads/2019/01/ajax-loading-gif-transparent-background-2.gif"
              ),),
              Positioned(
                  top: 20,
                  right: 20,
                  child: SizedBox(
                    width: getWidth(50, context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(order.orderTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                        getCube(2, context),
                        const Text(":التفاصيل", style: TextStyle(),textAlign: TextAlign.left,),
                        getCube(2, context),
                        Text(
                          order.orderDescription,
                          maxLines: 4,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Positioned(
                bottom: 10,
                right: 20,
                child:  Text("رقم الطلب: ${order.orderId}" )
              ),

            ],
          ),
      ),
    );
  }
}




















// child: Container(
//         height: getHeight(20, context),
//         width: getWidth(80, context),
//         decoration: BoxDecoration(
//             color: Colors.green.shade400, borderRadius: BorderRadius.circular(30)),
//         child: InkWell(
//           onTap: (){onTap;},
//           child: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Row(
//               children: [
//                 Column(
//                   children: [
//                     const Text(
//                       ":حالة الطلب",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Spacer(),
//                     Image.network(
//                         height: getHeight(7, context),
//                         // "https://mir-s3-cdn-cf.behance.net/project_modules/disp/35771931234507.564a1d2403b3a.gif"
//                       "https://icaengineeringacademy.com/wp-content/uploads/2019/01/ajax-loading-gif-transparent-background-2.gif"
//                     ),
//                     Text(
//                       order.orderStatus,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 20,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         InkWell(
//                             onTap: () {
//                               showToast("حدف", SnackBarType.save, context);
//                               // UrlLauncher.launch('tel:+${widget.phone.toString()}');
//                             },
//                             child: const Icon(Icons.delete_outline_outlined,
//                                 color: Colors.red,
//                                 size: 35)),
//                         SizedBox(
//                           width: getWidth(5, context),
//                         ),
//                         InkWell(
//                             onTap: () {
//                               showToast("ايميل", SnackBarType.save, context);
//                               // UrlLauncher.launch('mailto:${widget.email.toString()}');
//                             },
//                             child: const Icon(
//                               Icons.call,
//                               color: Colors.blue,
//                               size: 35,
//                             )),
//                         SizedBox(
//                           width: getWidth(5, context),
//                         ),
//                         InkWell(
//                             onTap: () {
//                               showToast("ايميل", SnackBarType.save, context);
//                               // UrlLauncher.launch('mailto:${widget.email.toString()}');
//                             },
//                             child: const Icon(
//                               Icons.send,
//                               color: Colors.yellow,
//                               size: 35,
//                             )),
//                       ],
//                     ),
//                     const Spacer(),
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "الطلب: ${order.orderTitle}",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
//                           child: FittedBox(
//                             child: Text(
//                               order.orderDescription,
//                               maxLines: 2,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer()
//                   ],
//                 ),
//
//               ],
//
//             ),
//           ),
//         ),
//       ),