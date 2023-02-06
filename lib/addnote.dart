class AddNote {
  final String doc_id;
  final String id;
  final String note;
  final String dateadded;
  final String notetitle;

  AddNote(
      {required this.doc_id,
      required this.id,
      required this.note,
      required this.dateadded,
      required this.notetitle});

  Map<String, dynamic> toJson() => {
        'doc_id': doc_id,
        'id': id,
        'note': note,
        'dateadded': dateadded,
        'notetitle': notetitle,
      };

  static AddNote fromJson(Map<String, dynamic> json) => AddNote(
      doc_id: json['doc_id'],
      id: json['id'],
      note: json['note'],
      dateadded: json['dateadded'],
      notetitle: json['notetitle']);
}
