import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:provider/provider.dart';

class ShowFoodScreen2 extends StatefulWidget {
  const ShowFoodScreen2({ Key? key }) : super(key: key);

  @override
  State<ShowFoodScreen2> createState() => _ShowFoodScreen2State();
}

class _ShowFoodScreen2State extends State<ShowFoodScreen2> {
  final keyForm = GlobalKey<FormState>();
  List<Widget> foodList = [];

  List<Widget> getFoodList(List<Foods> foods){
    for(Foods data in foods){
      foodList.add(
        Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Container(
            //   height: 88,
            //   width: 120,
            //   margin: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     image: const DecorationImage(
            //       image: AssetImage('assets/pizza.jpg'),
            //       fit: BoxFit.cover,
            //     ),
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            // ),
            Image.file(File(data.pic.toString()), height: 110,width: 120,),
            Text(data.name.toString()),
            Text(data.calories.toString()+" แคล"),
          ],
        ),
      );
    }
    return foodList;
  }

  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    var provider = Provider.of<FoodProvider>(context, listen: false);
    provider.initData("foods.db"); // init ข้อมูลอาหารของเรา
    //provider.initData("user_foods.db"); // init ข้อมูลอาหารของ user
    foodList = getFoodList(provider.foods);
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
              // กล่องค้นหารายการอาหาร

              // กดจำแนกกลุ่ม

              // รายการอาหารเป็นกล่องสี่เหลี่ยมใช้ GridView
              GridView.count(
                padding: const EdgeInsets.only(right: 20),
                shrinkWrap: true,
                crossAxisCount: 2, // 2 แถว
                children: foodList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}