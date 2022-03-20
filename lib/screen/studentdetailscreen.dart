import 'package:flutter/material.dart';
import 'package:mini_project/screen/addstudentscreen.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:provider/provider.dart';

import '../model/student_intel.dart';
import '../providers/srudent_provider.dart';

class DetailStuScreen extends StatefulWidget {
  const DetailStuScreen({ Key? key }) : super(key: key);

  @override
  State<DetailStuScreen> createState() => _DetailStuScreenState();
}

class _DetailStuScreenState extends State<DetailStuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('รายละเอียดนักเรียน'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddStudentScreen();
              }));
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, StudentProvider provider, child) {
          var count = provider.students.length;

          /*  เช็ค if -> else 
          1.ถ้า count <= 0 คือไม่มีข้อมูลจะแสดงข้อความว่าไม่มีข้อมูล
          2.ถ้าเป็นอย่างอื่นจะแสดงหน้าขึ้นมาพร้อมรายการนักเรียน
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
              itemCount: provider.students.length,
              itemBuilder: (context, int index) {
                Students data = provider.students[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: FittedBox(
                        child: Text('อายุ: '+data.age.toString()), // ตรงนี้โชว์อายุในวงกลม
                      ),
                    ),
                    title: Text(data.name!), // โชว์ชื่อ-นามสกุล
                    subtitle: Text('น้ำหนัก: '+data.weight.toString()), // โชว์น้ำหนัก (ส่วนสูงยังไม่รูจะแสดงยังไง)
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