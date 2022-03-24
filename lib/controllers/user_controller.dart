import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saturn/exceptions/user_exceptions.dart';
import 'package:saturn/models/user_model.dart';
import 'package:saturn/repositories/user_repository.dart';
import 'package:saturn/types/provider_states.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();
  late UserModel user;
  ProviderStates status = ProviderStates.idle;
  late String message;

  Future<void> getUserData() async {
    status = ProviderStates.loading;
    try {
      User? userT = _repository.getUser();
      if (userT != null) {
        user = (await _repository.getUserData(userT.uid))!;
      }
      status = ProviderStates.idle;
      notifyListeners();
    } on UserException catch (e) {
      status = ProviderStates.error;
      message = e.message;
    }
  }

  listenUserStatus() {
    try {
      Stream<User?> stream = _repository.listenUserState();
      stream.listen((event) async {
        status = ProviderStates.loading;
        if (event != null) {
          user = (await _repository.getUserData(event.uid))!;
        }
        status = ProviderStates.idle;
        notifyListeners();
      });
    } on UserException catch (e) {
      status = ProviderStates.error;
      message = e.message;
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    status = ProviderStates.loading;
    try {
      UserCredential? credential =
          await _repository.createUser(data["email"], data["password"]);
      data.addAll({"id": credential?.user?.uid});
      data.addAll({"createDate": DateTime.now()});
      data.addAll({"updateDate": DateTime.now()});

      UserModel userModel = UserModel.fromJson(data);

      await _repository.createUserFirestore(userModel);
      status = ProviderStates.idle;
      notifyListeners();
    } on UserException catch (e) {
      status = ProviderStates.error;
      message = e.message;
    }
  }

  Future<void> editUser(Map<String, dynamic> data) async {
    try {
      User? userT = _repository.getUser();
      data.addAll({"id": userT?.uid});
      data.addAll({"updateDate": DateTime.now()});
      await _repository.editUser(data);
    } on UserException catch (e) {
      status = ProviderStates.error;
      message = e.message;
    }
  }
}
