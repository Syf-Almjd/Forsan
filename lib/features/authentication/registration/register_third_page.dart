import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/core/shared/components.dart';
import 'package:forsan/domain/models/user_model.dart';
import 'package:forsan/domain/singletons/user_singleton.dart';
import 'package:forsan/state/app_data_cubit/app_cubit.dart';
import 'package:forsan/state/bottom_navi_bloc/ba_b_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterThirdPage extends StatefulWidget {
  final UserModel userData;

  const RegisterThirdPage({Key? key, required this.userData}) : super(key: key);

  @override
  State<RegisterThirdPage> createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  late UserModel userData;
  DateTime timeNow = DateTime.now();
  String? _imageBytes;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2), shape: BoxShape.circle),
              child: InkWell(
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.grey,
                  size: 25,
                ),
                onTap: () {
                  BlocProvider.of<RegisterBabBloc>(context).add(TabChange(2));
                },
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            "!ارنا ابتسامتك",
            style: TextStyle(fontSize: getWidth(10, context)),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: getHeight(20, context),
            width: getWidth(45, context),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(500),
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Center(
              child: InkWell(
                onTap: () async {
                  _pickFile();
                },
                child: Stack(
                  children: [
                    Center(
                      child: (_imageBytes != null)
                          ? previewImage(_imageBytes, context)
                          : chooseFile(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        loadButton(
          buttonHeight: getHeight(5, context),
          buttonWidth: getWidth(50, context),
          textSize: getWidth(4, context),
          textColor: Colors.blueGrey,
          buttonElevation: 0.0,
          onPressed: () {
            signUser("NOPHOTO");
          },
          buttonText: 'تخطي الصورة',
        ),
        const Spacer(),
        Center(
            child: loadButton(
                buttonText: "أبدا",
                onPressed: () {
                  if (_imageBytes != null) {
                    signUser(_imageBytes);
                  } else {
                    showToast('اختر صورة', SnackBarType.fail, context);
                  }
                })),
        getCube(10, context),
      ],
    );
  }

  Future<void> signUser(imageBytes) async {
    userData = UserModel(
        email: widget.userData.email,
        password: widget.userData.password,
        name: widget.userData.name,
        phoneNumber: widget.userData.phoneNumber,
        photoID: imageBytes,
        userID: "",
        address: widget.userData.address,
        points: '10.00');
    UserSingleton().userDataToBeUploaded = userData;

    AppCubit.get(context).saveSharedMap('currentuser', userData.toJson()).then(
        (value) => AppCubit.get(context)
            .userRegister(UserSingleton().userDataToBeUploaded, context));
  }

  void _pickFile() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      Uint8List bytesUint8List = Uint8List.fromList(bytes);
      setState(() {
        _imageBytes = base64Encode(bytesUint8List);
      });
    }
  }
}
