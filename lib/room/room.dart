import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:karoake_app/providers/book_provider.dart';
import 'package:provider/provider.dart';

class Room extends StatelessWidget {
  static const routeName = "/room";
  const Room({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String roomID = arguments['room_id'] as String;

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
                                elevation: 20,
                                child: ListTile(
                                  onTap: () {
                                    if (snapshot.data![index]['available'] ==
                                        false) {
                                      Fluttertoast.showToast(
                                        msg: " Reservation is full..",
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
                                      print("something");
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
