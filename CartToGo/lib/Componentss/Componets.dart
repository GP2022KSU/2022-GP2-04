import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//test
Widget defaultFormField({
  @required TextEditingController? controller,
  @required TextInputType? type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isClickable = true,
  bool isPassword = false,
  required Function? validate,
  required String? label,
  IconData? suffix,
  Function? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: 20.0,
        ),
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
