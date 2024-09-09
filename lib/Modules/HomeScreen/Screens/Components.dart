import 'package:flutter/material.dart';

import '../../../Components/Components.dart';

Widget ChooseFile(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.cloud_upload,
        size: 50,
        color: Colors.black.withOpacity(0.8),
      ),
      getCube(2, context),
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blueGrey),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "ارفع ملفاتك",
              style: fontAlmarai(size: 20, textColor: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    ],
  );
}

Widget FileChosen(fileInfo, context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.done_outline_outlined,
        size: 50,
        color: Colors.blue.withOpacity(0.9),
      ),
      getCube(2, context),
      Text(
        "تم رفع الملف بنجاح",
        style: fontAlmarai(size: 15, textColor: Colors.blue),
        textAlign: TextAlign.center,
      ),
      getCube(2, context),
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.amberAccent),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "اعادة رفع الملف",
              style: fontAlmarai(size: 15, textColor: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
      getCube(2, context),
      Text(
        "اسم الملف الذي رفع\n$fileInfo ",
        style: fontAlmarai(size: 15, textColor: Colors.black),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
