import 'package:dnd_301_final/character/character_creation.dart';
import 'package:dnd_301_final/character/character_selection.dart';
import 'package:dnd_301_final/character/character_preview.dart';
import 'package:dnd_301_final/character/races_and_classes.dart' as RacesAndClasses;
import 'package:dnd_301_final/home_page.dart';
import 'package:dnd_301_final/journals/race_viewer.dart';
import 'package:dnd_301_final/journals/monster_journal_new.dart';
import 'package:dnd_301_final/login_page.dart';
import 'package:dnd_301_final/menu.dart';
import 'package:dnd_301_final/session/lobby_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_301_final/backend/server.pb.dart';

main() {

  // Unit test
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

    // actual login needs android support so it is tested in integration tests

    // test Register button
    await tester.tap(find.text('Register'));
    await tester.pump(const Duration(seconds:1));

    expect(find.text('spongebob@cos123.com'), findsOneWidget);
    expect(find.text('qwerty'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Register New Account'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // actual registration would cause clutter and needs android support

    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(seconds:1));

    expect(find.text('Confirm Password'), findsNothing);
    expect(find.text('Register New Account'), findsNothing);
    expect(find.text('Login'), findsNothing);
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
    expect(find.text('View Races'), findsNothing);
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
    expect(find.text('View Races'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

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

  /// Tests Light Character Widgets
  testWidgets('Light Character Test', (WidgetTester tester) async {
    LightCharacter character = new LightCharacter();
    expect(character.hasName(), false);
    expect(character.hasCharacterClass(), false);
    expect(character.hasCharacterId(), false);
    expect(character.hasCreatorId(), false);
    expect(character.hasGender(), false);
    expect(character.hasHitpoints(), false);
    expect(character.hasRace(), false);

    character.name = "foo";
    character.characterClass = "Barbarian";
    character.race = "Aarakocra";
    character.gender = "Male";
    expect(character.hasName(), true);
    expect(character.hasCharacterClass(), true);
    expect(character.hasRace(), true);
    expect(character.hasGender(), true);
  });

  /// Tests Light Character Widgets
  testWidgets('Character Light View Test', (WidgetTester tester) async {
    LightCharacter character = new LightCharacter();
    character.name = "foo";
    character.characterClass = "Barbarian";
    character.race = "Aarakocra";
    character.gender = "Male";
    
    CharacterLightView characterLightView = new CharacterLightView(
        lightChar: character,
        titleStyle: new TextStyle()
    );

    await tester.pumpWidget(new MaterialApp(
        home: characterLightView
    ));

    expect(find.byType(CharacterLightView), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
  });

  /// Tests Light Character Widgets
  testWidgets('Character Item Test', (WidgetTester tester) async {
    LightCharacter character = new LightCharacter();
    character.name = "foo";
    character.characterClass = "Barbarian";
    character.race = "Aarakocra";
    character.gender = "Male";

    CharacterItem characterItem = new CharacterItem(
        lightChar: character,
    );

    await tester.pumpWidget(new MaterialApp(
        home: characterItem
    ));

    expect(find.byType(CharacterItem), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
  });

  /// Tests Character Selection Page
  testWidgets('Character Selection Page Test', (WidgetTester tester) async {
    // CharacterSelection in real app downloads characters. Mock characters
    // are used for tests
    characters.clear();
    LocalCharacter char = new LocalCharacter(
        title: 'James',
        charClass: RacesAndClasses.typeClasses.elementAt(2),
        charRace: RacesAndClasses.races.elementAt(22),
        charGender: 'Female',
        strength: 6,
        dexterity: 2,
        constitution: 6,
        intelligence: 2,
        wisdom: 2,
        charisma: 2,
        sessionId: ''
    );
    char.equipment = new List<LocalEquipment>();
    char.equipment.add(LocalEquipment("Blocker", "Shield", 2));

    // set up environment
    // Character Selection cannot run on its own
    await tester.pumpWidget(new MaterialApp(
        home: new HomePage()
    ));

    await tester.pumpWidget(new MaterialApp(
        home: new CharacterSelection()
    ));

    // check if page is loaded correctly
    expect(find.text('Character Selection'), findsOneWidget);

    characters.add(char);
    await tester.dragFrom(Offset(88.0, 102.0), Offset(88.0, 202.0));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

//    expect(find.text("James"), findsOneWidget);
//    expect(find.text(RacesAndClasses.typeClasses.elementAt(2).name), findsOneWidget);
//    expect(find.text(RacesAndClasses.races.elementAt(22).name), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Gender Icon Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new GenderIcon.str("Male")
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);

    await tester.pumpWidget(new MaterialApp(
        home: new GenderIcon.str("Female")
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Race Preview Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new RacePreview(race: RacesAndClasses.Race.getRace("Aarakocra"))
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);
    expect(find.text("Aarakocra"), findsOneWidget);
  });

  testWidgets('Class Preview Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new ClassPreview(charClass: RacesAndClasses.ClassType.getClass("Barbarian"))
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);
    expect(find.text("Barbarian"), findsOneWidget);
  });

  testWidgets('Class Icon Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new ClassIcon.str("Barbarian")
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Stat Icons Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new Container(child: Stat.Int(value: 2,hasButtons: false,),),
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);

    await tester.pumpWidget(new MaterialApp(
        home: new Container(child: Stat.Chr(value: 2,hasButtons: false,),),
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);

    await tester.pumpWidget(new MaterialApp(
        home: new Container(child: Stat.Str(value: 2,hasButtons: false,),),
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);

    await tester.pumpWidget(new MaterialApp(
        home: new Container(child: Stat.Wis(value: 2,hasButtons: false,),),
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);

    await tester.pumpWidget(new MaterialApp(
        home: new Container(child: Stat.Dex(value: 2,hasButtons: false,),),
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);

    await tester.pumpWidget(new MaterialApp(
        home: new Container(child: Stat.Con(value: 2,hasButtons: false,),),
    ));

    // check if page loaded correctly
    expect(find.byType(Image), findsOneWidget);
  });

  // Tests Character Details Page
  testWidgets('Character Details Page Test', (WidgetTester tester) async {
    // CharacterSelection in real app downloads characters. Mock characters
    // are used for tests
    characters.clear();
    LocalCharacter char = new LocalCharacter(
        title: 'James',
        charClass: RacesAndClasses.typeClasses.elementAt(2),
        charRace: RacesAndClasses.races.elementAt(22),
        charGender: 'Female',
        strength: 6,
        dexterity: 2,
        constitution: 6,
        intelligence: 2,
        wisdom: 2,
        charisma: 2,
        sessionId: ''
    );
    char.equipment = new List<LocalEquipment>();
    char.equipment.add(LocalEquipment("Blocker", "Shield", 2));

    // set up environment
    // Character Selection cannot run on its own
    await tester.pumpWidget(new MaterialApp(
        home: new HomePage()
    ));

    await tester.pumpWidget(new MaterialApp(
        home: new CharacterDetailsView(char: char)
    ));

    // check if page loaded correctly
    expect(find.text("Character Details"), findsOneWidget);
    expect(find.text("James"), findsOneWidget);
    expect(find.text("Stats: "), findsOneWidget);
    expect(find.text("Int"), findsOneWidget);
    expect(find.text("Dex"), findsOneWidget);
    expect(find.text("Str"), findsOneWidget);
    expect(find.text("Wis"), findsOneWidget);
    expect(find.text("Cha"), findsOneWidget);
    expect(find.text("Con"), findsOneWidget);
  });

  // Tests Character Preview
  testWidgets('Character Preview Test', (WidgetTester tester) async {
    // CharacterSelection in real app downloads characters. Mock characters
    // are used for tests
    characters.clear();
    LocalCharacter char = new LocalCharacter(
        title: 'James',
        charClass: RacesAndClasses.typeClasses.elementAt(2),
        charRace: RacesAndClasses.races.elementAt(22),
        charGender: 'Female',
        strength: 6,
        dexterity: 2,
        constitution: 6,
        intelligence: 2,
        wisdom: 2,
        charisma: 2,
        sessionId: ''
    );
    char.equipment = new List<LocalEquipment>();
    char.equipment.add(LocalEquipment("Blocker", "Shield", 2));

    // set up environment
    // Character Selection cannot run on its own
    await tester.pumpWidget(new MaterialApp(
        home: new HomePage()
    ));

    await tester.pumpWidget(new MaterialApp(
        home: new CharacterPreview(char: char)
    ));

    expect(find.text("Int"), findsOneWidget);
    expect(find.text("Dex"), findsOneWidget);
    expect(find.text("Str"), findsOneWidget);
    expect(find.text("Wis"), findsOneWidget);
    expect(find.text("Cha"), findsOneWidget);
    expect(find.text("Con"), findsOneWidget);
  });

  // Tests Character Creation Page
  testWidgets('Character Creation Page Test', (WidgetTester tester) async {
    // set up environment
    // Character Selection cannot run on its own
    await tester.pumpWidget(new MaterialApp(
        home: new HomePage()
    ));

    await tester.pumpWidget(new MaterialApp(
        home: new CharacterSelection()
    ));

    // check if page is loaded correctly
    Finder button = find.byType(FloatingActionButton);
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // check if page loaded correctly
    expect(find.text("Create Character"), findsOneWidget);
    expect(find.text("SAVE"), findsOneWidget);
    expect(find.text("Basic"), findsOneWidget);
    expect(find.text("Lore"), findsOneWidget);
    expect(find.text("Equipment"), findsOneWidget);
    // Basic
    expect(find.text("Type name here"), findsOneWidget);
    expect(find.text("Race"), findsOneWidget);
    expect(find.text("Gender"), findsOneWidget);
    expect(find.text("Class"), findsOneWidget);
    expect(find.text("Str"), findsOneWidget);
    expect(find.text("Int"), findsOneWidget);
    expect(find.text("Dex"), findsOneWidget);
    expect(find.text("Wis"), findsOneWidget);
    expect(find.text("Cha"), findsOneWidget);
    expect(find.text("Con"), findsOneWidget);
    // Lore
    await tester.drag(find.text("Wis"), Offset(-1000.0, 200.0));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text("Background"), findsOneWidget);
    expect(find.text("Personality"), findsOneWidget);
    expect(find.text("Ideals"), findsOneWidget);
    expect(find.text("Bonds"), findsOneWidget);
    expect(find.text("Flaws"), findsOneWidget);
    expect(find.text("Features & Traits"), findsOneWidget);
    // Equipment
    await tester.drag(find.text("Bonds"), Offset(-1000.0, 200.0));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Save
    await tester.tap(find.text("SAVE"));
    await tester.pump();
    await tester.pump(const Duration(microseconds: 500));

    expect(find.text("Character needs a name"), findsOneWidget);
  });

  // Tests Create Session
  // NOTE: This test requires android and backend support
  /*testWidgets('Create Session Test', (WidgetTester tester) async {
    // set up environment
    await tester.pumpWidget(new MaterialApp(
        home: new HomePage()
    ));

    await tester.tap(find.text('Create Game Session'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    //expect(find.text("Scan the QR code to join!"), findsOneWidget);
    //expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    //expect(find.text("Enter Session"), findsOneWidget);
  });*/

  // Tests View Races
  testWidgets('View Races Test', (WidgetTester tester) async {
    // set up environment
    // Character Selection cannot run on its own
    await tester.pumpWidget(new MaterialApp(
        home: new HomePage()
    ));
    await tester.pumpWidget(new MaterialApp(
        home: new RaceViewer()
    ));

    // check if page is loaded correctly
    expect(find.text('Hill Dwarf'), findsOneWidget);

    await tester.tap(find.text('Hill Dwarf'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Image), findsOneWidget);
  });

  // Tests View Races
  testWidgets('Monster Journal Test', (WidgetTester tester) async {
    // set up environment
    // Character Selection cannot run on its own
    await tester.pumpWidget(new MaterialApp(
        home: new HomePage()
    ));
    await tester.pumpWidget(new MaterialApp(
        home: new MonsterJournal()
    ));

    // check if page is loaded correctly
    expect(find.byType(Text), findsWidgets);
  });

  // Tests Menu Navigation
  testWidgets('Menu Navigation Test', (WidgetTester tester) async {
    final routes = <String, WidgetBuilder>{
      LoginPage.tag: (context) => new LoginPage(),
      HomePage.tag: (context) => new HomePage(),
      MonsterJournal.tag: (context) => new MonsterJournal(),
      CharacterSelection.tag: (context) => new CharacterSelection(),
      GameSession.tag: (context) => new GameSession(null),
      RaceViewer.tag: (context) => new RaceViewer()
    };

    // set up environment
    await tester.pumpWidget(
        new MaterialApp(
            home: new Scaffold(
              body: new Text("Start"),
              drawer: Menu(),
            ),
            routes: routes
        )
    );

    ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // test if all tiles exist
    Finder tile = find.byKey(new Key("monster_journal_page_tile"));
    expect(tile, findsOneWidget);
    tile = find.byKey(new Key("race_viewer_page_tile"));
    expect(tile, findsOneWidget);
    tile = find.byKey(new Key("character_selection_page_tile"));
    expect(tile, findsOneWidget);
    expect(find.text("Sign Out"), findsOneWidget);
    tile = find.byKey(new Key("menu_home_page_tile"));
    expect(tile, findsOneWidget);

    // Home page
    await tester.tap(tile);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // check if home page is loaded
    expect(find.text('Home Page'), findsOneWidget);

    // Monster Journal

    // go to character selection
    state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    tile = find.byKey(new Key("character_selection_page_tile"));
    expect(tile, findsOneWidget);
    await tester.tap(tile);
    await tester.pump();

    // check if character selection is loaded
    expect(find.text('Character Selection'), findsOneWidget);

    state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    tile = find.byKey(new Key("monster_journal_page_tile"));
    expect(tile, findsOneWidget);
    await tester.tap(tile);
    await tester.pump();

    // View Races
    state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pump();
    tile = find.byKey(new Key("race_viewer_page_tile"));
    expect(tile, findsOneWidget);
    await tester.tap(tile);
    await tester.pump();

    // check if races is loaded
//    expect(find.text('Races'), findsOneWidget);
  });
}
