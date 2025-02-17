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
      appBar: AppBar(
        title: Text('Daftar User'),),
      body: ListView.builder(
        itemCount: user.length,
        itemBuilder: (context, index) {
          final userItem = user[index];
          return ListTile(
            title: Text(userItem['username']),
            subtitle: Text('******'),
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
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => deleteUser(userItem['id']), 
                  icon: Icon(Icons.delete)
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> Insertuser(refreshUsers: fetchUsers)),
          )),
    );
  }
}