/* หน้านี้เป็นหน้าที่เอาไว้โหลดข้อมูลต่างๆ ก่อนจะเข้าหน้าหลักแอป  
-- https://www.youtube.com/watch?v=XXISgdYHdYw&t=2s
-- https://stackoverflow.com/questions/67770628/how-keep-user-logged-in-flutter
*/
import 'package:flutter/material.dart';
import 'package:mini_project/screen/loginscreen.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlashScreen extends StatefulWidget {
  const SlashScreen({Key? key}) : super(key: key);

  @override
  State<SlashScreen> createState() => _SlashScreenState();
}

class _SlashScreenState extends State<SlashScreen> {
  String finalEmail = "";
  bool isLogin = false;
  late Color appBackgroundColor; 
  late Color buttonColor; 
  late Color buttonTextColor; 
  
  @override
  void initState() {
    super.initState();
    getAppColor();
    _navigatetohome();
  }

  void getAppColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    if(await checkSharedpreferences()) {
      setState(() {
        appBackgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
        buttonColor = Color(int.parse(sharedpreferences.getString('AppButtonColor')!, radix: 16,));
        buttonTextColor = Color(int.parse(sharedpreferences.getString('AppButtonTextColor')!, radix: 16,));
      });
    } else {
      setState(() {
        sharedpreferences.setString('AppBackgroundColor', 'ff9d6060');
        sharedpreferences.setString('AppButtonColor', 'ff9d6060');
        sharedpreferences.setString('AppButtonTextColor', 'ffffffff');
      });
    }
  }

  Future<bool> checkSharedpreferences() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    return sharedpreferences.containsKey('AppBackgroundColor');
  }

  _navigatetohome() async {
    isStayLogin().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 1500), () {});
      if(isLogin==true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(const Text("หน้าหลัก"), MainPage(appBackgroundColor), 0, appBackgroundColor)
        ));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()
        ));
      }
    });
  }

  Future isStayLogin() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedpreferences.getString('email');
    bool? login = sharedpreferences.getBool('isLogin');
    setState(() {
      if(login==null && obtainedEmail==null){
        isLogin = false;
        obtainedEmail = "";
      }else{
        isLogin = true;
        obtainedEmail = obtainedEmail;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* วิธีเขียน circle avatar
              -- https://medium.com/@mohammedijas/circle-image-avatar-with-border-in-flutter-513cdf82df43
            */
            const CircleAvatar(
              radius: 180,
              backgroundImage: AssetImage('assets/splash_screen_pic.jpg'),
            ),
            const SizedBox(height: 20,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('กำลังโหลดข้อมูล',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(width: 20,),
                CircularProgressIndicator(strokeWidth: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}