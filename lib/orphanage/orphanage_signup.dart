import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/orphanagemodel.dart';
import 'package:flutter_application_1/user/login_screen.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geolocator/geolocator.dart';

class OrphanageSignUp extends StatefulWidget {
  const OrphanageSignUp({Key? key}) : super(key: key);

  @override
  _OrphanageSignUpState createState() => _OrphanageSignUpState();
}

class _OrphanageSignUpState extends State<OrphanageSignUp> {
  //our form key
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  //text editing controllers
  final orpahanageName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final StreetEditingController = TextEditingController();
  bool isLoading = false;

  Position? _currentPosition;
  String? street;
  double? latitude;
  double? longitude;
  List<Address>? address;

  @override
  Widget build(BuildContext context) {
    Future<Position> getPostion() async {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else {
        print('Location denied by User');
      }
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    getAddress(latitude, longitude) async {
      debugPrint('get address callled with $latitude and $longitude');
      address = await Geocoder.google("AIzaSyBXCZHGf1mEhK_YO8IprnrB7MOg0oWQpAY")
          .findAddressesFromCoordinates(Coordinates(latitude, longitude));

      address!.forEach((element) {
        debugPrint("address is ${element.addressLine}");
      });

      debugPrint("address is $address");
    }

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
          hintText: "Orphanage Name",
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
          hintText: "Phone Number",
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
    //Street field

    //bottomsheet for location searching
    _locationBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TypeAheadField<Address>(
                    textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Select Your Location',
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Colors.pinkAccent,
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    suggestionsCallback: (pattern) {
                      List<Address> newList = [];
                      address?.forEach((element) {
                        if (element.addressLine!.contains(pattern)) {
                          newList.add(element);
                        }
                      });
                      return newList;
                    },
                    getImmediateSuggestions: true,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: Text('${suggestion.addressLine}'),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      if (suggestion.addressLine != null) {
                        StreetEditingController.text = suggestion.addressLine!;
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          });
    }

    final locationField = InkWell(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        _currentPosition = await getPostion();
        getAddress(_currentPosition!.latitude, _currentPosition!.longitude);
        setState(() {
          isLoading = false;
        });

        _locationBottomSheet(context);
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: TextFormField(
            controller: StreetEditingController,
            onChanged: (value) {
              street = StreetEditingController.text;
            },
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_searching_outlined),
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: 'Location',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ),
    );

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
          icon: const Icon(Icons.arrow_back, color: Colors.pinkAccent),
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
                      locationField,
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

  void signup(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailstoFirestore()})
          .catchError((e) {});
      {}
    }
  }

  postDetailstoFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    OrphanageModel orphanageModel = OrphanageModel();
    orphanageModel.mail = user!.email;
    orphanageModel.uid = user.uid;
    orphanageModel.orphanageName = orpahanageName.text;
    orphanageModel.location = StreetEditingController.text;

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
