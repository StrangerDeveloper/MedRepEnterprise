import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ikram_enterprise/models/customer_model.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';
import 'package:ikram_enterprise/models/product_model.dart';
import 'package:ikram_enterprise/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static const customersKey = "customers",
      currentUserKey = "user",
      productsKey = 'products',
      placeOrderKey = "placeOrder";

  static storeCustomers(List<CustomerModel> list) async {
    // removeValues(customersKey);
    var pref = await SharedPreferences.getInstance();
    pref.setString(customersKey, CustomerModel.encode(list));
  }

  static getCustomers() async {
    var pref = await SharedPreferences.getInstance();

    String customers = pref.getString(customersKey)!;
    List<CustomerModel> list = CustomerModel.decode(customers);

    return list;
    //debugPrint("CustomerSP: ${list.length}");
  }

  static storeProducts(List<ProductModel> list) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(productsKey, jsonEncode(list));
  }

  static storeCurrentUser(UserModel? userModel) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString(currentUserKey, jsonEncode(userModel));
  }

  static Future<void> storePlacedOrder(PlaceOrderModel model) async {
    var pref = await SharedPreferences.getInstance();
    getPlaceOrder().then((value) => debugPrint("StorePlaceOrder(): ${value.toString()}"));
    /*if(getPlaceOrder().) {
      getPlaceOrder().then((value) => debugPrint("StorePlaceOrder(): ${value.toString()}"));

      List<PlaceOrderModel>? list = ;
      if (list!.isEmpty) {
        list.add(model);
        debugPrint("StorePlaceOrder() set: if inner ");
      } else {
        debugPrint("StorePlaceOrder() set: else inner ");
        list = [...list, model];
      }
      setPlaceOrder(list);
    }else{
      debugPrint("StorePlaceOrder() set: else outer---${model.customerId} ");
      setPlaceOrder([model]);
    }*/
  }

  static setPlaceOrder(list) async {
    debugPrint("StorePlaceOrder() setPlaceOrder");
    var pref = await SharedPreferences.getInstance();
    pref.setString(placeOrderKey, PlaceOrderModel.encode(list));
  }

  static Future<List<PlaceOrderModel>> getPlaceOrder() async {
    var pref = await SharedPreferences.getInstance();
    /*List<PlaceOrderModel>? list;
    if(pref.getString(placeOrderKey)!=null) {
       list =
        PlaceOrderModel.decode(pref.getString(placeOrderKey)!);
    }*/
    return PlaceOrderModel.decode(pref.getString(placeOrderKey)!);

  }

  static removeValues(String key) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }

  static clear() async {
    var pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
