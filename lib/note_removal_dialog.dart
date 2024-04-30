import 'package:flutter/material.dart';

class NoteRemovalDialog extends StatelessWidget {
  final int noteIndex;
  final Function() removalFunc;
  const NoteRemovalDialog(
      {super.key, required this.noteIndex, required this.removalFunc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove Note'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Are you sure you want to delete this note?'),
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
          child: const Text('Remove'),
          onPressed: () {
            removalFunc();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
