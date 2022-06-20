import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authDecoration(
          {Color colorBorder = Colors.deepPurple,
          Color colorLabel = Colors.grey,
          IconData? icon,
          required String hint,
          required String label}) =>
      InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorBorder),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorBorder, width: 2),
          ),
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(color: colorLabel),
          prefixIcon: icon != null ? Icon(icon, color: colorBorder) : null);
}
