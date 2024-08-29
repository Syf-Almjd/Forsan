import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Components/Components.dart';

import '../../../Components/Shared/Singleton.dart';
import '../../../Cubit/BaB BloC/ba_b_bloc.dart';
import '../../../Models/UserModel.dart';

class RegisterFirstPage extends StatefulWidget {
  const RegisterFirstPage({Key? key}) : super(key: key);

  @override
  State<RegisterFirstPage> createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  late UserModel userData;
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();

  final _validateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _validateKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: getWidth(10, context),
                  ),
                  onTap: () {
                    BlocProvider.of<RegisterBabBloc>(context).add(TabChange(0));
                  },
                ),
              ),
              Center(
                child: Text(
                  "التسجيل",
                  style: TextStyle(fontSize: getWidth(15, context)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  textDirection: TextDirection.rtl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      showToast("الاسم غير صحيح!", SnackBarType.fail, context);
                      return 'الاسم غير صحيح';
                    } else {
                      return null;
                    }
                  },
                  controller: name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "الاسم",
                    prefixIcon: const Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.name,
                ),
                getCube(2, context),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('0')) {
                      showToast("الرقم غير صحيح!", SnackBarType.fail, context);
                      return 'غير صحيح';
                    } else {
                      return null;
                    }
                  },
                  controller: phoneNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "رقم الهاتف",
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.number,
                ),
                getCube(2, context),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 8) {
                      showToast(
                          "العنوان قصير جدا!", SnackBarType.fail, context);
                      return 'العنوان قصير جدا';
                    } else {
                      return null;
                    }
                  },
                  controller: address,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(100),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "العنوان",
                    prefixIcon: const Icon(Icons.place_outlined),
                  ),
                  keyboardType: TextInputType.streetAddress,
                ),
              ],
            ),
          ),
          Center(
              child: loadButton(
                  buttonText: "التالي",
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (validateForm(_validateKey)) {
                      userData = UserModel(
                          email: "",
                          password: "",
                          name: name.text,
                          phoneNumber: phoneNumber.text,
                          photoID: "",
                          userID: "",
                          address: address.text,
                          points: '');
                      Singleton().userDataToBeUploaded = userData;
                      BlocProvider.of<RegisterBabBloc>(context)
                          .add(TabChange(2));
                    }
                  })),
          getCube(10, context),
        ],
      ),
    );
  }
}
