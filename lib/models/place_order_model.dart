import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';

class PlaceOrderModel {
  static const uID = "uId",
      pOrderBy = "orderBy",
      pCustomerId = "customerId",
      pAreaCode = "pAreaCode",
      pOrderCompleted = "isOrderCompleted",
      pOrderDateTime = "orderDateTime",
      pOrderPlacementDateTime = "orderPlacementDateTime",
      pCompletionDateTime = "completionDateTime",
      pOrderProducts = "orderProducts";

  String? uId, customerId, areaCode;
  Timestamp? orderDateTime,orderPlacementDateTime, completionDateTime;
  bool? isOrderCompleted;
  List<String>? orderBy;

  //List<OrderModel>? orderProducts;

  PlaceOrderModel({
    this.uId,
    this.orderBy,
    this.customerId,
    this.areaCode,
    this.orderDateTime,
    this.completionDateTime,
    this.orderPlacementDateTime,
    this.isOrderCompleted = false,
    //this.orderProducts,
  });

  factory PlaceOrderModel.fromMap(Map<String, dynamic> map) {
    return PlaceOrderModel(
        uId: map[uID],
        orderDateTime: map[pOrderDateTime],
        completionDateTime: map[pCompletionDateTime],
        orderPlacementDateTime: map[pOrderPlacementDateTime],
        areaCode: map[pAreaCode],
        orderBy: List.from(map[pOrderBy]),
        customerId: map[pCustomerId],
        isOrderCompleted: map[pOrderCompleted] ?? false
        //orderProducts: map[pOrderProducts],
        );
  }

  Map<String, dynamic> toMap() => {
        uID: uId,
        pOrderBy: orderBy,
        pOrderDateTime: orderDateTime,
        pCompletionDateTime: completionDateTime,
        pCustomerId: customerId,
        pAreaCode: areaCode,
        pOrderCompleted: isOrderCompleted,
        pOrderPlacementDateTime: orderPlacementDateTime
      };

  ///
  /// for storing in SharedPref as String converting to Json map format
  ///

  static String encode(List<PlaceOrderModel> ordersList) => json.encode(
    ordersList
        .map<Map<String, dynamic>>((placeOrderModel) => placeOrderModel.toMap())
        .toList(),
  );

  static List<PlaceOrderModel> decode(String? orders) =>
      (json.decode(orders!) as List<dynamic>)
          .map<PlaceOrderModel>((item) => PlaceOrderModel.fromMap(item))
          .toList();
}
