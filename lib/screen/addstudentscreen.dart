import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/model/student_intel.dart';
import 'package:mini_project/providers/srudent_provider.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:mini_project/screen/studentdetailscreen.dart';
import 'package:provider/provider.dart';

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
      drawer: const SideMenu(),
      appBar: AppBar(title: const Text('เพิ่มข้อมูลเด็กนักเรียน')),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const Text('ชื่อ-นามสกุล'),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: nameController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'กรุณาป้อนชื่อ-นามสกุล'),
              ]),
            ),
            const Text('อายุ'),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: ageController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'กรุณาป้อนอายุ'),
              ]),
            ),
            const Text('ส่วนสูง'),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: heightController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'กรุณาป้อนส่วนสูง'),
              ]),
            ),
            const Text('น้ำหนัก'),
            TextFormField(
              keyboardType: TextInputType.name,
              controller: weightController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'กรุณาป้อนน้ำหนัก'),
              ]),
            ),
            TextButton(
              onPressed: (){
                var name = nameController.text;
                var age = ageController.text;
                var height = heightController.text;
                var weight = weightController.text;
                Students student = Students(
                  name: name,
                  age: int.parse(age),
                  height: int.parse(height),
                  weight: double.parse(weight)
                );
                var provider = Provider.of<StudentProvider>(context, listen: false);
                provider.addStudent(student);

                // เมื่อเพิ่มข้อมูลลงฐานข้อมูลในเครื่องแล้วจะให้ Navigator ไปยังหน้าหลักเพื่อแสดงรายการนักเรียน
                Navigator.pushReplacement(
                  context, MaterialPageRoute(
                    builder: (context) => const DetailStuScreen()
                  ),
                );
              }, 
              child: const Text('เพิ่มข้อมูล'),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}