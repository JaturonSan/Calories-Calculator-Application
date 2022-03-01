import 'package:flutter/material.dart';
import 'package:mini_project/providers/profile_provider.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/registerscree.dart';
import 'package:path/path.dart';
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.blue),
        home: LoginScreen(),
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
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(this.context, listen: false).initData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('หน้าเข้าสู่ระบบ'),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset("assets/user_icon.png"),
                const Text('ชื่อผู้ใช้'),
                TextField(
                  keyboardType: TextInputType.name,
                  onChanged: (name){
                    username = name;
                  },
                ),
                const Text('รหัสผ่าน'),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (password){
                    userpass = password;
                  },
                ),
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(
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
                    onPressed: () {
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