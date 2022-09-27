import 'package:get/get.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';

class OrderHistoryController extends GetxController{

  final _orderHistoryCollection = "orders_history";
  final _orderSubProductsCollection = "orderProducts";

  var completedOrdersList = <PlaceOrderModel>[].obs;


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  pushToHistory(PlaceOrderModel orderModel){



  }
}