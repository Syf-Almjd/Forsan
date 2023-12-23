import 'package:flutter/material.dart';
import 'package:forsan/Models/ProductModel.dart';

import '../../Components/Components.dart';

class ProductCardView extends StatelessWidget {
  const ProductCardView(
      {Key? key,
      required this.product,
      this.imageAlignment = Alignment.bottomCenter,
      required this.onTap})
      : super(key: key);

  final ProductModel product;
  final Alignment imageAlignment;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onTap(product);
        },
        child: Column(children: [
          Expanded(
            child: SizedBox(
              height: getHeight(10, context),
              width: getWidth(100, context),
              child: Center(
                child: previewProductImage(product.productImgID, context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              children: [
                Text(
                  "ريال ${product.productPrice} ",
                  style: fontAlmarai(size: 10, textColor: Colors.green),
                ),
                const Spacer(),
                Text(
                  product.productTitle,
                  style: fontAlmarai(fontWeight: FontWeight.bold, size: 10),
                ),
              ],
            ),
          ),
          Text(
            product.productDescription,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: fontAlmarai(size: 10),
          ),
        ]),
      ),
    );
  }
}
