import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talk_app/firebase_options.dart';
import 'package:talk_app/pages/ChatSelector.dart';
import 'package:talk_app/pages/SettingModel/Theme.dart';
import 'package:talk_app/pages/Settings.dart';
import 'package:talk_app/pages/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk_app/pages/SignIn.dart';

import 'package:talk_app/pages/Customization.dart';
import 'package:talk_app/pages/SettingModel/Theme.dart';
import 'package:talk_app/pages/SettingModel/ThemeWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)=>ChangeNotifierProvider(
    create:(context)=>ThemeProvider(),
    builder:(context,_){
      final themeProvider = Provider.of<ThemeProvider>(context);
      return MaterialApp(
        title: 'Flutter Demo',
        themeMode: themeProvider.themeMode,
        theme: lightMode,
        darkTheme: darkMode,
        // theme: ThemeData(
        //   // This is the theme of your application.
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        home: const MyHomePage(title: 'talk app'),
      );
    },
  );
  }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _page = 0;
  User? _user;

  void setPage(int page) {
    setState(() {
      _page = page;
    });
  }

  void _setUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.data == null) {
            return const SignIn();
          }
          var currentUser = userSnapshot.data;
          print(currentUser);

          Widget page;
          switch (_page) {
            case 0:
              page = ChatSelector();
            case 1:
              page = Settings();
            case 2:
              page = Account(auth: _auth, user: currentUser!);
            // case 3:
            //   page = Customization();
            default:
              page = Center(child: Text("error"));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
              centerTitle: true,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _page,
              // selectedItemColor: Colors.blue,
              // unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Settings"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_rounded), label: "account"),
                // BottomNavigationBarItem(icon: Icon(Icons.phone), label: "Customization")
              ],
              onTap: (value) {
                setPage(value);
              },
            ),
            body: page,
          );
        });
  }
}
