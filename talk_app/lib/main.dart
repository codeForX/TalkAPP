import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talk_app/firebase_options.dart';
import 'package:talk_app/pages/ChatSelector.dart';
import 'package:talk_app/pages/Favorites.dart';
import 'package:talk_app/pages/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk_app/pages/SignIn.dart';

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

  static const customColorScheme = ColorScheme(
    primary: Color(0xFF7AA7FF),
    secondary: Colors.green,
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Color(0xFF0031AF),
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0031AF)),
        colorScheme: customColorScheme,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Talk App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;

  void setPage(int page) {
    setState(() {
      _page = page;
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
              page = ChatSelector(user: currentUser!);
              break;
            case 1:
              page = Favorites();
              break;
            case 2:
              page = Account(auth: _auth, user: currentUser!);
              break;
            default:
              page = Center(child: Text("error"));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title, style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _page,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: "Favorites"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_rounded), label: "Account")
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
