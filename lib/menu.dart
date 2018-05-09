import 'package:dnd_301_final/character_selection.dart';
import 'package:flutter/material.dart';
import 'package:dnd_301_final/monster_journal.dart';
import 'package:dnd_301_final/home_page.dart';
import 'package:dnd_301_final/app_data.dart';

class Menu extends StatelessWidget {
  AppData appData = AppData.instance();

  @override
  Widget build(BuildContext context) {

    Widget displayImage;

    if(appData.user_google_image!=null)
      displayImage = new SizedBox(
        height: 108.0,
        width: 108.0,
        child: appData.user_google_image,
      );
    else
      displayImage = new Hero(
            tag: 'profile_pic',
            child: new CircleAvatar(
                radius: 54.0,
                backgroundImage: new AssetImage('assets/placeholder.jpg'),
            )
        );


    return new Drawer(
            child: new ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                new DrawerHeader(
                  child: new SizedBox.expand(
                      child: new Column(
                        children: <Widget>[
                          new Text('D&D Game State Manager'),
                          displayImage,
                        ],
                      )
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.deepOrange,
                  ),
                ),
                new ListTile(
                  title: new Text('Home Page'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(HomePage.tag);
                  },
                ),
                new ListTile(
                  title: new Text('Character Selection'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    Navigator.pop(context);
                    Navigator.pushNamed(context, CharacterSelection.tag);
                  },
                ),
                new ListTile(
                  title: new Text('Monster Journal'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    Navigator.pop(context);
                    Navigator.pushNamed(context, MonsterJournal.tag);
                  },
                ),
                const Divider(),
                new ListTile(
                  title: new Text('Sign Out'),
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    await appData.signout();
                    Navigator.pop(context);
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                )
              ],
            )
        );








  }
}