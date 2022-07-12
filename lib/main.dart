// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_firstapp/screens/location_page.dart';
import 'screens/products/product_page.dart';
import './tabbarview/tabbarview1.dart' as home;
import './tabbarview/tabbarview2.dart' as gallery;
import './tabbarview/tabbarview3.dart' as account;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.red),
    title: 'Flutter First App',
    home: const MyApp(), // stateful
  )); // entry point
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle letterStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(70, 132, 153, 1),
  );

  TabController? controller; // nullable

  @override
  // initState adalah fungsi utk inisialisasi nilai awal
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: getListView(context)),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              snap: true,
              pinned: true,
              backgroundColor: const Color.fromRGBO(70, 132, 153, 1),
              leading: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu)),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => print("Open search"),
                ),
              ],
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Custom Appbar'),
                background: Image(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/02/02/11/09/office-620822_960_720.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: controller,
          children: const <Widget>[
            home.TabBarView1(),
            gallery.TabBarView2(),
            account.TabBarView3(),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: const Color.fromRGBO(70, 132, 153, 1),
        child: TabBar(
          controller: controller,
          tabs: const <Tab>[
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.photo)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }

  // buat widget getListView()
  Widget getListView(BuildContext context) {
    var listView = ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        myCustomDrawerHeader(),
        const Divider(),
        ListTile(
          title: const Text('Home', style: letterStyle),
          leading: const Icon(Icons.home),
          onTap: () => print('Homepage is opened'),
        ),
        ListTile(
          title: const Text('Products', style: letterStyle),
          leading: const Icon(Icons.shopify),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(),
              ),
            );
            print("Membuka ProductPage");
          },
        ),
        ListTile(
          title: const Text('Account', style: letterStyle),
          leading: const Icon(Icons.person),
          onTap: () => print('Accountpage is opened'),
        ),
        ListTile(
          title: const Text('Open Maps', style: letterStyle),
          leading: const Icon(Icons.location_city),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPage(),
              ),
            );
          },
        ),
      ],
    );
    return listView;
  }

  // buat widget myCustomDrawerHeader
  Widget myCustomDrawerHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://images.pexels.com/photos/3473569/pexels-photo-3473569.jpeg'),
            fit: BoxFit.fill),
      ),
      child: Stack(
        children: const <Widget>[
          Positioned(
            left: 20,
            bottom: 90,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/1759531/pexels-photo-1759531.jpeg'),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 30,
            child: Text(
              "Custom Header Drawer",
              style: titleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
