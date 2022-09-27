import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/constants/firebase.dart';
import 'package:ikram_enterprise/models/area_model.dart';
import 'package:ikram_enterprise/models/customer_model.dart';
import 'package:ikram_enterprise/utils/shared_pref.dart';

class CustomerController extends GetxController {
  final _customerCollection = "customers";

  final adminTag = "AdminCustomer";

  var codeController = TextEditingController();
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var areaCodeController = TextEditingController();
  var areaNameController = TextEditingController();

  var searchController = TextEditingController();

  //TODO: dropdown for areas

  var customerList = <CustomerModel>[].obs;

  var columnHeaders = [];

  //Todo: Set Customer MODEL in Order Place UI
  final _isCustomerPicked = false.obs;

  setCustomerIsPicked(bool value) {
    _isCustomerPicked.value = value;
  }

  bool? get isCustomerPicked => _isCustomerPicked.value;

  final _customerModel = CustomerModel().obs;

  setCustomerModel(CustomerModel? model) {
    _customerModel.value = model!;
  }

  resetCustomerModel() {
    _isCustomerPicked.value = false;
    _customerModel.value = CustomerModel();
    customerSearchList.clear();
  }

  CustomerModel? get customerModel => _customerModel.value;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    customerList.bindStream(getCustomers());

    getColumnHeaders();
    getAdminCustomer();

    //ever(customerList, storeInSharePref);
  }

  void storeInSharePref(List<CustomerModel> list){
    SharedPrefHelper.storeCustomers(list);
    SharedPrefHelper.getCustomers();
  }


  getColumnHeaders() {
    columnHeaders.add("Code");
    columnHeaders.add("Customer Name");
    columnHeaders.add("Address");
    columnHeaders.add("AreaCode");
    columnHeaders.add("AreaName");
    columnHeaders.add("Actions");
  }

  ///
  /// CRUD on Customer
  ///
  createCustomer() async {
    CustomerModel customer = CustomerModel(
      uid: codeController.text.trim(),
      address: addressController.text.trim(),
      name: nameController.text.trim(),
      code: codeController.text.trim(),
      areaCode: areaCodeController.text.trim(),
      areaName: areaNameController.text.trim(),
    );

    await firebaseFirestore
        .collection(_customerCollection)
        .doc(customer.code)
        .set(customer.toMap())
        .then((value) {
      clearControllers();
      Get.back();
      AppConstant.displaySuccessSnackBar(
          "Customer Alert!", "Customer Added Successfully!");
    });
  }

  Stream<List<CustomerModel>> getCustomers() {
    return firebaseFirestore
        .collection(_customerCollection)
        .orderBy(CustomerModel.cAreaCode, descending: false)
        .snapshots()
        .map((event) => event.docs
            .map((e) =>
                e.exists ? CustomerModel.fromMap(e.data()) : CustomerModel())
            .toList());
  }

  ///
  /// Admin side Get Customer by limiting documents firestore
  ///
  //var adminCustomersList = <CustomerModel>[].obs;
  var adminCustomersList = <DocumentSnapshot>[].obs;

  var isLoading = false.obs; // track if products fetching

  var hasMore = true.obs; // flag for more products available or not

  int documentLimit = 30; // documents to be fetched per request

  // flag for last document from where next 10 records to be fetched
  DocumentSnapshot? lastDocument;
  int count = 0;

