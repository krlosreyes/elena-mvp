import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> testFirestore() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  print("AUTH USER: $uid");

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({"test": "ok"}, SetOptions(merge: true));

    print("WRITE OK");
  } catch (e) {
    print("ERROR WRITE: $e");
  }

  try {
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    print("READ OK: ${snap.data()}");
  } catch (e) {
    print("ERROR READ: $e");
  }
}
