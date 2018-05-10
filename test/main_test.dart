import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_301_final/main.dart';
import 'package:dnd_301_final/menu.dart';
import 'package:dnd_301_final/login_page.dart';
import 'package:dnd_301_final/home_page.dart';
import 'package:dnd_301_final/character_selection.dart';
import 'package:dnd_301_final/monster_journal.dart';

void testMonsterJournalLoad(WidgetTester tester) {

}

main() {
  // Tests Home Page
  testWidgets('Home Page Test', (WidgetTester tester) async {
    final String flava_text = 'The many worlds of Dungeons & Dragons are places of magic and monsters, of brave warriors and spectacular adventures. '
        'They begin with a foundation of medieval fantasy and '
        'then add the creatures, places, and magic that make these worlds unique.';

    // set up environment
    await tester.pumpWidget(new MaterialApp(
      home: new HomePage()
    ));

    // check if page is loaded correctly
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.byType(Hero), findsOneWidget);
    expect(find.text(flava_text), findsOneWidget);
    expect(find.text('Join Game Session'), findsOneWidget);
    expect(find.text('Create Game Session'), findsOneWidget);
  });

  // Tests Character Selection Page
  testWidgets('Character Selection Page Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new CharacterSelection()
    ));

    // check if page is loaded correctly
    expect(find.text('Character Selection'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(Text), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  // Tests Monster Journal Page
  testWidgets('Monster Journal Page Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new MonsterJournal()
    ));

    expect(find.text('Monster Journal'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(Text), findsWidgets);

    await tester.tap(find.byType(SafeArea).first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Text), findsNWidgets(4));
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
  });

  // Tests Login Page opens
  testWidgets('Login Page Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(
        new MaterialApp(
          home: new LoginPage()
        )
    );

    // check if page is loaded correctly
    expect(find.byType(Hero), findsOneWidget);
    expect(find.text('spongebob@cos123.com'), findsOneWidget);
    expect(find.text('qwerty'), findsOneWidget);
    expect(find.text('Enter World!'), findsOneWidget);
    expect(find.text('Google Sign In!'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    await tester.tap(find.text('Enter World!'));
    await tester.pump();
    await tester.pump(const Duration(seconds:1));

    //expect(find.text('Logging you in...'), findsOneWidget);
  });


  // Tests Menu Drawer when it is open and closed
  testWidgets('Menu Drawer Open/Closed Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(
        new MaterialApp(
            home: new Scaffold(
                drawer: new Menu()
            )
        )
    );

    // not open
    expect(find.text('D&D Game State Manager'), findsNothing);
    expect(find.text('Home Page'), findsNothing);
    expect(find.text('Character Selection'), findsNothing);
    expect(find.text('Monster Journal'), findsNothing);
    expect(find.text('Sign Out'), findsNothing);

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));

    state.openDrawer();
    await tester.pump();

    // open
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('D&D Game State Manager'), findsOneWidget);
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.text('Character Selection'), findsOneWidget);
    expect(find.text('Monster Journal'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  // Tests Menu Navigation
  testWidgets('Menu Navigation Test', (WidgetTester tester) async {
    final routes = <String, WidgetBuilder>{
      LoginPage.tag: (context) => new LoginPage(),
      HomePage.tag: (context) => new HomePage(),
      MonsterJournal.tag: (context) => new MonsterJournal(),
      CharacterSelection.tag: (context) => new CharacterSelection()
    };

    // set up environment
    await tester.pumpWidget(
        new MaterialApp(
            home: new Scaffold(
              drawer: new Menu(),
              body: new Text('Start'),
            ),
            routes: routes
        )
    );

    expect(find.text('Start'), findsOneWidget);

    // Home page
    ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    Finder tile = find.byKey(new Key("menu_home_page_tile"));
    expect(tile, findsOneWidget);
    await tester.tap(tile);

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final String flava_text = 'The many worlds of Dungeons & Dragons are places of magic and monsters, of brave warriors and spectacular adventures. '
        'They begin with a foundation of medieval fantasy and '
        'then add the creatures, places, and magic that make these worlds unique.';

    // check if page is loaded correctly
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.byType(Hero), findsOneWidget);
    expect(find.text(flava_text), findsOneWidget);
    expect(find.text('Join Game Session'), findsOneWidget);
    expect(find.text('Create Game Session'), findsOneWidget);

    // Character Selection
    state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    tile = find.byKey(new Key("character_selection_page_tile"));
    expect(tile, findsOneWidget);
    await tester.tap(tile);

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // check if page is loaded correctly
    expect(find.text('Character Selection'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(Text), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Monster Journal
    state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    tile = find.byKey(new Key("monster_journal_page_tile"));
    expect(tile, findsOneWidget);
    await tester.tap(tile);

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // check if page is loaded correctly
    expect(find.text('Monster Journal'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(find.byType(Image), findsWidgets);
    expect(find.byType(Text), findsWidgets);
  });

  // Tests if app opens
  testWidgets('Open App', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MyApp());

    // check if page is loaded correctly
    expect(find.byType(Hero), findsOneWidget);
    expect(find.text('spongebob@cos123.com'), findsOneWidget);
    expect(find.text('qwerty'), findsOneWidget);
    expect(find.text('Enter World!'), findsOneWidget);
    expect(find.text('Google Sign In!'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
