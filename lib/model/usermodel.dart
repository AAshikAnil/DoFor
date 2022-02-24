

class UserModel{
  String? uid;
  String? email;
  String? firstname;
  String? secondname;

 

UserModel({this.uid,this.email,this.firstname,this.secondname});
factory UserModel.fromMap(map){
  return UserModel(
    uid: map['uid'],
    email: map['email'],
    firstname: map['firstname'],
    secondname: map['secondname']
  );
}
Map<String, dynamic>toMap(){
  return{
    'uid' : uid,
    'email' : email,
    'firstname' : firstname,
    'secondname' : secondname
  };
}
}

