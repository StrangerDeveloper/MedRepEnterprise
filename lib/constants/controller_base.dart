import 'package:get/get.dart';
import 'package:ikram_enterprise/controllers/area_controller.dart';
import 'package:ikram_enterprise/controllers/auth_controller.dart';
import 'package:ikram_enterprise/controllers/customer_controller.dart';
import 'package:ikram_enterprise/controllers/menu_controller.dart';
import 'package:ikram_enterprise/controllers/navigation_controller.dart';
import 'package:ikram_enterprise/controllers/order_controller.dart';
import 'package:ikram_enterprise/controllers/product_controller.dart';

MenuController menuController = MenuController.instance;
NavigationController navigationController = NavigationController.instance;

AuthController authController = AuthController.instance;
ProductController productController = Get.find<ProductController>();

OrderController orderController = Get.find<OrderController>();

AreaController areaController = Get.find<AreaController>();
CustomerController customerController = Get.find<CustomerController>();
