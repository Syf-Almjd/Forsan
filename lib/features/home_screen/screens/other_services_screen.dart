import 'dart:io';
import 'dart:math';

import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

import 'package:forsan/features/shared/components.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/features/home_screen/widgets/choose_file_widget.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';

class OtherServicesScreen extends StatefulWidget {
  final String title;

  const OtherServicesScreen(this.title, {super.key});

  @override
  OtherServicesScreenState createState() => OtherServicesScreenState();
}

class OtherServicesScreenState extends State<OtherServicesScreen> {
  TextEditingController moreRequirement = TextEditingController();
  bool fileUploaded = false;
  late PlatformFile userUploadedFile;
  String fileName = "";
  String? fileLink;
  var numOfPages = 0;
  int loader = 0;

  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  bool isImageLoading = false;

  GeneCode() => String.fromCharCodes(
      Iterable.generate(8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  @override
  Widget build(BuildContext context) {
    String generatedCode = GeneCode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "صفحة ${widget.title}",
          style: fontAlmarai(fontWeight: FontWeight.bold),
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
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(fileUploaded && numOfPages != 0
                    ? "$loader% :تم التحميل"
                    : "<---------     رفع الملف اختياري     --------->")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
            getCube(2, context),
            if (numOfPages != 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          numOfPages = 0;
                          loader = 0;
                          fileUploaded = false;
                          fileName = "";
                          fileLink = null;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                        ),
                        label: const Text('ازالة الملف',
                            style: TextStyle(color: Colors.red))),
                    Text(
                      "{$numOfPages} عدد الصفحات",
                      style: fontAlmarai(size: getWidth(4, context)),
                    ),
                  ],
                ),
              ),
            getCube(1, context),
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
            Text(
              "نوع الخدمة: ${widget.title}",
              style: fontAlmarai(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            getCube(2, context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: moreRequirement,
                maxLines: 50,
                minLines: 5,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "اذكر لنا التفاصيل للخدمة التي تريدها ",
                  labelStyle: const TextStyle(
                    color: Colors.brown,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 5, color: Colors.teal),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 5, color: Colors.yellow),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
              if (state is GettingData && numOfPages != 0) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '...الملف قيد المعالجة يرجى الانتظار \n يتم رفع الملف بأعلى دقة',
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Container();
              }
            }),
            SizedBox(
              height: getHeight(10, context),
              width: getWidth(90, context),
              child: Center(
                child: loadButton(
                    onPressed: () async {
                      await checkUserInput(generatedCode);
                    },
                    buttonText: "ابدا الطلب"),
              ),
            ),
            getCube(5, context),
          ],
        ),
      ),
    );
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

  Future<void> checkUserInput(String generatedCode) async {
    if (moreRequirement.text.isEmpty) {
      showToast("يرجى ان تكمل بعض التفاصيل للخدمة", SnackBarType.fail, context);
    } else {
      var user = await AppCubit.get(context).getLocalUserData();
      var submittedOrder = OrderModel(
          orderId: generatedCode.toUpperCase(),
          orderFile: fileLink ?? '',
          orderUser: user.userID,
          orderTitle: widget.title,
          orderPrice: "",
          orderUserName: user.name,
          orderStatus: "لم يدفع",
          orderColor: "",
          orderSize: "",
          orderPadding: "",
          orderPaper: "",
          orderDescription: moreRequirement.text,
          orderType: 'service',
          orderDate: DateTime.now().toLocal(),
          orderDiscount: '',
          orderPackaging: '');
      if (mounted) {
        await AppCubit.get(context).uploadUserOrders(submittedOrder, context);
        loader = 0;
      }
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
      final stream = ByteStream(File(file.path!).readAsBytesSync());

      final doc = await PDFParser(stream).parse();
      final pagesNum = await (await doc.catalog).getPages();

      /// normal file
      setState(() {
        numOfPages = pagesNum.pageCount;
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
