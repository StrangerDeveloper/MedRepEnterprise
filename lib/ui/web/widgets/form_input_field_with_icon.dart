import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';

class FormInputFieldWithIcon extends StatelessWidget {
  const FormInputFieldWithIcon(
      {Key? key,
      required this.controller,
      required this.iconPrefix,
      required this.labelText,
      this.suffix,
      this.iconColor,
      this.textStyle,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.minLines = 1,
      this.maxLines = 1,
      this.isExpanded = false,
      this.maxLength,
      this.hint,
      this.autofocus = false,
      this.textCapitalization = TextCapitalization.none,
      this.maxLengthEnforcement,
      required this.onChanged,
      required this.onSaved})
      : super(key: key);

  final TextEditingController controller;
  final IconData iconPrefix;
  final String? labelText, hint;
  final bool? autofocus;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int minLines;
  final int? maxLines;
  final bool? isExpanded;
  final Color? iconColor;
  final TextStyle? textStyle;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextCapitalization? textCapitalization;
  final void Function(String) onChanged;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus!,
      textCapitalization: textCapitalization!,
      textAlignVertical: TextAlignVertical.top,
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      decoration: InputDecoration(
        filled: false,
        suffix: suffix,
        hintText: hint,
        prefixIcon: Icon(
          iconPrefix,
          color: iconColor ?? active!,
        ),
        labelText: labelText,
        labelStyle: textStyle ?? bodyText1,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: iconColor ?? active!,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: iconColor ?? active!, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      controller: controller,
      cursorColor: iconColor,
      style: textStyle ?? bodyText1,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      expands: isExpanded!,
      maxLines: isExpanded! ? null : maxLines,
      minLines: isExpanded! ? null : minLines,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLength: maxLength,
      validator: validator,
    );
  }
}
