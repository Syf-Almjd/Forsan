import 'package:flutter/material.dart';

List<IconData> homeMenuIcons = [
  Icons.account_circle_outlined,
  Icons.shopping_cart_outlined,
  Icons.add_business_outlined,
  Icons.home_outlined
];

List<BottomNavigationBarItem> homeMenu = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.account_circle_rounded),
    label: 'حسابي',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.shopping_cart_outlined),
    label: 'السلة',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.shopping_basket_sharp),
    label: 'المنتجات',
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'الرئيسية',
  ),
];
