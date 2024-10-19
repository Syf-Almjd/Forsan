import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/core/shared/components.dart';
import 'package:forsan/domain/models/user_model.dart';
import 'package:forsan/domain/models/user_payment_model.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';
import 'package:hexcolor/hexcolor.dart';

class BankPaymentPage extends StatefulWidget {
  final OrderModel order;
  const BankPaymentPage({Key? key, required this.order}) : super(key: key);

  @override
  State<BankPaymentPage> createState() => _BankPaymentPageState();
}

class _BankPaymentPageState extends State<BankPaymentPage> {
  UserModel userModel = UserModel.loadingUser();

  final TextEditingController name = TextEditingController();

  final TextEditingController num = TextEditingController();

  @override
  void initState() {
    getLocalUser();
    super.initState();
  }

  getLocalUser() async {
    userModel = await AppCubit.get(context).getLocalUserData();
    setState(() {
      name.text = userModel.name;
      num.text = userModel.phoneNumber;
    });
  }

  @override
  void dispose() {
    name.dispose();
    num.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController code =
        TextEditingController(text: widget.order.orderId);

    return Scaffold(
      appBar: appCustomBar("دفع بالايصال", context),
      resizeToAvoidBottomInset: false,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  children: [
                    Text(
                      "يرجى إيداع المبلغ قبل المتابعة",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      " بمجرد إتمام عملية الدفع، ربما ستتصل بك المكتبة",
                      style: TextStyle(fontSize: 10, color: Colors.black45),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "يرجى ملء هذه التفاصيل",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        labelText: 'اسم صاحب الطلب',
                        labelStyle: TextStyle(
                          color: HexColor("#948fa1"),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#2C3E35")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: num,
                      decoration: InputDecoration(
                        labelText: 'رقم هاتف صاحب الطلب للاتصال',
                        labelStyle: TextStyle(
                          color: HexColor("#948fa1"),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#2C3E35")),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        showToast("تم النسخ", SnackBarType.success, context);
                        await Clipboard.setData(
                            ClipboardData(text: widget.order.orderId));
                      },
                      child: Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.qr_code,
                              color: Colors.black45,
                              size: 100,
                            ),
                            const Text(
                              "ضع هذا الكود في الرصيد",
                              style: TextStyle(color: Colors.black45),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.order.orderId,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.black45),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              "رجاء قم بدفع كامل المبلغ المستحق",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black45),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("معلومات الحساب:"),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            showToast("تم نسخ اسم الحساب إلى حافظة جهازك",
                                SnackBarType.success, context);
                            await Clipboard.setData(const ClipboardData(
                                text: "مؤسسة القدرة الفريق التجارية"));
                          },
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade200,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 30, 10),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      "مؤسسة القدرة الفريق التجارية",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Expanded(child: SizedBox.expand()),
                                    Icon(Icons.copy)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            showToast("تم نسخ رقم الأيبان إلى حافظة جهازك",
                                SnackBarType.success, context);
                            await Clipboard.setData(const ClipboardData(
                                text: "SA3405000068205175845000"));
                          },
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade200,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 30, 10),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      "الأيبان: SA3405000068205175845000",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Expanded(child: SizedBox.expand()),
                                    Icon(Icons.copy)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("المبلغ المستحق"),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            checkNOpenUrl(
                                "https://wa.me/+966501510093", context);
                          },
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade100,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 30, 10),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.attach_money_outlined),
                                    const Expanded(child: SizedBox.expand()),
                                    Text(
                                      widget.order.orderPrice.isEmpty
                                          ? "(تواصل لتحديد) غير محدد"
                                          : widget.order.orderPrice,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Expanded(child: SizedBox.expand()),
                                    const Icon(Icons.sms_outlined)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "يُرجى التأكد من ذكر الرمز الذي تم إنشاؤه في إيصالك ومن مطابقة المعلومات لتفاصيلك الخاصة، تأكد من التوضيح في رسالة الإيصال.\nشكرًا لك!",
                      style: TextStyle(color: Colors.black45, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: loadButton(
                        textSize: getWidth(5, context),
                        onPressed: () {
                          validateCashPayment(code.text, context);
                        },
                        buttonText: "تاكيد التحويل البنكي",
                      ),
                    ),
                    getCube(5, context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validateCashPayment(code, context) async {
    if (name.text.isEmpty || num.text.isEmpty || code.isEmpty) {
      showToast("الرجاء تعبئة المعلومات المتعلقة بالمستلم", SnackBarType.fail,
          context);
      // showErrorMessage("No Empty Boxes Allowed! :(");
    } else {
      widget.order.orderStatus = "تحويل بنكي";
      await AppCubit.get(context).updateUserOrders(widget.order, context);
      await AppCubit.get(context).sendUserPaymentMessage(UserPaymentModel(
          userID: userModel.userID,
          name: name.text,
          email: userModel.email,
          phoneNumber: num.text,
          code: code,
          amount: widget.order.orderPrice.isEmpty
              ? "غير محدد"
              : widget.order.orderPrice,
          orderID: widget.order.orderId,
          status: 'غير مؤكد',
          timestamp: DateTime.now().toLocal()));

      // showToast("تم تحويل الرصيد بنجاح", SnackBarType.success, context);
      NaviCubit.get(context).navigateToHome(context);
    }
  }
}
