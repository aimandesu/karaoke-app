import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:karoake_app/providers/book_provider.dart';
import 'package:provider/provider.dart';

class Room extends StatelessWidget {
  static const routeName = "/room";
  const Room({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String roomID = arguments['room_id'] as String;
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: Provider.of<BookProvider>(context).fetchRooms(roomID),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data![index]['time'].toString());
                });
          } else if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
