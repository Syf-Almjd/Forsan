import 'package:flutter/material.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/core/utils/managers/app_assets.dart';
import 'package:introduction_screen/introduction_screen.dart';

List<IconData> homeMenuIcons = [
  Icons.account_circle_outlined,
  Icons.shopping_cart_outlined,
  Icons.add_business_outlined,
  Icons.home_outlined
];

List<PageViewModel> listPagesViewModel(context) => [
      PageViewModel(
        title: 'مرحبًا بك في تطبيق فرسان للطباعة',
        body: 'خدماتنا تشمل طباعة المستندات، الصور، الملصقات، الشهادات، وأكثر',
        image: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AppAssets.assetsForsanLogo),
          ),
        ),
      ),
      PageViewModel(
        title: 'اطبع ملفاتك بكل سهولة ويُسر',
        body:
            'اطبع ملفاتك بأعلى جودة وبأسعار مناسبة وتوصيل سريع لمنزلك أو مكتبك',
        image: Center(
          child: Image.network(
              "https://i.pinimg.com/originals/0c/28/08/0c28087b5cedf7276ee6c8d81e28d328.gif",
              height: getHeight(50, context)),
        ),
      ),
      PageViewModel(
        title: 'احصل على طباعة مخصصة وفعالة',
        body: 'اطبع ملصقات وبطاقات أعمال وأكثر بتصميمات مخصصة لاحتياجاتك',
        image: Center(
          child: Image.network(
              "https://i.pinimg.com/originals/03/a9/23/03a923c621632e6e80b675909ababb9d.gif",
              height: getHeight(50, context)),
        ),
      ),
    ];
