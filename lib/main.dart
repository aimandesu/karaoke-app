import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karoake_app/about/about.dart';
import 'package:karoake_app/providers/book_provider.dart';
import 'package:karoake_app/room/room.dart';
import 'package:provider/provider.dart';

import 'book/book.dart';
import 'firebase_options.dart';
import 'home/home.dart';
import 'login_sign/login_sign.dart';
import 'providers/login_sign_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LoginSignProvider()),
        ChangeNotifierProvider(create: (ctx) => BookProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return const LoginSign();
            }
          },
        ),
        routes: {
          Book.routeName: (context) => const Book(),
          About.routeName: (context) => const About(),
          Room.routeName: (context) => const Room(),
        },
      ),
    );
  }
}
