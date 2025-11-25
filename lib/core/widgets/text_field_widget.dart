import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final bool isPassword;
  final bool revealPassword;
  final String textFieldlabel;
  final String? errorText;
  final Function onChangedFn;
  final Function? onTapFn;
  final Function? onRevealPasswordFn;
  final int? maxLines;
  final bool readOnly;
  final TextEditingController? controller;
  final String? textFieldHint;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  const TextFieldWidget({
    super.key,
    required this.textFieldlabel,
    this.errorText,
    this.isPassword = false,
    this.revealPassword = false,
    required this.onChangedFn,
    this.onRevealPasswordFn,
    this.inputFormatters,
    this.maxLines,
    this.onTapFn,
    this.readOnly = false,
    this.controller,
    this.textFieldHint,
    this.focusNode,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      maxLines: maxLines ?? 1,
      onTap: () => onTapFn?.call(),
      onChanged: (value) {
        onChangedFn(value);
      },
      readOnly: readOnly,
      controller: controller,
      obscureText: isPassword && !revealPassword,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        errorText: errorText,
        labelText: textFieldlabel,
        hintText: textFieldHint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(revealPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () {
                  onRevealPasswordFn!();
                },
                color: Colors.black.withOpacity(0.4),
                iconSize: 22.sp,
              )
            : null,
      ),
    );
  }
}
