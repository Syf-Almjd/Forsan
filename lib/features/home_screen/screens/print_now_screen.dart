import 'dart:io';
import 'dart:math';

import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/features/shared/components.dart';
import 'package:forsan/core/utils/managers/app_constants.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/features/home_screen/widgets/choose_file_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

import 'package:increment_decrement_form_field/increment_decrement_form_field.dart';

class PrintNowScreen extends StatefulWidget {
  final String title;

  const PrintNowScreen(this.title, {super.key});

  @override
  PrintNowPageState createState() => PrintNowPageState();
}

class PrintNowPageState extends State<PrintNowScreen> {
  TextEditingController moreRequirement = TextEditingController();
  TextEditingController discountText = TextEditingController();
  ValueNotifier<int> numberOfCopies = ValueNotifier<int>(1);
  double totalPrice = 0.0;
  FormFieldState<int>? formFieldState = FormFieldState<int>();

  bool fileUploaded = false;
  String fileName = "";
  String? fileLink;
  Map<String, String> orderList = {};
  bool changePassBtn = false;
  String? discountCode;
  late PlatformFile userUploadedFile;
  var numOfPages = 0;
  var isImageLoading = false;
  int loader = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "صفحة ${widget.title}",
              style: fontAlmarai(fontWeight: FontWeight.bold),
            ),
            Text(
              "السعر الإجمالي: ${totalPrice.toStringAsFixed(2)} ${AppConstants.appCurrancy}}",
              style: fontAlmarai(size: getWidth(4, context)),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel_outlined,
            size: 30,
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
            if (fileUploaded && numOfPages != 0)
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "$loader% :تم التحميل",
                  )),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: InkWell(
                onTap: () {
                  if (!isImageLoading) {
                    _pickFile();
                  }
                },
                child: Container(
                  height: getHeight(40, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  child: Center(
                    child: fileUploaded
                        ? FileChosen(fileName, context)
                        : ChooseFile(context),
                  ),
                ),
              ),
            ),
            const Text(
              "او",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            getCube(1, context),
            const Text(
              "(يفضل في حالة الملفات الكبيرة او ملفات درايف)\n ",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: getWidth(85, context),
              child: textFieldA(
                  maxLines: 1,
                  onChanged: (value) {
                    if (value.isNotEmpty && value.length > 10) {
                      setState(() {
                        fileLink = value;
                        fileName = value;
                        fileUploaded = true;
                      });
                    }
                  },
                  textAlign: TextAlign.end,
                  controller: TextEditingController(),
                  hintText: "لينك الملف  🔗 "),
            ),
            getCube(3, context),
            if (numOfPages != 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "{$numOfPages} عدد الصفحات",
                  style: fontAlmarai(size: getWidth(4, context)),
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
              child: ChooseFileWidget(
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
              height: getHeight(25, context),
              child: ChooseFileWidget(
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
              child: ChooseFileWidget(
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
                child: ChooseFileWidget(
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
                  "نوع التغليف",
                  style: fontAlmarai(size: getWidth(7, context)),
                ),
              ),
            ),
            SizedBox(
              width: getWidth(90, context),
              height: getHeight(60, context),
              child: ChooseFileWidget(
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
                  "عدد النسخ",
                  style: fontAlmarai(size: getWidth(7, context)),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: numberOfCopies,
              builder: (context, value, child) {
                return InkWell(
                  onTap: () async {
                    var noPaper = await showPrintingNoDialog(context: context);
                    numberOfCopies.value = noPaper;
                    formFieldState?.didChange(noPaper);

                    totalPrice = calculatePrice();

                    setState(() {});
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 15, right: 10, left: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    width: getWidth(80, context),
                    child: Center(
                      child: IncrementDecrementFormField<int>(
                        autovalidateMode: AutovalidateMode.always,
                        onSaved: (value) {
                          numberOfCopies.value = value!;
                        },

                        // an initial value
                        initialValue: numberOfCopies.value,
                        // if no value set 0, otherwise display the value as a string
                        displayBuilder: (value, field) {
                          formFieldState = field;
                          return Text(
                            value == null ? "1" : value.toString(),
                          );
                        },
                        onDecrement: (currentValue) {
                          if (currentValue! <= 1) {
                            return 1;
                          }
                          setState(() {
                            numberOfCopies.value = currentValue - 1;
                          });
                          totalPrice = calculatePrice();

                          return numberOfCopies.value;
                        },

                        onIncrement: (currentValue) {
                          setState(() {
                            numberOfCopies.value = currentValue! + 1;
                          });
                          totalPrice = calculatePrice();

                          return numberOfCopies.value;
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            getCube(4, context),
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
            BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
              if (state is GettingData) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('...الملف قيد المعالجة يرجى الانتظار'),
                );
              } else {
                return Container();
              }
            }),
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
    );
  }

  Future<void> checkUserInput(String generatedCode) async {
    if (orderList.values.length <= 4 || fileName.isEmpty) {
      showToast("يرجى ان تكمل كل الخيارات", SnackBarType.fail, context);
    } else {
      var user = await AppCubit.get(context).getLocalUserData();

      OrderModel submittedOrder = OrderModel(
        orderId: generatedCode.toUpperCase(),
        orderFile: fileLink ?? '',
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
        orderDescription: "${widget.title}\n${moreRequirement.text}",
        orderType: 'printing',
        orderDate: DateTime.now().toLocal(),
        orderPackaging: orderList["التغليف"].toString(),
      );
      if (mounted) {
        await AppCubit.get(context).uploadUserOrders(submittedOrder, context);
      }
    }
  }

  double calculatePrice() {
    double basePrice = 0.0;

    // Determine the base price based on selected options
    if (orderList.containsKey("اللون")) {
      // basePrice += orderList["اللون"] == "ملون" ? 0.40 : 0.10;
    }

    if (orderList.containsKey("الحجم")) {
      if (orderList["الحجم"] == "A5 (صغير)" ||
          orderList["الحجم"] == "A4 (عادي)") {
        basePrice += orderList["اللون"] == "ملون"
            ? 0.40
            : 0.10; // No additional cost for A5 and A4
      } else if (orderList["الحجم"] == "A3 (كبير)") {
        basePrice += orderList["اللون"] == "ملون"
            ? 3.00 //todo only add if a3
            : 1.00; // A3 pricing based on color
      }
    }

    if (orderList.containsKey("النوع للورق")) {
      basePrice += orderList["النوع للورق"] == "ورق عادي"
          ? 0.00
          : 3.00; // Fixed price for all paper types
    }
    var packageCosting = 0.0;

    // Add packaging options
    if (orderList.containsKey("التغليف")) {
      switch (orderList["التغليف"]) {
        case 'سلك حديد':
          packageCosting += 5.00; // Add 5.00 for iron wire
          break;
        case 'سلك بلاستيك':
          packageCosting += 5.00; // Add 5.00 for plastic wire
          break;
        case 'كيس شفاف':
          packageCosting += 0.50; // Add 0.50 for transparent bag
          break;
        case 'لصق':
          packageCosting += 3.00; // Add 3.00 for tape
          break;
        case 'تدبيس جانبي':
          packageCosting += 0.00; // No additional cost for side stapling
          break;
        case 'تدبيس زاوية':
          packageCosting += 0.00; // No additional cost for corner stapling
          break;
        case 'بدون تغليف وبدون تدبيس':
          packageCosting +=
              0.00; // No additional cost for no packaging or stapling
          break;
        case 'التغليف الحراري':
          packageCosting += 3.00; // Add 3.00 for thermal packaging
          break;
      }
    }

    basePrice = basePrice * numOfPages; // Add 3.00 for packing
    // Apply discount if applicable
    if (changePassBtn && discountCode == "طالب") {
      basePrice *= 0.95; // 5% student discount
    }

    // Multiply by the number of papers
    return (basePrice * numberOfCopies.value) + packageCosting;
  }

  void startLoader() async {
    loader = 0;

    for (int i = 0; i < numOfPages && i < 100; i++) {
      if (fileLink != null) {
        loader = 100;
        setState(() {});
        break;
      }
      await Future.delayed(Duration(milliseconds: userUploadedFile.size ~/ 50));
      loader += 1;

      setState(() {});
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _pickFile() async {
    isImageLoading = true;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );
    if (result != null && result.files.single.path != null) {
      /// Load result and file details
      PlatformFile file = result.files.first;
      if (file.extension == "pdf" ||
          file.extension == "PDF" ||
          file.extension == "doc" ||
          file.extension == "DOC" ||
          file.extension == "docx" ||
          file.extension == "DOCX") {
        final stream = ByteStream(File(file.path!).readAsBytesSync());

        final doc = await PDFParser(stream).parse();
        final pagesNum = await (await doc.catalog).getPages();
        numOfPages = pagesNum.pageCount;
      } else {
        numOfPages = 1;
      }

      /// normal file
      setState(() {
        userUploadedFile = file;
        fileName = file.name;
        fileUploaded = true;
        // fileLink = FileLINK;
      });
      if (mounted) {
        startLoader();
        fileLink = await AppCubit.get(context)
            .uploadUserFiles(userUploadedFile, context);
        startLoader();
      }
    }
    isImageLoading = false;
  }
}
