import 'package:dnd_301_final/menu.dart';

import 'package:firebase_auth/firebase_auth.dart';
// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Monster {
  const Monster({
    this.assetName,
    this.title,
    this.description,
  });

  final String assetName;
  final String title;
  final String description;

  bool get isValid => assetName != null && title != null && description != null;
}

final List<Monster> monsters = <Monster>[
  const Monster(
    assetName: 'assets/monster_images/beholder.jpg',
    title: 'Beholder',
    description: 'One glance at a beholder is enough to assess its foul and otherworldly nature.'
      ' A beholder’s spheroid body is covered in chitinous plates,'
      'scales, or leathery flesh.',
  ),
  const Monster(
    assetName: 'assets/monster_images/fire_giant.jpg',
    title: 'Fire Giant',
    description: 'Master crafters and organized warriors, '
        'fire giants dwell among volcanoes, lava floes, and rocky mountains. '
        'They are ruthless militaristic brutes whose mastery of metalwork is legendary.',
  ),
  const Monster(
    assetName: 'assets/monster_images/dragon.png',
    title: 'Dragon',
    description: 'True dragons are known and feared for their predatory cunning and their magic, '
        'with the oldest dragons accounted as some of the most powerful creatures in the world. ',
  ),
  const Monster(
    assetName: 'assets/monster_images/yuan-ti.jpg',
    title: 'Yuan Ti',
    description: 'Devious serpent folk devoid of compassion, yuan-ti manipulate other creatures '
        'by arousing their doubts, evoking their fears, and elevating and crushing their hopes. ',
  )
];

//This is the monster card class - aka the Cards
class MonsterItem extends StatelessWidget {
  MonsterItem({ Key key, @required this.mon })
      : assert(mon != null && mon.isValid), //if it receives a null monster object to populate the card, fatal error
        super(key: key);

  static const double height = 187.0; // original value was 366.0
  final Monster mon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);//copy theme data from parent
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.white);//make our title text look nice
    final TextStyle descriptionStyle = theme.textTheme.subhead; //give our description a matching style

    //a box that is of explicit size
    SizedBox photoAndTitle = new SizedBox(
      height: 92.0, // 184.0 is original height
      child: new Stack(//stacks allow us to place widgets on top of each other
        children: <Widget>[
          new Positioned.fill(//add image to bottom of stack
            child: new Image.asset(
              mon.assetName,
              fit: BoxFit.cover,//fit image to box
              alignment: Alignment.topCenter,
            ),
          ),
          new Positioned(//positioned widgets can be moved within their parent (aka stack)
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: new FittedBox(//new box, fitted to remaining space
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,//place box left
              child: new Text(mon.title,  //place a Text widget inside - aka our title - which is above our image on the stack
                style: titleStyle,
              ),
            ),
          ),
        ],
      ),
    );

    // description
    Expanded description = new Expanded(
      child: new Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0), //padding from Left Top Right Bottom
        child: new DefaultTextStyle( //text widget to pass a text styling down
          softWrap: false,
          overflow: TextOverflow.ellipsis,//when text is too much for a container it should elipse (...)
          style: descriptionStyle,
          child: new SizedBox.expand(  //add a column to allow our text to aign on x(horizontal) axis
              child: new Text(mon.description, //our text widget with our description
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis //overflow
              ),
          ),
        ),
      ),
    );

    Card card = new Card(child: new Column(
      //move to crossaxis (aka horizontal as we are vertical)'s start (left)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        photoAndTitle,
        description
      ]
    ));

    // A detailed view of the monster that is called when a monster card is tapped
    ListView detailedView = new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          new SizedBox( //holds our image
              height: 184.0,
              child: new Stack( //this stack is redundant - was originally to place text name over image
                  children: <Widget>[
                    new Positioned.fill(
                        child: new Image.asset(
                          mon.assetName,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )
                    )
                  ]
              )
          ),
          new Row( //allows us to place items consecutively on the horizontal
            children: <Widget>[
              new Padding(  //padding on top and bottom to space from image box and description
                padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                child: new Text(mon.title,  //text box with name
                  style: titleStyle,
                  textAlign: TextAlign.center,),//aligned left of row
              ),
              const SizedBox(), //all rows must contain the same amount of columns
              //so we use a 'blank' widget to fill holes in our 'table'
            ],
          ),
          new Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
              child: new Container(
                key: key,
                child: new Text(mon.description, style: descriptionStyle),//our description
              )
          ),
          new Table(  //this table was to be used to hold the stats of the monster
              columnWidths: const <int, TableColumnWidth>{
                0: const FlexColumnWidth(1.0) //this means to resize children to fit all (1.0/1.0) available space
              },
              children: <TableRow>[ //a collection of rows in out stats table
                new TableRow( //only one for now - didnt add stats examples
                    children: <Widget>[
                      new Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 4.0),
                          //our stats text - styled to be blue and bold
                          child: new Text('Stats', style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, height: 24.0/15.0))
                      ),
                      const SizedBox(),//agian keep columns in each row the same
                    ]
                ),
              ]
          ),
        ]
    );

    return new SafeArea(
        top: false,
        bottom: false,
        // Allow user to tap card
        child: new GestureDetector(
            onTap: () {Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  //build a new widget
                  return new Scaffold( //new scaffold
                      appBar: new AppBar(
                        title: const Text('Monster Journal Entry'), //title of view
                      ),
                      body: detailedView
                  );
                }
            ));},
            child: new Container(
                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                height: height,
                child: card
            )
        )
    );
  }
}

//main build function of our Monster Journal Page
//all 'build' functions are called when fast reload is used
//responisble for populating our page with Cards
class MonsterJournal extends StatelessWidget {
  static const String routeName = '/material/cards';//honestly i've removed this and it didnt do anyhting - lit no idea what it does

  static String tag = 'monster-journal';

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
          drawer: new Menu(),
          appBar: new AppBar( //AppBars are the bars on top of the view
            title: const Text('Monster Journal'),
            actions: <Widget>[
          new Padding(
          padding: new EdgeInsets.symmetric(vertical: 16.0),
        child: new Material(
          borderRadius: new BorderRadius.circular(30.0),
          elevation: 5.0,
          child: new MaterialButton(
            minWidth: 100.0,
            height: 42.0,
            onPressed: () async {
              GoogleSignIn _googleSignIn = new GoogleSignIn();
              FirebaseAuth.instance.signOut();
              await _googleSignIn.signOut();
              Navigator.popUntil(context,ModalRoute.withName('/'));
            },
            color: Colors.deepOrange,
            child: new Text('Sign Out!', style: new TextStyle(color: Colors.white)),
          ),
        ),
      ),
            ],
          ),
          //this holds our 'Card's
          //it's a listview widget that 'lists'
          //widgets below each other.
          body: new ListView(
              itemExtent: MonsterItem.height,
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),//adds padding between cards and screen
              children: monsters.map((Monster mon) {  //this goes through all our monsters and makes a card for each
                return new Container(       //this is our 'card'
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: new MonsterItem(mon: mon)  //give our card a monster to use
                );
              }).toList()
          ),
    );
  }
}