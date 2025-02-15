import 'package:flutter/material.dart';
import 'package:ukk_2025/beranda.dart';
import 'package:ukk_2025/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tqczrpnnlyinoxxenzkt.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxY3pycG5ubHlpbm94eGVuemt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTAxOTksImV4cCI6MjA1NDk4NjE5OX0.ZJQ6wXx_BGrMleqJNZpiK13sdcAHOnqCEu76oQBJ4ho');

    runApp(const MyApp());
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isPasswordVisible = false;
  
  Future<void> _Login() async {
      final String username = usernameController.text.trim();
      final String password = passwordController.text.trim();
      
    try{
      final response = await supabase 
      .from('user')
      .select('id, username, password')
      .eq('username', username)
      .single();

      if (response != null && response['password'] == password) {
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Login Berhasil'),)
        );
        if (response['user'] == 'user')  {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context)=> Beranda()),
          );
        } else {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context)=> Beranda(),),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Harap isi semua field'),)
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(content: Text('masih ada kesalahan'),));
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Container(
        width: double.infinity,
        color: Colors.purple[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80,),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(Icons.person),
                  hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
           ),
           const SizedBox(height: 20),
           ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Beranda()),);
            }, 
            child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}