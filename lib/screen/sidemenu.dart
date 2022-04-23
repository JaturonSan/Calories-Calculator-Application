import 'package:flutter/material.dart';
import 'package:mini_project/main.dart';
import 'package:mini_project/screen/mainscreen.dart';


// การทำ sidemenu -- https://maffan.medium.com/how-to-create-a-side-menu-in-flutter-a2df7833fdfb
// เอาหน้านี้ไปใส่ไว้ใน drawer ของ Scaffold 
class SideMenu extends StatelessWidget {
  const SideMenu({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.cyan[900],
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
                onTap: () => {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => MainScreen(const Text("หน้าหลัก"), MainPage(), 0)),
                  ),
                },
              ),
            ),
            Card(
              color: Colors.white54,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.black,),
                title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.black,),),
                onTap: () => {
                  Navigator.of(context).pushReplacement( 
                    MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}