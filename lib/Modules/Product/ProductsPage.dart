import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Modules/HomeScreen/Screens/PrintNowPage.dart';
import 'package:forsan/Modules/Product/ItemType.dart';

import '../../API/Data/inAppData.dart';
import '../../Components/Components.dart';
import '../../Cubit/AppDataCubit/app_cubit.dart';
import '../../Cubit/BaB BloC/ba_b_bloc.dart';
import '../../Models/ProductModel.dart';
import 'DetailsPage.dart';
import 'ProductCardView.dart';

class productsPage extends StatefulWidget {
  const productsPage({super.key});

  @override
  State<productsPage> createState() => _productsPageState();
}

class _productsPageState extends State<productsPage> {
  @override
  Widget build(BuildContext context) {
    bool isReversed = false;
    final appDataState = BlocProvider.of<AppCubit>(context);
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  BlocProvider.of<BaBBloc>(context).add(TabChange(1));
                },
                child: Column(
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
              ),
              const Spacer(),
              Container(
                height: getHeight(10, context),
                decoration: const BoxDecoration(
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
              const Spacer(),
              InkWell(
                onTap: () {
                  NaviCubit.get(context)
                      .navigate(context, const printNowPage("الطباعة"));
                },
                child: Column(
                  children: [
                    const Icon(
                      Icons.print_outlined,
                      size: 30,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "اطبع",
                      style: fontAlmarai(size: 10, textColor: Colors.blue),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          getCube(2, context),
          SizedBox(
            height: getHeight(5, context), //height for overall container
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: ProductListType.length,
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) =>
                  itemType(ProductListType[index], () {
                setState(() {
                  isReversed = !isReversed;
                });
              }),
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
                    child: Text(
                      "لا يوجد منتجات",
                    ),
                  );
                }
                List<ProductModel> ListProducts =
                    appDataState.getDataJson(snapshot);
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 80,
                    ),
                    itemCount: ListProducts.length,
                    shrinkWrap: true,
                    // reverse: isReversed,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ProductCardView(
                        product: ListProducts[index],
                        onTap: (productData) {
                          NaviCubit.get(context).navigate(
                              context, DetailsPage(product: productData));
                        },
                      );
                    });
              },
            ),
          ),
        ],
      )),
    );
  }
}
