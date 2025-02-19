import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Insertuser extends StatefulWidget {
  final Function refreshUsers;
  Insertuser({required this.refreshUsers});

  @override
  _insertUserState createState() => _insertUserState();
}

class _insertUserState extends State<Insertuser> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> addUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Input tidak boleh kosong')));
      return;
    }

    final existingUser = await supabase.from('user').select().eq('username', username);

    if (existingUser.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User sudah ada')));
      return;
    }

    await supabase.from('user').insert({'username': username, 'password': password});
    widget.refreshUsers();
    Navigator.pop(0);
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 202, 189, 241),
      appBar: AppBar(title: Text('Tambah User'),
      backgroundColor: Color.fromARGB(255, 202, 189, 241),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'username')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'password'), obscureText: true,),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: addUser, child: Text('Tambah'))
          ],
        ),
        ),
    );
  }
}