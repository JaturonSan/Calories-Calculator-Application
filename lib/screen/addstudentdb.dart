import 'package:flutter/material.dart';
import 'package:mini_project/model/student_intel.dart';

class AddStudentScreen extends StatelessWidget {
  AddStudentScreen({ Key? key }) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(); 
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ข้อมูลเด็กนักเรียน')),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'ชื่อ-นามสกุล'),
              autofocus: true,
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'อายุ'),
              controller: ageController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'ความสูง'),
              controller: heightController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'น้ำหนัก'),
              controller: weightController,
            ),
            TextButton(
              onPressed: (){
                var name = nameController.text;
                var age = ageController.text;
                var height = heightController.text;
                var weight = weightController.text;
                StudentDB student = StudentDB(
                  name: name,
                  age: int.parse(age),
                  height: double.parse(height),
                  weight: double.parse(weight)
                );
              }, 
              child: Text('เพิ่มข้อมูล'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 20),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}