import 'package:flutter/material.dart';
import 'package:mini_project/screen/showcalscreen.dart';

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
            DrawerHeader(
              child: Text(
                'เมนู',
                style: TextStyle(fontSize: 25),
              ),
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
                leading: Icon(Icons.camera, color: Colors.white,),
                title: Text('แสดงแคลลอรี่', style: TextStyle(color: Colors.white,),),
                onTap: () => {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ShowCalScreen()),
                  ),
                },
              ),
            ),
            // Card(
            //   color: Colors.lightGreen[800],
            //   child: ListTile(
            //     leading: Icon(Icons.map, color: Colors.white,),
            //     title: Text('แผนที่', style: TextStyle(color: Colors.white,),),
            //     // onTap: () => {
            //     //   Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(builder: (context) => MapScreen()),
            //     //   ),
            //     // },
            //   ),
            // ),
            // Card(
            //   color: Colors.lightGreen[800],
            //   child: ListTile(
            //     leading: Icon(Icons.home, color: Colors.white,),
            //     title: Text('หน้าหลัก', style: TextStyle(color: Colors.white,),),
            //     // onTap: () => {
            //     //   Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(builder: (context) => MainScreen()),
            //     //   ),
            //     // },
            //   ),
            // ),
            // Card(
            //   color: Colors.lightGreen[800],
            //   child: ListTile(
            //     leading: Icon(Icons.filter_vintage_outlined, color: Colors.white,),
            //     title: Text('พันธ์ุดอกบัวในแอป', style: TextStyle(color: Colors.white,),),
            //     // onTap: () => {
            //     //   Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(builder: (context) => LotusScreen()),
            //     //   ),
            //     // },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}