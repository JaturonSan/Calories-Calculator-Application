import 'package:flutter/material.dart';
import 'package:mini_project/database/food_db.dart';
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
  FoodDB fooddb = FoodDB(dbName: 'foods.db');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddFood();
              }));
            },
            icon: const Icon(Icons.restaurant),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, FoodProvider provider, child) {
          var count = provider.foods.length;

          /*  เช็ค if -> else 
          1.ถ้า count <= 0 คือไม่มีข้อมูลจะแสดงข้อความว่าไม่มีข้อมูล
          2.ถ้าเป็นอย่างอื่นจะแสดงหน้าขึ้นมาพร้อมรายการอาหาร
           */
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
                        child: Text(data.amount.toString() + " อัน"), // โชว์จำนวนอาหารกี่จาน / ชิ้น
                      ),
                    ),
                    title: Text(data.name!), // ชื่ออาหาร
                    subtitle: Text(data.calories.toString() + " แคล"), // จำนวนแคลลอรี่
                    trailing: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              // โค้ดแก้ไขข้อมูลในฐานข้อมูล
                            }, 
                            icon: Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () async {
                              // ลบข้อมูลในฐานข้อมูลโดย เรียกฟังก์ชั่น DeleteFood ใน FoodDB แล้วใส่ข้อมูลตัวที่จะลบลงไป
                              var provider = Provider.of<FoodProvider>(context, listen: false);
                              provider.deleteFood(data);
                            }, 
                            icon: Icon(Icons.delete)
                          ),
                        ],
                      ),
                    ),
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
