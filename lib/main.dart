import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_signin_ii_example/pages/logged_in.dart';
import 'package:google_signin_ii_example/pages/signup.dart';
import 'package:google_signin_ii_example/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

// Variant: debugAndroidTest
// Config: debug
// Store: C:\Users\61415\.android\debug.keystore
// Alias: AndroidDebugKey
// MD5: 38:F5:38:95:E5:B1:09:56:C1:CC:D3:3E:B6:ED:A0:03
// SHA1: 37:09:58:23:5E:08:61:7E:72:D2:DD:C3:08:25:7C:68:D9:12:E8:35
// SHA-256: E5:77:94:B5:14:1D:3A:9F:8E:28:84:3C:07:6F:4A:19:ED:53:6B:91:A8:A6:05:38:91:3D:42:82:0C:B4:DA:6D
// Valid until: 2052?7?9????

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return GoogleSignInProvider();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        // 监听 流，获取user信息
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            //  正常登陆
          } else if (snapshot.hasData) {
            return const LoggedIn();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Opps'),
            );
          } else {
            //登录页
            return const SignUpPage(
              title: 'Sign Up',
            );
          }
        },
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                //  1. 建立provider
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogIn();
              },
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              label: const Text('Sign Up with google'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
