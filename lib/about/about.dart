import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_sign_provider.dart';
import 'package:intl/intl.dart';

class About extends StatelessWidget {
  static const routeName = "/about";
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          color: Color(0xFF94618E),
        ),
        child: SafeArea(
          child: FutureBuilder(
            future: Provider.of<LoginSignProvider>(context, listen: false)
                .currentUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            50.0), // Adjust the value to change the roundness
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR98s7M5CnUJKx3uTqxNtxDrqS4YjbcSCWBVNaxWSbBxxym67Dalure2rTflsLohHWmYP0&usqp=CAU',
                          width: size.width * 0.9,
                          height: 350.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'Name: ${snapshot.data![0]['username']}',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Birth:  ${DateFormat('yyyy-MM-dd').format(
                          (snapshot.data![0]['birthDate'] as Timestamp)
                              .toDate(),
                        )}',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Phone No: ${snapshot.data![0]['phoneNo']}',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Email: ${snapshot.data![0]['email']}',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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
