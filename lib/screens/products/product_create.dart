// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../../base_url.dart';
import '../../forms/form_page.dart';
import 'package:http/http.dart' as http;

class ProductCreate extends StatefulWidget {
  ProductCreate({Key? key}) : super(key: key);

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  // text style
  static const TextStyle appBarStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle createProductFormStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final formKey = GlobalKey<FormState>();

  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

  Future createProduct() async {
    final url = "${BaseUrl.BASE_URL}/models/products/product_create.php";
    return await http.post(
      Uri.parse(url),
      body: {
        "product_name": productNameCtrl.text,
        "product_price": productPriceCtrl.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Create', style: appBarStyle),
        backgroundColor: const Color.fromRGBO(70, 132, 153, 1),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(8),
          child: FormPage(
            formKey: formKey,
            productNameCtrl: productNameCtrl,
            productPriceCtrl: productPriceCtrl,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(70, 132, 153, 1)),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              onCreateProduct(context);
            }
          },
          child: const Text('SAVE', style: createProductFormStyle),
        ),
      ),
    );
  }

  void onCreateProduct(context) async {
    await createProduct();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
