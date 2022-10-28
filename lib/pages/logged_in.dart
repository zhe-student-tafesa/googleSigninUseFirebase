import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/google_sign_in.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  @override
  Widget build(BuildContext context) {
    //使用已经登录 的用户 的信息,zai 各个页面都可以访问
    final user= FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LoggedIn'),
        actions: [
          TextButton(
            onPressed: () {
              //点击 时：退出
              final provider = Provider.of<GoogleSignInProvider>(context,listen:false );
              provider.googleLogOut();
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: const Center(
                child: Text('LoggedIn'),
              ),

            ),
            const SizedBox(height: 30,),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage((user?.photoURL)??''),
            ),
            const SizedBox(height: 8,),
            Text('Name: '+((user?.displayName)??'')),
            const SizedBox(height: 8,),
            Text('Email: '+((user?.email)??'')),

          ],
        ),
      ),
    );
  }
}
