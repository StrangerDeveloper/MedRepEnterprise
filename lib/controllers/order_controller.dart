import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/constants/firebase.dart';
import 'package:ikram_enterprise/models/customer_model.dart';
import 'package:ikram_enterprise/models/order_model.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';
import 'package:ikram_enterprise/models/product_model.dart';
import 'package:ikram_enterprise/models/user_model.dart';
import 'package:ikram_enterprise/utils/shared_pref.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:universal_html/html.dart' as html;

class OrderController extends GetxController {
  final _orderCollection = "orders";
  final _orderHistoryCollection = "orders_history";
  final _orderSubProductsCollection = "orderProducts";

  var searchController = TextEditingController();
  var staffSearchController = TextEditingController();
  var productSearchController = TextEditingController();

  //TODO: order more details
  var productQtyController = TextEditingController();
  var productBonusController = TextEditingController();
  var productExtraController = TextEditingController();

  var productNetController = TextEditingController();
  var productRemarksController = TextEditingController();

  //TODO: diff similar called from different pages
  final _isCalledFromOverviewPage = true.obs;

  setCallFromOverviewPage(value) {
    _isCalledFromOverviewPage.value = value;
  }

  bool? get pageCalledFor => _isCalledFromOverviewPage.value;

  DateTime? startDate = DateTime.now().add(const Duration(days: -7));

  DateTime? endDate = DateTime.now();
  var selectedStartAndEndDateRange = "".obs;

  var isFabPressed = false.obs;

  var completedOrdersList = <PlaceOrderModel>[].obs;
  var inProgressOrdersList = <PlaceOrderModel>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    formatStartAndEndDate(startDate, endDate);
    getOrderColumnHeaders();

