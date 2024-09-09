import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as widgets;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/Shared/utils/managers/app_enums.dart';
import 'package:forsan/Components/Shared/utils/managers/app_extensions.dart';
import 'package:forsan/Components/Shared/utils/styles/app_colors.dart';
import 'package:forsan/Models/UserModel.dart';
import 'package:forsan/generated/assets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Cubit/AppDataCubit/app_cubit.dart';
import '../Cubit/Navigation/navi_cubit.dart';

bool isGuestMode = false;

TextStyle fontAlmarai(
    {double? size, Color? textColor, FontWeight? fontWeight}) {
  return GoogleFonts.almarai(
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: size ?? 16,
      color: textColor ?? Colors.black54);
}

TextStyle fontElMessiri(
    {double? size, Color? textColor, FontWeight? fontWeight}) {
  return GoogleFonts.elMessiri(
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: size ?? 16,
      color: textColor ?? Colors.black54);
}

double getHeight(int percent, context) {
  return (MediaQuery.of(context).size.height * (percent / 100)).toDouble();
}

SizedBox getCube(int percent, context) {
  return SizedBox(
    width: (MediaQuery.of(context).size.width * (percent / 100)).toDouble(),
    height: (MediaQuery.of(context).size.height * (percent / 100)).toDouble(),
  );
}

double getWidth(int percent, context) {
  return (MediaQuery.of(context).size.width * (percent / 100)).toDouble();
}

Widget loadingAnimation({Widget? loadingType}) {
  if (loadingType != null) {
    return loadingType;
  } else {
    return Center(
        child: LoadingAnimationWidget.waveDots(color: Colors.yellow, size: 30));
  }
}

Widget padBox({size}) {
  return Padding(padding: EdgeInsets.all(size ?? 10));
}

Widget textFieldA({
  // here if you put in before the { it is required by default but if you put after it you need to say required
  Key?
      key, //the difference is that inside {} it can be optional if you want to enforce input when call use "required"
  required TextEditingController controller,
  required String hintText,
  bool? obscureText = false, //optional
  int maxLines = 5, //optional
  TextAlign textAlign = TextAlign.start, //optional
  Icon? prefixIcon,
  double? internalPadding,
  void Function(String)? onChanged,
  void Function(String)? onSubmitted,
}) {
  return TextField(
    key: key,
    controller: controller,
    obscureText: obscureText ?? false,
    cursorColor: HexColor("#4f4f4f"),
    textAlign: textAlign,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hintText,
      fillColor: HexColor("#f2f3ff"),
      contentPadding: EdgeInsets.all(internalPadding ?? 20),
      hintStyle: GoogleFonts.almarai(
        fontSize: 15,
        color: Colors.black87,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      prefixIcon: prefixIcon,
      prefixIconColor: HexColor("#4f4f4f"),
      filled: true,
    ),
    onChanged: onChanged,
    onSubmitted: onSubmitted,
  );
}

Widget buttonA({
  final Function()? onPressed,
  required final String buttonText,
  int? height,
  int? width,
  Color? color,
  int? borderSize,
  Color? textColor,
}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      height: (height ?? 55).toDouble(),
      width: (height ?? 275).toDouble(),
      decoration: BoxDecoration(
        color: (color ?? HexColor('#ebcd34')),
        borderRadius: BorderRadius.circular(
          (borderSize ?? 17).toDouble(),
        ),
      ),
      child: Center(
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: fontAlmarai(size: 22),
        ),
      ),
    ),
  );
}

Widget itemsList({
  String? name,
  String? img,
}) {
  bool isClicked = false;
  return GestureDetector(
    // onTap: () => NaviState.navigate(context, widget.pageWidget),
    // onTapDown: (context) {
    // },
    // onTapCancel: () => ,
    // onTapUp: () => ,
    // onTap: () {
    //   if (widget.pageNum == 1) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const anyPage()));
    //   } else if (widget.pageNum == 2) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const anyPage()));
    //   } else if (widget.pageNum == 3) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const anyPage()));
    //   } else if (widget.pageNum == 4) {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const anyPage()));
    //   }
    // },
    child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              // mainPageController.statePage == false
              //     ? Colors.grey
              // :
              // HexColor("#44564a"),
              Colors.white38,
          border: Border.all(
              color: isClicked == false
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.3),
              style: BorderStyle.solid,
              width: 0.75),
          // color: HexColor("#44564a"),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                img!,
                fit: BoxFit.contain,
                scale: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name!,
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )),
  );
}

