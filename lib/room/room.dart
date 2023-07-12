import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:karoake_app/providers/book_provider.dart';
import 'package:provider/provider.dart';

class Room extends StatefulWidget {
  static const routeName = "/room";
  const Room({super.key});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  // String? _roomType;
  final paxController = TextEditingController();
  final facilityController = TextEditingController();

  @override
  void dispose() {
    paxController.dispose();
    facilityController.dispose();
    super.dispose();
  }

  void clearAddReservation() {
    paxController.clear();
    facilityController.clear();
    // setState(() {
    //   _roomType = null;
    // });
  }

  void show(
    String pax,
    String reservationID,
    String roomID,
    double price,
    String room,
    String time,
    String facility,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Reservation"),
            content: Text(
              "Reserve this slot?",
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
        Provider.of<BookProvider>(context, listen: false).addReservation(
          pax,
          reservationID,
          roomID.trim(),
          price,
          room,
          time,
          facility,
        );
        // print(paxController);

        // print(reservationID);
        // print(roomID);
        // print(price);
      } else {
        Fluttertoast.showToast(
          msg: "reservation is cancelled",
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
    String reservationID,
    String roomID,
    double price,
    String room,
    String time,
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
            height: 250,
            child: Column(
              children: [
                Pax(paxController: paxController),
                Facility(facilityController: facilityController),
                // Container(
                //   margin:
                //       const EdgeInsets.only(bottom: 30, left: 15, right: 15),
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.purple,
                //     ),
                //     borderRadius: const BorderRadius.all(
                //       Radius.circular(25),
                //     ),
                //   ),
                //   child: StatefulBuilder(
                //     builder: (context, setState) {
                //       return DropdownButton(
                //         borderRadius: BorderRadius.circular(20),
                //         underline: const SizedBox(),
                //         hint: const Text("Room Type"),
                //         value: _roomType,
                //         isExpanded: true,
                //         items: ['Regular Room', 'Vip Room'].map((String value) {
                //           return DropdownMenuItem(
                //               value: value, child: Text(value));
                //         }).toList(),
                //         onChanged: (String? value) {
                //           setState(() {
                //             _roomType = value;
                //           });
                //         },
                //       );
                //     },
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      Navigator.of(context).pop();
                      show(paxController.text, reservationID, roomID, price,
                          room, time, facilityController.text);

                      // print(paxController.text);
                      // // print(_roomType);
                      // print(reservationID);
                      // print(roomID);
                      // print(price);
                    } catch (e) {
                      print(e.toString());
                    } finally {
                      clearAddReservation();
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

  // void dropDownCallback(String? selectedValue) {
  //   setState(() {
  //     _roomType = selectedValue;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String roomID = arguments['room_id'] as String;
    final double price = arguments['price'] as double;
    final String room = arguments['room'] as String;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              stream: Provider.of<BookProvider>(context).fetchRooms(roomID),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Reservation",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.8,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: Card(
                                color: Color(0xFFF4DECB),
                                elevation: 20,
                                child: ListTile(
                                  onTap: () {
                                    if (snapshot.data![index]['available'] ==
                                        false) {
                                      Fluttertoast.showToast(
                                        msg: "The slot has been reserved..",
                                        toastLength: Toast
                                            .LENGTH_SHORT, // or Toast.LENGTH_LONG
                                        gravity: ToastGravity
                                            .BOTTOM, // positioning of the toast
                                        timeInSecForIosWeb:
                                            1, // duration of the toast on iOS and web
                                        backgroundColor: Colors
                                            .black, // background color of the toast
                                        textColor: Colors
                                            .white, // text color of the toast
                                        fontSize:
                                            16.0, // font size of the toast message
                                      );
                                    } else {
                                      _launch(
                                        context,
                                        snapshot.data![index]['id'].toString(),
                                        snapshot.data![index]['room_id']
                                            .toString(),
                                        price,
                                        room,
                                        snapshot.data![index]['time']
                                            .toString(),
                                      );
                                    }
                                  },
                                  leading:
                                      snapshot.data![index]['available'] == true
                                          ? const Icon(Icons.event_available)
                                          : const Icon(Icons.event_busy),
                                  title: Text(
                                      snapshot.data![index]['time'].toString()),
                                  subtitle:
                                      snapshot.data![index]['available'] == true
                                          ? const Text(
                                              'Available',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                // color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : const Text(
                                              "Reserved",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                // color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                  // trailing:
                                  //     snapshot.data![index]['available'] == true
                                  //         ? const IconButton(
                                  //             onPressed: null,
                                  //             icon: Icon(Icons.play_arrow),
                                  //           )
                                  //         : const Icon(null),
                                  isThreeLine: true,
                                ),
                              ),
                            );
                          },
                        ),
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
              }),
        ),
      ),
    );
  }
}

class Pax extends StatelessWidget {
  const Pax({
    super.key,
    required this.paxController,
  });

  final TextEditingController paxController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.purple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: paxController,
        decoration: const InputDecoration.collapsed(
          hintStyle: TextStyle(),
          hintText: "Pax ",
        ),
      ),
    );
  }
}

class Facility extends StatelessWidget {
  const Facility({
    super.key,
    required this.facilityController,
  });

  final TextEditingController facilityController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.purple,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: TextFormField(
        controller: facilityController,
        decoration: const InputDecoration.collapsed(
          hintStyle: TextStyle(),
          hintText: "Request Facility",
        ),
      ),
    );
  }
}
