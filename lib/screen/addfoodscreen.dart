import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/showfoodscreen.dart';
import 'package:provider/provider.dart';

import '../providers/food_provider.dart';

class AddFood extends StatelessWidget {
  AddFood({ Key? key }) : super(key: key);
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final calController = TextEditingController();
  final proController = TextEditingController();
  final amountController = TextEditingController();
  final gramController = TextEditingController();
  final picController = TextEditingController();
  FoodProvider foddProvider = FoodProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่ออาหาร',
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: calController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนจำนวนแคลอรี่'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'แคลอรี่ (ต่อ 100 กรัม)',
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: proController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนจำนวนโปรตีน'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'โปรตีน',
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: amountController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาจำนวนอาหาร'),
                    MinLengthValidator(1, errorText: 'จำนวนอาหารต้องมีอย่างน้อย 1 จาน'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'จำนวน',
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: gramController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาน้ำหนักอาหาร'),
                    MinLengthValidator(1, errorText: 'น้ำหนักอาหารต้องมีอย่างน้อย 100 กรัม'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'กี่กรัม',
                  ),
                ),
                const SizedBox(height: 20,),
                 TextFormField( // เพิ่มฟิวเอาไว้ใส่รูป ในอนาคตจะมีการโหลดรูปจากเครื่องได้
                  keyboardType: TextInputType.name,
                  controller: picController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาใส่รูป'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'รูปอาหาร',
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan[900]),
                    onPressed: () {
                      var name = nameController.text;
                      var cal = int.parse(calController.text);
                      var pro = int.parse(proController.text);
                      var amout = int.parse(amountController.text);
                      var gram = int.parse(gramController.text);
                      var pic = picController.text;
                      Foods foods = Foods(name: name,calories: cal,protein: pro,amount: amout,gram: gram,pic: pic);
                      var provider = Provider.of<FoodProvider>(context, listen: false);
                      //provider.addFood(foods, "user_foods.db"); // เพิ่มฐานข้อมูลอาหารของ user 
                      provider.addFood(foods, "foods.db"); // เพิ่มฐานข้อมูลอาหารของแอป ไว้ตอนเพิ่มอาหารแบบค้นหาได้เลย ไม่ต้องมานั่งพิมพ์

                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const MainScreen(Text("อาหาร"), ShowFoodScreen(), 2)),
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