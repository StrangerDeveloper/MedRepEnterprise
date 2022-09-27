import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/firebase.dart';
import 'package:ikram_enterprise/models/area_model.dart';

class AreaController extends GetxController {
  var areaCodeController = TextEditingController();
  var areaNameController = TextEditingController();

  final areaCollection = "areas";

  //TODO: area dropdown
  static const _chooseArea = "Choose Area";

  var selectedArea = _chooseArea.obs;

  void setSelectedArea(String area) {
    selectedArea.value = area;
  }

  var areasList = <AreaModel>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    areasList.bindStream(getAreas());

    ever(areasList, handleAreaDropDown);
  }

  handleAreaDropDown(List<AreaModel> areas) {
    setSelectedArea(areas.isNotEmpty ? areas.first.areaName! : _chooseArea);
  }

  createArea() async {
    var docRef = firebaseFirestore.collection(areaCollection).doc();
    AreaModel areaModel = AreaModel(
        uid: docRef.id,
        areaCode: areaCodeController.text.trim(),
        areaName: areaNameController.text.trim());

    await addToDb(areaModel);
  }

  addToDb(AreaModel areaModel) async {
    await firebaseFirestore
        .collection(areaCollection)
        .doc(areaModel.areaCode!)
        .set(areaModel.toMap())
        .then((value) => _clearControllers());
  }

  Stream<List<AreaModel>> getAreas() {
    return firebaseFirestore
        .collection(areaCollection)
        .orderBy(AreaModel.aCode, descending: false)
        .snapshots()
        .map((event) => event.docs
            .map((e) => e.exists ? AreaModel.fromMap(e.data()) : AreaModel())
            .toList());
  }

  Future<void> deleteArea(AreaModel model) async {
    await firebaseFirestore
        .collection(areaCollection)
        .doc(model.areaCode)
        .delete()
        .then((value) {
      Get.back();
      AppConstant.displaySuccessSnackBar(
          "Delete", "Area ${model.areaName} Deleted!");
    });
  }

  Future<void> updateArea(AreaModel model) async {
    await firebaseFirestore
        .collection(areaCollection)
        .doc(model.areaCode)
        .set(model.toMap(), SetOptions(merge: true))
        .then((value) {
      Get.back();
      AppConstant.displaySuccessSnackBar("Update", "Area Update!");
      _clearControllers();
    });
  }

  _clearControllers() {
    areaCodeController.clear();
    areaNameController.clear();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _clearControllers();
  }
}
