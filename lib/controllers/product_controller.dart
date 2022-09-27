import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/constants/firebase.dart';
import 'package:ikram_enterprise/models/product_model.dart';
import 'package:ikram_enterprise/models/user_model.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  final _productsCollection = "products";

  var prodCodeController = TextEditingController();
  var prodNameController = TextEditingController();
  var compCodeController = TextEditingController();
  var compNameController = TextEditingController();

  var searchController = TextEditingController();

  var csvHeaderList = <String>[];
  var productList = <ProductModel>[].obs;
  var medRepProductList = <ProductModel>[].obs;

  //TODO: add selected product to List


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    productList.bindStream(getCsvProducts());
    if (authController.admin.isFalse && !kIsWeb) {
      ever(productList, handleMedRepProducts);
    }
    getColumnHeaders();
  }

  getColumnHeaders() {
    csvHeaderList.add("Product Code");
    csvHeaderList.add("Product Name");
    csvHeaderList.add("Company Code");
    csvHeaderList.add("Company Name");
    csvHeaderList.add("Actions");
  }

  ///
  /// Create, Update and Delete Product Section
  ///

  createProduct() async {
    ProductModel productModel = ProductModel(
      csvFileName: "Manually",
      companyCode: compCodeController.text.trim(),
      companyName: compNameController.text.trim(),
      productCode: prodCodeController.text.trim(),
      productName: prodNameController.text.trim(),
    );

    await firebaseFirestore
        .collection(_productsCollection)
        .doc(productModel.productCode)
        .set(productModel.toMap())
        .then((value) {
      clearControllers();
      Get.back();
      AppConstant.displaySuccessSnackBar(
          "Product Alert!", "Product Added Successfully!");
    });
  }

  deleteProductById(ProductModel? productModel) async {
    await firebaseFirestore
        .collection(_productsCollection)
        .doc(productModel!.productCode)
        .delete()
        .then((value) =>
        AppConstant.displayNormalSnackBar(
            "Product Alert!", "Product deleted successfully!"));
  }

  updateProductById(ProductModel? productModel) async {
    await firebaseFirestore
        .collection(_productsCollection)
        .doc(productModel!.productCode)
        .set(productModel.toMap(), SetOptions(merge: true))
        .then((value) {
      clearControllers();
      Get.back();
      AppConstant.displaySuccessSnackBar(
          "Product Alert!", "Product Added Successfully!");
    });
  }

  ///
  ///  Search in all Products Admin side
  ///
  var searchInAllProductList = <ProductModel>[].obs;

  searchInAllProducts(String? searchQuery) {
    searchInAllProductList.clear();
    if (productList.isNotEmpty) {
      for (ProductModel model in productList) {
        if (model.productName!.toLowerCase().startsWith(searchQuery!) ||
            model.productCode!.contains(searchQuery) ||
            model.companyCode!.contains(searchQuery) ||
            model.companyName!.toLowerCase().startsWith(searchQuery)){
          searchInAllProductList.add(model);
        }
      }
    }
  }

  Stream<List<ProductModel>> getCsvProducts() {
    return firebaseFirestore.collection(_productsCollection).snapshots().map(
            (event) =>
            event.docs
                .map((e) =>
            e.exists ? ProductModel.fromMap(e.data()) : ProductModel())
                .toList());
  }

  var productSearchList = [].obs;

  handleProductSearch(String searchQuery) {
    productSearchList.clear();
    if (searchQuery.isNotEmpty) {
      for (ProductModel model in productList) {
        if (model.productName!
            .toLowerCase()
            .startsWith(searchQuery.toLowerCase()) ||
            model.productCode!.contains(searchQuery) ||
            model.companyCode!.contains(searchQuery) ||
            model.companyName!.toLowerCase() == searchQuery.toLowerCase()) {
          productSearchList.add(model);
        }
      }
    }
    productSearchList.refresh();
  }

  ///
  /// Medical Representative Products
  ///

  bool getMedRepUser() {
    UserModel? userModel =
    authController.getUserById(authController.getCurrentUserUID());

    if (userModel.userType == AppConstant.medicalRep) {
      return true;
    }
    return false;
  }

  handleMedRepProducts(List<ProductModel> list) {
    if (list.isNotEmpty) {
      medRepProductList.clear();
      UserModel? userModel =
      authController.getUserById(authController.getCurrentUserUID());

      if (userModel.companyCode != null) {
        List<String> codes = userModel.companyCode!.split(",");
        for (var value in codes) {
          for (ProductModel model in list) {
            if (value == model.companyCode) {
              debugPrint("MedRep Products $value ${model.productName}");
              medRepProductList.add(model);
            }
          }
        }
      } else {
        debugPrint("MedRep user not found");
      }
    } else {
      debugPrint("MedRep list is empty");
    }
  }

  handleMedRepProductSearch(String searchQuery) {
    debugPrint("handleMedRepProductSearch()");
    productSearchList.clear();
    if (medRepProductList.isNotEmpty) {
      for (ProductModel model in medRepProductList) {
        if (model.productName!
            .toLowerCase()
            .startsWith(searchQuery.toLowerCase()) ||
            model.productCode!.contains(searchQuery) ||
            model.companyCode!.contains(searchQuery) ||
            model.companyName!.toLowerCase() == searchQuery.toLowerCase()) {
          productSearchList.add(model);
        }
      }
    } else {
      debugPrint("medRep product List empty");
    }
  }

  clearSelectedProduct() {
    if (productSearchList.isNotEmpty) {
      for (var value in productSearchList) {
        if (value.isAddedToList!) {
          value.isAddedToList = false;
        }
      }
    }
    productSearchList.clear();
  }

  String getCompanyByCode(String code) {
    return productList.isNotEmpty
        ? productList
        .firstWhere((element) => element.companyCode == code)
        .companyName!
        : code;
  }

  void sortProducts(String sortOn) {
    if (sortOn == csvHeaderList[1]) {
      productList.sort(
            (a, b) => a.productName!.compareTo(b.productName!),
      );
    } else if (sortOn == csvHeaderList[2]) {
      productList.sort(
            (a, b) => a.companyCode!.compareTo(b.companyCode!),
      );
    } else if (sortOn == csvHeaderList[3]) {
      productList.sort(
            (a, b) => a.companyName!.compareTo(b.companyName!),
      );
    } else {
      productList.sort(
            (a, b) => a.productCode!.compareTo(b.productCode!),
      );
    }
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
    for (var element in list) {
      ProductModel csvModel = ProductModel.fromList(element);
      csvModel.csvFileName = csvFile.files.first.name;
      firebaseFirestore
          .collection(_productsCollection)
          .doc("${csvModel.productCode}")
          .set(csvModel.toMap());
    }
  }

  clearControllers() {
    prodCodeController.clear();
    prodNameController.clear();
    compCodeController.clear();
    compNameController.clear();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    clearControllers();
  }
}
