import 'package:flutter/material.dart';
import 'package:ukk_2025/User/insertuser.dart';
import 'package:ukk_2025/User/updateuser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserIndex extends StatefulWidget {

  @override
  _UserIndexState createState() => _UserIndexState();
}

class _UserIndexState extends State<UserIndex> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String,dynamic>> user = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await supabase.from('user').select();
    setState(() {
      user = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> deleteUser(int id) async {
    await supabase.from('user').delete().eq('id', id);
    fetchUsers();
  }

  @override 
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 252, 216, 255),
      appBar: AppBar(
        title: const Text('Daftar User'),
        backgroundColor: const Color.fromARGB(255, 252, 216, 255),
        ),
      body: ListView.builder(
        itemCount: user.length,
        itemBuilder: (context, index) {
          final userItem = user[index];
          return Card(
            color: const Color.fromARGB(255, 202, 189, 241),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
            title: Text(userItem['username']),
            subtitle: const Text('******'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>
                    Updateuser(user: userItem, 
                    refreshUsers:fetchUsers,
                    ),
                  ),
                  ), 
                  icon: const Icon(Icons.edit, color: Colors.blueAccent,),
                ),
                IconButton(
                  onPressed: () => deleteUser(userItem['id']), 
                  icon: const Icon(Icons.delete, color: Colors.redAccent,)
                )
              ],
            ),
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> Insertuser(refreshUsers: fetchUsers)),
          )),
    );
  }
}