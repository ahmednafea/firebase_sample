import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDBManager {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<DocumentReference> add(String email) async {
    final docRef = await db.collection("users").add({"Email": email});
    return docRef;
  }

  static Future<void> delete(String email) async {
    final docRef = await db.collection("users").get();
    for (var user in docRef.docs) {
      if (user.get("Email") == email) {
        user.reference.delete();
      }
    }
  }

  static Future<void> update(String email) async {
    final docRef =
        await db.collection("users").where("Email", isEqualTo: email).get();
    for (var user in docRef.docs) {
      user.reference.update({"name": "Testing ${DateTime.now()}"});
    }
  }
}
