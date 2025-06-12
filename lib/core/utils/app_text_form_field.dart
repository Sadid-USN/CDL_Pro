import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  final String hint;
  final String? placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validate;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType textInputType;
  final Widget? suffix;
  final Widget? prefix;
  final int? minLines;
  final bool checkForNullEmpty;
  final bool readonly;
  final bool enabled;
  final String? errorText;
  final void Function()? onTap;
  final InputDecoration? inputDecoration;
  final void Function(String text)? onChanged;
  final void Function()? onEditingComplete;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final double? fontSize;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final double? borderRadius;
  final int? maxLength;
  final Color? fillColor;

  const AppTextFormField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.checkForNullEmpty = false,
    this.readonly = false,
    this.enabled = true,
    this.textAlign = TextAlign.left,
    this.textInputAction = TextInputAction.done,
    this.fontSize,
    this.focusNode,
    this.onFieldSubmitted,
    this.minLines,
    this.onEditingComplete,
    this.onTap,
    this.placeholder,
    this.validate,
    this.inputFormatters,
    this.suffix,
    this.prefix,
    this.errorText,
    this.inputDecoration,
    this.onChanged,
    this.textStyle,
    this.hintStyle,
    this.borderRadius,
    this.maxLength,
    this.fillColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textFieldInputFormatters = [
      NoLeadingSpaceFormatter(),
      ...?inputFormatters,
    ];

    final List<TextInputFormatter> textInputFormatters = textInputType ==
            TextInputType.number
        ? [FilteringTextInputFormatter.digitsOnly, ...textFieldInputFormatters]
        : textFieldInputFormatters;

    return TextFormField(
      style: textStyle,
      focusNode: focusNode,
      textAlign: textAlign,
      enabled: enabled,
      onTap: onTap,
      controller: controller,
      readOnly: readonly,
      obscureText: obscureText,
      keyboardType: textInputType,
      minLines: minLines,
      maxLines: minLines != null ? null : 1,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      maxLength: maxLength,
      decoration: inputDecoration ??
          InputDecoration(

            // filled: true,
             fillColor: fillColor ?? AppColors.greyshade400,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? 10.r,
              ),
            ),
            labelStyle: AppTextStyles.manrope14,
            hintStyle: hintStyle ??
                AppTextStyles.manrope14,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? 10.r,
              ),
              borderSide: BorderSide(
                color: AppColors.greyshade400,
              ),
            ),

            // focusColor: Colors.yellow,
            // fillColor: Colors.white,
            // labelText: label,
            // labelStyle: const TextStyle(color: Colors.black),
            // floatingLabelStyle: TextStyle(color: Colors.white),
            suffixIcon: suffix,
            prefixIcon: prefix,
            hintText: hint,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 10.h,
            ),
          ),
      inputFormatters: textInputFormatters,
      validator: (value) {
        if (checkForNullEmpty && (value == null || value.isEmpty)) {
          return errorText ?? "fillEmptyField";
        }

        return validate?.call(value);
      },
    );
  }
}
