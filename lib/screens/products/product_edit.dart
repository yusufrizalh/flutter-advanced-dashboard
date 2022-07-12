// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../../base_url.dart';
import '../../models/products_model.dart';
import '../../forms/form_page.dart';
import 'package:http/http.dart' as http;

class ProductEdit extends StatefulWidget {
  final ProductsModel productsModel;

  ProductEdit({required this.productsModel});

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  // text style
  static const TextStyle appBarStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle editProductFormStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final formKey = GlobalKey<FormState>();

  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

  Future updateProduct() async {
    final url = "${BaseUrl.BASE_URL}/models/products/product_update.php";
    return await http.post(
      Uri.parse(url),
      body: {
        "product_id": widget.productsModel.product_id.toString(),
        "product_name": productNameCtrl.text,
        "product_price": productPriceCtrl.text,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    productNameCtrl = TextEditingController(
        text: widget.productsModel.product_name.toString());
    productPriceCtrl = TextEditingController(
        text: widget.productsModel.product_price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Edit Product ID: ${widget.productsModel.product_id.toString()}",
            style: appBarStyle),
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
              onUpdateProduct(context);
            }
          },
          child: const Text('UPDATE', style: editProductFormStyle),
        ),
      ),
    );
  }

  void onUpdateProduct(context) async {
    await updateProduct();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
