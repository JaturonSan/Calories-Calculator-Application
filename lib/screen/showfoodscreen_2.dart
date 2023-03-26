import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:provider/provider.dart';

import 'editfoodscreen.dart';

class ShowFoodScreen2 extends StatefulWidget {
  const ShowFoodScreen2({ Key? key }) : super(key: key);

  @override
  State<ShowFoodScreen2> createState() => _ShowFoodScreen2State();
}

class _ShowFoodScreen2State extends State<ShowFoodScreen2> {
  SizedBox box = const SizedBox(height: 20,);

  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    var provider = Provider.of<FoodProvider>(context, listen: false);
    //provider.initData("foods.db"); // init ข้อมูลอาหารของเรา
    provider.initData("user_foods.db"); // init ข้อมูลอาหารของ user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // รายการอาหารเป็นกล่องสี่เหลี่ยมใช้ GridView
              Consumer(
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
                    return GridView.count(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: List.generate(provider.foods.length, (index) {
                        Foods data = provider.foods[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                                return EditFoodScreen(data);
                              }),
                            );
                          },
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
                            margin: const EdgeInsets.all(12.0),
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow[100], // background color of the cards
                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: const [
                                // this is the shadow of the card
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.5,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // posion the everything to the bottom
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.file(File(data.pic.toString()), height: 80,width: 80,),
                                Text(data.name.toString(), style: const TextStyle(fontSize: 10),),
                                Text(data.calories.toString()+" แคล", style: const TextStyle(fontSize: 10),),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }
                }, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}