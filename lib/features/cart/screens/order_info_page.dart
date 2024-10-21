import 'package:flutter/material.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/core/utils/styles/app_colors.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/features/cart/screens/payment/order_receipt.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

class OrderInfoPage extends StatefulWidget {
  final OrderModel order;

  const OrderInfoPage({Key? key, required this.order}) : super(key: key);

  @override
  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  late OrderModel _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    List optionalRows = [
      _buildViewRow(
        'اللون',
        _order.orderColor,
      ),
      _buildViewRow(
        'الحجم',
        _order.orderSize,
      ),
      _buildViewRow(
        'التباعد',
        _order.orderPadding,
      ),
      _buildViewRow(
        'نوع الورق',
        _order.orderPaper,
      ),
      _buildViewRow(
        'التغليف',
        _order.orderPackaging,
      ),
      _buildViewRow(
        'الخصم',
        _order.orderDiscount,
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appCustomBar("تفاصيل الطلب", context),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              if ("product" != _order.orderType)
                fileActionWidget(
                    onOpen: () {
                      checkNOpenUrl(_order.orderFile, context);
                    },
                    title: "الملف المرفوع للطباعة"),
              // fileActionWidget(
              //     onOpen: () {
              //       NaviCubit.get(context).navigate(
              //           context,
              //           UserInfoPage(
              //             userId: widget.order.orderUser,
              //           ));
              //     },
              //     title: "المستخدم"),
              fileActionWidget(
                  onOpen: () {
                    NaviCubit.get(context).navigate(
                        context,
                        OrderReceiptPage(
                          orderModel: widget.order,
                        ));
                  },
                  title: "الفاتورة"),
              _buildViewRow(
                'رقم الطلب',
                _order.orderId,
              ),
              _buildViewRow(
                'الوصف',
                _order.orderDescription,
              ),
              _buildViewRow(
                'عنوان الطلب',
                _order.orderTitle,
              ),
              if ("product" != _order.orderType &&
                  "service" != _order.orderType)
                ...optionalRows,
              _buildViewRow(
                'السعر',
                _order.orderPrice,
              ),
              _buildViewRow(
                'الحالة',
                _order.orderStatus,
              ),
              _buildViewRow('التاريخ', _order.orderDate.toString()),

              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewRow(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
          color: AppColors.white,
          elevation: 0,
          child: ListTile(
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: value.toString().isEmpty
                ? const Text('لا يوجد')
                : Text(value.toString()),
          )),
    );
  }
}
