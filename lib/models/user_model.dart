//User Model

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const uID = "uid";
  static const uNAME = "name";
  static const uTYPE = "userType";
  static const uPHONE = "phone";
  static const uEMAIL = "email";
  static const uPASS = "password";
  static const uPhotoURL = "photo_url";
  static const uADDRESS = "address";
  static const uCreateDate = "createDateTime";
  static const uIsAdmin = "isAdmin";
  static const uISDeleted = "isDeleted";
  static const uCompanyCode = "companyCode";

  String? uid, companyCode, email, password, address;
  String? name, userType, phone, photoUrl;
  bool? isAdmin, isDeleted;
  Timestamp? createdDate;

  UserModel(
      {this.uid,
      this.companyCode,
      this.email,
      this.password,
      this.name,
      this.userType,
      this.phone,
      this.isAdmin = false,
      this.isDeleted = false,
      this.photoUrl = "https://cdn-icons-png.flaticon.com/512/3011/3011270.png",
      this.address,
      this.createdDate});

  factory UserModel.fromMap(Map<String, dynamic>? data) {
    return UserModel(
      uid: data![uID],
      companyCode: data[uCompanyCode] ?? "",
      email: data[uEMAIL],
      password: data[uPASS],
      name: data[uNAME] ?? '',
      userType: data[uTYPE],
      phone: data[uPHONE],
      photoUrl: data[uPhotoURL],
      isAdmin: data[uIsAdmin],
      isDeleted: data[uISDeleted],
      address: data[uADDRESS] ?? '',
      createdDate: data[uCreateDate],
    );
  }

  factory UserModel.fromDoc(Object? data) {
    Map<String, dynamic> map = data as Map<String, dynamic>;
    return UserModel.fromMap(map);
  }

  Map<String, dynamic> toJson() => {
        uID: uid,
        uCompanyCode: companyCode,
        uEMAIL: email,
        uPASS: password,
        uNAME: name,
        uPHONE: phone,
        uPhotoURL: photoUrl,
        uIsAdmin: isAdmin,
        uISDeleted: isDeleted,
        uADDRESS: address,
        uTYPE: userType,
        uCreateDate: createdDate
      };
}

enum UserGroup { admin, medicalRepresentative, salesMan }
