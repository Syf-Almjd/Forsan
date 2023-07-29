import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Models/ProductModel.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  // Loading loading = Loading(isLoading: false);
  // DidGetDataSuccessful GotIt = DidGetDataSuccessful(GotData: false);

  // int currentIndex => CurrentIndex.getCurrentIndex;

  void startLoading() => emit(StartLoadingState());

  void stopLoading() => emit(StopLoadingState());

  void startClick() => emit(StartClick());

  void stopClick() => emit(StopClick());

  bool isLoading(state) => state is StartLoadingState ? true : false;

  bool gotData() => state is UpdateDataSuccessful ? true : false;

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

// Future<void> updateImgs(snapshot) async {
//   List<String> idList = firebaseDocIDs(snapshot);
//   emit(GettingData());
//   List<String> url = [];
//   var collection = FirebaseFirestore.instance.collection('products');
//   for (int item = 0; item < idList.length; item++) {
//     final ref =  FirebaseStorage.instance.ref().child("products/${idList[item]}.png").getDownloadURL().toString();
//     await collection
//         .doc(idList[item])
//         .update({'imgID' : ref}) // <-- Updated data
//         .then((_) => emit(UpdateDataSuccessful()))
//         .catchError((error) =>emit(GetDataError()));
//     // snapshot.data!.docs.where((doc) => doc.id == idList[item])
//   }
// }
}
