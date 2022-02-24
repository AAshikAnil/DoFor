import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/orphanagemodel.dart';
import 'package:flutter_application_1/user/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  //our form key
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  //text editing controllers
  final orpahanageName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final location = TextEditingController();
  String? orphhanageType = '';

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
      autofocus: false, controller: orpahanageName,
      keyboardType: TextInputType.name,
      //validator
      onSaved: (value) {
        orpahanageName.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //phone field
    final phoneField = TextFormField(
      autofocus: false,
      controller: phone,
      keyboardType: TextInputType.phone,
      onSaved: (value) {
        phone.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phnone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //email field
    final EmailField = TextFormField(
      autofocus: false, controller: email,
      keyboardType: TextInputType.emailAddress,
      //validator
      onSaved: (value) {
        email.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false, controller: password,
      obscureText: true,
      //validator
      onSaved: (value) {
        password.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //confirm password

//signup button
    final SignupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.pinkAccent,
      child: MaterialButton(
        onPressed: () {
          signup(email.text, password.text);
        },
        child: const Text(
          "Signup",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.pinkAccent,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/logoo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 45),
                      firstNameField,
                      const SizedBox(height: 25),
                      phoneField,
                      const SizedBox(height: 25),
                      EmailField,
                      const SizedBox(height: 25),
                      passwordField,
                      const SizedBox(height: 25),
                      SignupButton,
                      const SizedBox(height: 25)
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  onRadioButtonChanges(String? value) {
    setState(() {
      orphhanageType = value;
    });
  }

  void signup(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailstoFirestore()})
          .catchError((e) {});
    }
  }

  postDetailstoFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    OrphanageModel orphanageModel = OrphanageModel();
    orphanageModel.mail = user!.email;
    orphanageModel.uid = user.uid;
    orphanageModel.orphanageName = orpahanageName.text;

    await firebaseFirestore
        .collection('Orphanages')
        .doc(user.uid)
        .set(orphanageModel.toMap());
    Fluttertoast.showToast(msg: 'Account Created successfully');

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
