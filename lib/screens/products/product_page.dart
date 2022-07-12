// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:paginable/paginable.dart';
import './product_detail.dart';
import '../../base_url.dart';
import '../../models/products_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

import 'product_create.dart';

class ProductPage extends StatefulWidget {
  // ProductPage({required this.productsModel});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

// Widget utk otomatisasi ketika teks pencarian diketik
class Debouncer {
  int? millisconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class _ProductPageState extends State<ProductPage> {
  late final ProductsModel productsModel;

  // text style
  static const TextStyle appBarStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle productNameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(70, 132, 153, 1),
  );

  static const TextStyle productPriceStyle = TextStyle(
    fontSize: 14,
    color: Color.fromRGBO(70, 132, 153, 1),
  );

  final _debouncer = Debouncer();

  List<ProductsModel> prodList = []; // menyimpan hasil dari pencarian
  List<ProductsModel> productList = []; // datanya masih kosong

  String url = "${BaseUrl.BASE_URL}/models/products/products_list.php";

  Future<List<ProductsModel>> getProductsList() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // mengambil data per 5 records
      // List<ProductsModel> tempProducts = [];
      List<ProductsModel> products = parseJson(response.body);
      // int next = 1;
      // for (int p = 0; p < 5; p++) {
      //   tempProducts.add(products[p]);
      // }
      // // batas akhir = 5 + next = 6
      // productList.addAll(tempProducts);
      // products = productList;
      return products;
    } else {
      throw Exception("Error while getting products...");
    }
  }

  static List<ProductsModel> parseJson(String responseBody) {
    final parsedJson =
        convert.json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsedJson
        .map<ProductsModel>((json) => ProductsModel.fromJson(json))
        .toList();
  }

  // ketika ProductPage terbuka, maka otomatis initState dijalankan
  @override
  void initState() {
    super.initState();
    getProductsList().then(
      (objectProducts) {
        setState(() {
          prodList = objectProducts;
          productList = prodList;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Page',
          style: appBarStyle,
        ),
        backgroundColor: const Color.fromRGBO(70, 132, 153, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search product name",
                  suffixIcon: InkWell(
                    child: Icon(Icons.search),
                  ),
                ),
                onChanged: (keyword) {
                  _debouncer.run(
                    () {
                      setState(
                        () {
                          productList = prodList
                              .where(
                                (productSearched) => (productSearched
                                    .product_name
                                    .toLowerCase()
                                    .contains(
                                      keyword.toLowerCase(),
                                    )),
                              )
                              .toList();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: PaginableListView.builder(
                loadMore: () async {
                  // await getProductsList();
                  // if (mounted) {
                  //   setState(() {});
                  // }
                },
                progressIndicatorWidget: const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorIndicatorWidget: (exception, tryAgain) => Container(
                  color: Colors.redAccent,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exception.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: tryAgain,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext context, int position) {
                  if (productList.isEmpty) {
                    return const CircularProgressIndicator();
                  } else {
                    return Dismissible(
                      confirmDismiss: (direction) =>
                          confirmSwipeToDelete(direction),
                      key: Key(productList[position].toString()),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.list),
                                title: Text(
                                  productList[position].product_name.toString(),
                                  style: productNameStyle,
                                ),
                                subtitle: Text(
                                  "IDR ${productList[position].product_price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}",
                                  style: productPriceStyle,
                                ),
                                onTap: () {
                                  // membuka detail produk
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetail(
                                        productsModel: productList[position],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                itemCount: productList.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // membuka form tambah produk baru
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductCreate(),
            ),
          );
        },
        backgroundColor: Color.fromRGBO(70, 132, 153, 1),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<bool> confirmSwipeToDelete(DismissDirection direction) async {
    String action;
    if (direction == DismissDirection.endToStart) {
      action = "delete";
      print(action.toString());
    } else {
      action = "another";
      print(action.toString());
    }

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure want to delete?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: Icon(Icons.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                // deleteProduct(context)
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Icon(Icons.check),
            ),
          ],
        );
      },
    );
  }
}
