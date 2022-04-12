import 'package:flutter/material.dart';
import 'package:mini_project/screen/addfoodscreen.dart';
import 'package:mini_project/screen/sidemenu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หน้าหลัก'), backgroundColor: Colors.cyan[900],),
      drawer: const SideMenu(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image(image: AssetImage('assets/children.png'), width: 250, height: 250,),
                    Image(image: AssetImage('assets/fastfood.png'), width: 250, height: 250,),
                    Image(image: AssetImage('assets/vegetable.jpg'), width: 250, height: 250,),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (Context) => AddFood())
                  );
                }, 
                child: Text('เริ่มต้น', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}