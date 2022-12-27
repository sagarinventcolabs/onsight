import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class BaseTypeAhead extends StatefulWidget {
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String) onSuggestionSelected;
  final SuggestionsBoxController? suggestionsBoxController;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLength;
  final TextInputType textInputType;
  final String? labelText,errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? floatingLabelStyle;
  final FutureOr<List<String>> Function(String) suggestionsCallback;
  const BaseTypeAhead({Key? key,this.textInputType = TextInputType.text,this.maxLength = null,required this.onSuggestionSelected,required this.suggestionsCallback,this.errorText,this.floatingLabelStyle, this.inputFormatters,this.labelText,this.onTap,this.suggestionsBoxController,this.controller,this.focusNode,this.onChanged,}) : super(key: key);

  @override
  State<BaseTypeAhead> createState() => _BaseTypeAheadState();
}

class _BaseTypeAheadState extends State<BaseTypeAhead> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: TypeAheadField<String>(
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
        hideOnError: true,
        suggestionsBoxController: widget.suggestionsBoxController,
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.controller,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          keyboardType: widget.textInputType,
          maxLength: widget.maxLength,
          onTap: widget.onTap,
          decoration: InputDecoration(
            labelText: widget.labelText??"",
            labelStyle:  TextStyle(color: Get.isDarkMode?ColourConstants.white: ColourConstants.black54),
            floatingLabelStyle: widget.floatingLabelStyle,
            errorText: widget.errorText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Get.isDarkMode ? ColourConstants.white : ColourConstants.borderGreyColor),
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

          ),
        ),
        suggestionsCallback: widget.suggestionsCallback,
        itemBuilder: (context, String? suggestion) {
          final user = suggestion!;
          return ListTile(
            title: Text(user),
          );
        },
        noItemsFoundBuilder: (context) => SizedBox(
          height: 0,
          child: Center(
            child: Text(
              noJobsFound,
              style: TextStyle(fontSize: Dimensions.font24),
            ),
          ),
        ),
        onSuggestionSelected: widget.onSuggestionSelected,
      ),
    );
  }
}
