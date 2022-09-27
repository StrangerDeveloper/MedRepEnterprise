import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/ui/web/area/area_ui.dart';
import 'package:ikram_enterprise/ui/web/customers/customers_ui.dart';
import 'package:ikram_enterprise/ui/web/order_history/order_history_ui.dart';
import 'package:ikram_enterprise/ui/web/overview/overview.dart';
import 'package:ikram_enterprise/ui/web/products/product_ui.dart';
import 'package:ikram_enterprise/ui/web/profile/profile_page.dart';
import 'package:ikram_enterprise/ui/web/routing/routes.dart';
import 'package:ikram_enterprise/ui/web/staff/staff_ui.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      orderController.setCallFromOverviewPage(true);
      return _getPageRoute(const OverviewPage());
    case productPageRoute:
      return _getPageRoute(const ProductPage());
    case staffPageRoute:
      return _getPageRoute(const StaffPage());
    case clientsPageRoute:
      return _getPageRoute(const CustomersPage());
    case areasPageRoute:
      return _getPageRoute(const AreasPage());
    case orderPageRoute:
      orderController.setCallFromOverviewPage(false);
      return _getPageRoute(const OrderHistoryPage());

    case profilePageRoute:
      return _getPageRoute(const ProfilePage());
    default:
      orderController.setCallFromOverviewPage(true);
      return _getPageRoute(const OverviewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}



