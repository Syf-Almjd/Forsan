import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';
import 'package:forsan/Components/Shared/utils/styles/app_colors.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/OrderModel.dart';
import 'package:forsan/Modules/Cart/Payment/OrderReceipt.dart';

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
      _buildEditableRow('اللون', _order.orderColor,
          (value) => _updateOrderField('orderColor', value)),
      _buildEditableRow('الحجم', _order.orderSize,
          (value) => _updateOrderField('orderSize', value)),
      _buildEditableRow('التباعد', _order.orderPadding,
          (value) => _updateOrderField('orderPadding', value)),
      _buildEditableRow('نوع الورق', _order.orderPaper,
          (value) => _updateOrderField('orderPaper', value)),
      _buildEditableRow('التغليف', _order.orderPackaging,
          (value) => _updateOrderField('orderPackaging', value)),
      _buildEditableRow('الخصم', _order.orderDiscount,
          (value) => _updateOrderField('orderDiscount', value)),
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
              _buildEditableRow('رقم الطلب', _order.orderId,
                  (value) => _updateOrderField('orderId', value)),
              _buildEditableRow('الوصف', _order.orderDescription,
                  (value) => _updateOrderField('orderDescription', value)),
              _buildEditableRow('عنوان الطلب', _order.orderTitle,
                  (value) => _updateOrderField('orderTitle', value)),
              // _buildEditableRow('المستخدم', _order.orderUserName,
              // (value) => _updateOrderField('orderUserName', value)),
              if ("product" != _order.orderType &&
                  "service" != _order.orderType)
                ...optionalRows,
              _buildEditableRow('السعر', _order.orderPrice,
                  (value) => _updateOrderField('orderPrice', value)),
              _buildEditableRow(
                'الحالة',
                _order.orderStatus,
                (value) => _updateOrderField('orderStatus', value),
              ),
              // _buildEditableRow('التاريخ', _order.orderDate.toString(),
              //     (value) => showToast("لا يمكن تغير التاريخ", context),
              //     isChangable: false),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () async {
              //     showToast(
              //         "تم نسخ رقم خدمة العملاء", SnackBarType.success, context);
              //     await Clipboard.setData(
              //         const ClipboardData(text: "+966501510093"));
              //     checkNOpenUrl("tel:+966501510093", context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.amber,
              //   ),
              //   child: const Text(
              //     'تواصل للتتغير',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(
    String label,
    String value,
    Function(String) onChanged,
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
          )
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextFormField(
          //           enabled: false,
          //           initialValue: value,
          //           maxLines: null,
          //           decoration: InputDecoration(
          //             labelText: label,
          //             suffixIcon: suffixWidget,
          //             border: const OutlineInputBorder(),
          //             contentPadding:
          //                 const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          //           ),
          //           onChanged: onChanged,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }

  // Widget _buildFileRow(String label, String filePath, BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Card(
  //       color: AppColors.white,
  //       elevation: 5,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       checkNcheckNOpenUrl(filePath, context);
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.amber,
  //                     ),
  //                     child: const Text(
  //                       'فتح',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               ': $label',
  //               style: const TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _updateOrderField(String fieldName, String value) {
    setState(() {
      switch (fieldName) {
        case 'orderId':
          _order.orderId = value;
          break;
        case 'orderUserName':
          _order.orderUserName = value;
          break;
        case 'orderType':
          _order.orderType = value;
          break;
        case 'orderFile':
          _order.orderFile = value;
          break;
        case 'orderTitle':
          _order.orderTitle = value;
          break;
        case 'orderPrice':
          _order.orderPrice = value;
          break;
        case 'orderDiscount':
          _order.orderDiscount = value;
          break;
        case 'orderColor':
          _order.orderColor = value;
          break;
        case 'orderSize':
          _order.orderSize = value;
          break;
        case 'orderPadding':
          _order.orderPadding = value;
          break;
        case 'orderPaper':
          _order.orderPaper = value;
          break;
        case 'orderPackaging':
          _order.orderPackaging = value;
          break;
        case 'orderDescription':
          _order.orderDescription = value;
          break;
        case 'orderStatus':
          _order.orderStatus = value;
          break;
        case 'orderDate':
          // _order.orderDate = DateTime.tryParse(value) ?? DateTime.now();
          break;
      }
    });
  }

  // Future<void> updateOrderInfo(OrderModel updatedOrder) async {
  //   await AppCubit.get(context).updateUserOrders(updatedOrder, context);
  //   NaviCubit.get(context).pop(context);
  // }
}
