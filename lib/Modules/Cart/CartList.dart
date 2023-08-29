import 'package:flutter/material.dart';
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
            color: Colors.yellow, borderRadius: BorderRadius.circular(30)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        // UrlLauncher.launch('mailto:${widget.email.toString()}');
                      },
                      child: const Icon(
                        Icons.send,
                        size: 35,
                      )),
                  SizedBox(
                    width: getWidth(5, context),
                  ),
                  InkWell(
                      onTap: () {
                        // UrlLauncher.launch('tel:+${widget.phone.toString()}');
                      },
                      child: const Icon(Icons.call_outlined, size: 35)),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.downloading_outlined,
                                size: 80,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Loading...",
                                style:
                                    TextStyle(fontSize: 10, color: Colors.white),
                              ),
                            ],
                          ),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(20.0),
                          //   child: Image.network(
                          //     order.,
                          //     width: 120.0,
                          //     height: 120.0,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Text(
                      order.orderTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Text(
                    order.orderDescription,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
