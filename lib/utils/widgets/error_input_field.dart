import 'package:flutter/material.dart';
import 'package:on_sight_application/utils/constants.dart';

class ErrorInputField extends InputDecorationTheme{

  static const InputDecorationTheme errorInputStyle =InputDecorationTheme(
    labelStyle:TextStyle(color: ColourConstants.red),
      floatingLabelStyle: TextStyle(
          color:ColourConstants.red),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: ColourConstants.red),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: ColourConstants.red),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          width: 1, color: ColourConstants.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          width: 1, color: ColourConstants.red),
    ),
  );
}

class CustomInputField extends InputDecorationTheme{

  static const InputDecorationTheme errorInputStyle =InputDecorationTheme(
    labelStyle:TextStyle(color: ColourConstants.white),
    floatingLabelStyle: TextStyle(
        color:ColourConstants.black54),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: ColourConstants.white),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: ColourConstants.primary),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          width: 1, color: ColourConstants.red),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          width: 1, color: ColourConstants.red),
    ),
  );
}