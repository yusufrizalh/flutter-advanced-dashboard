import 'package:flutter/material.dart';

class TabBarView3 extends StatelessWidget {
  const TabBarView3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Tab bar view 3"),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[Text("Tab bar view 3")],
        ),
      ),
    );
  }
}
