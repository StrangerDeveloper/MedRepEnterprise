import 'package:flutter/cupertino.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';


class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No Data Found!",
        style: headline5.copyWith(color: dark),
      ),
    );
  }
}
