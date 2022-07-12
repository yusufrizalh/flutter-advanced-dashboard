// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, must_be_immutable, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // properties
  late TextEditingController productNameCtrl;
  late TextEditingController productPriceCtrl;

  // constructor
  FormPage({
    required this.formKey,
    required this.productNameCtrl,
    required this.productPriceCtrl,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // membuat validasi
  String? validateString(String? value) {
    if (value!.length < 8) return 'Product name at least 8 characters!';
    return null;
  }

  String? validateNumber(String? value) {
    Pattern pattern = r'(?<=\s|^)\d+(?=\s|$)';
    RegExp regExp = RegExp(pattern.toString());
    if (!regExp.hasMatch(value!)) return 'Product price must be number!';
    return null;
  }

  static const TextStyle textFormFieldStyle = TextStyle(
    fontSize: 24,
    color: Color.fromRGBO(70, 132, 153, 1),
  );

  // formatted productPrice
  String formattedPrice(String price) {
    return NumberFormat.decimalPattern().format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: widget.productNameCtrl,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(labelText: 'Enter product name'),
            style: textFormFieldStyle,
            validator: validateString,
          ),
          const Padding(padding: EdgeInsets.all(8)),
          TextFormField(
            controller: widget.productPriceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter product price'),
            style: textFormFieldStyle,
            onChanged: (number) {
              number = '${formattedPrice(
                number.replaceAll(',', ''),
              )}';
              widget.productPriceCtrl.value = TextEditingValue(
                  text: number,
                  selection: TextSelection.collapsed(
                    offset: number.length,
                  ));
            },
            // validator: validateNumber,
          ),
          const Padding(padding: EdgeInsets.all(8)),
        ],
      ),
    );
  }
}
