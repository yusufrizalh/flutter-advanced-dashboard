// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_firstapp/base_url.dart';
import '../../models/products_model.dart';
import 'product_edit.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final ProductsModel productsModel;

  ProductDetail({required this.productsModel});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // text style
  static const TextStyle appBarStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle productDetailStyle = TextStyle(
    fontSize: 16,
    color: Color.fromRGBO(70, 132, 153, 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product ID: ${widget.productsModel.product_id.toString()}",
          style: appBarStyle,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (() => confirmDelete(context)),
            icon: Icon(Icons.delete),
          ),
        ],
        backgroundColor: const Color.fromRGBO(70, 132, 153, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Product name: ${widget.productsModel.product_name.toString()}",
              style: productDetailStyle,
            ),
            Padding(padding: EdgeInsets.all(8)),
            Text(
              "Product price: IDR ${widget.productsModel.product_price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}",
              style: productDetailStyle,
            ),
            Padding(padding: EdgeInsets.all(8)),
            Text(
              "Created at: ${widget.productsModel.created_at.toString()}",
              style: productDetailStyle,
            ),
            Padding(padding: EdgeInsets.all(8)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // membuka form ubah produk
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductEdit(
                productsModel: widget.productsModel,
              ),
            ),
          );
        },
        backgroundColor: Color.fromRGBO(70, 132, 153, 1),
        child: Icon(Icons.edit),
      ),
    );
  }

  // konfirmasi menghapus produk
  void confirmDelete(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure want to delete?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: Icon(Icons.cancel),
            ),
            ElevatedButton(
              onPressed: () => deleteProduct(context),
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Icon(Icons.check),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(context) async {
    final url = "${BaseUrl.BASE_URL}/models/products/products_delete.php";
    await http.post(
      Uri.parse(url),
      body: {
        'product_id': widget.productsModel.product_id.toString(),
      },
    );
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
