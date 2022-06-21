// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import './tabbarview/tabbarview1.dart' as first;
import './tabbarview/tabbarview2.dart' as second;
import './tabbarview/tabbarview3.dart' as third;

void main() {
  runApp(const MyApp()); // entry point
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
    color: Color.fromRGBO(70, 132, 153, 1),
  );

  TabController? controller;

  @override
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      title: 'Flutter First App',
      home: Scaffold(
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
                    onPressed: () => print("Open menu"),
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
              first.TabBarView1(),
              second.TabBarView2(),
              third.TabBarView3(),
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
      ),
    );
  }
}
