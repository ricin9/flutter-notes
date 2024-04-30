import 'package:flutter/material.dart';
import 'package:notes/notes_data.dart';

class NoteAddDialog extends StatelessWidget {
  final Function(Note) addFunc;
  NoteAddDialog({
    super.key,
    required this.addFunc,
  });

  final c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a Note'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: c,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter Note text"),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            addFunc((
              date: DateTime.now().toIso8601String().split("T")[0],
              text: c.text,
              id: null
            ));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
