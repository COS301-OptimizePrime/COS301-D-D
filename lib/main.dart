import 'package:dnd_301_final/home_page.dart';
import 'package:dnd_301_final/login_page.dart';
import 'package:dnd_301_final/monster_journal.dart';
import 'package:flutter/material.dart';



void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => new LoginPage(),
    HomePage.tag: (context) => new HomePage(),
    MonsterJournal.tag: (context) => new MonsterJournal()
//    SignUpPage.tsg: (context) => new SignUpPage();
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '301 DnD Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        accentColor: Colors.deepOrange,
        textSelectionHandleColor: Colors.white,
        fontFamily: 'Nunito',
      ),
      home: new LoginPage(),
      routes: routes,
    );
  }
}
