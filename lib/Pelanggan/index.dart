import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Pelanggan/insert.dart';
import 'package:ukk_2025/Pelanggan/update.dart';

class PelangganIndex extends StatefulWidget {

  @override 
  _PelangganIndexState createState() => _PelangganIndexState();
}

class _PelangganIndexState extends State<PelangganIndex> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController searchController =TextEditingController();
  List<Map<String,dynamic>> pelanggan = [];
  List<Map<String,dynamic>> filteredPelanggan = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();

  }

  Future<void> fetchPelanggan() async {
      final response = await supabase.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        filteredPelanggan = pelanggan;
    });
  }
  void filterPelanggan(String query) {
    setState(() {
      filteredPelanggan = pelanggan
      .where((item) => 
       item['NamaPelanggan'].toString().toLowerCase().contains(query.toLowerCase()))
       .toList();
    });
  }

  Future<void> deletePelanggan(int id) async {
    await supabase.from('pelanggan').delete().eq('PelangganID', id);
    fetchPelanggan();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 252, 216, 255),
    appBar: AppBar(title: Text('Daftar Pelanggan'),
    backgroundColor: const Color.fromARGB(255, 252, 216, 255),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Cari Pelanggan',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(Icons.search, color: Colors.black),
            ),
            onChanged: filterPelanggan,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredPelanggan.length,
            itemBuilder: (context, index) {
              final item = filteredPelanggan[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                title: Text(item['NamaPelanggan'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                subtitle: Text('Alamat: ${item['Alamat']} | Telepon: ${item['NomorTelepon']}',style: TextStyle(fontSize: 16, color: Colors.black) ,),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> UpdatePelanggan(
                          pelanggan: item, 
                          refreshPelanggan: fetchPelanggan,
                      )
                      )
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => deletePelanggan(item['PelangganID']),
                    )
                   ],
                  ),
                )
                 );
                }
               )
              )
             ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.black),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> InsertPelanggan(refreshPelanggan: fetchPelanggan),
             ),
            ),
           ),
           );
          }
         }