import 'package:cloud_firestore/cloud_firestore.dart';

class FastingSession {
  final String id;
  final DateTime start;
  final DateTime? end;

  FastingSession({
    required this.id,
    required this.start,
    this.end,
  });

  factory FastingSession.fromMap(String id, Map<String, dynamic> data) {
    return FastingSession(
      id: id,
      start: (data['start'] as Timestamp).toDate(),
      end: data['end'] == null ? null : (data['end'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
    };
  }
}
