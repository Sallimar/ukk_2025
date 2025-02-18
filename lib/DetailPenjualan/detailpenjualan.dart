import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/DetailPenjualan/detailpenjualan.dart';

class RiwayatPenjualan extends StatefulWidget {
  @override 
  _RiwayatPenjualanState createState() => _RiwayatPenjualanState();
}

class _RiwayatPenjualanState extends State<RiwayatPenjualan> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> penjualan = [];

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    try {
      final response = await supabase.from('penjualan').select();
      print("Response dari Supabase: $response");
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
      });
      print("Data penjualan yang di-set: $penjualan");
    } catch (e) {
      print(e) {
        print("Eror saat mengambil data: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchDetailPenjualan(int penjualanID) async {
    final response = await supabase
    .from('detailpenjualan')
    .select('ProdukID, JumlahProduk, Subtotal, produk(NamaProduk, Harga)')
    .eq('PenjualanID', penjualanID);

    print("Response detail penjualan: $response");

    return List<Map<String, dynamic>>.from(response.map((item) => {
      'NamaProduk': item['Produk']['NamaProduk'],
      'Harga': item['Produk']['Harga'],
      'JumlahProduk': item['JumlahProduk'],
      'Subtotal': item['Subtotal'],
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 146, 212, 248),
      appBar: AppBar(title: Text("Riwayat Penjualan"),
      backgroundColor: Color.fromARGB(255, 146, 212, 248),
      ),
      body: penjualan.isEmpty
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: penjualan.length,
        itemBuilder: (context, index) {
          final item = penjualan[index];
          return ListTile(
            title: Text('Penjualan ${item['PenjualanID']}'),
            subtitle: Text("Total: Rp ${item['TotalHarga']}"),
            onTap: () async {
              List<Map<String, dynamic>> detailproduk =
              await fetchDetailPenjualan(item['PenjualanID']);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> RiwayatPenjualan(),
              )
              );
            },
          );
        })
    );
  }
}