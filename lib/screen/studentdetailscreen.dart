import 'package:flutter/material.dart';
import 'package:mini_project/database/student_db.dart';
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
  StudentDB studentdb = StudentDB(dbName: "students.db");

  // initSate เป็นฟังก์ชั่นในการเริ่มฟังก์ชั่นต่างๆก่อนสร้างหน้าขึ้น เพื่อเตียมข้อมูลที่จะแสดงผลไว้ก่อน เพื่อไม่ให้เกิดค่าว่าง หรือหน้าไม่ยอมโหลด
  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    var provider = Provider.of<StudentProvider>(context, listen: false);
    provider.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('รายละเอียดนักเรียน'),
        backgroundColor: Colors.cyan[900],
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddStudentScreen();
              }));
            },
            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () async {
              var provider = Provider.of<StudentProvider>(context, listen: false);
              // เรียกฟังก์ชั่นลบข้อมูลทั้งที่อยู่ในฐานข้อมูล NoSQL
              provider.deleteAllData();

              // ใช้ refresh หน้านี้
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DetailStuScreen()),
                (Route<dynamic> route) => false,
              );
            }, 
            icon: Icon(Icons.delete),
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
                              var provider = Provider.of<StudentProvider>(context, listen: false);
                              provider.deleteStudent(data);
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