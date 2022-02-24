import 'dart:io';

import 'package:butizon_2/models/category_model.dart';
import 'package:butizon_2/models/employee_model.dart';
import 'package:butizon_2/models/services_model.dart';
import 'package:butizon_2/models/shop_model.dart';
import 'package:butizon_2/models/shopworking_model.dart';
import 'package:butizon_2/models/user_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  static final CollectionReference admindata =
      FirebaseFirestore.instance.collection("Admin");
  static final CollectionReference shops =
      FirebaseFirestore.instance.collection("Shops");

  static Future getAdminData() async {
    QuerySnapshot querySnapshot = await admindata.get();
    final uidList = querySnapshot.docs.map((doc) => doc.id).toList();
    return uidList;
  }

  static Future<DocumentSnapshot> getUserData(
          {required String? userId}) async =>
      await FirebaseFirestore.instance.collection("Users").doc(userId).get();

  // To save category name in firebase
  static final CollectionReference instance = FirebaseFirestore.instance
      .collection("Shops")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("Categories");
  static Future createCategory(CategoryModel categoryModel) async {
    await instance.doc(categoryModel.uid).set(categoryModel.toJson());
    return categoryModel.categoryname;
  }

  static Future updateCategory(CategoryModel categoryModel) async {
    await instance.doc(categoryModel.uid).set(
          categoryModel.toJson(),
        );
  }

  //to create service in firebase
  static Future createService(
      {required ServiceModel serviceModel, required String categoryId}) async {
    await instance
        .doc(categoryId)
        .collection("Services")
        .doc(serviceModel.uid)
        .set(serviceModel.toJson())
        .then((value) => debugPrint("${categoryId}is added"))
        .catchError((error) => debugPrint("the error is $error"));
  }

//to delete service
  static Future deleteService(
      {required String categoryId, required String serviceId}) async {
    await instance
        .doc(categoryId)
        .collection("Services")
        .doc(serviceId)
        .delete();
  }

//to edit service
  static Future editService(
      {required ServiceModel serviceModel, required String categoryId}) async {
    await instance
        .doc(categoryId)
        .collection("Services")
        .doc(serviceModel.uid)
        .set(serviceModel.toJson())
        .then((value) => debugPrint(
            "edit service called with categoryId $categoryId ,service ${serviceModel.toJson()}"))
        .catchError((error, stackTrace) => debugPrint(error.toString()));
  }

//save shop working time
  static final CollectionReference shopworking = FirebaseFirestore.instance
      .collection("Shops")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("ShopWorkingTime");

  static Future saveTime({required ShopWorkingModel shopWorkingModel}) async {
    await shopworking
        .doc(shopWorkingModel.uid)
        .set(shopWorkingModel.toMap())
        .then((value) => debugPrint("save time ${shopWorkingModel.toMap()}"));
    return shopWorkingModel.uid;
  }

  static Future deleteTime({required String day}) async {
    await shopworking.doc(day).delete();
  }

//save employee details
  static final CollectionReference employeeDetails = FirebaseFirestore.instance
      .collection("Shops")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("EmployeeDetails");
  static Future saveEmployee(
      ShopModel shopModel, EmployeeModel employeeModel) async {
    await employeeDetails.doc(employeeModel.uid).set(employeeModel.toJson());
    return employeeModel.uid;
  }

  static Future deleteEmployee({required String employeeID}) async {
    await employeeDetails.doc(employeeID).delete();
  }

  static Future editEmployee(
      {required EmployeeModel employeeModel,
      required String? employeeId}) async {
    await employeeDetails
        .doc(employeeId)
        .set(employeeModel.toJson())
        .then((value) => debugPrint(
            "edit employee details called with employee ${employeeModel.toJson()}"))
        .catchError((error, stackTrace) => debugPrint(error.toString()));
  }

// shopEditing Details
  static final DocumentReference shopDetails = FirebaseFirestore.instance
      .collection("Shops")
      .doc(FirebaseAuth.instance.currentUser?.uid);

//edit salon details

  static Future editSalonDetails(
      {required ShopModel shopModel, required String? shopId}) async {
    await shopDetails
        .set(shopModel.toJson())
        .then((value) => debugPrint(
            "edit salon info called with salon ${shopModel.toJson()}"))
        .catchError((error, stackTrace) => debugPrint(error.toString()));
  }

  static Future approveSalon(
      {required ShopModel shopModel,
      required String? shopId,
      required String? status}) async {
    await shops.doc(shopModel.uid).update({"status": status});
  }

  static final FirebaseStorage storage = FirebaseStorage.instance;
//for licence file uploading
  static Future<String?> uploadLicenceFile(
      String filePath, String fileName) async {
    try {
      final reference = storage.ref().child("SalonLicenses/$fileName");

      //Upload file to the firebase
      final uploadTask = reference.putFile(File(filePath));
      final taskSnapshot = await uploadTask;

      //waits till the file is uploaded then stores the download url

      String url = await taskSnapshot.ref.getDownloadURL();
      return url; //this url will be useful to retirive uploaded image

    } catch (e) {
      return null;
    }
  }

//for salon pic uploading
  static Future<String?> uploadSalonPic(
      String filePath, String fileName) async {
    try {
      final reference = storage.ref().child("SalonImages/$fileName");

      //Upload file to the firebase
      final uploadTask = reference.putFile(File(filePath));
      final taskSnapshot = await uploadTask;

      //waits till the file is uploaded then stores the download url

      String url = await taskSnapshot.ref.getDownloadURL();
      return url; //this url will be useful to retirive uploaded image

    } catch (e) {
      return null;
    }
  }

  //upload employee image
  static Future<String?> uploadPic(String filePath, String fileName) async {
    try {
      final reference = storage.ref().child("EmployeeImages/$fileName");

      //Upload file to the firebase
      final uploadTask = reference.putFile(File(filePath));
      final taskSnapshot = await uploadTask;

      //waits till the file is uploaded then stores the download url

      String url = await taskSnapshot.ref.getDownloadURL();
      return url; //this url will be useful to retrieve uploaded image

    } catch (e) {
      return null;
    }
  }

  //requests documents inside shops
  static Future sendBookingRequest({required UserRequestModel request}) async {
    await shops
        .doc(request.shopId)
        .collection("requests")
        .doc(request.timeStamp)
        .set(request.toJson());
  }

  static Future changeBookingStatus(
      {required UserRequestModel request, required String status}) async {
    await shops
        .doc(request.shopId)
        .collection("requests")
        .doc(request.timeStamp)
        .update({"status": status});
  }
}
