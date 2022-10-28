import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  //实例化 GoogleSignIn
  final googleSignIn = GoogleSignIn();

//  实例化 登录的用户
  GoogleSignInAccount? _user;

  //get 方法
  GoogleSignInAccount get user => _user!;

  // 单击时 调用的方法
  Future googleLogIn() async {
    try {
      //  pop一个弹窗，让你选择 想要  登录的google账户
      final googleUser = await googleSignIn.signIn();

      //  如果用户  没有 选择了一个google账户
      if (googleUser == null) {
        return;
      }
      //  如果用户    选择了一个google账户
      _user = googleUser;

      //获取 授权
      final googleAuth = await googleUser.authentication;
      //取出 授权信息
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // 登录 FirebaseAuth
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // 退出时 单击 调用的方法
  Future googleLogOut() async {
    // 退出 F google
    await googleSignIn.disconnect();
    //  退出 firebase
    FirebaseAuth.instance.signOut();
  }
}
