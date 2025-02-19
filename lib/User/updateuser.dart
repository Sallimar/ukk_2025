import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Updateuser extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function refreshUsers;
  Updateuser({required this.user, required this.refreshUsers});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<Updateuser> {
  final SupabaseClient supabase = Supabase.instance.client;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user['username']);
    passwordController = TextEditingController(text: widget.user['password']);
  }

  Future<void> Updateuser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Input tidak boleh kosong')),);
      return;
    }

    await supabase.from('user').update({'username': username, 'password': password}).eq('id', widget.user['id']);
    widget.refreshUsers();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: const InputDecoration( labelText: 'Username')),
             TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true,),
            const SizedBox(height: 10,),
             ElevatedButton(onPressed: Updateuser, child:const Text('Update')),
          ],
        ),
        ),
    );
  }
}