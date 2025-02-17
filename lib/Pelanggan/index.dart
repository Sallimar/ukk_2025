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
      appBar: AppBar(
        title: Text('Daftar Pelanggan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Cari Pelanggan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
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
                    title: Text(item['NamaProduk']),
                    subtitle: Text('Harga: ${item['Harga']} | Stok: ${item['Stok']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> UpdateProduk(
                              produk: item, 
                              refreshProduk: fetchProduk,
                              )
                            )
                          ).then((_) => fetchProduk()),
                          icon: Icon(Icons.edit)
                        ),
                        IconButton( 
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteProduk(item['ProdukID']),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> DetailProduk(produk: item)),);
                    },
                  ),
                );
              }
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context)=>addproduk()),
          ).then((_)=> fetchProduk());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
