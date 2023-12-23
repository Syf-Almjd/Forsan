import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/OrderModel.dart';
import '../../Models/ProductModel.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);
  int attempts = 0;

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
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({"updated": DateTime.now()});

      FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('userOrders')
          .doc(order.orderId)
          .set(order.toJson());
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'تم الاضافة للسلة ');
      emit(GetDataSuccessful());
    } catch (e) {
      emit(GetDataError());
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'حاول مرة أخرى');
    }
  }

  Future<void> updateUserOrders(OrderModel order, context) async {
    try {
      emit(GettingData());
      //update order Data
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({"updated": DateTime.now()});

      //upload order
      FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('userOrders')
          .doc(order.orderId)
          .update(order.toJson());
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
    List<OrderModel> orderDataList = [];

    var collection = await FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('userOrders')
        .get();
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

  Future<void> deleteUserOrders(OrderModel order, context) async {
    try {
      emit(GettingData());
      FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('userOrders')
          .doc(order.orderId)
          .delete();
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'تم اللغاء للطلب ');
      emit(GetDataSuccessful());
    } catch (e) {
      emit(GetDataError());
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'حاول مرة أخرى');
    }
  }

  Future<void> uploadUserFiles(userFile, OrderModel order) async {
    emit(GettingData());
    var path = '/userOrderFiles/${userFile.name}';
    final file = File(userFile.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      var uploadTask = await ref.putFile(file);
      var getFileLink = await uploadTask.ref.getDownloadURL();

      var docRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("userOrders")
          .doc(order.orderId);

      await docRef.update({'orderFile': getFileLink});
      emit(GetDataSuccessful());
    } catch (error) {
      print(error);
      attempts++;
      if (attempts < 3) {
        await uploadUserFiles(userFile, order); // Retry the upload
      } else {
        emit(GetDataError());
      }
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

  Future<void> updateUserFBData(UserModel userModel, context) async {
    emit(GettingData());
    try {
      var userID = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .set(userModel.toJson());
      await clearSharedAll();
      await saveSharedMap('currentuser', userModel.toJson());
      NaviCubit.get(context).pop(context);
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.save,
          label: 'نجح تحديث المعلومات ');
      emit(GetDataSuccessful());
    } on FirebaseAuthException {
      IconSnackBar.show(
          context: context,
          snackBarType: SnackBarType.fail,
          label: '!اعد المحاولة');
      emit(GetDataError());
    }
  }

  Future<bool> changePassword(String newPassword) async {
    try {
      var user = await FirebaseAuth.instance.currentUser;
      await user?.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
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

  //Update Shared Local Data of current user
  Future<void> updateSharedUser() async {
    emit(UpdatingLocalData());
    try {
      var getData = await getUserData();
      saveSharedMap('currentuser', getData.toJson());
      emit(LocalDataSuccessful());
    } catch (e) {
      emit(LocalDataFailed());
    }
  }

  Future<void> saveSharedMap(String mapName, Map mapData) async {
    emit(UpdatingLocalData());
    String jsonString = jsonEncode(mapData);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(mapName, jsonString);
      emit(LocalDataSuccessful());
    } catch (e) {
      emit(LocalDataFailed());
    }
  }

  Future<Map<String, dynamic>> getSharedMap(String mapName) async {
    emit(GettingLocalData());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString(mapName);
      Map<String, dynamic> savedData = jsonDecode(jsonString!);
      emit(LocalDataSuccessful());
      return savedData;
    } catch (e) {
      emit(LocalDataFailed());
      return Future.error("LocalDataFailed");
    }
  }

  //Save Shared Local Data of current user
  Future<void> saveSharedData(Map data) async {
    emit(UpdatingLocalData());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      data.forEach((key, value) {
        prefs.setString(key, value);
      });
      emit(LocalDataSuccessful());
    } catch (e) {
      emit(LocalDataFailed());
    }
  }

  Future<void> clearSharedAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  //Get Shared Local Data of current user as list of values
  Future<List?> getSharedList(List keys) async {
    emit(UpdatingLocalData());
    List data = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var element in keys) {
        data.add(prefs.getString(element));
      }
      emit(LocalDataSuccessful());
      return data;
    } catch (e) {
      emit(LocalDataFailed());
    }
    return data;
  }
}
