import 'package:email_password_signup/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.validator,
    required this.controller,
    required this.onChange,
    required this.icon,
    this.textInputAction = TextInputAction.next,
    required this.textInputType,
  }) : super(key: key);

  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final ValueSetter<String> onChange;
  final FormFieldValidator<String>? validator;
  final IconData icon;
  final TextInputAction textInputAction;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 15,
        //     fontWeight: FontWeight.w400,
        //     color: Colors.redAccent,
        //   ),
        // ),
        const SizedBox(height: 5),
        TextFormField(
          textInputAction: textInputAction,
          onChanged: onChange,
          controller: controller,
          obscureText: obscureText,
          decoration: kTextFormFieldDec.copyWith(
              prefixIcon: Icon(icon), hintText: label),
          validator: validator,
          keyboardType: textInputType,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
