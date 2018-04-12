import 'package:flutter/material.dart';
import 'package:dnd_301_final/monster_journal.dart';
import 'package:dnd_301_final/home_page.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: new Text('DND Game State Manager'),
                decoration: new BoxDecoration(
                  color: Colors.deepOrange,
                ),
            ),
            new ListTile(
              title: new Text('Home Page'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new HomePage()),);
              },
            ),
            new ListTile(
              title: new Text('Monster Journal'),
              onTap: () {
               // Update the state of the app
               // ...
                Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new MonsterJournal()),);
              },
            ),
          ],
        )
    );
  }
}