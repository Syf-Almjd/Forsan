import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/OrderModel.dart';

import '../../../Components/ChooseWidget.dart';
import '../../../Components/Components.dart';
import '../../../Cubit/AppDataCubit/app_cubit.dart';
import 'Components.dart';

class printNowPage extends StatefulWidget {
  final String title;

  const printNowPage(this.title, {super.key});

  @override
  printNowPageState createState() => printNowPageState();
}

class printNowPageState extends State<printNowPage> {
  TextEditingController moreRequirement = TextEditingController();
  TextEditingController discountText = TextEditingController();

  bool fileUploaded = false;
  var FILEuploded;
  String fileName = "";
  Map<String, String> orderList = {};
  bool changePassBtn = false;
  var discountCode;

  void addItemToOrder(String key, String item) {
    orderList[key] = (item);
  }

  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  GeneCode() => String.fromCharCodes(
      Iterable.generate(8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  @override
  Widget build(BuildContext context) {
    String generatedCode = GeneCode();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "صفحة ${widget.title}",
            style: fontAlmarai(fontWeight: FontWeight.bold),
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
                      addItemToOrder("النوع للورق",
                          selectedItem); // Call the method when an item is selected
                    },
                    itemPerRow: 3,
                  )),
              getCube(2, context),
              SizedBox(
                height: getHeight(18, context),
                width: getWidth(90, context),
                child: textFieldA(
                    internalPadding: 30,
                    textAlign: TextAlign.center,
                    controller: moreRequirement,
                    hintText: "اذكر لنا تفاصيل أخرى للطباعة التي تريدها "),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoSwitch(
                    applyTheme: true,
                    value: changePassBtn,
                    onChanged: (value) => setState(() {
                      changePassBtn = value;
                    }),
                  ),
                  const Text('هل لديك كود خصم؟'),
                ],
              ),
              if (changePassBtn)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: discountText,
                    decoration: const InputDecoration(
                        labelText: 'استخدم (طالب) لخصم الطلاب',
                        prefixIcon: Icon(Icons.price_change_outlined),
                        suffixIcon: Icon(Icons.price_change_outlined)),
                  ),
                ),
              SizedBox(
                height: getHeight(10, context),
                width: getWidth(90, context),
                child: Center(
                  child: loadButton(
                      onPressed: () async {
                        checkUserInput(generatedCode);
                      },
                      buttonText: "ابدا الطلب"),
                ),
              ),
              getCube(5, context)
            ],
          ),
        ),
      ),
    );
  }

  void checkUserInput(generatedCode) {
    if (changePassBtn && discountText.text != "طالب") {
      showToast("لا يوجد هذا الخصم", SnackBarType.fail, context);
    }
    if (orderList.values.length != 4 || fileName == "") {
      showToast("يرجى ان تكمل كل الخيارات", SnackBarType.fail, context);
    } else {
      OrderModel submittedOrder = OrderModel(
        orderId: generatedCode,
        orderFile: "",
        orderTitle: widget.title,
        orderPrice: "",
        orderColor: orderList["اللون"].toString(),
        orderSize: orderList["الحجم"].toString(),
        orderPadding: orderList["الوجه"].toString(),
        orderPaper: orderList["النوع للورق"].toString(),
        orderStatus: "لم يدفع",
        orderDescription: moreRequirement.text,
        orderUser: FirebaseAuth.instance.currentUser!.uid,
        orderType: 'printing',
      );
      AppCubit.get(context).uploadUserOrders(submittedOrder, context);
      AppCubit.get(context).uploadUserFiles(FILEuploded, submittedOrder);
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );
    if (result != null && result.files.single.path != null) {
      /// Load result and file details
      PlatformFile file = result.files.first;

      /// normal file
      setState(() {
        FILEuploded = file;
        fileName = file.name;
        fileUploaded = true;
        // fileLink = FileLINK;
      });
    } else {}
  }

// void _pickMultipleFiles() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
//
//   if (result != null) {
//     List<File> files = result.paths.map((path) => File(path!)).toList();
//     print("DONE");
//   } else {
//     print("canceled");
//   }
// }
}
