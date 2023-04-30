import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/screen/loginscreen.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/settingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


// การทำ sidemenu -- https://maffan.medium.com/how-to-create-a-side-menu-in-flutter-a2df7833fdfb
// เอาหน้านี้ไปใส่ไว้ใน drawer ของ Scaffold 
class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final user = FirebaseAuth.instance;
  Color backgroundColor = Colors.cyan[900]!;

  // เรียกสีแอปหลักจาก SharedPreferences
  void getAppBackgroundColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAppBackgroundColor();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/foods.png')
                )
              ),
            ),
            Card(
              color: Colors.white54,
              child: ListTile(
                leading: const Icon(Icons.home, color: Colors.black,),
                title: const Text('หน้าหลัก', style: TextStyle(color: Colors.black,),),
                onTap: () {
                  getAppBackgroundColor();
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => MainScreen(const Text("หน้าหลัก"), MainPage(backgroundColor), 0, backgroundColor)
                    ),
                  );
                },
              ),
            ),
            Card(
              color: Colors.white54,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.black,),
                title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.black,),),
                onTap: () {
                  // เป็นส่วนของการ log out ออกสู่ระบบของ firebase และออกจากระบบจดจำอีเมลด้วย
                  user.signOut().then((value) async {
                    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
                    sharedpreferences.remove('email'); // เอาอีเมลออก
                    sharedpreferences.remove('isLogin'); // เซ็ตว่าเครื่องนี้ยังไม่มีการล็อกอิน
                    Navigator.of(context).pushReplacement( 
                      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                    );
                  });
                },
              ),
            ),
            Card(
              color: Colors.white54,
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.black),
                title: const Text('การตั้งค่าแอป', style: TextStyle(color: Colors.black,),),
                onTap: () {
                  // การทำงานของหน้าการตั้งค่าแอป เราสามารถเปลี่ยนสีแอปได้ เปลี่ยนรูปแบบการแสดงผลได้
                  Navigator.of(context).push( 
                    MaterialPageRoute(builder: (BuildContext context) => const SettingScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}