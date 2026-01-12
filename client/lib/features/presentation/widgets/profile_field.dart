import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/common/utils/validation_utils.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
          color: AppColor.placeholderBg,
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 15,
        ),
        keyboardType: keyboardType,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your ${label.toLowerCase()}";
          }

          if (label.toLowerCase() == "email" &&
              !ValidationUtils.isValidEmail(value)) {
            return "Please enter a valid ${label.toLowerCase()}";
          }

          if (label.toLowerCase() == "phone number" &&
              !ValidationUtils.isValidPhone(value)) {
            return "Please enter a valid ${label.toLowerCase()}";
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
      ),
    );
  }
}
