
import '../../Models/UserModel.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();
  UserModel userDataToBeUploaded;
  factory Singleton() {
    return _singleton;
  }

  Singleton._internal(): userDataToBeUploaded = UserModel.loadingUser();
}
