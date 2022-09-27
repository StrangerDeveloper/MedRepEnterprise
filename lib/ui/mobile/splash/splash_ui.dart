import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';

class SplashUI extends StatelessWidget {
  const SplashUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/logo.png"),
          ),

          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2.5,
          ),

        ],
      ),
    );
  }
}
