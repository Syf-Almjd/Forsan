import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/OrderModel.dart';

import '../../../Components/Components.dart';
import '../../../Cubit/AppDataCubit/app_cubit.dart';
import 'Components.dart';

class otherServices extends StatefulWidget {
  final String title;

  const otherServices(this.title, {super.key});

  @override
  otherServicesState createState() => otherServicesState();
}

class otherServicesState extends State<otherServices> {
  TextEditingController moreRequirement = TextEditingController();
  bool fileUploaded = false;
  var FILEuploded;
  String fileName = "";
  String fileLink = "";
  bool _isLoading = false;

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
                      borderSide:
                          const BorderSide(width: 5, color: Colors.teal),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 5, color: Colors.yellow),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
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
              getCube(5, context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkUserInput(String generatedCode) async {
    if (moreRequirement.text.isEmpty) {
      showToast("يرجى ان تكمل التفاصيل للخدمة", SnackBarType.fail, context);
    } else {
      var user = await AppCubit.get(context).getLocalUserData();
      var submittedOrder = OrderModel(
          orderId: generatedCode.toUpperCase(),
          orderFile: "",
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
          orderType: 'printing',
          orderDate: DateTime.now().toUtc().toString(),
          orderDiscount: '',
          orderPackaging: '');
      await AppCubit.get(context)
          .uploadFullOrder(submittedOrder, FILEuploded, context);
    }
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
        FILEuploded = file;
        fileName = file.name;
        fileUploaded = true;
        // fileLink = FileLINK;
      });
    }
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
