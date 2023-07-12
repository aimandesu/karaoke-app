import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';

class Reservation extends StatefulWidget {
  static const routeName = "/reservation";
  const Reservation({super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  String? _time;

  void show(
    String roomID,
    String reservationID,
    String reservedID,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Reservation"),
            content: Text(
              "Delete Reservation?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("proceed"),
              ),
            ],
          );
        }).then((value) {
      if (value == true) {
        // print(pax);
        // print(reservationID);
        // print(roomID);
        // print(price);
        // print(room);
        // print(time);
        Provider.of<BookProvider>(context, listen: false)
            .deleteOrder(roomID.trim(), reservationID, reservedID);
        // print(paxController);

        // print(reservationID);
        // print(roomID);
        // print(price);
      } else {
        Fluttertoast.showToast(
          msg: "deletion is cancelled",
          toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
          gravity: ToastGravity.BOTTOM, // positioning of the toast
          timeInSecForIosWeb: 1, // duration of the toast on iOS and web
          backgroundColor: Colors.black, // background color of the toast
          textColor: Colors.white, // text color of the toast
          fontSize: 16.0, // font size of the toast message
        );
      }
    });
  }

  void _launch(
    BuildContext buildContext,
    String roomID,
    List<String> list,
    String currentReservationID,
    String reservedID,
  ) {
    showDialog(
      context: buildContext,
      builder: (_) {
        return Dialog(
          shadowColor: Colors.black,
          elevation: 30,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            height: 150,
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 30, left: 15, right: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.purple,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return DropdownButton(
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox(),
                        hint: const Text("Time"),
                        value: _time,
                        isExpanded: true,
                        items: list.map((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _time = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      Navigator.of(context).pop();
                      // print(_time);
                      Provider.of<BookProvider>(context, listen: false)
                          .updateReservation(
                        roomID.trim(),
                        _time.toString(),
                        currentReservationID,
                        reservedID,
                      );
                      // print(paxController.text);
                      // // print(_roomType);
                      // print(reservationID);
                      // print(roomID);
                      // print(price);
                    } catch (e) {
                      print(e.toString());
                    } finally {
                      // clearAddReservation();
                      setState(() {
                        _time = null;
                      });
                    }
                  },
                  child: const Text("update"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF94618E),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment(0.8, 1),
          //   colors: <Color>[
          //     Color(0xff1f005c),
          //     Color(0xff5b0060),
          //     Color(0xff870160),
          //     Color(0xffac255e),
          //     Color(0xffca485c),
          //     Color(0xffe16b5c),
          //     Color(0xfff39060),
          //     Color(0xffffb56b),
          //   ], // Gradient from https://learnui.design/tools/gradient-generator.html
          //   tileMode: TileMode.mirror,
          // ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: Provider.of<BookProvider>(context).fetchOwnReservation(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    const Text(
                      "Reserved",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.87,
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                              ),
                              height: size.height * 0.2,
                              width: size.width * 1,
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.1,
                                    margin: const EdgeInsets.only(
                                      left: 5,
                                      top: 5,
                                      right: 25,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Color(0xFFF4DECB),
                                    ),
                                    child: Text(
                                      (index + 1).toString(),
                                      // style: const TextStyle(
                                      //   color: Colors.white,
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.65,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pax: ${snapshot.data![index]['pax']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "RM: ${snapshot.data![index]['price']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Room: ${snapshot.data![index]['room']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Time: ${snapshot.data![index]['time']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          show(
                                            snapshot.data![index]['room_id']
                                                .toString(),
                                            snapshot.data![index]
                                                ['reservation_id'],
                                            snapshot.data![index]
                                                ['reserved_id'],
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          List<String> list = [];

                                          list =
                                              await Provider.of<BookProvider>(
                                                      context,
                                                      listen: false)
                                                  .fetchAvailability(
                                            snapshot.data![index]['room_id']
                                                .toString(),
                                          );
                                          _launch(
                                              context,
                                              snapshot.data![index]['room_id']
                                                  .toString(),
                                              list,
                                              snapshot.data![index]
                                                  ['reservation_id'],
                                              snapshot.data![index]
                                                  ['reserved_id']);
                                        },
                                        icon: const Icon(
                                          Icons.update,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Cart is empty",
                      style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    Lottie.asset(
                      'assets/lottie.json', // Replace with the correct path and filename
                      // width: 200,
                      // height: 200,
                    ),
                  ],
                ));
              } else {
                return Center(
                  child: Container(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
