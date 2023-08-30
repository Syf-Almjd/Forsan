import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/UserModel.dart';

import '../../Models/OrderModel.dart';
import '../../Models/ProductModel.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  //not sure about above method
  List<String> firebaseDocIDs(snapshot) {
    List<String> dataList = [];
    for (var element in snapshot.data!.docs) {
      dataList.add(element.id);
    }
    return dataList;
  }

  List<ProductModel> getDataJson(snapshot) {
    List<Map<String, dynamic>> itemList = snapshot.data!.docs
        .where((doc) => doc.id != "test")
        .map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    emit(GettingData());
    List<ProductModel> firebaseCData = [];
    List<String> idList = firebaseDocIDs(snapshot);
    //.key is for the map ex. key of map asd {"a": "1"} id a or its "doc name"
    for (int item = 0; item < itemList.length; item++) {
      firebaseCData.add(
        ProductModel(
          productId: idList[item],
          productImgID: itemList[item]['imgID'],
          productTitle: itemList[item]['title'],
          productPrice: itemList[item]['price'],
          productDescription: itemList[item]['description'],
        ),
      );
    }
    if (firebaseCData.isEmpty) {
      emit(GetDataError());
    } else {
      emit(GetDataSuccessful());
    }
    return firebaseCData;
  }

  Future<void> uploadUserOrders(OrderModel order, context) async {
    try {
      emit(GettingData());
      FirebaseFirestore.instance.collection('orders').doc(FirebaseAuth.instance.currentUser?.uid).collection('userOrders').doc(order.orderId).set(order.toJson());
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'تم ارسال الطلب ');
      emit(GetDataSuccessful());
      return NaviCubit.get(context).navigateToHome(context);
    } catch (e) {
      emit(GetDataError());
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'حاول مرة أخرى');
    }
  }
  Future<List<OrderModel>> getOrdersData() async {
    emit(GettingData());
    List<OrderModel> orderDataList =[];

    var collection =  await FirebaseFirestore.instance.collection("orders").doc(FirebaseAuth.instance.currentUser?.uid).collection('userOrders').get();
    for (var doc in collection.docs) {
      orderDataList.add(OrderModel.fromJson(doc.data()));
    }
    if (orderDataList.isNotEmpty) {
      emit(GetDataSuccessful());
      return orderDataList;
    } else {
      emit(GetDataError());
      return orderDataList;
    }
  }
  Future<UserModel> getUserData() async {
    emit(GettingData());

    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userSnapshot.exists) {
        final userData = UserModel.fromJson(userSnapshot.data()!);
        emit(GetDataSuccessful());
        return userData;
      } else {
        emit(GetDataError());
        throw ("User Doesn't Exist");
      }
    } on FirebaseAuthException {
      emit(GetDataError());
      rethrow;
    }
  }


  Future<void> uploadUserFiles(userFile) async {
    emit(GettingData());
    var path = '/userOrderFiles/${userFile.name}_${FirebaseAuth.instance.currentUser?.uid}';
    final file = File(userFile.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    var getFileLink =
        await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    DocumentReference<Map<String, dynamic>> docRef =
        FirebaseFirestore.instance.collection('orders').doc(FirebaseAuth.instance.currentUser?.uid);
    await docRef.update({'orderFile': getFileLink});
    if (getFileLink.isEmpty) {
      emit(GetDataError());
    } else {
      emit(GetDataSuccessful());
    }
  }

  Future<void> userLogin(String mail, String pwd, context) async {
    emit(GettingData());

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pwd);

      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'نجح تسجيل الدخول ');
      emit(GetDataSuccessful());
      NaviCubit.get(context).navigateToHome(context);
    } on FirebaseAuthException {
      emit(GetDataError());
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.fail,
          label: '!اعد المحاولة');
    }
  }

  //Firebase Register with current user data
  Future<void> userRegister(UserModel userModel, context) async {
    emit(GettingData());
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: userModel.email, password: userModel.password)
          .then((value) =>
      userModel.userID = FirebaseAuth.instance.currentUser!.uid);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.userID)
          .set(userModel.toJson());

      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'نجح تسجيل الدخول ');

      emit(GetDataSuccessful());
      NaviCubit.get(context).navigateToHome(context);

    } on FirebaseAuthException {
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.fail,
          label: '!اعد المحاولة');
      emit(GetDataError());
    }
  }
}
