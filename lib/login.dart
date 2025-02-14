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
  const Login ({super.key});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameprdk = TextEditingController();
  final _passwordprdk = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isPasswordVisible = false;
  
  Future<void> _Login() async {
    final username = _usernameprdk.text;
    final password = _passwordprdk.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap isi semua field')),
      );
      return;
    }

    try{
      final response = await supabase 
      .from('user')
      .select('username, password')
      .eq('username', username)
      .single();

      if (response != null && response['password'] == password) {
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Login Berhasil'),)
        );
        if (response['role'] == 'admin')  {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context)=> Beranda()),
          );
        } else {
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Username atau Password Salah')),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20,),
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