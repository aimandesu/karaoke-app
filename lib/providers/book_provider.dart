import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BookProvider with ChangeNotifier {
  Future<List<Map<String, dynamic>>> fetchReservation() async {
    return FirebaseFirestore.instance
        .collection("room")
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> fetchRooms(String roomID) async* {
    yield* FirebaseFirestore.instance
        .collection('room')
        .doc(roomID)
        .collection('reservation')
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
