import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';

import '../../../Components/ChooseWidget.dart';
import '../../../Components/Components.dart';
import '../../../Cubit/AppDataCubit/app_cubit.dart';
import '../../../Models/OrderModel.dart';
import 'Components.dart';

class printNowPage extends StatefulWidget {
  final String title;

  const printNowPage(this.title, {super.key});

  @override
  PrintNowPageState createState() => PrintNowPageState();
}

class PrintNowPageState extends State<printNowPage> {
  TextEditingController moreRequirement = TextEditingController();
  TextEditingController discountText = TextEditingController();
  TextEditingController numberOfPapersController =
      TextEditingController(text: "1");
  double totalPrice = 0.0;

  bool fileUploaded = false;
  String fileName = "";
  Map<String, String> orderList = {};
  bool changePassBtn = false;
  String? discountCode;
  var userUploadedFile;

  void addItemToOrder(String key, String item) {
    setState(() {
      orderList[key] = item;
      totalPrice =
          calculatePrice(); // Update price whenever an item is selected
    });
  }

  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  String generateCode() => String.fromCharCodes(
      Iterable.generate(8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  @override
  Widget build(BuildContext context) {
    String generatedCode = generateCode();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                "صفحة ${widget.title}",
                style: fontAlmarai(fontWeight: FontWeight.bold),
              ),
              Text(
                "السعر الإجمالي: ${totalPrice.toStringAsFixed(2)} ريال",
                style: fontAlmarai(size: getWidth(4, context)),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              NaviCubit.get(context).pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  height: getHeight(40, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: _pickFile,
                      child: fileUploaded
                          ? FileChosen(fileName, context)
                          : ChooseFile(context),
                    ),
                  ),
                ),
              ),
              Text(
                "نوع الخدمة: ${widget.title}",
                style: fontAlmarai(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "اختر اللون",
                    style: fontAlmarai(size: getWidth(7, context)),
                  ),
                ),
              ),
              SizedBox(
                width: getWidth(90, context),
                height: getHeight(30, context),
                child: ChooseItemWidget(
                  name: const ["ابيض واسود", "ملون"],
                  onTap: (selectedItem) {
                    addItemToOrder("اللون", selectedItem);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 15),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "اختر الحجم",
                    style: fontAlmarai(size: getWidth(7, context)),
                  ),
                ),
              ),
              SizedBox(
                width: getWidth(90, context),
                height: getHeight(30, context),
                child: ChooseItemWidget(
                    name: const ["A5 (صغير)", "A4 (عادي)", "A3 (كبير)"],
                    onTap: (selectedItem) {
                      addItemToOrder("الحجم", selectedItem);
                    },
                    itemPerRow: 3),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 15),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "جوانب الطباعة",
                    style: fontAlmarai(size: getWidth(7, context)),
                  ),
                ),
              ),
              SizedBox(
                width: getWidth(90, context),
                height: getHeight(30, context),
                child: ChooseItemWidget(
                  name: const ["وجهين", "وجه واحد"],
                  onTap: (selectedItem) {
                    addItemToOrder("الوجه", selectedItem);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 15),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "نوع الورق",
                    style: fontAlmarai(size: getWidth(7, context)),
                  ),
                ),
              ),
              SizedBox(
                  width: getWidth(90, context),
                  height: getHeight(60, context),
                  child: ChooseItemWidget(
                    name: const [
                      'ورق عادي',
                      'ورق مقوى 180 جرام',
                      'ورق لماع 250 جرام',
                      'ورق لماع 100 جرام',
                      'ورق لماع 130 جرام',
                      'ورق لماع 200 جرام',
                      'استيكر ابيض لامع',
                      'استيكر شفاف',
                      'استيكر ابيض مطفي'
                    ],
                    onTap: (selectedItem) {
                      addItemToOrder("النوع للورق", selectedItem);
                    },
                    itemPerRow: 3,
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 15, top: 15),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "عدد الأوراق",
                    style: fontAlmarai(size: getWidth(7, context)),
                  ),
                ),
              ),
              SizedBox(
                width: getWidth(90, context),
                height: getHeight(60, context),
                child: ChooseItemWidget(
                  itemPerRow: 3,
                  name: const [
                    'سلك حديد',
                    'سلك بلاستيك',
                    'كيس شفاف',
                    'لصق',
                    'تدبيس جانبي',
                    'تدبيس زاوية',
                    'بدون تغليف وبدون تدبيس',
                    'التغليف الحراري',
                  ],
                  onTap: (selectedItem) {
                    addItemToOrder("التغليف", selectedItem);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 15, top: 15),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "عدد الأوراق",
                    style: fontAlmarai(size: getWidth(7, context)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  textDirection: TextDirection.rtl,
                  controller: numberOfPapersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "أدخل عدد الأوراق",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      totalPrice = calculatePrice();
                    });
                  },
                ),
              ),
              getCube(2, context),
              SizedBox(
                height: getHeight(18, context),
                width: getWidth(90, context),
                child: textFieldA(
                    internalPadding: 30,
                    maxLines: 20,
                    textAlign: TextAlign.center,
                    controller: moreRequirement,
                    hintText: "اذكر لنا تفاصيل أخرى للطباعة التي تريدها "),
              ),
              getCube(4, context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoSwitch(
                    value: changePassBtn,
                    onChanged: (value) => setState(() {
                      changePassBtn = value;
                      totalPrice =
                          calculatePrice(); // Recalculate on discount toggle
                    }),
                  ),
                  const Text('هل لديك كود خصم؟'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  "السعر الإجمالي: ${totalPrice.toStringAsFixed(2)} ريال",
                  style: fontAlmarai(size: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (changePassBtn)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    controller: discountText,
                    decoration: const InputDecoration(
                        labelText: 'استخدم (طالب) لخصم الطلاب',
                        prefixIcon: Icon(Icons.price_change_outlined),
                        suffixIcon: Icon(Icons.price_change_outlined)),
                    onChanged: (value) => setState(() {
                      discountCode = value;
                      totalPrice = calculatePrice();
                    }),
                  ),
                ),
              getCube(3, context),
              loadButton(
                onPressed: () {
                  checkUserInput(generatedCode);
                  // Uncomment if needed: showToast("تم ارسال طلبك بنجاح", SnackBarType.success, context);
                },
                buttonText: "اطبع الآن",
              ),
              getCube(5, context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkUserInput(String generatedCode) async {
    if (orderList.values.length <= 4 || fileName.isEmpty) {
      showToast("يرجى ان تكمل كل الخيارات", SnackBarType.fail, context);
    } else {
      var user = await AppCubit.get(context).getLocalUserData();

      OrderModel submittedOrder = OrderModel(
        orderId: generatedCode.toUpperCase(),
        orderFile: fileName,
        orderTitle: widget.title,
        orderPrice: totalPrice.toStringAsFixed(2),
        orderUser: user.userID,
        orderUserName: user.name,
        orderDiscount: changePassBtn && discountCode == "طالب"
            ? 'المستخدم لديه كود "$discountCode"'
            : "",
        orderColor: orderList["اللون"].toString(),
        orderSize: orderList["الحجم"].toString(),
        orderPadding: orderList["الوجه"].toString(),
        orderPaper: orderList["النوع للورق"].toString(),
        orderStatus: "لم يدفع",
        orderDescription: moreRequirement.text,
        orderType: 'printing',
        orderDate: DateTime.now().toUtc().toString(),
        orderPackaging: orderList["التغليف"].toString(),
      );

      await AppCubit.get(context)
          .uploadFullOrder(submittedOrder, userUploadedFile, context);
    }
  }

  double calculatePrice() {
    double basePrice = 0.0;

    // Determine the base price based on selected options
    if (orderList.containsKey("اللون")) {
      basePrice += orderList["اللون"] == "ملون" ? 0.40 : 0.10;
    }

    if (orderList.containsKey("الحجم")) {
      if (orderList["الحجم"] == "A5 (صغير)" ||
          orderList["الحجم"] == "A4 (عادي)") {
        basePrice += 0.00; // No additional cost for A5 and A4
      } else if (orderList["الحجم"] == "A3 (كبير)") {
        basePrice += orderList["اللون"] == "ملون"
            ? 3.00
            : 1.00; // A3 pricing based on color
      }
    }

    if (orderList.containsKey("النوع للورق")) {
      basePrice += 3.00; // Fixed price for all paper types
    }

    // Add packaging options
    if (orderList.containsKey("التغليف")) {
      switch (orderList["التغليف"]) {
        case 'سلك حديد':
          basePrice += 5.00; // Add 5.00 for iron wire
          break;
        case 'سلك بلاستيك':
          basePrice += 5.00; // Add 5.00 for plastic wire
          break;
        case 'كيس شفاف':
          basePrice += 0.50; // Add 0.50 for transparent bag
          break;
        case 'لصق':
          basePrice += 3.00; // Add 3.00 for tape
          break;
        case 'تدبيس جانبي':
          basePrice += 0.00; // No additional cost for side stapling
          break;
        case 'تدبيس زاوية':
          basePrice += 0.00; // No additional cost for corner stapling
          break;
        case 'بدون تغليف وبدون تدبيس':
          basePrice += 0.00; // No additional cost for no packaging or stapling
          break;
        case 'التغليف الحراري':
          basePrice += 3.00; // Add 3.00 for thermal packaging
          break;
      }
    }

    // Apply discount if applicable
    // if (changePassBtn && discountCode == "طالب") {
    //   basePrice *= 0.9; // 10% student discount
    // }

    // Multiply by the number of papers
    int numberOfPapers = int.tryParse(numberOfPapersController.text) ?? 1;
    return basePrice * numberOfPapers;
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );
    if (result != null && result.files.single.path != null) {
      /// Load result and file details
      PlatformFile file = result.files.first;

      /// normal file
      setState(() {
        userUploadedFile = file;
        fileName = file.name;
        fileUploaded = true;
        // fileLink = FileLINK;
      });
    }
  }
}
