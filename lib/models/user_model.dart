class UserModel {
  String name;
  String photoUser = "";
  String typeUser;
  String username;
  String email;
  String lastname;
  String id = "";
  DateTime createDate;
  DateTime updateDate;
  UserModel(
      {required this.id,
      required this.name,
      required this.lastname,
      required this.email,
      required this.username,
      required this.typeUser,
      this.photoUser = "",
      required this.createDate,
      required this.updateDate});

  factory UserModel.fromJson(dynamic json) => UserModel(
      id: json?.id,
      name: json["name"],
      lastname: json["lastname"],
      email: json["email"],
      username: json["username"],
      typeUser: json["typeUser"],
      photoUser: json["photoUser"],
      createDate: DateTime.parse(json["createDate"]),
      updateDate: DateTime.parse(json["updateDate"]));

  @override
  String toString() {
    return 'Nombre: $name,Apellido: $lastname,email: $email,username: $username,typeUser: $typeUser,photoUser: $photoUser';
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "lastname": lastname,
        //"typeUser": typeUser,
        "photoUser": photoUser,
        "updateDate": updateDate,
      };
}
