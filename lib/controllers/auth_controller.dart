import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/constants/firebase.dart';
import 'package:ikram_enterprise/layout.dart';
import 'package:ikram_enterprise/models/profile_avatars.dart';
import 'package:ikram_enterprise/models/user_model.dart';
import 'package:ikram_enterprise/ui/mobile/staff_home.dart';
import 'package:ikram_enterprise/ui/web/authentication/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final _userCollection = "users";
  final _profileAvatars = "profile_avatars";

  final defaultImageUrl =
      "https://cdn-icons-png.flaticon.com/128/3011/3011270.png";

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController companyCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController editTextFieldController = TextEditingController();

  /// btn state for progressive bar indicator
  ///  0 for default
  ///  1 for progressing
  ///  2. for done state.
  final _btnState = 0.obs;

  int? get btnState => _btnState.value;

  setBtnState(int value) {
    _btnState.value = value;
  }

  Rxn<User>? firebaseUser = Rxn<User>();

  final _userModel = UserModel().obs;

  UserModel? get userModel => _userModel.value;

  final RxBool admin = false.obs;

  var usersList = <UserModel>[].obs;
  var staffList = <UserModel>[].obs;

  //TODO: Manage Staff companyType dropdown
  var isMedicalRep = false.obs;

  //TODO: manage dropdown for staff type
  static const _chooseType = "Select Type";

  var selectedType = _chooseType.obs;

  void setType(String value) {
    selectedType.value = value;

    if (value.contains("Medical Representative")) {
      isMedicalRep.value = true;
    } else {
      isMedicalRep.value = false;
    }
  }

  var staffTypeList = [].obs;
  var profileAvatarsList = <ProfileAvatars>[].obs;

  @override
  void onReady() {
    super.onReady();

    firebaseUser!.bindStream(firebaseAuth.userChanges());
    //firebaseUser.listen((p0) { });
    //findUserInDB();
    ever(firebaseUser!, handleAuthChanged);
    usersList.bindStream(getAllUsers());
    ever(usersList, getStaffFromUsers);

    staffTypeList.addAll(["Admin", "Medical Representative", "Sales Man"]);

    setType(staffTypeList.isEmpty ? _chooseType : staffTypeList.first);

    profileAvatarsList.bindStream(getProfileAvatars());
  }

  handleAuthChanged(User? firebaseUser) async {
    if (firebaseUser?.uid != null) {
      _userModel.bindStream(streamCurrentUser());
      await isAdmin();
    }

    if (firebaseUser == null) {
      Get.offAll(() => const AuthenticationPage());
    } else {
      if (admin.isTrue) {
        Get.offAll(() => SiteLayout());
      } else {
        if (!kIsWeb) {
          Get.offAll(() => const StaffHome());
        }
      }
    }
  }

  getStaffFromUsers(List<UserModel> users) {
    staffList.clear();
    staffList.addAll(usersList.where((p0) => !p0.isAdmin!));
  }

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamCurrentUser() {
    debugPrint("streamCurrentUser()");
    var uid = firebaseUser!.value?.uid;
    return firebaseFirestore
        .collection(_userCollection)
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.exists
            ? UserModel.fromMap(snapshot.data()!)
            : UserModel());
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => firebaseAuth.currentUser!;

  //check if user is an admin user
  isAdmin() async {
    await getUser.then((user) async {
      await firebaseFirestore
          .collection(_userCollection)
          .doc(user.uid)
          .get()
          .then((value) {
        if (value.exists && value["isAdmin"]) {
          admin.value = true;
        } else {
          admin.value = false;
        }
      });

      //update();
    });
  }

  Future<void> loginWithEmailAndPassword() async {
    setBtnState(1);
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((result) {
        setBtnState(2);

        _clearControllers();

        AppConstant.displaySuccessSnackBar(
            "Sign In Alert!", "Logged in Successfully!");
      });
    } catch (error) {
      setBtnState(0);
      debugPrint("$error");
      //signUpWithEmailAndPassword();
    }
  }

  UserModel getUserById(String? userId) {
    return usersList.isNotEmpty
        ? usersList.firstWhere(
            (element) => element.uid!.contains(userId!.trim()),
            orElse: () => UserModel())
        : UserModel();
  }

  String getCurrentUserUID() {
    debugPrint("user: ${userModel!.uid}");
    debugPrint("user: ${firebaseAuth.currentUser!.uid}");

    return firebaseAuth.currentUser != null
        ? firebaseAuth.currentUser!.uid
        : userModel != null
            ? userModel!.uid!
            : "";
  }

  UserModel getStaffById(String? userId) {
    return staffList.isNotEmpty
        ? staffList.firstWhere((element) =>
            element.uid!.contains(userId!) || element.name!.contains(userId))
        : UserModel();
  }

  String getStaffNameByID(String? userId) {
    return staffList.isNotEmpty
        ? staffList
            .firstWhere((element) => element.uid!.contains(userId!))
            .name!
        : "Not Found";
  }

  var isUserRegistered = false.obs;

  void findUserInDB() async {
    await getUser.then((user) async {
      firebaseFirestore.collection(_userCollection).snapshots().map((event) {
        return event.docs.map((e) {
          if (e.exists) {
            UserModel userModel = UserModel.fromMap(e.data());
            if (userModel.email == user.email) {
              firebaseFirestore
                  .collection(_userCollection)
                  .doc(userModel.uid)
                  .delete();
              userModel.uid = user.uid;
              _createUserFirestore(userModel);
            }
          }
        });
      });
    });
  }

  Stream<List<UserModel>> getAllUsers() {
    return firebaseFirestore.collection(_userCollection).snapshots().map(
        (event) => event.docs
            .map((e) => e.exists ? UserModel.fromMap(e.data()) : UserModel())
            .toList());
  }

  Stream<List<ProfileAvatars>> getProfileAvatars() {
    return firebaseFirestore.collection(_profileAvatars).snapshots().map(
        (event) =>
            event.docs.map((e) => ProfileAvatars.fromMap(e.data())).toList());
  }

  List getProfileData() {
    var profileData = [
      {
        "title": "Phone",
        "subtitle": userModel!.phone ?? 'no phone number',
        "icon": "assets/icons/phone_icon.svg"
      },
      {
        "title": "Email",
        "subtitle": userModel!.email ?? "example@gmail.com",
        "icon": "assets/icons/email_icon.svg"
      },
      {
        "title": "Password",
        "subtitle": userModel!.password,
        "icon": "assets/icons/phone_icon.svg"
      },
      {
        "title": "Address",
        "subtitle": userModel!.address ?? 'e.g. street, e.g. city',
        "icon": "assets/icons/address_icon.svg"
      },
    ];
    return profileData;
  }

  updateProfileAvatar(ProfileAvatars profileAvatar) async {
    await firebaseFirestore
        .collection(_userCollection)
        .doc(userModel!.uid!)
        .set({UserModel.uPhotoURL: profileAvatar.url!},
            SetOptions(merge: true)).whenComplete(() {
      Get.back();
      AppConstant.displaySuccessSnackBar(
          "Success!", "Profile Avatar Successfully Updated!");
    });
  }

  // User registration using email and password
  signUpWithEmailAndPassword() async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((result) async {
        debugPrint("User: user ${result.user!.email} with created");
        //findUserInDB();
        //create the new user object
        UserModel newUser = UserModel(
          uid: result.user!.uid,
          email: result.user!.email!,
          password: passwordController.text.trim(),
          name: nameController.text,
          createdDate: Timestamp.now(),
          phone: phoneController.text,
          userType: selectedType.value,
          companyCode: companyCodeController.text.trim(),
          address: addressController.text,
        );
        //create the user in firestore
        _createUserFirestore(newUser);
      });
    } on FirebaseAuthException catch (error) {
      AppConstant.displayFailedSnackBar("Sign Up alert!",
          "Something went wrong,P\n Please check the details or contact with Developer!\n  ${error.message}");
    }
  }

  addStaffToDb() {
    var docRef = firebaseFirestore.collection(_userCollection).doc();
    UserModel newUser = UserModel(
      uid: docRef.id,
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text,
      createdDate: Timestamp.now(),
      phone: phoneController.text,
      userType: selectedType.value,
      companyCode: companyCodeController.text.trim(),
      address: addressController.text,
    );
    _createUserFirestore(newUser);
  }

  //create the firestore user in users collection
  void _createUserFirestore(UserModel userModel) async {
    await firebaseFirestore
        .collection(_userCollection)
        .doc(userModel.uid)
        .set(userModel.toJson())
        .then((value) => {
              setBtnState(2),
              _clearControllers(),
              AppConstant.displaySuccessSnackBar(
                  "Success", "User was registered successfully!")
            })
        .onError((error, stackTrace) => {
              //setBtnState(0),
              AppConstant.displayFailedSnackBar(
                  "Registration Error!", "Something went wrong! $error")
            });
  }

  List populateStaffType() {
    return ["Admin", "Medical Representative", "Sales Man"];
  }

  deleteUser(UserModel userModel) async {
    await firebaseFirestore
        .collection(_userCollection)
        .doc(userModel.uid)
        .delete()
        .then((value) async {
      AppConstant.displayNormalSnackBar(
          "Deleted", "Staff/Booker Successfully Deleted");
      Get.back();
    });
    AuthCredential credentials = EmailAuthProvider.credential(
        email: userModel.email!, password: userModel.password!);
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credentials);
    final user = userCredential.user;
    await user
        ?.delete()
        .onError((error, stackTrace) => debugPrint("delete Error: $error"));
  }

  updateUser(UserModel userModel) async {
    await firebaseFirestore
        .collection(_userCollection)
        .doc(userModel.uid)
        .set(userModel.toJson(), SetOptions(merge: true))
        .then((value) {
      Get.back();
      AppConstant.displaySuccessSnackBar(
          "Update Alert!", "User was Updated successfully");
      _clearControllers();
    });
  }

  Future<void> updateUserBuyTitle(String title) async {
    String value = editTextFieldController.text.trim();
    await firebaseFirestore
        .collection(_userCollection)
        .doc(userModel!.uid!)
        .set({title.toLowerCase(): value},
            SetOptions(merge: true)).whenComplete(() {
      editTextFieldController.clear();
    });
  }

  updateUserPassword(UserModel? model) async {
    String? email = model!.email!;
    String? password = model.password!.toLowerCase();

    String? currentPassword = passwordController.text.toLowerCase();
    String? newPassword = newPasswordController.text.toLowerCase();

    if (currentPassword != newPassword) {
      if (password == currentPassword) {
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;
        debugPrint("UpdatePassword ${user?.uid}");
        user!.updatePassword(newPassword).whenComplete(() {
          model.password = newPassword;
          updateUser(model);
        });
      } else {
        showError("Wrong old password!");
      }
    } else {
      showError("new Password must be different than old");
    }
  }

  showError(String message) {
    AppConstant.displayFailedSnackBar("Password Update Alert!", message);
  }

  /// Profile Image Capture/Pick Section
  ///
  /// callingType
  ///  0 for Camera
  ///  1 for Gallery
  var uploadingText = "".obs;

  pickOrCaptureImageGallery(int? callingType) async{
      try {
        final ImagePicker picker = ImagePicker();
        XFile? imgFile = await picker.pickImage(
            source: callingType == 0 ? ImageSource.camera : ImageSource
                .gallery);
        uploadImage(imgFile);
      }catch(e){
        debugPrint("UploadImage: $e");
      }
  }

  uploadImage(XFile? imgFile){
    //final fileName = basename(_photo!.path);
    //final destination = 'Images/$fileName';

    try{

      final imageStorage = firebaseStorage.ref("ProfileImages");
      if(imgFile!=null){
        File image = File(imgFile.path);

        UploadTask? uploadTask = imageStorage.child("${userModel!.uid!}/").putFile(image);

        uploadTask.snapshotEvents.listen((event) {
          uploadingText("Uploading...${event.bytesTransferred} of Total: ${event.totalBytes}");
        });
        uploadTask.then((TaskSnapshot task) {

          debugPrint("UploadImage: ${task.state.toString()}");
          task.ref.getDownloadURL().then((value){
            userModel!.photoUrl =value;
            updateUser(userModel!);
          });

        });

      }else{
        debugPrint("UploadImage: No Image found");
      }
      
    }catch(e){
      debugPrint("UploadImage: $e");
    }

  }

  /// Profile Image End

  _clearControllers() {
    uploadingText("");
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    addressController.clear();
    companyCodeController.clear();
    newPasswordController.clear();
    editTextFieldController.clear();
  }

  _disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    newPasswordController.dispose();
  }

  Future<void> signOut() async {
    _clearControllers();
    usersList.clear();
    orderController.clearLists();
    await FirebaseAuth.instance.signOut();
  }

  @override
  void onClose() {
    super.onClose();
    _disposeControllers();
  }
}
