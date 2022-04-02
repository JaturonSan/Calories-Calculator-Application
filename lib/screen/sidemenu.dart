import 'package:flutter/material.dart';
import 'package:mini_project/main.dart';
import 'package:mini_project/screen/addfoodscreen.dart';
import 'package:mini_project/screen/addstudentscreen.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/showfoodscreen.dart';
import 'package:mini_project/screen/showcalscreen.dart';
import 'package:mini_project/screen/studentdetailscreen.dart';


// การทำ sidemenu -- https://maffan.medium.com/how-to-create-a-side-menu-in-flutter-a2df7833fdfb
// เอาหน้านี้ไปใส่ไว้ใน drawer ของ Scaffold 
class SideMenu extends StatelessWidget {
  const SideMenu({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.lightGreen[100],
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
              color: Colors.lightGreen[800],
              child: ListTile(
                leading: const Icon(Icons.home, color: Colors.white,),
                title: const Text('หน้าหลัก', style: TextStyle(color: Colors.white,),),
                onTap: () => {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  ),
                },
              ),
            ),
            Card(
              color: Colors.lightGreen[800],
              child: ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.white,),
                title: const Text('รายการอาหาร', style: TextStyle(color: Colors.white,),),
                onTap: () => {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const ShowFoodScreen()),
                  ),
                },
              ),
            ),
            Card(
              color: Colors.lightGreen[800],
              child: ListTile(
                leading: const Icon(Icons.incomplete_circle, color: Colors.white,),
                title: const Text('แสดงแคลลอรี่', style: TextStyle(color: Colors.white,),),
                onTap: () => {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const ShowCalScreen()),
                  ),
                },
              ),
            ),
            Card(
              color: Colors.lightGreen[800],
              child: ListTile(
                leading: const Icon(Icons.restaurant, color: Colors.white,),
                title: const Text('เพิ่มรายการอาหาร', style: TextStyle(color: Colors.white,),),
                onTap: () => {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => AddFood()),
                  ),
                },
              ),
            ),
            Card(
              color: Colors.lightGreen[800],
              child: ListTile(
                leading: const Icon(Icons.person_add, color: Colors.white,),
                title: const Text('เพิ่มข้อมูลนักเรียน', style: TextStyle(color: Colors.white,),),
                onTap: () => {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => AddStudentScreen()),
                  ),
                },
              ),
            ),
            Card(
              color: Colors.lightGreen[800],
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.white,),
                title: const Text('รายละเอียดนักเรียน', style: TextStyle(color: Colors.white,),),
                onTap: () => {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const DetailStuScreen()),
                  ),
                },
              ),
            ),
            Card(
              color: Colors.lightGreen[800],
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white,),
                title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white,),),
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