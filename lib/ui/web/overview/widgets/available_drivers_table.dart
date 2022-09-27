
import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';


/// Example without datasource
class AvailableDriversTable extends StatelessWidget {
  const AvailableDriversTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active!.withOpacity(.4), width: .5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGrey!.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
             const SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Available Drivers",
                color: lightGrey!,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