// listener for listview scrolling
  ScrollController scrollController = ScrollController();

  getAdminCustomer() async {
    count++;
    if (!hasMore.value) {
      debugPrint('$adminTag: No More Products');
      return;
    }
    if (isLoading.value) {
      return;
    }
    isLoading(true);

    QuerySnapshot? querySnapshot;

    if (lastDocument == null) {
      querySnapshot = await firebaseFirestore
          .collection(_customerCollection)
          .orderBy(CustomerModel.cAreaCode, descending: false)
          .limit(documentLimit)
          .get();
      debugPrint("$adminTag, if called");
    } else {
      querySnapshot = await firebaseFirestore
          .collection(_customerCollection)
          .orderBy(CustomerModel.cAreaCode, descending: false)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      debugPrint("$adminTag, else called");
    }
    if (querySnapshot.docs.length < documentLimit) {
      debugPrint("$adminTag, has more called");
      hasMore(false);
    }

    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

    /* return querySnapshot.docs.map((e) => e.exists
        ? CustomerModel.fromMap(e.data() as Map<String, dynamic>)
        : CustomerModel());*/

    adminCustomersList.addAll(querySnapshot.docs);
    debugPrint("$adminTag: count $count");
    isLoading(false);
  }


  addListenerToController(context) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;

      if (maxScroll - currentScroll <= delta) {
        debugPrint("$adminTag addListenerToController()");
        getAdminCustomer();

      }
    });
  }

  /// End Get Customer

  CustomerModel getCustomerById(String customerId) {
    return customerList.isNotEmpty
        ? customerList.firstWhere(
            (p0) =>
                p0.code!.contains(customerId) ||
                p0.name!.toLowerCase().contains(customerId.toLowerCase()),
            orElse: () => CustomerModel())
        : CustomerModel();
  }

  ///
  /// Delete and update Customers
  ///

  Future<void> deleteCustomer(CustomerModel model) async {
    await firebaseFirestore
        .collection(_customerCollection)
        .doc(model.code)
        .delete()
        .then((value) => AppConstant.displayNormalSnackBar(
            "Customer Alert!", "Customer deleted successfully!"));
  }

  Future<void> updateCustomer(CustomerModel model) async {
    await firebaseFirestore
        .collection(_customerCollection)
        .doc(model.code)
        .set(model.toMap(), SetOptions(merge: true))
        .then((value) {
      clearControllers();
      Get.back();
      AppConstant.displaySuccessSnackBar(
          "Customer Alert!", "Customer updated Successfully!");
    });
  }

  var customerSearchList = <CustomerModel>[].obs;

  ///
  /// Customer Search All
  ///

  handleCustomerSearch(String searchQuery) {
    customerSearchList.clear();
    if (searchQuery.isNotEmpty) {
       for (CustomerModel model in customerList) {
        if (model.name!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            model.code!.contains(searchQuery) ||
            model.areaCode!.contains(searchQuery) ||
            model.areaName!.toLowerCase().contains(searchQuery)) {
          customerSearchList.add(model);
        }
      }

    }
    customerSearchList.refresh();
  }

  void sortCustomerList(String sortOn) {
    if (sortOn.toLowerCase() == "code") {
      customerList.sort(
        (a, b) => a.code!.compareTo(b.code!),
      );
    } else if (sortOn.toLowerCase() == "areaCode".toLowerCase()) {
      customerList.sort(
        (a, b) => a.areaCode!.compareTo(b.areaCode!),
      );
    }
    customerList.refresh();
  }

  importCsvFromStorage() async {
    try {
      FilePickerResult? csvFile = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv'],
        type: FileType.custom,
      );

      if (csvFile != null) {
        final bytes = utf8.decode((csvFile.files.first.bytes)!.toList());
        List<List<dynamic>> list = const CsvToListConverter().convert(bytes);

        list.removeAt(0);
        debugPrint("ListOfList ${list.first}");
        handleCsvData(list, csvFile);
      }
    } on PlatformException catch (e) {
      debugPrint("Platform${e.message}");
    } catch (e) {
      debugPrint("Fatal: $e");
    }
  }

  handleCsvData(List<List<dynamic>> list, FilePickerResult csvFile) {
    list.toSet().toList();
    int areaSerialNo = 101;
    for (var element in list) {
      CustomerModel csvModel = CustomerModel.fromList(element);

      AreaModel area = AreaModel(
          areaCode: csvModel.areaCode,
          areaName: csvModel.areaName,
          uid: csvModel.areaCode);

      areaController.addToDb(area);

      firebaseFirestore
          .collection(_customerCollection)
          .doc("${csvModel.code}")
          .set(csvModel.toMap())
          .whenComplete(() {});
      areaSerialNo += 1;
    }
  }

  clearControllers() {
    codeController.clear();
    nameController.clear();
    addressController.clear();
    areaNameController.clear();
    areaCodeController.clear();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    clearControllers();
  }
}
