import 'package:forsan/domain/models/user_model.dart';

class UserSingleton {
  static final UserSingleton _singleton = UserSingleton._internal();
  UserModel userDataToBeUploaded;
  factory UserSingleton() {
    return _singleton;
  }

  UserSingleton._internal() : userDataToBeUploaded = UserModel.loadingUser();
}
