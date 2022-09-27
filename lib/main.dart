import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/firebase.dart';
import 'package:ikram_enterprise/controllers/area_controller.dart';
import 'package:ikram_enterprise/controllers/auth_controller.dart';
import 'package:ikram_enterprise/controllers/customer_controller.dart';
import 'package:ikram_enterprise/controllers/menu_controller.dart';
import 'package:ikram_enterprise/controllers/navigation_controller.dart';
import 'package:ikram_enterprise/controllers/order_controller.dart';
import 'package:ikram_enterprise/controllers/product_controller.dart';
import 'package:ikram_enterprise/layout.dart';
import 'package:ikram_enterprise/ui/mobile/splash/splash_ui.dart';
import 'package:ikram_enterprise/ui/web/404/error.dart';
import 'package:ikram_enterprise/ui/web/authentication/authentication.dart';
import 'package:ikram_enterprise/ui/web/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await firebaseInitialization.then((value) {
    Get.put(AuthController());
    Get.put(MenuController());
    Get.put(NavigationController());

    Get.put(AreaController());
    Get.put(CustomerController());
    Get.put(OrderController());
    Get.put(ProductController());
  });

  runApp(const MyApp());
  runApp(
    /// 1. Wrap your App widget in the Phoenix widget
    Phoenix(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: kIsWeb ? authenticationPageRoute : splashPageRoute,
      unknownRoute: GetPage(
          name: '/not-found',
          page: () => PageNotFound(),
          transition: Transition.fadeIn),
      getPages: [

        GetPage(name: rootRoute, page: () => SiteLayout()),
        GetPage(
            name: authenticationPageRoute,
            page: () => const AuthenticationPage()),
        GetPage(
            name: splashPageRoute,
            page: () => const SplashUI()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: colorLight,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.indigo,
      ),
      // home: AuthenticationPage(),
    );
  }
}
