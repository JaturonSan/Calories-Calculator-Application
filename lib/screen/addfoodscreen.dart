import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/screen/showfoodscreen.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:provider/provider.dart';

import '../providers/food_provider.dart';

class AddFood extends StatelessWidget {
  AddFood({ Key? key }) : super(key: key);
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final calController = TextEditingController();
  final amountController = TextEditingController();
  FoodProvider foddProvider = FoodProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: const Text('เพื่มเมนูอาหาร'), backgroundColor: Colors.cyan[900],),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนชื่ออาหาร'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่ออาหาร',
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: calController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนจำนวนแคลอรี่'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'แคลอรี่',
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: amountController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาจำนวนอาหาร'),
                    MinLengthValidator(1, errorText: 'จำนวนอาหารต้องมีอย่างน้อย 1 จาน'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'จำนวน',
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan[900]),
                    onPressed: () {
                      var count = foddProvider.foods.length;
                      var name = nameController.text;
                      var cal = double.parse(calController.text);
                      var amout = int.parse(amountController.text);
                      Foods foods = Foods(id: count,name: name,calories: cal,amount: amout);
                      var provider = Provider.of<FoodProvider>(context, listen: false);
                      provider.addFood(foods);
                      
                      // เมื่อเพิ่มข้อมูลลงฐานข้อมูลในเครื่องแล้วจะให้ Navigator ไปยังหน้าหลักเพื่อแสดงรายการอาหาร
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => const ShowFoodScreen()
                        ),
                      );
                    }, 
                    child: const Text('ลงทะเบียน'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}