    inProgressOrdersList.bindStream(getInProgressOrders());
    inProgressOrdersList.listen((p0) {
      if (authController.admin.isFalse && !kIsWeb) {
        handleStaffInProgressList(p0);
      }
    });
    completedOrdersList.bindStream(getCompletedOrders());
    completedOrdersList.listen((p0) {
      if (authController.admin.isFalse && !kIsWeb) {
        handleStaffCompleteList(p0);
      }
    });
  }

  /// Order Details and display section
  var orderColumnsHeader = [];
  var staffOrderColumnsHeader = [];

  getOrderColumnHeaders() {
    orderColumnsHeader.add("Area");
    orderColumnsHeader.add("Customer");
    orderColumnsHeader.add("Booker Name");
    orderColumnsHeader.add("DateTime");
    orderColumnsHeader.add("Status");
    orderColumnsHeader.add("Actions");

    staffOrderColumnsHeader.add("Area");
    staffOrderColumnsHeader.add("Customer");
    staffOrderColumnsHeader.add("DateTime");
    staffOrderColumnsHeader.add("Status");
    staffOrderColumnsHeader.add("Actions");
  }

  Stream<List<PlaceOrderModel>> getInProgressOrders() {
    return firebaseFirestore
        .collection(_orderCollection)
        .orderBy(PlaceOrderModel.pOrderDateTime, descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) {
              if (e.exists) {
                PlaceOrderModel orderModel = PlaceOrderModel.fromMap(e.data());
                CustomerModel customerModel =
                    customerController.getCustomerById(orderModel.customerId!);
                List<String> users = [];
                for (String element in orderModel.orderBy!) {
                  UserModel userModel = authController.getUserById(element);

                  if (userModel.name != null &&
                      !users.toString().contains(userModel.name!)) {
                    users.add(userModel.name!.trim());
                  }
                  debugPrint("Users: ${users.toString()}");
                }
                PlaceOrderModel model = PlaceOrderModel(
                  uId: orderModel.customerId,
                  customerId: customerModel.name ?? orderModel.customerId,
                  areaCode: customerModel.areaName ?? orderModel.areaCode,
                  orderDateTime: orderModel.orderDateTime,
                  isOrderCompleted: orderModel.isOrderCompleted ?? false,
                  orderBy: users,
                );
                return model;
              }
              return PlaceOrderModel();
            }).toList());
  }

  Stream<List<PlaceOrderModel>> getCompletedOrders() {
    return firebaseFirestore
        .collection(_orderHistoryCollection)
        .orderBy(PlaceOrderModel.pCompletionDateTime, descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => e.exists
                ? PlaceOrderModel.fromMap(e.data())
                : PlaceOrderModel())
            .toList());
  }

  ///
  /// Staff/ booker History and inProgress Orders
  ///
  var staffInProgressOrdersList = <PlaceOrderModel>[].obs;
  var staffCompleteOrdersList = <PlaceOrderModel>[].obs;

  handleStaffCompleteList(List<PlaceOrderModel> list) {
    staffCompleteOrdersList.clear();
    if (authController.getCurrentUserUID() == "") {
      debugPrint("User is not found!");
    } else {
      UserModel userModel =
          authController.getUserById(authController.getCurrentUserUID());
      if (list.isNotEmpty) {
        for (PlaceOrderModel model in list) {
          for (var element in model.orderBy!) {
            if (element == userModel.name) {
              model.orderBy!.clear();
              model.orderBy!.add(element);
              staffCompleteOrdersList.add(model);
            }
          }
        }
      }
    }
  }

  handleStaffInProgressList(List<PlaceOrderModel> list) {
    staffInProgressOrdersList.clear();

    if (authController.getCurrentUserUID() == "") {
      debugPrint("User Not Found");
    } else {
      UserModel userModel =
          authController.getUserById(authController.getCurrentUserUID());
      debugPrint("listID: name ${userModel.name}");
      if (list.isNotEmpty) {
        for (PlaceOrderModel model in list) {
          for (var element in model.orderBy!) {
            if (element == userModel.name) {
              debugPrint("listID: name $element");
              model.orderBy!.clear();
              model.orderBy!.add(element);
              staffInProgressOrdersList.add(model);
            }
          }
        }
      } else {
        debugPrint("List is empty");
      }
    }
  }

  ///
  /// Order History
  ///

  pushToOrderHistory(PlaceOrderModel placeOrderModel) async {
    productList.bindStream(getProductsByOrderID(placeOrderModel));

    String inProgressOrderDeletionUID = placeOrderModel.uId!;

    var colRef = firebaseFirestore.collection(_orderHistoryCollection);

    String id = colRef.doc().id;
    placeOrderModel.isOrderCompleted = true;
    placeOrderModel.uId = id;
    placeOrderModel.completionDateTime = Timestamp.now();

    await colRef.doc(id).set(placeOrderModel.toMap()).then((value) async {
      await addOrderSubCollection(placeOrderModel, calledForHistory: true);

      if (productList.isNotEmpty) {
        var docRef = firebaseFirestore
            .collection(_orderCollection)
            .doc(inProgressOrderDeletionUID);
        for (var value in productList) {
          await docRef
              .collection(_orderSubProductsCollection)
              .doc(value.pCode)
              .delete();
        }

        await docRef.delete().then((value) {
          AppConstant.displaySuccessSnackBar(
              "Place Order", "Order Completed Successfully!");
          clearControllers();
        });
      }
    });
  }

  Future<void> completeAllInProgressOrders() async {
    if (inProgressOrdersList.isNotEmpty) {
      for (PlaceOrderModel model in inProgressOrdersList) {
        await pushToOrderHistory(model);
      }
    }
  }

  Future<void> deletePlacedOrder(PlaceOrderModel model) async {
    productList.clear();
    productList.bindStream(getProductsByOrderID(model));
    var docRef = firebaseFirestore
        .collection(pageCalledFor! ? _orderCollection : _orderHistoryCollection)
        .doc(model.uId);
    if (productList.isNotEmpty) {
      for (var value in productList) {
        docRef
            .collection(_orderSubProductsCollection)
            .doc(value.pCode)
            .delete();
      }
    }
    docRef.delete().then((value) {
      Get.back();
      AppConstant.displayFailedSnackBar(
          "Delete Alert!", "Order of ${model.customerId} is deleted");
    });
  }

  var productList = <OrderModel>[].obs;

  Stream<List<OrderModel>> getProductsByOrderID(PlaceOrderModel model) {
    productList.clear();
    return firebaseFirestore
        .collection(pageCalledFor! ? _orderCollection : _orderHistoryCollection)
        .doc(model.uId)
        .collection(_orderSubProductsCollection)
        .snapshots()
        .map((event) => event.docs
            .map((e) => e.exists ? OrderModel.fromMap(e.data()) : OrderModel())
            .toList());
  }

  Stream<List<OrderModel>> getOrderProductsByUserId(
      PlaceOrderModel model, calledFor) {
    debugPrint("CustomerId: ${model.customerId}");
    productList.clear();
    return firebaseFirestore
        .collection(calledFor == "inProgress"
            ? _orderCollection
            : _orderHistoryCollection)
        .doc(model.uId)
        .collection(_orderSubProductsCollection)
        .where(OrderModel.oOrderBy, isEqualTo: authController.userModel!.uid)
        .snapshots()
        .map((event) => event.docs
            .map((e) => e.exists ? OrderModel.fromMap(e.data()) : OrderModel())
            .toList());
  }

  ///
  /// handle Update and delete at in progress order staff side
  ///

  Future<void> deleteStaffInProgressOrder(PlaceOrderModel model) async {
    productList.bindStream(getOrderProductsByUserId(model, "inProgress"));
    if (productList.isNotEmpty) {
      for (var value in productList) {
        await deleteProductById(model, value);
      }
      if (model.orderBy!.length > 1) {
        debugPrint(
            "StaffDeleteORder: CurrentUser ${authController.userModel!.uid}");
        model.orderBy!.remove(authController.userModel!.uid);
        await firebaseFirestore
            .collection(_orderCollection)
            .doc(model.uId)
            .set(model.toMap(), SetOptions(merge: true))
            .then((value) => AppConstant.displaySuccessSnackBar(
                "Delete", "In Progress Order deleted!"));
      } else {
        await firebaseFirestore
            .collection(_orderCollection)
            .doc(model.uId)
            .delete()
            .then((value) => AppConstant.displaySuccessSnackBar(
                "Delete", "In Progress Order deleted!"));
      }
    } else {
      debugPrint("StaffDeletedL productList is empty");
    }
  }

  Future<void> deleteProductById(
      PlaceOrderModel placeOrderModel, OrderModel orderModel) async {
    await firebaseFirestore
        .collection(_orderCollection)
        .doc(placeOrderModel.uId)
        .collection(_orderSubProductsCollection)
        .doc(orderModel.pCode)
        .delete()
        .then((value) => debugPrint("Product deleted"));
  }

  Future<void> addProductToExistingOrder(
      String? orderDocId, OrderModel orderModel) async {
    await firebaseFirestore
        .collection(_orderCollection)
        .doc(orderDocId)
        .collection(_orderSubProductsCollection)
        .doc(orderModel.pCode)
        .set(orderModel.toMap())
        .then((value) {
      clearControllers();
      AppConstant.displayNormalSnackBar(
          "Product Addition!", "product added to order list");
    });
  }

  ///
  /// Handle Searches admin
  ///
  var inProgressSearchList = <PlaceOrderModel>[].obs;
  var completedSearchList = <PlaceOrderModel>[].obs;

  handleInProgressListSearch(String searchQuery) {
    inProgressSearchList.clear();
    if (inProgressOrdersList.isNotEmpty && searchQuery.isNotEmpty) {
      for (PlaceOrderModel element in inProgressOrdersList) {
        if (element.areaCode!.toLowerCase().contains(searchQuery) ||
            element.customerId!.toLowerCase().contains(searchQuery) ||
            element.orderBy!
                .firstWhere(
                    (element) => element.toLowerCase().contains(searchQuery),
                    orElse: () => "")
                .isNotEmpty) {
          inProgressSearchList.add(element);
        }
      }
    }
  }

  handleCompleteListSearch(String searchQuery) {
    completedSearchList.clear();
    if (completedOrdersList.isNotEmpty && searchQuery.isNotEmpty) {
      for (PlaceOrderModel element in completedOrdersList) {
        if (element.areaCode!.toLowerCase().contains(searchQuery) ||
            element.customerId!.toLowerCase().contains(searchQuery) ||
            element.orderBy!
                .firstWhere(
                    (element) => element.toLowerCase().contains(searchQuery),
                    orElse: () => "")
                .isNotEmpty) {
          completedSearchList.add(element);
        }
      }
    }
  }

  ///
  /// Search by Date Admin side
  ///

  searchInProgressListByDate() {
    inProgressSearchList.clear();

    for (PlaceOrderModel model in inProgressOrdersList) {
      if (model.orderDateTime!.toDate().compareTo(startDate!) >= 0 &&
          model.orderDateTime!.toDate().compareTo(endDate!) <= 0) {
        inProgressSearchList.add(model);
      }
    }
    inProgressSearchList.refresh();
  }

  searchCompleteListByDate() {
    completedSearchList.clear();

    for (PlaceOrderModel model in completedOrdersList) {
      if (model.orderDateTime!.toDate().compareTo(startDate!) >= 0 &&
          model.orderDateTime!.toDate().compareTo(endDate!) <= 0) {
        completedSearchList.add(model);
      }
    }
    completedSearchList.refresh();
  }

  ///
  /// Staff Searches section
  ///

  var staffInProgressSearchList = <PlaceOrderModel>[].obs;
  var staffCompleteSearchList = <PlaceOrderModel>[].obs;

  handleStaffInProgressSearch(String searchQuery) {
    staffInProgressSearchList.clear();
    if (staffInProgressOrdersList.isNotEmpty && searchQuery.isNotEmpty) {
      for (PlaceOrderModel element in staffInProgressOrdersList) {
        if (element.areaCode!.toLowerCase().contains(searchQuery) ||
            element.customerId!.toLowerCase().contains(searchQuery)) {
          staffInProgressSearchList.add(element);
        }
      }
    }
  }

  handleStaffCompletedSearch(String searchQuery) {
    staffCompleteSearchList.clear();
    if (staffCompleteOrdersList.isNotEmpty && searchQuery.isNotEmpty) {
      for (PlaceOrderModel element in staffCompleteOrdersList) {
        if (element.areaCode!.toLowerCase().contains(searchQuery) ||
            element.customerId!.toLowerCase().contains(searchQuery)) {
          staffCompleteSearchList.add(element);
        }
      }
    }
  }

  ///
  /// Order creation and placing section
  ///
  createOrder() {
    AppConstant.checkInternetConnection().then((hasConnection) async {
      debugPrint("Internet: $hasConnection");
      authController.setBtnState(1);
     /* if (hasConnection) {
        debugPrint("Internet: $hasConnection");
        await placeOrderOnline();
      } else {*/
        debugPrint("Internet: $hasConnection");
        //add new order if not exists
        List<String> list = [];
        list.add(authController.userModel!.uid!);
        PlaceOrderModel poModel = PlaceOrderModel(
          uId: customerController.customerModel!.code!,
          customerId: customerController.customerModel!.code,
          areaCode: customerController.customerModel!.areaCode,
          orderBy: list,
          orderDateTime: Timestamp.now(),
        );
        SharedPrefHelper.storePlacedOrder(poModel).then((value) => {authController.setBtnState(2),clearControllers(),AppConstant.displaySuccessSnackBar("Order alert!",
            "Order is placed and saved successfully in local memory!")} );
      //}
    });
  }

  syncAndUploadLocalStoredOrders() {
    SharedPrefHelper.getPlaceOrder().then((List<PlaceOrderModel> listOrders) {
      for (PlaceOrderModel poModel in listOrders) {
        addOrderToDb(poModel);
      }
    });
  }

  placeOrderOnline() async {
    // find customer Order if already someone take order.
    findCustomerInOrders(customerController.customerModel!)
        .then((PlaceOrderModel? model) {
      if (model!.customerId != null) {
        //add staff if order already exists
        List<String> list = model.orderBy!;
        if (!model.orderBy!.contains(authController.userModel!.uid!)) {
          list.add(authController.userModel!.uid!);
        }
        model.uId = model.customerId!;
        // model.orderBy = staffs.toString();
        model.orderDateTime = Timestamp.now();
        addOrderToDb(model);
      } else {
        //add new order if not exists
        List<String> list = [];
        list.add(authController.userModel!.uid!);
        PlaceOrderModel poModel = PlaceOrderModel(
          uId: customerController.customerModel!.code!,
          customerId: customerController.customerModel!.code,
          areaCode: customerController.customerModel!.areaCode,
          orderBy: list,
          orderDateTime: Timestamp.now(),
        );
        addOrderToDb(poModel);
      }
    });
  }

  addOrderToDb(PlaceOrderModel poModel) async {
    poModel.orderPlacementDateTime = Timestamp.now();

    await firebaseFirestore
        .collection(_orderCollection)
        .doc(poModel.customerId)
        .set(poModel.toMap())
        .then((value) async {
      await addOrderSubCollection(poModel, calledForHistory: false);
      clearControllers();
      AppConstant.displaySuccessSnackBar(
          "Place Order", "Order Placed Successfully!");
    });
  }

  addOrderSubCollection(PlaceOrderModel model, {bool? calledForHistory}) async {
    var colRef = firebaseFirestore
        .collection(
            calledForHistory! ? _orderHistoryCollection : _orderCollection)
        .doc(model.uId)
        .collection(_orderSubProductsCollection);
    if (calledForHistory) {
      if (productList.isNotEmpty) {
        for (OrderModel orderModel in productList) {
          await colRef.doc(orderModel.pCode).set(orderModel.toMap());
        }
      } else {
        debugPrint("Product list: empty");
      }
    } else {
      for (OrderModel element in orderProductList) {
        // var docRef = colRef.doc();
        findProductsInOrders(model, element).then((OrderModel model) async {
          if (model.pCode != null) {
            model.orderQuantity = model.orderQuantity! + element.orderQuantity!;
            await colRef.doc(model.pCode).set(model.toMap());
          } else {
            await colRef.doc(element.pCode).set(element.toMap());
          }
        });
      }
    }
  }

  Future<OrderModel> findProductsInOrders(placeOrderModel, productModel) async {
    return await firebaseFirestore
        .collection(_orderCollection)
        .doc(placeOrderModel.customerId)
        .collection(_orderSubProductsCollection)
        .doc(productModel.pCode)
        .get()
        .then((value) =>
            value.exists ? OrderModel.fromMap(value.data()!) : OrderModel());
  }

  Future<PlaceOrderModel> findCustomerInOrders(CustomerModel model) async {
    return await firebaseFirestore
        .collection(_orderCollection)
        .doc(model.code)
        .get()
        .then((value) => value.exists
            ? PlaceOrderModel.fromMap(value.data()!)
            : PlaceOrderModel());
  }

  ///
  ///  Handle while product picking staff/booker section, Place order
  ///
  //staff picking product list
  var orderProductList = <OrderModel>[].obs;

  addOrderProductToList(ProductModel model) {
    OrderModel orderModel = OrderModel(
      pName: model.productName!,
      pCode: model.productCode,
      productAdditionDateTime: Timestamp.now(),
      extra: productExtraController.text.isEmpty
          ? "0"
          : productExtraController.text,
      bonus: productBonusController.text.isEmpty
          ? "0"
          : productBonusController.text,
      orderQuantity:
          productQtyController.text.isEmpty ? "0" : productQtyController.text,
      net: productNetController.text.isEmpty ? "0" : productNetController.text,
      remarks: productRemarksController.text,
      orderBy: authController.userModel!.uid,
    );
    if (!orderProductList.contains(orderModel)) {
      orderProductList.add(orderModel);
    } else {
      orderModel.orderQuantity =
          (int.parse(orderModel.orderQuantity!) + 1).toString();
      orderProductList.add(orderModel);
    }
  }

  updateOrderProductList(OrderModel orderModel) {
    orderProductList.remove(orderModel);

    orderModel.orderQuantity = productQtyController.text;
    orderModel.bonus = productBonusController.text;
    orderModel.extra = productExtraController.text;
    orderModel.net = productNetController.text;
    orderModel.remarks = productRemarksController.text;

    orderProductList.add(orderModel);
    orderProductList.refresh();
  }

  removeFromOrderProductList(orderModel) {
    orderProductList.remove(orderModel);
    orderProductList.refresh();
  }

  void onDateSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      startDate = args.value.startDate;
      endDate = args.value.endDate ?? startDate;
    }
    formatStartAndEndDate(startDate, endDate);
  }

  void formatStartAndEndDate(DateTime? start, DateTime? end) {
    selectedStartAndEndDateRange.value =
        "Start: ${AppConstant.formatDateTime("dd-MMM", dateTime: start)} "
        "End: ${AppConstant.formatDateTime("dd-MMM", dateTime: end)}";
  }

  ///
  ///  Exporting CSV Files
  ///
  var csvOrderProducts = [];

  exportOrderProducts() async {
    List<String> headers = [
      "customerName",
      "customerCode",
      "area",
      "productCode",
      "productName",
      "orderQuantity",
      "bonus",
      "extra",
    ];
    // here we will make a 2D array to handle a row
    List<List<dynamic>> rows = [];

    rows.add(headers);

    for (PlaceOrderModel element in inProgressOrdersList) {
      //everytime loop executes we need to add new row

      csvOrderProducts.clear();
      csvOrderProducts = await getOrderProductByCustomerId(element.uId);
      for (OrderModel model in csvOrderProducts) {
        List<dynamic> dataRow = [];
        dataRow.add(element.customerId); //customerName
        dataRow.add(element.uId); //customerCode
        dataRow.add(element.areaCode); //Area
        dataRow.add(model.pCode); //product Code
        dataRow.add(model.pName); // product Name
        dataRow.add(model.orderQuantity); // product Quantity
        dataRow.add(model.bonus); // product Bonus
        dataRow.add(model.extra); // product Extra
        rows.add(dataRow);
      }
    }
    //now convert our 2d array into the csv list using the plugin of csv
    String csv = const ListToCsvConverter().convert(rows);
    if (kIsWeb) {
      html.AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
        ..setAttribute("download", "InProgressOrders.csv")
        ..click();
    }
  }

  exportSingleOrderProducts(PlaceOrderModel element) async {
    List<String> headers = [
      "customerName",
      "customerCode",
      "area",
      "productCode",
      "productName",
      "orderQuantity",
      "bonus",
      "extra",
    ];
    // here we will make a 2D array to handle a row
    List<List<dynamic>> rows = [];

    rows.add(headers);

    csvOrderProducts.clear();
    csvOrderProducts = await getOrderProductByCustomerId(element.uId);
    for (OrderModel model in csvOrderProducts) {
      List<dynamic> dataRow = [];
      dataRow.add(element.customerId); //customerName
      dataRow.add(element.uId); //customerCode
      dataRow.add(element.areaCode); //Area
      dataRow.add(model.pCode); //product Code
      dataRow.add(model.pName); // product Name
      dataRow.add(model.orderQuantity); // product Quantity
      dataRow.add(model.bonus); // product Bonus
      dataRow.add(model.extra); // product Extra
      rows.add(dataRow);
    }

    //now convert our 2d array into the csv list using the plugin of csv
    String csv = const ListToCsvConverter().convert(rows);
    if (kIsWeb) {
      html.AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
        ..setAttribute("download", "${element.customerId}Orders.csv")
        ..click();
    }
  }

  Future<List<OrderModel>> getOrderProductByCustomerId(uid) async {
    return await firebaseFirestore
        .collection(_orderCollection)
        .doc(uid)
        .collection(_orderSubProductsCollection)
        .get()
        .then((value) => value.docs
            .map((e) => e.exists ? OrderModel.fromMap(e.data()) : OrderModel())
            .toList());
  }

  clearControllers() {
    productExtraController.clear();
    productBonusController.clear();
    productQtyController.clear();
    searchController.clear();
    productSearchController.clear();
    orderProductList.clear();
    productList.clear();
    customerController.resetCustomerModel();
    isFabPressed.value = false;

    orderProductList.refresh();
    productList.refresh();
    productController.clearSelectedProduct();
  }

  clearLists() {
    staffCompleteOrdersList.clear();
    staffInProgressOrdersList.clear();
    inProgressOrdersList.clear();
    completedOrdersList.clear();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    clearControllers();
    clearLists();
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
