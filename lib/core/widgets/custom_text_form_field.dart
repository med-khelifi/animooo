import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.isPassword,
    required this.hint,
    this.label,
    this.obscuringCharacter,
    this.validator,
    this.onChange,
    this.controller,
    this.keyboardType,
  });
  final bool? isPassword;
  final String? label;
  final String hint;
  final String? obscuringCharacter;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          CustomText(
            text: widget.label!,
            color: AppColors.secondary,
            fontSize: AppFontSize.f18,
            fontFamily: AppFonts.poppins,
          ),
        Gap(widget.label == null ? AppHeight.h0 : AppHeight.h6),
        TextFormField(
          validator: widget.validator,
          onChanged: widget.onChange,
          controller: widget.controller,
          obscureText: !isVisible,
          obscuringCharacter: widget.obscuringCharacter ?? '*',
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            suffixIcon: widget.isPassword == true
                ? InkWell(
                    onTap: () => setState(() => isVisible = !isVisible),
                    child: Icon(
                      isVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                      color: AppColors.textHint,
                    ),
                  )
                : null,
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
            fillColor: AppColors.lightGrey,
            filled: true,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
              borderSide: BorderSide(color: AppColors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
            ),
          ),
        ),
      ],
    );
  }
}
