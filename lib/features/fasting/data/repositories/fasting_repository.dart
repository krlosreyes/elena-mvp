import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/fasting_model.dart';

class FastingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _col {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('fastingSessions');
  }

  /// Obtener sesión activa
  Future<FastingSession?> getActiveSession() async {
    if (uid == null) return null;

    final query = await _col
        .where('end', isNull: true)
        .orderBy('start', descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final d = query.docs.first;
    return FastingSession.fromMap(d.id, d.data());
  }

  /// Iniciar ayuno
  Future<FastingSession> startFasting() async {
    if (uid == null) throw Exception("No user logged");

    final doc = await _col.add({
      'start': FieldValue.serverTimestamp(),
      'end': null,
    });

    final snap = await doc.get();
    return FastingSession.fromMap(doc.id, snap.data()!);
  }

  /// Finalizar ayuno
  Future<void> endFasting(String sessionId) async {
    if (uid == null) throw Exception("No user logged");

    await _col.doc(sessionId).update({
      'end': FieldValue.serverTimestamp(),
    });
  }

  /// Actualización de rachas
  Future<void> updateStreaks() async {
    if (uid == null) return;

    final streakDoc = _firestore
        .collection('users')
        .doc(uid)
        .collection('streaks')
        .doc('fasting');

    return streakDoc.set({
      'currentFastingStreak': FieldValue.increment(1),
      'lastCompletedDay': DateTime.now(),
    }, SetOptions(merge: true));
  }
}
