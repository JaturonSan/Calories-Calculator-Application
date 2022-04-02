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
  StudentProvider studentProvider = StudentProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: const Text('เพิ่มข้อมูลเด็กนักเรียน')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนชื่อ-นามสกุล'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อ-นามสกุล',
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: ageController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนอายุ'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'อายุ',
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: heightController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนส่วนสูง'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ส่วนสูง',
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: weightController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนน้ำหนัก'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'น้ำหนัก',
                  ),
                ),
                SizedBox(height: 30,),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      var count = studentProvider.students.length;
                      var name = nameController.text;
                      var age = ageController.text;
                      var height = heightController.text;
                      var weight = weightController.text;
                      Students student = Students(
                        id: count,
                        name: name,
                        age: int.parse(age),
                        height: int.parse(height),
                        weight: double.parse(weight)
                      );
                      var provider = Provider.of<StudentProvider>(context, listen: false);
                      provider.addStudent(student);
                      
                      // เมื่อเพิ่มข้อมูลลงฐานข้อมูลในเครื่องแล้วจะให้ Navigator ไปยังหน้าหลักเพื่อแสดงรายการอาหาร
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => const DetailStuScreen()
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