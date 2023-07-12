import 'package:flutter/material.dart';
import 'package:karoake_app/providers/login_sign_provider.dart';
import 'package:karoake_app/reservation/reservation.dart';
import 'package:provider/provider.dart';

import '../about/about.dart';
import '../book/book.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
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
          child: FutureBuilder<String>(
            future: Provider.of<LoginSignProvider>(context, listen: false)
                .fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Text("no");
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          50.0), // Adjust the value to change the roundness
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/karaoke-app-79fc9.appspot.com/o/Annotation%202023-07-12%20110243.jpg?alt=media&token=7d2bf923-97b2-4841-8f91-404a4b238e5c',
                        width: size.width * 0.9,
                        height: 350.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Welcome ${snapshot.data!}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "we are open weekly except friday from 10am to 10pm. We are waiting you there ;)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF4DECB),
                            ),
                            onPressed: () => Navigator.of(context).pushNamed(
                              Book.routeName,
                            ),
                            child: const Text(
                              "Book now",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF4DECB),
                            ),
                            onPressed: () => Navigator.of(context).pushNamed(
                              Reservation.routeName,
                            ),
                            child: const Text(
                              "Reservation",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Color(0xFFF4DECB),
                          //   ),
                          //   onPressed: () => Navigator.of(context).pushNamed(
                          //     About.routeName,
                          //   ),
                          //   child: const Text(
                          //     "About Us",
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
