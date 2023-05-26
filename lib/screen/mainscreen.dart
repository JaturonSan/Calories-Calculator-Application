import 'package:flutter/material.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/screen/addfoodscreen.dart';
import 'package:mini_project/screen/showcalscreen.dart';
import 'package:mini_project/screen/showfoodscreen_2.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// การส่งค่าระหว่าง StatefulWidget -- https://medium.com/swlh/the-simplest-way-to-pass-and-fetch-data-between-stateful-and-stateless-widgets-pages-full-2021-c5dbce8db1db
class MainScreen extends StatefulWidget {
  final Widget title; // การส่งค่าระหว่าง StatefulWidget
  final Widget page; // การส่งค่าระหว่าง StatefulWidget
  final int index;
  final Color backgroundColor;
  const MainScreen(this.title, this.page,this.index, this.backgroundColor, {Key? key}) : super(key: key); // การส่งค่าระหว่าง StatefulWidget
  

  @override
  // ignore: no_logic_in_create_state
  State<MainScreen> createState() => _MainScreenState(title: title, page: page,index: index, backgroundColor: backgroundColor); // การส่งค่าระหว่าง StatefulWidget
}

class _MainScreenState extends State<MainScreen> {
  Widget title; // การส่งค่าระหว่าง StatefulWidget
  Widget page; // การส่งค่าระหว่าง StatefulWidget
  int index; 
  Color backgroundColor;
  _MainScreenState({required this.title,required this.page, required this.index, required this.backgroundColor}); // การส่งค่าระหว่าง StatefulWidget
  int _selectedBottomNavigationIndex = 0; // ตัวแปรไว้เก็บว่าตอนนี้ผู้ใช้เลือกตัวไหนของบาร์ด้านล่างอยู่
  //Color? backgroundcolor = Colors.cyan[900]; // ตัวแปรเก็บสีพื้นหลังของแอป
  late Widget _page1; // ตัวแปรเก็บหน้าที่ 1 (หน้าหลัก) ไว้ใช้ใน BottomNavigationBar
  final Widget _page2 = const ShowCalScreen(); // ตัวแปรเก็บหน้าที่ 2 (หน้าแสดงแคลลอรี่) ไว้ใชใน BottomNavigationBar
  final Widget _page3 = const ShowFoodScreen2(); // ตัวแปรเก็บหน้าที่ 3 (หน้าแสดงรายการอาหาร) ไว้ใชใน BottomNavigationBar
  final Widget _page4 = const AddFoodScreen(); // ตัวแปรเก็บหน้าที่ 4 (หน้าเพิ่มรายการอาหาร) ไว้ใชใน BottomNavigationBar
  late Widget _currentPage; // ตัวแปรไว้เก็บว่าหน้าปัจจุบันตอนนี้คือหน้าไหน
  late Widget _currentTitle; // ตัวแปรไว้เก็บว่า title ของ Scaffold ปัจจุบันตอนนี้คืออะไร
  late List<Widget> _pages; // ตัวแปรไว้เก็บ List<Widget> ของหน้าทั้งหมดที่จะมีใน BottomNavigationBar
  static const List<Widget> _titlePage = <Widget>[Text("หน้าหลัก"), Text("แคลลอรี่"), Text("อาหาร"), Text("เพิ่มอาหาร")]; // ตัวแปรไว้เก็บหัวข้อของ Scaffold ทั้งหมดที่จะมีใน BottomNavigationBar

