import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/ui/web/routing/router.dart';
import 'package:ikram_enterprise/ui/web/routing/routes.dart';

Navigator localNavigator() =>   Navigator(
  key: navigationController.navigatorKey,
  onGenerateRoute: generateRoute,
  initialRoute: overviewPageRoute,
);