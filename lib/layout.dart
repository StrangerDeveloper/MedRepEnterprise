import 'package:flutter/material.dart';
import 'package:ikram_enterprise/helpers/local_navigator.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/ui/web/widgets/large_screen.dart';
import 'package:ikram_enterprise/ui/web/widgets/side_menu.dart';
import 'package:ikram_enterprise/ui/web/widgets/top_nav.dart';

class SiteLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  SiteLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: const Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
        largeScreen: const LargeScreen(),
        smallScreen: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: localNavigator(),
        ),
      ),
    );
  }
}
