import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:forsan/core/shared/components.dart';
import 'package:forsan/domain/models/order_model.dart';
import 'package:forsan/domain/models/user_contact_model.dart';
import 'package:forsan/domain/models/user_model.dart';
import 'package:forsan/domain/models/user_payment_model.dart';
import 'package:forsan/features/home_screen/widgets/choose_file_widget.dart';
import 'package:forsan/state/navigation_cubit/navi_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/product_model.dart';
import '../../features/authentication/login/login_user.dart';
import '../bottom_navi_bloc/ba_b_bloc.dart';

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

  // uploadFullOrder(OrderModel orderModel, file, context) async {
  //   try {
  //     showLoadingDialog(context);
  //     await uploadUserOrders(orderModel, context);
  //     // await uploadToAllOrders(orderModel, context);
  //     NaviCubit.get(context).pop(context, forced: true);
  //     NaviCubit.get(context).pop(context);
  //     BlocProvider.of<BaBBloc>(context).add(TabChange(1));
  //     emit(GetDataSuccessful());
  //   } catch (e) {
  //     NaviCubit.get(context).pop(context);
  //     showToast("خطا", SnackBarType.fail, context);
  //     print(e.toString());
  //     showToast(e.toString(), SnackBarType.fail, context);
  //     emit(GetDataError());
  //   }
  // }

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

  Future<void> sendUserPaymentMessage(UserPaymentModel payment) async {
    try {
      emit(GettingData());
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(payment.timestamp.toString())
          .set(payment.toJson());
      emit(GetDataSuccessful());
    } catch (e) {
      emit(GetDataError());
    }
  }

  Future<OrderModel?> getOrderById(String userId, String orderId,
      {String? collection = "userOrders"}) async {
    try {
      // Emit loading state if needed
      emit(GettingData());

      // Reference to the specific order document
      DocumentReference orderDocument = FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection(collection!)
          .doc(orderId);

      // Fetch the order document
      DocumentSnapshot orderSnapshot = await orderDocument.get();

      // Check if the document exists
      if (orderSnapshot.exists) {
        // Fetch the sub-collection data
        OrderModel orderDataList =
            OrderModel.fromJson(orderSnapshot.data() as Map<String, dynamic>);

        // Emit successful state
        emit(GetDataSuccessful());

        // Return the first OrderModel or null if needed
        return orderDataList;
      } else {
        if (collection == "userOrders") {
          return getOrderById(userId, orderId, collection: "finishedOrders");
        } else {
          emit(GetDataError());
          return null;
        }
      }
    } catch (e) {
      // Emit error state
      emit(GetDataError());
      // Return null or rethrow the error if needed
      return null;
    }
  }

  Future<void> uploadUserOrders(OrderModel order, context) async {
    try {
      showLoadingDialog(context);

      await deleteUserTempFile(justRefDel: true);
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success, label: "يتم ارسال طلبك...");

      emit(GettingData());
      var firebaseDocRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      // IconSnackBar.show(context,
      //     snackBarType: SnackBarType.success, label: "يتم الآن معالجة ملفك...");

      await firebaseDocRef.set({"updated": DateTime.now()});

      await firebaseDocRef
          .collection('userOrders')
          .doc(order.orderId)
          .set(order.toJson());
      NaviCubit.get(context).pop(context);
      NaviCubit.get(context).pop(context);
      emit(GetDataSuccessful());
    } catch (e) {
      NaviCubit.get(context).pop(context);

      emit(GetDataError());
      print(e);
      // IconSnackBar.show(context,
      // snackBarType: SnackBarType.success, label: 'حاول مرة أخرى');
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
      final DateTime orderDate = order.orderDate;

      // Get the current UTC time
      final DateTime currentTime = DateTime.now().toLocal();

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

  Future<void> deleteUserTempFile({bool justRefDel = false}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (justRefDel) {
      await FirebaseFirestore.instance
          .collection('tempData')
          .doc(userId)
          .delete();
      return;
    }
    try {
      if (userId == null) {
        throw Exception("No authenticated user.");
      }

      // Fetch the document from Firestore
      final response = await FirebaseFirestore.instance
          .collection('tempData')
          .doc(userId)
          .get();

      // Check if the document has data
      final data = response.data();
      if (data != null && data.containsKey('file')) {
        final filePath = data['file'];
        if (filePath != null) {
          // Delete the file from Firebase Storage
          await FirebaseStorage.instance.refFromURL(filePath).delete();
        } else {
          // throw Exception("File path is null.");
        }
      } else {
        // throw Exception("No file found in user temp data.");
      }
    } catch (e) {
      // Log or handle the error appropriately
      print("Error deleting user temp file: $e");
    }
  }

  Future<String?> uploadUserFiles(userFile, context) async {
    emit(GettingData());
    // IconSnackBar.show(context,
    //     snackBarType: SnackBarType.success, label: "يتم الآن معالجة طلبك...");
    print('saif1');

    await deleteUserTempFile();
    print('saif2');

    var path =
        '/userOrderFiles/${DateTime.now().toUtc().toIso8601String().replaceAll(':', '_').replaceAll('-', '_').replaceAll('.', '_')}_${userFile.name}';
    final file = File(userFile.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    // IconSnackBar.show(context,
    //     snackBarType: SnackBarType.success, label: "تم تحميل الملف...");
    print('saif3');

    try {
      var uploadTask = await ref.putFile(file);
      print('saif4');

      var getFileLink = await uploadTask.ref.getDownloadURL();
      print('saif5');

      await FirebaseFirestore.instance
          .collection('tempData')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set(
        {'date': DateTime.now(), 'file': getFileLink},
      );
      print('saif6');

      emit(GetDataSuccessful());
      return getFileLink;
    } catch (error) {
      print("error");
      print(error);
      // attempts++;
      // if (attempts < 3) {
      // return await uploadUserFiles(userFile, context); // Retry the upload
      // } else {
      emit(GetDataError());
      return null;
      // }
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

  Future<void> resetPassword(String email, context) async {
    emit(GettingData());

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      IconSnackBar.show(context,
          snackBarType: SnackBarType.success,
          label: 'تم ارسال رابط اعادة تعيين كلمة المرور');
      emit(GetDataSuccessful());
      NaviCubit.get(context).navigate(context, const Login());
    } on FirebaseAuthException catch (e) {
      emit(GetDataError());
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'المستخدم غير موجود';
          break;
        case 'invalid-email':
          errorMessage = 'الايميل غير صحيح';
          break;
        default:
          errorMessage = 'حدث خطأ! اعد المحاولة';
      }

      IconSnackBar.show(context,
          snackBarType: SnackBarType.fail, label: errorMessage);
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
      BlocProvider.of<RegisterBabBloc>(context).add(TabChange(0));
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
      await saveSharedMap('currentuser', getData.toJson());
      if (getData.email == "guest@forsan.com") {
        isGuestMode = true;
      }
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
