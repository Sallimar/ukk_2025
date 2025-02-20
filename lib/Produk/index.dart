import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Produk/detailproduk.dart';
import 'package:ukk_2025/Produk/insert.dart';
import 'package:ukk_2025/Produk/update.dart';

class ProdukIndex extends StatefulWidget {

  @override 
  _ProdukIndexState createState() => _ProdukIndexState();
}

class _ProdukIndexState extends State<ProdukIndex> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String,dynamic>> produk = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchProduk();

  }

  Future<void> fetchProduk() async {
    try {
      final response = await supabase.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching produk: $e');
      
    }
  }

  Future<void> deleteProduk(int id) async {
    await supabase.from('produk').delete().eq('ProdukID', id);
    fetchProduk();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> filteredProduk = produk
      .where((item) =>
        item['NamaProduk'].toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();
      
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 216, 255),
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        backgroundColor: Color.fromARGB(255, 252, 216, 255),
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari Produk...',
                prefixIcon: const Icon(Icons.search, color: Colors.black,),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredProduk.isEmpty
            ? Center(child: Text('Produk tidak ditemukan'))
            : ListView.builder(
              itemCount: filteredProduk.length,
              itemBuilder: (context, index) {
                final item = filteredProduk[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item['NamaProduk'], style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    subtitle: Text('Harga: ${item['Harga']} | Stok: ${item['Stok']}', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),),
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
                          icon: Icon(Icons.edit, color: Colors.blueAccent,)
                        ),
                        IconButton( 
                        icon: Icon(Icons.delete, color: Colors.redAccent,),
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
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
