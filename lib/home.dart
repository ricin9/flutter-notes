import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:notes/main.dart';
import 'package:notes/note_add_dialog.dart';
import 'package:notes/note_database.dart';
import 'package:notes/note_model.dart';
import 'package:notes/note_page.dart';
import 'package:notes/note_removal_dialog.dart';
// import 'package:notes/notes_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware, WidgetsBindingObserver {
  int? _currentNoteLandscape;

  @override
  void initState() {
    refreshNotes();
    super.initState();
    initialization();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("============== ${state.toString()}");
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        stopTTS(); // Optional: Stop any ongoing speech (redundant?)
        break;
      default:
        break;
    }
  }

  Future<void> stopTTS() async {
    final FlutterTts flutterTts = FlutterTts(); // Create a new TTS instance

    await flutterTts.stop();
  }

  @override
  void didPushNext() {
    // Route was pushed onto navigator and is now topmost route.
    print("============= pushed main");
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    stopTTS();
    print("============= poppedNext main");
  }

  @override
  void didPop() async {
    // Covering route was popped off the navigator.
    stopTTS();
    print("============= popped main");
  }

  @override
  void dispose() {
    noteDatabase.close();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    print('go!');
    FlutterNativeSplash.remove();
  }

  Future<void> _showNoteRemovalDialog(index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return NoteRemovalDialog(
            noteIndex: index,
            removalFunc: () {
              noteDatabase.delete(index);
              refreshNotes();
              setState(() {
                if (notes.indexWhere((element) => element.id == index) ==
                    _currentNoteLandscape) {
                  _currentNoteLandscape = null;
                }
              });
            });
      },
    );
  }

  Future<void> _showNoteAddDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return NoteAddDialog(
          addFunc: (note) {
            noteDatabase.create(NoteModel(text: note.text, date: note.date));
            refreshNotes();
          },
        );
      },
    );
  }

  NoteDatabase noteDatabase = NoteDatabase.instance;

  List<NoteModel> notes = [];

  refreshNotes() {
    noteDatabase.readAll().then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Notes App"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      floatingActionButton: FloatingActionButton(
          child: Text("+"), onPressed: () => _showNoteAddDialog()),
      body: OrientationBuilder(
          builder: (context, orientation) => Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) => Card(
                              child: InkWell(
                                onLongPress: () =>
                                    _showNoteRemovalDialog(notes[index].id),
                                onTap: () {
                                  if (orientation == Orientation.landscape) {
                                    setState(() {
                                      _currentNoteLandscape = index;
                                      stopTTS();
                                    });
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Notepage(note: notes[index])));
                                  }
                                },
                                child: ListTile(
                                    leading:
                                        Image.asset("assets/note-rounded.png"),
                                    title: Text("Miloudi Mohamed"),
                                    subtitle: Text(
                                      notes[index].text.length > 15
                                          ? "${notes[index].text.substring(0, 14)}..."
                                          : notes[index].text,
                                    )),
                              ),
                            )),
                  ),
                  Expanded(
                      flex: orientation == Orientation.landscape &&
                              _currentNoteLandscape != null
                          ? 1
                          : 0,
                      child: orientation == Orientation.landscape &&
                              _currentNoteLandscape != null
                          ? NoteDetail(note: notes[_currentNoteLandscape!])
                          : Container())
                ],
              )),
    );
  }
}
