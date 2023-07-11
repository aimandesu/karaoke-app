import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:karoake_app/providers/book_provider.dart';
import 'package:karoake_app/room/room.dart';
import 'package:provider/provider.dart';

class Book extends StatelessWidget {
  static const routeName = "/book";
  const Book({super.key});

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
          child: FutureBuilder(
              future: Provider.of<BookProvider>(context, listen: false)
                  .fetchReservation(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Text("no");
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: size.height * 0.1,
                        width: size.width * 1,
                        child: const Text(
                          "List Rooms",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.7,
                        width: size.width * 1,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                print(snapshot.data![index]['room_id']);
                                print(
                                    snapshot.data![index]['price'].toString());
                                print(snapshot.data![index]['room']);
                                Navigator.of(context).pushNamed(
                                  Room.routeName,
                                  arguments: {
                                    'room_id': snapshot.data![index]['room_id'],
                                    'price': double.parse(
                                      snapshot.data![index]['price'].toString(),
                                    ),
                                    'room': snapshot.data![index]['room'],
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                width: size.width * 1,
                                height: 120,
                                decoration: BoxDecoration(
                                  // color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    // color: Colors.blue,
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Image.network(
                                      'https://cdn.donmai.us/original/b9/0e/b90e0dc77ade614dbebbc274cb88d2bc.jpg',
                                      width: size.width * 0.2,
                                      height: 95,
                                      // height: 350.0,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      width: size.width * 0.6,
                                      margin: EdgeInsets.only(left: 10),
                                      // height: 30,
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        // mainAxisSpacing: 10,
                                        childAspectRatio: 2.5 / 1,
                                        mainAxisSpacing: 3,
                                        crossAxisSpacing: 3,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,

                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the circular border
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data![index]['room']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the circular border
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data![index]
                                                        ['capacity']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,

                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the circular border
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data![index]['price']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,

                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the circular border
                                            ),
                                            child: Center(
                                              child: Text(
                                                snapshot.data![index]['type']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
