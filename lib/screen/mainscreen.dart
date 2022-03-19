import 'package:flutter/material.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/screen/addfoodscreen.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddFood();
              }));
            },
            icon: Icon(Icons.restaurant),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, FoodProvider provider, child) {
          var count = provider.foods.length;
          if (count <= 0) {
            return const Center(
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(fontSize: 35),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.foods.length,
              itemBuilder: (context, int index) {
                Foods data = provider.foods[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: FittedBox(
                        child: Text(data.amount.toString() + " อัน"),
                      ),
                    ),
                    title: Text(data.name!),
                    subtitle: Text(data.calories.toString() + " แคล"),
                  ),
                );
              },
            );
          }
        }, 
      ),
    );
  }
}
