import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/OrderModel.dart';
import 'package:hexcolor/hexcolor.dart';

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

  @override
  Widget build(BuildContext context) {
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
              NaviCubit.get(context).pop(context, widget);
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
                      borderSide: const BorderSide( width: 5, color: Colors.teal),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width:5  , color: Colors.yellow),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: getHeight(10, context),
                  width: getWidth(90, context),
                  child: Center(
                    child: _isLoading
                        ? loadingAnimation()
                        : Container(
                            width: double.infinity,
                            height: 60.0,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                  animationDuration:
                                      Duration(milliseconds: 500),
                                  enableFeedback: true),
                              onPressed: () async {
                                if (moreRequirement.text.isEmpty) {
                                  showToast("يرجى ان تكمل التفاصيل للخدمة",
                                      SnackBarType.fail, context);
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var submittedOrder = OrderModel(
                                      orderId:
                                          "${FirebaseAuth.instance.currentUser!.uid} orderId ${Random().nextInt(1000000)}",
                                      orderFile: "",
                                      orderTitle: widget.title,
                                      orderPrice: "",
                                      orderColor: "service",
                                      orderSize: "service",
                                      orderPadding: "service",
                                      orderPaper: "service",
                                      orderDescription: moreRequirement.text);
                                  AppCubit.get(context).uploadUserOrders(
                                      submittedOrder, context);
                                  AppCubit.get(context)
                                      .uploadUserFiles(FILEuploded);
                                }
                              },
                              child: const Text(
                                "ابدا الطلب",
                              ),
                            ),
                          ),
                  )),
              getCube(5, context)
            ],
          ),
        ),
      ),
    );
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
