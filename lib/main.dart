import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/login.dart';

void main(async) {
  Supabase.initialize(
    url: 'https://tqczrpnnlyinoxxenzkt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxY3pycG5ubHlpbm94eGVuemt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTAxOTksImV4cCI6MjA1NDk4NjE5OX0.ZJQ6wXx_BGrMleqJNZpiK13sdcAHOnqCEu76oQBJ4ho');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Administrasi',
      theme: ThemeData(
      ),
      home: const MyHomePage());
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[200],
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()),);
          }, 
          icon: Icon(Icons.login_outlined)),
      ),
      body: Container(
        color: Colors.blueGrey[200],
        child: const Center(
          child: Text('Selamat Datang Di toko kami \n silahkan klik tombol login di kiri atas', 
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ), 
  ); 
  }
}
