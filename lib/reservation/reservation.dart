import 'package:flutter/material.dart';
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
                        hint: const Text("Room Type"),
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
                        roomID,
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
                  child: const Text("Reserve"),
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color(0xff1f005c),
              Color(0xff5b0060),
              Color(0xff870160),
              Color(0xffac255e),
              Color(0xffca485c),
              Color(0xffe16b5c),
              Color(0xfff39060),
              Color(0xffffb56b),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
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
                                      color: Colors.deepPurple,
                                    ),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
                                        onPressed: () {},
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
              } else if (snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
