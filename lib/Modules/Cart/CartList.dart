import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';

class cartList extends StatelessWidget {
  const cartList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Center(
            child: Container(
              height: getHeight(10, context),
              width: getWidth(90, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: Row(
                children: [],
              ),
            ),
          ),
        ),
        getCube(2, context)
      ],
    );
  }
}
