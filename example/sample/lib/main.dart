import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynavbar/mynavbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      bottomNavigationBar: ZNavbar(
        indexCallback: (int i) {
          print("CURRENT INDEX : $i");
        },
        backgroundColor: Colors.grey.shade900,
        inactiveColor: Colors.white.withOpacity(.5),
        indicatorSize: 4,
        indicatorColor: const Color(0xFFF09000),
        activeColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        tabs: [
          ZTabIcon(
            text: "Home",
            icon: const Icon(CupertinoIcons.home),
          ),
          // Tab(
          //   text: "Home",
          //   icon: Icon(CupertinoIcons.home),

          // ),
          ZTabIcon(
            text: "Live TV",
            icon: Icon(CupertinoIcons.tv),
          ),
          // ZTabIcon(
          //   text: "Movies",
          //   icon: Icon(
          //     CupertinoIcons.videocam_fill,
          //   ),
          // ),
          // ZTabIcon(
          //   text: "Series",
          //   icon: Icon(CupertinoIcons.film_fill),
          // ),
          // ZTabIcon(
          //   text: "Favorites",
          //   icon: Icon(CupertinoIcons.heart_fill),
          // ),
        ],
      ),
    );
  }
}
