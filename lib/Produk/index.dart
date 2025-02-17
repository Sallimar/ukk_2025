import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      final response = await Supabase.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching produk: $e');
      
    }
  }

  Future<void> deleteProduk(int id) async {
    try {
      await Supabase.instance.client
      .from('produk')
      .delete()
      .eq('ProdukID', produkID);
      fetchProduk();
    } catch (e) {
      print('Error deleting produk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage()),);
          }, 
          icon: Icon(Icons.arrow_back)),
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator())
      : produk.isEmpty
        ? Center(
        child: Text('Tidak Ada Produk'),
      )
      : ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: produk.length,
        itemBuilder: (context, index) {
          final produkItem = produk[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> ProdukTab()//produkdetail
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produkItem['NamaProduk']?.toString() ?? 'Produk tidak tersedia',
                    ),
                    SizedBox(height: 4),
                    Text(
                      produkItem['Harga']?.toString()?? 'Harga Tidak Tersedia',
                    ),
                    SizedBox(height: 8),
                    Text(
                      produkItem['Stok']?.toString()?? 'Stok Tidak Tersedia',
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent,),
                          onPressed: () {
                            final produkID = produkItem['ProdukID'] ?? 0;
                            if (produkID != 0) {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context)=> ProdukTab() //editproduk
                                ),
                              ).then((result) {
                                if (result == true) {
                                  fetchProduk();
                                }
                              });
                            } else {
                              print('ID produk tidak valid');
                            }
                          }, 
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent,),
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Hapus Produk'),
                                  content: const Text('Apakah anda yakin ingin menghapus produk ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context), 
                                      child: const Text('Batal', style: TextStyle(fontSize: 16, color: Colors.blueAccent),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteProduk(produkItem['ProdukID']);
                                        Navigator.pop(context);
                                      }, 
                                      child: const Text('Hapus', style: TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),))
                                  ],
                                );
                              }
                            );
                          }, 
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context)=>addproduk()),
          ).then((result) {
            if (result == true) {
              fetchProduk();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
