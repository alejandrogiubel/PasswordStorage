class Credential {
  final int id;
  String name;
  String userName;
  String password;

  Credential({this.id, this.name, this.userName, this.password});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'user_name' : userName,
      'password' : password,
    };
  }
}