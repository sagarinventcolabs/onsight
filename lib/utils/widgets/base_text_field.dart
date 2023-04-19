
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';

class BaseTextField extends StatefulWidget {
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final SuggestionsBoxController? suggestionsBoxController;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLength;
  final TextInputType keyboardType;
  final String? labelText,errorText;
  final Widget? label;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? floatingLabelStyle;
  const BaseTextField({Key? key,this.label,this.keyboardType = TextInputType.text,this.maxLength = null,this.errorText,this.floatingLabelStyle, this.inputFormatters,this.labelText,this.onTap,this.suggestionsBoxController,this.controller,this.focusNode,this.onChanged,}) : super(key: key);

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.height20,right: Dimensions.height20, top: Dimensions.height5, bottom: Dimensions.height5),
      child: TextField(
        controller: widget.controller,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textInputAction: TextInputAction.next,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          counterStyle: TextStyle(fontSize: 0),
          label: widget.label,
          isDense: true,
          floatingLabelStyle: widget.floatingLabelStyle,
          errorText: widget.errorText,
          labelStyle: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black54),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: ColourConstants.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: ColourConstants.primary),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: ColourConstants.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: ColourConstants.red),
          ),
        ),
      ),
    );
  }
}
