import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:forsan/Models/ProductModel.dart';

import '../../Components/Components.dart';

class ProductCardView extends StatelessWidget {
  const ProductCardView(
      {Key? key,
      required this.product,
      this.imageAlignment = Alignment.bottomCenter,
      this.onTap})
      : super(key: key);

  final ProductModel product;
  final Alignment imageAlignment;
  final Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: Column(children: [
          Expanded(
            child: SizedBox(
              height: getHeight(10, context),
              width: getWidth(100, context),
              child: Center(
                child: FutureBuilder(
                  future: FirebaseStorage.instance
                      .ref()
                      .child("products/${product.productImgID}.png")
                      .getDownloadURL(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return loadingAnimation();
                    }
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          snapshot.data!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return loadingAnimation(); // Show a loading indicator while the image is loading
                            }
                          },
                          errorBuilder: (context, error, stackTrace) => Text(
                            "خطا $error",
                            style: TextStyle(fontSize: 10),
                          ),
                          alignment: imageAlignment,
                          fit: BoxFit.cover,
                        ));
                  },
                ),
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
