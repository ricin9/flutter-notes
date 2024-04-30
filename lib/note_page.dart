import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:notes/note_model.dart';

class Notepage extends StatelessWidget {
  final NoteModel note;
  const Notepage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: NoteDetail(note: note),
    );
  }
}

class NoteDetail extends StatelessWidget {
  const NoteDetail({
    super.key,
    required this.note,
  });

  final NoteModel note;

  Future<void> _speakNote(BuildContext context) async {
    final FlutterTts flutterTts = FlutterTts(); // Create a new TTS instance

    await flutterTts.stop(); // Optional: Stop any ongoing speech (redundant?)

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(note.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset("assets/note-rounded.png", height: 128.0),
              Text("Miloudi Mohamed"),
              Text(note.text),
              ElevatedButton(
                  onPressed: () {
                    _speakNote(context);
                  },
                  child: Text("Text-to-Speech")),
              Text(note.date)
            ],
          ),
        ),
      ),
    );
  }
}
