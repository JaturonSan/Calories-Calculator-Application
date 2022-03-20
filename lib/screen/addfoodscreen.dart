import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:provider/provider.dart';

import '../providers/food_provider.dart';

class AddFood extends StatelessWidget {
  AddFood({ Key? key }) : super(key: key);
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final calController = TextEditingController();
  final amountController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: const Text('เพื่มเมนูอาหาร')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              const Text('ชื่ออาหาร'),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'กรุณาป้อนชื่ออาหาร'),
                ]),
              ),
              const Text('แคลอรี่'),
              TextFormField(
                controller: calController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'กรุณาป้อนจำนวนแคลอรี่'),
                ]),
              ),
              const Text('จำนวน'),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: amountController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'กรุณาจำนวนอาหาร'),
                  MinLengthValidator(1, errorText: 'จำนวนอาหารต้องมีอย่างน้อย 1 จาน'),
                ]),
              ),
              SizedBox(
                height: 30,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    var name = nameController.text;
                    var cal = double.parse(calController.text);
                    var amout = int.parse(amountController.text);
                    Foods foods = Foods(name: name,calories: cal,amount: amout);
                    var provider = Provider.of<FoodProvider>(context, listen: false);
                    provider.addFood(foods);
                    
                    // เมื่อเพิ่มข้อมูลลงฐานข้อมูลในเครื่องแล้วจะให้ Navigator ไปยังหน้าหลักเพื่อแสดงรายการอาหาร
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const MainScreen()
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
    );
  }
}