  // เรียกสีแอปหลักจาก SharedPreferences
  void getAppColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
    });
  }

  // ฟังก์ชั่นตอนที่เรากดเปลี่ยน BottomNavigationBar แล้วจะเปลี่ยนค่าต่างๆ
  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomNavigationIndex = index;
      _currentPage = _pages[index];
      _currentTitle = _titlePage[index];
    });
  }

  @override
  void initState() {
    super.initState();
    _page1 = MainPage(backgroundColor);

    _selectedBottomNavigationIndex = index;
    _currentPage = page;
    _pages = [_page1, _page2, _page3, _page4];
    _currentTitle = title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentTitle,
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              // ใช้ refresh หน้านี้
              setState(() {
                _selectedBottomNavigationIndex = 3;
                _currentPage = _pages[3];
                _currentTitle = _titlePage[3];
              });
            }, 
            icon: const Icon(Icons.fastfood)
          ),
          IconButton(
            onPressed: () async {
              // แจ้งเตือนผู้ใช้ว่าจะลบข้อมูลอาหารหรือไม่
              await showDialog<String>(
                context: context,
                // ป้องกันผู้ใช้กดออกจากหน้าโหลดโดยคลิ้กข้างๆ showdialog
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('จะลบข้อมูลอาหารของคุณหรือไม่'),
                  content: const Text("ถ้าดำเนินการต่อไปจะเป็นการลบข้อมูลอาหารของคุณ"),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        var provider = Provider.of<FoodProvider>(context, listen: false);
                        // เรียกฟังก์ชั่นลบข้อมูลทั้งที่อยู่ในฐานข้อมูล NoSQL
                        provider.deleteAllData("user_foods.db"); // ฐานข้อมูลอาหารที่ผู้ใช้ใส่เข้ามา
                        //provider.deleteAllData("foods.db"); // ฐานข้อมูลอาหารในแอป ไว้ตอนค้นหาอาหารเข้ารายการอาหาร

                        // ใช้ refresh 
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                              return MainScreen(const Text("อาหาร"), const ShowFoodScreen2(), 2, backgroundColor);
                            },
                          )
                        );
                      },
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      drawer: const SideMenu(),
      onDrawerChanged: (val) {
        getAppColor();
      },
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavigationIndex,
        selectedItemColor: Colors.white,
        backgroundColor: backgroundColor,
        type: BottomNavigationBarType.fixed, // ใน BottomNavigationBar ถ้าอยากให้ Items มีมากกว่า 3 ค่าต้องเซ็ตค่านี้ด้วย
        onTap: (index) {
          // ขึ้นหน้าโหลดง่ายๆ
          showDialog(
            context: context, 
            // ป้องกันผู้ใช้กดออกจากหน้าโหลดโดยคลิ้กข้างๆ showdialog
            barrierDismissible: false,
            builder: (context) {
              return const Center(child: CircularProgressIndicator(),);
            }
          );

          _onItemTapped(index);

          // เอาหน้าโหลดออก
          Navigator.of(context).pop();
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "หน้าหลัก",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "แคลลอรี่",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "อาหาร",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "เพิ่มอาหาร",
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final Color backgroundColor;
  const MainPage(this.backgroundColor, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MainPage> createState() => _MainPageState(backgroundColor: backgroundColor);
}

// แบ่งหน้าออกจาก Scaffold อย่างชิ้นเชิง เพื่อสร้าง BottomNavigationBar
class _MainPageState extends State<MainPage> {
  Color backgroundColor;
  _MainPageState({required this.backgroundColor});
  SizedBox box = const SizedBox(height: 20,width: 20,); 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.cyan[100],
              child: ListTile(
                hoverColor: Colors.cyan,
                title: const Text('กินอาหาร'),
                subtitle: Text('มนุษย์เราต้องการพลังงานในการใช้ชีวิต เพิ่มอาหารที่คุณกินในชีวิตประจำวัน', style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                leading: const Icon(Icons.restaurant),
                trailing: const Image(
                  image: AssetImage('assets/fastfood.png'),
                  // width: 250,
                  // height: 250,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => MainScreen(const Text("เพิ่มอาหาร"), const AddFoodScreen(), 3, backgroundColor)),
                  ); 
                },
              ),
            ),
            box,
            Card(
              color: Colors.cyan[100],
              child: ListTile(
                hoverColor: Colors.cyan,
                title: const Text('รายการอาหาร'),
                subtitle: Text('อาหารที่เรากินในแต่ละวัน', style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                leading: const Icon(Icons.fastfood),
                trailing: const Image(
                  image: AssetImage('assets/vegetable.jpg'),
                  // width: 250,
                  // height: 250,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => MainScreen(const Text("อาหาร"), const ShowFoodScreen2(), 2, backgroundColor)
                    ),
                  ); 
                },
              ),
            ),
            box,
            Card(
              color: Colors.cyan[100],
              child: ListTile(
                hoverColor: Colors.cyan,
                title: const Text('แคลลอรี่'),
                subtitle: Text('เมื่อเรากินอาหารเข้าไป อาหารเหล่านั้นจะเพิ่มพลังงานเป็นหน่วยแคลลอรี่ เราไม่ควรกินเกินตามความต้องการของร่างกาย', style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                leading: const Icon(Icons.fastfood),
                trailing: const Image(
                  image: AssetImage('assets/children.png'),
                  // width: 250,
                  // height: 250,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => MainScreen(const Text("แคลลอรี่"), const ShowCalScreen(), 1, backgroundColor)
                    ),
                  ); 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}