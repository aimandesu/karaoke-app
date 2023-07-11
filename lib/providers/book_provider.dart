import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> addReservation(
    String pax,
    String reservationID,
    String roomID,
    double price,
    String room,
    String time,
  ) async {
    final addItem = FirebaseFirestore.instance.collection("reserved");
    addItem.add({
      'pax': pax,
      'reservation_id': reservationID,
      'room_id': roomID,
      'price': price,
      'user_uid': FirebaseAuth.instance.currentUser!.uid,
      'room': room,
      'time': time,
    }).then((value) => addItem.doc(value.id).update({
          'reserved_id': value.id,
        }));

    final item = FirebaseFirestore.instance
        .collection("room")
        .doc(roomID)
        .collection("reservation")
        .doc(reservationID);
    item.update({
      'available': false,
      'user_uid': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Stream<List<Map<String, dynamic>>> fetchOwnReservation() async* {
    yield* FirebaseFirestore.instance
        .collection('reserved')
        .where("user_uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<List<String>> fetchAvailability(String roomID) async {
    List<String> list = [];

    var item = await FirebaseFirestore.instance
        .collection("room")
        .doc(roomID)
        .collection("reservation")
        .where("available", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        list.add(element.data()['time']);
      }
    });
    // for (var e in list) {
    //   print(e);
    // }
    return list;
  }

  Future<void> updateReservation(
    String roomID,
    String time,
    String currentReservationID,
    String reservedID,
  ) async {
    String id = "";
    await FirebaseFirestore.instance
        .collection("room")
        .doc(roomID)
        .collection("reservation")
        .where("time", isEqualTo: time)
        .where("available", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        id = element.data()['id'];
      }
    });
    print(id);

    if (id != "") {
      print(roomID);
      print(currentReservationID);
      print(reservedID);
      print(time);

      await FirebaseFirestore.instance
          .collection("room")
          .doc(roomID)
          .collection("reservation")
          .doc(id)
          .update({
        'available': false,
        'user_uid': FirebaseAuth.instance.currentUser!.uid,
      });

      await FirebaseFirestore.instance
          .collection("room")
          .doc(roomID)
          .collection("reservation")
          .doc(currentReservationID)
          .update({
        'available': true,
        'user_uid': "",
      });

      await FirebaseFirestore.instance
          .collection("reserved")
          .doc(reservedID)
          .update({
        'time': time,
      });
    }
  }
}
