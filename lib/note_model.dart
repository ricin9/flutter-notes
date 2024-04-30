class NoteModel {
  final int? id;
  final String text;
  final String date;
  const NoteModel({required this.text, required this.date, this.id});

  Map<String, Object?> toJson() => {
        "id": id,
        "text": text,
        "date": date,
      };

  NoteModel copy({
    int? id,
    String? text,
    String? date,
  }) =>
      NoteModel(
        id: id ?? this.id,
        text: text ?? this.text,
        date: date ?? this.date,
      );
  factory NoteModel.fromJson(Map<String, Object?> json) => NoteModel(
        id: json["id"] as int?,
        text: json["text"] as String,
        date: json["date"] as String,
      );
}
