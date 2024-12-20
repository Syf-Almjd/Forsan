import 'package:flutter/material.dart';
import 'package:forsan/features/shared/components.dart';

class ProductTypeWidget extends StatelessWidget {
  final String name;
  final Function onTap;

  const ProductTypeWidget(this.name, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        getCube(2, context),
        GestureDetector(
            onTap: () {
              onTap();
            },
            child: Container(
              width: getWidth(22, context),
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.yellow,
              ),
              child: Text(
                name,
                style: fontAlmarai(size: 10, textColor: Colors.black),
                textAlign: TextAlign.center,
              ),
            )),
        getCube(2, context),
      ],
    );
  }
}
