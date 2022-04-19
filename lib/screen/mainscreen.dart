import 'package:flutter/material.dart';
import 'package:mini_project/screen/addfoodscreen.dart';
import 'package:mini_project/screen/showcalscreen.dart';
import 'package:mini_project/screen/sidemenu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedBottomNavigationIndex = 0; // ตัวแปรไว้เก็บว่าตอนนี้ผู้ใช้เลือกตัวไหนของบาร์ด้านล่างอยู่
  Color? backgroundcolor = Colors.cyan[900]; // ตัวแปรเก็บสีพื้นหลังของแอป
  final Widget _page1 = const MainPage(); // ตัวแปรเก็บหน้าที่ 1 (หน้าหลัก) ไว้ใชใน BottomNavigationBar
  final Widget _page2 = const ShowCalScreen(); // ตัวแปรเก็บหน้าที่ 2 (หน้าแสดงแคลลอรี่) ไว้ใชใน BottomNavigationBar
  late Widget _currentPage; // ตัวแปรไว้เก็บว่าหน้าปัจจุบันตอนนี้คือหน้าไหน
  late Widget _currentTitle; // ตัวแปรไว้เก็บว่า title ของ Scaffold ปัจจุบันตอนนี้คืออะไร
  late List<Widget> _pages; // ตัวแปรไว้เก็บ List<Widget> ของหน้าทั้งหมดที่จะมีใน BottomNavigationBar
  static const List<Widget> _titlePage = <Widget>[Text("หน้าหลัก"), Text("แสดงแคลลอรี่")]; // ตัวแปรไว้เก็บว่า title ของ Scaffold ทั้งหมดที่จะมีใน BottomNavigationBar

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
    _currentPage = _page1;
    _pages = [_page1, _page2];
    _currentTitle = _titlePage[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentTitle,
        backgroundColor: backgroundcolor,
      ),
      drawer: const SideMenu(),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavigationIndex,
        selectedItemColor: Colors.white,
        backgroundColor: backgroundcolor,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "หน้าหลัก",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "แสดงแคลลอรี่",
          ),
        ],
      ),
    );
  }
}


// แบ่งหน้าออกจาก Scaffold อย่างชิ้นเชิง เพื่อสร้าง BottomNavigationBar
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  Image(
                    image: AssetImage('assets/children.png'),
                    width: 250,
                    height: 250,
                  ),
                  Image(
                    image: AssetImage('assets/fastfood.png'),
                    width: 250,
                    height: 250,
                  ),
                  Image(
                    image: AssetImage('assets/vegetable.jpg'),
                    width: 250,
                    height: 250,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFood()));
              },
              child: const Text(
                'เริ่มต้น',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}