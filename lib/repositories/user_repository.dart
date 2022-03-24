// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saturn/exceptions/user_exceptions.dart';
import 'package:saturn/models/user_model.dart';

class UserRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> listenUserState() {
    try {
      return auth.authStateChanges();
    } catch (e) {
      print("User repository listen: $e");
      throw UserException(
          message: "Ocurrió un error al traer los datos del usuario.");
    }
  }

  Future<UserModel?> getUserData(String id) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("users");
    try {
      DocumentSnapshot doc = await collection.doc(id).get();
      UserModel user = UserModel.fromJson(doc.data());
      return user;
    } catch (e) {
      print("User repository: $e");
      throw UserException(
          message: "Ocurrió un error al traer los datos del usuario.");
    }
  }

  User? getUser() {
    return auth.currentUser;
  }

  Future<UserCredential?> createUser(String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } catch (e) {
      print("User repository create: $e");
      throw UserException(message: "Ocurrió un error al crear el usuario.");
    }
  }

  Future<DocumentReference> createUserFirestore(UserModel user) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("users");
    try {
      DocumentReference doc = await collection.add(user);
      return doc;
    } catch (e) {
      print("User repository create firestore: $e");
      throw UserException(message: "Ocurrió un error al crear el usuario.");
    }
  }

  Future<void> editUser(Map<String, dynamic> data) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("users");
    try {
      await collection.doc(data["id"]).update(data);
    } catch (e) {
      print("User repository update user: $e");
      throw UserException(
          message: "Ocurrió un error al editar datos del usuario.");
    }
  }
}
