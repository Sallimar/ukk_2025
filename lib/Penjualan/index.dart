import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Pelanggan/strukbelanjan.dart';

class PenjualanIndex extends StatefulWidget {
  @override 
  _PenjualanIndexState createState()=> _PenjualanIndexState();
}

class _PenjualanIndexState extends State<PenjualanIndex> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> selectedProduk = [];

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> simpanTransaksi() async{
    try {
      print("Memulai penyimpanan transaksi...");

      //simpan ke tabel 'penjualan'
      final penjualanResponse = await supabase.from('penjualan').insert({
        'TanggalPenjualan': DateTime.now().toIso8601String(),
        'TotalHarga': selectedProduk.fold(0, (sum, item) {
          int harga = item['Harga'] ?? 0;
          int jumlah = item ['JumlahProduk'] ?? 0;
          return sum + (harga * jumlah);
        }),
        'PelangganID':1,
      }).select().single();

      print("Data penjualan berhasil disimpan: $penjualanResponse");
      int penjualanID = penjualanResponse['PenjualanID'];

      //simpan ke tabel detail_penjualan
      List<Map<String, dynamic>> detailpenjualan = selectedProduk.map((item) {
        return {
          'PenjualanID': penjualanID,
          'ProdukID': item['ProdukID'],
          'JumlahProduk': item['JumlahProduk'],
          'Subtotal': (item['Harga'] ?? 0) * (item['JumlahProduk'] ?? 0),
        };
      }).toList();

      await supabase.from('detailpenjualan').insert(detailpenjualan);
      print("Data detail Penjualan berhasil disimpan");

      //pindah ke halaman struk
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=> StrukPage(
            selectedProduk: selectedProduk, 
            totalHarga: penjualanResponse['TotalHarga'],
      )
     )
     );
    } catch (e) {
      print("eror saat menyimpan transaksi: $e");
    }
  }

  Future<void> fetchProduk() async {
    try {
      print("Mengambil data produk dari supabase...");
      final response = await supabase.from('produk').select();
      print("Response dari Supabase: $response");
      if (response == null || response.isEmpty) {
        print("Tidak ada data produk di database");
      }
      setState(() {
        produk= List<Map<String, dynamic>>.from(response);
      });

      print("data produk setelah si-set:$produk");
    } catch(e) {
      print("eror saat mengambil produk dari supabase: $e");
    }
  }

   // mengelola jumlah produk
  void toggleSelection(Map<String, dynamic> item, bool isSelected, {int quantity = 1}) {
    setState(() {
      if (isSelected) {
        selectedProduk.add({...item, 'JumlahProduk': quantity});
      } else {
        selectedProduk.removeWhere((p) => p['ProdukID'] == item['ProdukID']);
      }
    });
    print("Produk terpilih: $selectedProduk");
  }
     //mengupdate jumlah produk
     void updateQuantity(Map<String,dynamic> item, int quantity) {
      setState(() {
        final index = selectedProduk.indexWhere((p) => p['ProdukID'] == item['ProdukID']);
        if (index != -1 && quantity >0) {
          selectedProduk[index]['JumlahProduk'] = quantity;
        }
      });
     }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 146, 212, 248),
      appBar: AppBar(title:const Text('Pilih Produk'),
      backgroundColor: Color.fromARGB(255, 146, 212, 248),
      ),
      body: ListView.builder(
        itemCount: produk.length,
        itemBuilder: (context, index) {
          final item = produk[index];
          Text(item['NamaProduk']);
          Text('Harga: Rp ${item['Harga']} | Stok: ${item['Stok']}');
          bool isSelected = selectedProduk.any((p) => p['ProdukID'] == item['ProdukID']);
          int quantity = isSelected
            ? selectedProduk.firstWhere((p) => p['ProdukID'] == item['ProdukID'])['JumlahProduk']
            : 1;

            return ListTile(
              title: Text (item['NamaProduk']),
              subtitle: Text('Harga: Rp ${item['Harga']} | Stok: ${item['Stok']}'),
              trailing: isSelected
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:const Icon(Icons.remove),
                          onPressed: () {
                            if (quantity >1) {
                              updateQuantity(item, quantity -1);
                            }
                          }, 
                          ),
                          Text('$quantity'),
                          IconButton(
                            onPressed: () {
                              updateQuantity(item, quantity +1);
                            }, 
                            icon: const Icon(Icons.add),
                        )
                      ],
                    )
                    : IconButton(
                          icon: const Icon(Icons.add_shopping_cart,),
                          onPressed: () {
                            toggleSelection(item, true, quantity: 1);
                          },
                          ),
                          onTap: () {
                            if (isSelected) {
                              toggleSelection(item, !isSelected);
                            } else {
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  int selectedQty = 1;
                                  return AlertDialog(title: Text('Masukkan Jumlah Produk'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Jumlah:'),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          selectedQty = int.tryParse(value) ?? 1;
                                        },
                                        decoration: InputDecoration(hintText: 'Jumlah Produk'),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        toggleSelection(item, true, quantity: selectedQty);
                                        Navigator.pop(context);
                                      }, 
                                      child: Text('Konfirmasi'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context), 
                                      child: Text('Batal'),
                                    ),
                                  ],
                                  );
                                },
                              );
                            }
                          },
                         );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selectedProduk.isEmpty ? null : () async {
          await simpanTransaksi();
        }, 
        label: Text('Lanjutkan'),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: selectedProduk.isEmpty ? Colors.grey : Colors.green,
        ),
    );
  }
}