Widget rowHomeItems({
  required String name,
  required String img,
  required Function onTap,
}) {
  return InkWell(
    onTap: () {
      onTap(name);
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white70,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 100,
                  width: 150,
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return Center(
                              child: LoadingAnimationWidget.flickr(
                                  leftDotColor: Colors.blue,
                                  rightDotColor: Colors.yellow,
                                  size: 30));
                        },
                        errorWidget: (context, url, error) {
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(name),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget socialMediaItem({
  required int index,
  required String img,
  required Function onTap,
}) {
  return Padding(
    padding: const EdgeInsets.all(7.0),
    child: InkWell(
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: img,
            fit: BoxFit.contain,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Center(
                  child: LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.blue,
                      rightDotColor: Colors.yellow,
                      size: 30));
            },
            errorWidget: (context, url, error) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
}

//Show a toast

Widget loadButton({
  double? buttonHeight,
  double? buttonWidth,
  Color? textColor,
  double? textSize,
  bool isLoadButton = true,
  double? buttonElevation,
  required Function() onPressed,
  required String buttonText,
}) {
  return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
    if (state is GettingData && isLoadButton) {
      return loadingAnimation(
          loadingType: LoadingAnimationWidget.beat(
              color: Colors.yellow, size: getWidth(10, context)));
    } else {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          width: buttonWidth ?? getWidth(80, context),
          height: buttonHeight ?? 60.0,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 18, color: textColor ?? Colors.white),
            ),
          ),
        ),
      );
    }
  });
}

Future showChoiceDialog(
    {required BuildContext context,
    String? title,
    String? content,
    bool showCancel = true,
    String yesText = "Ok",
    String noText = "Cancel",
    required Function onYes,
    Function? onNo}) {
  return (showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          title: Text(title ?? ""),
          titleTextStyle: TextStyle(
            fontSize: getWidth(4, context),
            fontWeight: FontWeight.w700,
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          content: Text(content ?? "هل انت متاكد؟"),
          actions: [
            showCancel
                ? TextButton(
                    child: Text(noText),
                    onPressed: () {
                      NaviCubit.get(context).pop(context);
                      if (onNo != null) {
                        onNo();
                      }
                    },
                  )
                : Container(),
            TextButton(
              child: Text(yesText),
              onPressed: () {
                NaviCubit.get(context).pop(context);
                onYes();
              },
            ),
          ],
        );
      }));
}

