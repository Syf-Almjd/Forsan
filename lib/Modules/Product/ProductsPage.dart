import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/API/Data/inAppData.dart';
import 'package:forsan/Modules/Product/ItemTypeList.dart';

import '../../Components/Components.dart';
import '../../Cubit/AppDataCubit/app_cubit.dart';
import '../../Models/ProductModel.dart';
import 'ItemsList.dart';

class productsPage extends StatefulWidget {
  const productsPage({super.key});

  @override
  State<productsPage> createState() => _productsPageState();
}

class _productsPageState extends State<productsPage> {
  @override
  Widget build(BuildContext context) {
    final appDataState = BlocProvider.of<AppCubit>(context);
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Column(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 30,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "السلة",
                    style: fontAlmarai(size: 10, textColor: Colors.green),
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: getHeight(10, context),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                  color: Colors.amberAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Text(
                    " منتجاتنا المكتبية",
                    style: fontAlmarai(size: 20, textColor: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Spacer(),
              Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    size: 30,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "المفضّل",
                    style: fontAlmarai(size: 10, textColor: Colors.red),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          getCube(2, context),
          SizedBox(
            height: getHeight(5, context), //hight for overall container
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ProductListType.length,
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  itemType(ProductListType[index], () {}),
            ),
          ),
          getCube(2, context),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loadingAnimation();
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text("Error fetching data"),
                  );
                }
                FirebaseAuth.instance.signInAnonymously();
                List<ProductModel> ListProducts =
                    appDataState.getDataJson(snapshot);
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 80,
                    ),
                    itemCount: 3,
                    //ListProducts.length
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ProductCardView(product: ListProducts[index]);
                    });
              },
            ),
          ),
        ],
      )),
    );
  }
}
