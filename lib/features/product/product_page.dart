import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsan/core/shared/components.dart';
import 'package:forsan/features/home_screen/screens/print_now_screen.dart';
import 'package:forsan/features/product/widgets/product_type_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/bottom_navi_bloc/ba_b_bloc.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

import '../../data/local/local_app_data.dart';
import '../../domain/models/product_model.dart';
import 'screens/product_details_page.dart';
import 'widgets/product_card_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    bool isReversed = false;
    final appDataState = BlocProvider.of<AppCubit>(context);
    return Column(
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
                    .navigate(context, const PrintNowScreen("الطباعة"));
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
                ProductTypeWidget(ProductListType[index], () {
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

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "لا يوجد منتجات",
                  ),
                );
              }
              List<ProductModel> ListProducts =
                  appDataState.getDataJson(snapshot);
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
