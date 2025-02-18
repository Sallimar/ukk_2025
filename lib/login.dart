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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isPasswordVisible = false;
  
  Future<void> _login() async {
      final String username = usernameController.text.trim();
      final String password = passwordController.text.trim();
      
      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap isi semua field')),
        );
        return;
      }
    try{
      final List<dynamic> response = await supabase
      .from('user')
      .select('id, username, password')
      .eq('username', username);

      if (response.isNotEmpty) {
        final user = response.first;
        if (user['password'] == password) {
          ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Login Berhasil')),
        );
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context)=>Beranda()),
        );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Salah')),
          );
        }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('username tidak dapat ditemukan')),
        );
      }
    } catch (e) {
    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(content: Text('Periksa kembali username dan Passwordnya')),
    );
  }
}
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 146, 209, 238),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Silahkan Login Terlebih Dahulu', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox( height: 40),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(Icons.person),
                  hintStyle: TextStyle(color: Color.fromARGB(255, 6, 4, 4)),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: "password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    ),
                    hintStyle:  const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _login, 
                child: const Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
