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
        height: getHeight(20, context),
        width: getWidth(80, context),
        decoration: BoxDecoration(
            color: Colors.green.shade400, borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          onTap: (){onTap;},
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Column(
                  children: [
                    const Text(
                      ":حالة الطلب",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Image.network(
                        height: getHeight(7, context),
                        // "https://mir-s3-cdn-cf.behance.net/project_modules/disp/35771931234507.564a1d2403b3a.gif"
                      "https://icaengineeringacademy.com/wp-content/uploads/2019/01/ajax-loading-gif-transparent-background-2.gif"
                    ),
                    Text(
                      order.orderStatus,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              showToast("حدف", SnackBarType.save, context);
                              // UrlLauncher.launch('tel:+${widget.phone.toString()}');
                            },
                            child: const Icon(Icons.delete_outline_outlined,
                                color: Colors.red,
                                size: 35)),
                        SizedBox(
                          width: getWidth(5, context),
                        ),
                        InkWell(
                            onTap: () {
                              showToast("ايميل", SnackBarType.save, context);
                              // UrlLauncher.launch('mailto:${widget.email.toString()}');
                            },
                            child: const Icon(
                              Icons.call,
                              color: Colors.blue,
                              size: 35,
                            )),
                        SizedBox(
                          width: getWidth(5, context),
                        ),
                        InkWell(
                            onTap: () {
                              showToast("ايميل", SnackBarType.save, context);
                              // UrlLauncher.launch('mailto:${widget.email.toString()}');
                            },
                            child: const Icon(
                              Icons.send,
                              color: Colors.yellow,
                              size: 35,
                            )),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        // Icon(
                        //   Icons.file_copy_outlined,
                        //   size: 80,
                        //   color: Colors.white,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "الطلب: ${order.orderTitle}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: SizedBox(
                            width: getWidth(35, context),
                            child: Text(
                              order.orderDescription,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer()
                  ],
                ),

              ],

            ),
          ),
        ),
      ),
    );
  }
}
