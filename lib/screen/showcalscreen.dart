/* หน้านี้เป็นหน้าแสดงแคลลอรี่ของคนๆนี้ */

import 'package:flutter/material.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ShowCalScreen extends StatefulWidget {
  const ShowCalScreen({Key? key}) : super(key: key);

  @override
  State<ShowCalScreen> createState() => _ShowCalScreenState();
}

class _ShowCalScreenState extends State<ShowCalScreen> {
  double weight = 55.4;
  int height = 167;
  int age = 22;
  int calsNow =
      800; // แคลลอรี่ที่เหลือในวันนี้ ต้องมาจากหน้าเพิ่มอาหารในฐานข้อมูล
  int cals = 0; // แคลเลอรี่ BMR
  int calNone = 0; // ไม่ออกกำลังกายเลย
  int cal_1to3day = 0; // แคลเลอรี่รวมถ้าเราออกกำลังกาย 1-3 วันต่อสัปดาห์
  int cal_4to5day = 0; // แคลเลอรี่รวมถ้าเราออกกำลังกาย 4-5 วันต่อสัปดาห์
  int cal_6to7day = 0; // แคลเลอรี่รวมถ้าเราออกกำลังกาย 6-7 วันต่อสัปดาห์
  int cal_2perday = 0; // แคลเลอรี่รวมถ้าเราออกกำลังกาย 2 ครั้งต่อวัน
  int carb = 0; // คาร์โบไฮเดรต
  int pro = 0; // โปรตีน
  int fat = 0; // ไขมัน
  double circlePercent = 0;

  @override
  void initState() {
    super.initState();
    getCals(weight, height, age);
    getNutrients();
    calRemain(calsNow, calNone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: const Text('หน้าแสดงแคลลอรี่')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              CircularPercentIndicator(
                radius: 160.0,
                lineWidth: 20,
                animation: true,
                arcType: ArcType.HALF,
                percent: circlePercent,
                arcBackgroundColor: Colors.grey.withOpacity(0.3),
                startAngle: 270,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Theme.of(context).primaryColor,
                center: Column(
                  children: [
                    Container(height: 50),
                    Text(
                      weight.toString() + ' kg', // แสดงน้ำหนัก
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      age.toString() +
                          ' year  ' +
                          height.toString() +
                          ' cm', // แสดงอายุกับส่วนสูง
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20.0,
                      ),
                    ),
                    const Icon(
                      Icons.male,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              Text('แคลลอรี่ BMR: '+cals.toString()+' แคล'),
              Text(
                'แคลลอรี่คนไม่ออกกำลังกาย: '+calNone.toString()+' แคล',
              ),
              Text(
                'แคลลอรี่คนออกกำลังกาย 1-3 วัน: '+cal_1to3day.toString() +' แคล',
              ),
              Text(
                'แคลลอรี่คนออกกำลังกาย 4-5 วัน: '+cal_4to5day.toString() +' แคล',
              ),
              Text(
                'แคลลอรี่คนออกกำลังกาย 6-7 วัน: '+cal_6to7day.toString()+' แคล',
              ),
              Text(
                'แคลลอรี่คนออกกำลังกาย 2 ครั้งต่อวัน: '+cal_2perday.toString()+' แคล',
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://img.lovepik.com/free-png/20210924/lovepik-cartoon-avocado-png-image_401366645_wh1200.png'),
                          backgroundColor: Colors.green,
                          radius: 40,
                        ),
                        Text(
                          'ไขมัน: ' + fat.toString() + ' กรัม ',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://www.clipartmax.com/png/middle/99-993803_cartoon-steak-background-beef-cartoon-meat-protein-cartoon-beef.png'),
                          backgroundColor: Colors.redAccent,
                          radius: 40,
                        ),
                        Text(
                          'โปรตีน: ' + pro.toString() + ' กรัม ',
                          style: const TextStyle(fontSize: 13)
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://flyclipart.com/thumb2/carbohydrates-clipart-free-clip-art-images-197710.png'),
                          backgroundColor: Colors.brown,
                          radius: 40,
                        ),
                        Text(
                          'คาร์โบไฮเดตร: ' + carb.toString() + ' กรัม ',
                          style: const TextStyle(fontSize: 13)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calRemain(int calnow, int calnone) {
    /* คำนนวณเป็นเปอร์เซ็นง่ายๆ สมมุติ แคลปัจจุบันคือ 800 ถ้าเลือกไม่ออกกำลังกายเลย แคลจะเท่ากับ 1792
     800/1792=0.4464285714285714 เปอร์เซ็น
    */
    double cirper = calnow / calnone;
    if (cirper > 1) {
      setState(() {
        circlePercent =
            cirper - 1.0; // ต้องไปจัดการว่าค่าแคลลอรี่ที่เหลือจะเอายังไง
      });
    } else {
      setState(() {
        circlePercent = cirper;
      });
    }
  }

  void getCals(double wei, int hei, int age) {
    // https://www.lokehoon.com/app.php?q_id=calculate_bmr_tdee
    // https://www.calculator.net/bmr-calculator.html
    int cal = (10 * wei + 6.25 * hei - 5 * age + 5).round();
    setState(() {
      cals = cal;
      calNone = (cal * 1.2).round();
      cal_1to3day = (cal * 1.375).round();
      cal_4to5day = (cal * 1.55).round();
      cal_6to7day = (cal * 1.7).round();
      cal_2perday = (cal * 1.9).round();
    });
  }

  void getNutrients() {
    // https://www.womenshealthmag.com/uk/food/weight-loss/a706111/counting-calculate-macros/#:~:text=To%20work%20out%20how%20many%20grams%20of%20each%20you%20need,grams%20of%20each%20to%20eat.
    setState(() {
      carb = ((cals * 0.3) / 4)
          .round(); // คำนวณคาร์โบไฮเดตรโดยคิดเป็น 30% ในวันนี้
      pro = ((cals * 0.4) / 4).round(); // คำนวณโปรตีนโดยคิดเป็น 40% ในวันนี้
      fat = ((cals * 0.3) / 9).round(); // คำนวณไขมันโดยคิดเป็น 30% ในวันนี้
    });
  }
}