appCustomBar(String title, context) {
  return AppBar(
    title: Text(title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
    leading: IconButton(
      // Back button
      icon: const Icon(Icons.cancel_outlined, color: Colors.black),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    centerTitle: true,
    backgroundColor: AppColors.white,
  );
}

Widget fileActionWidget({
  required VoidCallback onOpen,
  icon = Icons.file_present,
  required String title,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(
                Icons.file_present,
                size: 24,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onOpen,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(150, 50), // Ensures button is sizable
          ),
          child: const Text(
            'فتح', // "Open" in Arabic
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

void showToast(String text, SnackBarType type, context) => IconSnackBar.show(
      context,
      snackBarType: type,
      label: text,
    );

bool isDesktopSize(context) {
  return getWidth(100, context) >= DeviceType.ipad.getMaxWidth();
}

String getFormatDate(date) {
  if (date is DateTime) {
    return date.toLocal().toString().substring(0, 16).replaceAll(" ", " - ");
  }
  return DateTime.tryParse(date)?.toLocal().toString().substring(0, 16) ??
      ''.replaceAll(" ", " - ");
}

String generateCode() {
  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return String.fromCharCodes(Iterable.generate(
      8, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
}

//Validate Text field
validateForm(
  GlobalKey<FormState> validateKey,
) {
  if (validateKey.currentState!.validate()) {
    validateKey.currentState!.save();
    return true;
  } else {
    return false;
  }
}

///shows logo
Padding logoContainer(context) {
  return Padding(
    padding: const EdgeInsets.all(50.0),
    child: Container(
      width: getWidth(50, context),
      height: getHeight(20, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 2),
      ),
      child: const Image(
        image: AssetImage(Assets.assetsForsanNoBg),
        fit: BoxFit.contain,
      ),
    ),
  );
}

void checkNOpenUrl(orderUrl, context) {
  try {
    MemoryImage(base64Decode(orderUrl));
    showToast(
        'لا يوجد ملف, هذا الطلب عبارة عن منتج', SnackBarType.alert, context);
  } catch (e) {
    var openUrl = Uri.parse(orderUrl);
    launchUrl(
      openUrl,
      mode: LaunchMode.externalApplication,
    );
  }
}

///For photo selection
Widget chooseFile(context) {
  return Container(
    decoration: const BoxDecoration(
        color: Colors.amberAccent,
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: Stack(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(
              image: AssetImage(Assets.assetsProfilePicture),
              fit: BoxFit.fill,
            )),
        Positioned(
          bottom: 25,
          right: 25,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black12),
            child: const Icon(
              Icons.mode_edit_outline_outlined,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget previewProductImage(fileUser, context) {
  fileUser = base64Decode(fileUser);
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Colors.amber),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.memory(
        fileUser,
        height: getHeight(20, context),
        width: getWidth(30, context),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget previewDetailsImage(
  fileUser,
  context,
) {
  if (fileUser == "NOPHOTO") {
    fileUser = UserModel.loadingUser().photoID;
  }
  fileUser = base64Decode(fileUser);
  return Container(
    decoration:
        const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    child: Center(
      child: ClipOval(
        child: Image.memory(
          fileUser,
          height: getHeight(15, context),
          width: getWidth(32, context),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

///For photo preview
Widget previewImage(
  fileUser,
  context,
) {
  if (fileUser == "NOPHOTO") {
    fileUser = UserModel.loadingUser().photoID;
  }
  fileUser = base64Decode(fileUser);
  return Stack(
    children: [
      Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.memory(
                fileUser,
                height: getHeight(15, context),
                width: getWidth(32, context),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

void showToast2(String text, asd, context) => IconSnackBar.show(
      context,
      snackBarType: asd as SnackBarType,
      label: text,
    );

Future<Uint8List> assetToUint8List(String assetPath) async {
  ByteData data = await rootBundle.load(assetPath);
  List<int> bytes = data.buffer.asUint8List();
  return Uint8List.fromList(bytes);
}

Future<String> fromImageSavePDF(Uint8List screenShot) async {
  final widgets.Document pdf = widgets.Document();

  // Add page with the image
  final image = widgets.MemoryImage(screenShot);
  pdf.addPage(
    widgets.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (context) {
        return widgets.Center(
          child: widgets.Image(image),
        );
      },
    ),
  );

  // Save PDF differently depending on the platform
  final Uint8List pdfBytes = await pdf.save();

  // if (kIsWeb) {
  //   // For web: create a downloadable link
  //   final blob = html.Blob([pdfBytes], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..setAttribute('download', 'forsan_order.pdf')
  //     ..click();

  //   html.Url.revokeObjectUrl(url);
  //   return anchor.pathname ?? "";
  // }
  // else
  // {
  // For mobile: save to the file system
  final Directory? directory = await getApplicationDocumentsDirectory();
  if (directory == null) {
    throw Exception('Could not access storage');
  }
  final String path = '${directory.path}/forsan_order.pdf';
  final File file = File(path);

  try {
    await file.writeAsBytes(pdfBytes);
    if (!kIsWeb) {
      shareFile(path);
    }
    return file.path;
  } catch (error) {
    rethrow;
  }
  // }
}

void shareFile(
  path,
) async {
  try {
    await Share.shareXFiles([XFile(path)]);
  } catch (e) {
    rethrow;
  }
}

//OTHER

// biometricLogin(context, attempts) {
//   return InkWell(
//     focusColor: Colors.transparent,
//     hoverColor: Colors.transparent,
//     splashColor: Colors.transparent,
//     onTap: () async {
//       var userData = await AppCubit.get(context).getUserData();
//       var savedID = await getSharedData("userID");
//       // var isVerified = await AppCubit.get(context).getBioAuthentication();
//       if (savedID == userData.userID && attempts <= 3) {
//         showToast("Successful!", SnackBarType.save, context);
//       } else {
//         NaviCubit.get(context).navigateToBiometricLogin(context);
//         showToast(
//           "Unsuccessful, try again",
//           SnackBarType.fail,
//           context,
//         );
//       }
//     },
//     child: (Platform.isIOS)
//         ? Icon(
//             Icons.face_outlined,
//             size: getWidth(35, context),
//             color: Colors.grey,
//           )
//         : Icon(
//             Icons.fingerprint_outlined,
//             size: getWidth(35, context),
//             color: Colors.grey,
//           ),
//   );
// }

// Widget buildProductDetails({String? name, String? img}) {
//   return Card(
//     elevation: 4.0,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8.0),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         ClipRRect(
//           child: Image.network(
//             img!,
//             height: 50.0,
//             width: 50,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name!,
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget columnHomeItems({required ProductModel product}) {
//   return Column(
//     children: [
//       SizedBox(
//         height: 100,
//         width: double.maxFinite,
//         child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: Image.network(
//               product.productImgID,
//               fit: BoxFit.cover,
//             )),
//       ),
//       const SizedBox(
//         height: 30,
//       ),
//       Row(
//         children: [
//           Text(
//             "${product.productPrice} ريال",
//             style: fontArabicA(size: 10, textColor: Colors.green),
//           ),
//           const Spacer(),
//           Text(
//             product.productTitle,
//             style: fontArabicA(fontWeight: FontWeight.bold, size: 10),
//           ),
//         ],
//       ),
//       const SizedBox(
//         height: 10,
//         width: 10,
//       ),
//       Text(
//         product.productDescription,
//         overflow: TextOverflow.ellipsis,
//         style: fontArabicA(size: 10),
//       ),
//       SizedBox(
//         height: 10,
//         width: 10,
//       ),
//     ],
//   );
// }
