import 'package:flutter/material.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/providers/profile_provider.dart';
import 'package:mini_project/providers/srudent_provider.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/registerscreen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ProfileProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return FoodProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return StudentProvider();
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late String username;
  late String userpass;

  // ฟังก์ชั่นในการประกาศข้อมูลที่มาจากฐานข้อมูลเพื่อเตรียมแสดงผลโดยใช้ TransactionProvider
  @override
  void initState(){
    super.initState();
    Provider.of<FoodProvider>(context, listen: false).initData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('หน้าเข้าสู่ระบบ'), backgroundColor: Colors.cyan[900],),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/user_icon.png"),
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  onChanged: (name){
                    username = name;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อผู้ใช้',
                    labelStyle: TextStyle(fontSize: 15,),
                  ),
                ),
                const SizedBox(height: 15,),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (password){
                    userpass = password;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'รหัสผ่าน',
                    labelStyle: TextStyle(fontSize: 15,),
                  ),
                ),
                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan[900]),
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                          return const MainScreen();
                        },)
                      );
                    }, 
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ),
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan[900]),
                    onPressed: () {
                      // ต้องแก้ส่วนนี้ตอนล็อกอินว่าจะต้องเช็คบัญชีผู้ใช้
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) {
                          return RegisterScreen();  
                        },)
                      );
                    }, 
                    child: const Text('สร้างบัญชีใหม่'),
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