/// Notes : "Exhibitor Image 5 for LS"

class NotesModelLeadSheet {
  NotesModelLeadSheet({
      String? notes,}){
    _notes = notes;
}

  NotesModelLeadSheet.fromJson(dynamic json) {
    _notes = json['Notes'];
  }
  String? _notes;
NotesModelLeadSheet copyWith({  String? notes,
}) => NotesModelLeadSheet(  notes: notes ?? _notes,
);
  String? get notes => _notes;

  set notes(String? value) {
    _notes = value;
  }

  Map<String, String> toJson() {
    final map = <String, String>{};
    map['Notes'] = _notes.toString();
    return map;
  }

}