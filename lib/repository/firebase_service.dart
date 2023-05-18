import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('home_settings');

  Stream getSettingsStream() {
    return collection.doc("settings").snapshots();
  }

  void setFrontDoor(bool isOpen) {
    collection.doc("settings").update({"frontDoorIsLocked": isOpen});
  }
}
