import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/Cubit/Navigation/navi_cubit.dart';
import 'package:forsan/Models/UserContactModel.dart';
import 'package:forsan/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/ChooseWidget.dart';
import '../../Models/OrderModel.dart';
import '../../Models/ProductModel.dart';
import '../BaB BloC/ba_b_bloc.dart';

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

  uploadFullOrder(OrderModel orderModel, file, context) async {
    try {
      showLoadingDialog(context);
      await uploadUserOrders(orderModel, context);
      // await uploadToAllOrders(orderModel, context);
      await uploadUserFiles(file, orderModel, context);
      NaviCubit.get(context).pop(context, forced: true);
      NaviCubit.get(context).pop(context);
      BlocProvider.of<BaBBloc>(context).add(TabChange(1));
      emit(GetDataSuccessful());
    } catch (e) {
      NaviCubit.get(context).pop(context);

      emit(GetDataError());
    }
  }

  // Future<void> uploadToAllOrders(OrderModel order, context) async {
  //   try {
  //     emit(GettingData());
  //     var firebaseDocRef = await FirebaseFirestore.instance
  //         .collection('orders')
  //         .doc("users_all_orders");
  //     await firebaseDocRef.set({"updated": DateTime.now().toUtc()});
  //
  //     await firebaseDocRef
  //         .collection('users_all_orders')
  //         .doc(order.orderDate)
  //         .set(order.toJson());
  //
  //     // IconSnackBar.show(context,
  //     //     snackBarType: SnackBarType.success, label: "يتم الآن معالجة طلبك...");
  //     emit(GetDataSuccessful());
  //   } catch (e) {
  //     // IconSnackBar.show(context,
  //     //     snackBarType: SnackBarType.success, label: 'حاول مرة أخرى');
  //
  //     emit(GetDataError());
  //   }
  // }

  Future<void> sendUserContactMessage(UserContactModel contactModel) async {
    try {
      emit(GettingData());
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc(contactModel.timestamp.toString())
          .set(contactModel.toJson());
      emit(GetDataSuccessful());
    } catch (e) {
      emit(GetDataError());
    }
  }

  Future<void> uploadUserOrders(OrderModel order, context) async {
    try {
      emit(GettingData());
      var firebaseDocRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      await firebaseDocRef.set({"updated": DateTime.now()});

      await firebaseDocRef
          .collection('userOrders')
          .doc(order.orderId)
          .set(order.toJson());
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success, label: "يتم ارسال طلبك...");
      emit(GetDataSuccessful());
    } catch (e) {
      emit(GetDataError());
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success, label: 'حاول مرة أخرى');
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
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success, label: 'حاول مرة أخرى');
    }
  }

  Future<List<OrderModel>> getHistoryOrdersData() async {
    emit(GettingData());
    List<OrderModel> orderDataList = [];

    var collection = await FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('finishedOrders')
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

      // Parse the order date and convert it to UTC
      final DateTime orderDate = DateTime.parse(order.orderDate).toUtc();

      // Get the current UTC time
      final DateTime currentTime = DateTime.now().toUtc();

      // Check if the current time is within 5 minutes of the order date
      if (currentTime.isBefore(orderDate.add(const Duration(minutes: 5)))) {
        // Proceed with deleting the order
        try {
          await FirebaseStorage.instance.refFromURL(order.orderFile).delete();
        } catch (e) {
          // Handle the specific error for deleting the order file
          print("Error deleting order file: $e");
        }

        try {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(order.orderUser)
              .collection('finishedOrders')
              .doc(order.orderId)
              .delete();
        } catch (e) {
          // Handle the specific error for deleting the finished order
          print("Error deleting finished order: $e");
        }

        try {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('userOrders')
              .doc(order.orderId)
              .delete();
          IconSnackBar.show(
            context,
            snackBarType: SnackBarType.success,
            label: 'تم إلغاء الطلب بنجاح',
          );
        } catch (e) {
          // Handle the specific error for deleting the user order
          print("Error deleting user order: $e");
          IconSnackBar.show(
            context,
            snackBarType: SnackBarType.fail,
            label: 'حدث خطأ أثناء محاولة إلغاء الطلب',
          );
        }
      } else {
        IconSnackBar.show(
          context,
          snackBarType: SnackBarType.fail,
          label:
              'لا يمكن إلغاء الطلب بعد مرور 5 دقائق \n الرجاء الاتصال بفرسان',
        );
      }
    } catch (e) {
      // Handle any other errors that might occur
      print("Unexpected error: $e");
      IconSnackBar.show(
        context,
        snackBarType: SnackBarType.fail,
        label: 'حدث خطأ أثناء محاولة إلغاء الطلب',
      );
    }
  }

  Future<void> uploadUserFiles(userFile, OrderModel order, context) async {
    emit(GettingData());
    IconSnackBar.show(context,
        snackBarType: SnackBarType.success, label: "يتم الآن معالجة طلبك...");

    var path = '/userOrderFiles/${userFile.name}';
    final file = File(userFile.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    IconSnackBar.show(context,
        snackBarType: SnackBarType.success, label: "تم تحميل الملف...");

    try {
      var uploadTask = await ref.putFile(file);
      var getFileLink = await uploadTask.ref.getDownloadURL();

      var docRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("userOrders")
          .doc(order.orderId);
      // IconSnackBar.show(context,
      //     snackBarType: SnackBarType.success,
      //     label: "نجحت معالجة ورفع الملف... ");

      await docRef.update({'orderFile': getFileLink});
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success,
          label: "🤗 يتم الان تجهيز طلبك...");

      emit(GetDataSuccessful());
    } catch (error) {
      attempts++;
      if (attempts < 3) {
        await uploadUserFiles(userFile, order, context); // Retry the upload
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

      IconSnackBar.show(context,
          snackBarType: SnackBarType.success, label: 'نجح تسجيل الدخول ');
      emit(GetDataSuccessful());
      NaviCubit.get(context).navigateToHome(context);
    } on FirebaseAuthException {
      emit(GetDataError());
      IconSnackBar.show(context,
          snackBarType: SnackBarType.fail, label: '!اعد المحاولة');
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
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success, label: 'نجح تحديث المعلومات ');
      emit(GetDataSuccessful());
    } on FirebaseAuthException {
      IconSnackBar.show(context,
          snackBarType: SnackBarType.fail, label: '!اعد المحاولة');
      emit(GetDataError());
    }
  }

  Future<bool> changePassword(String newPassword) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
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

      IconSnackBar.show(context,
          snackBarType: SnackBarType.success, label: 'نجح تسجيل الدخول ');

      emit(GetDataSuccessful());
      NaviCubit.get(context).navigateToHome(context);
    } on FirebaseAuthException catch (e) {
      IconSnackBar.show(context,
          snackBarType: SnackBarType.fail, label: '!اعد المحاولة');
      IconSnackBar.show(context,
          snackBarType: SnackBarType.fail, label: e.message.toString());

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

  Future<UserModel> getLocalUserData() async {
    emit(UpdatingLocalData());
    try {
      emit(LocalDataSuccessful());
      return UserModel.fromJson(await getSharedMap('currentuser'));
    } catch (e) {
      emit(LocalDataFailed());
      return getUserData();
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
