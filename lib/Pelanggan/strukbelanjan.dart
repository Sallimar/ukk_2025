import 'package:flutter/material.dart';
import 'package:ukk_2025/DetailPenjualan/detailpenjualan.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StrukPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProduk;
  final pdf = pw.Document();
  final int totalHarga;

  StrukPage({required this.selectedProduk, required this.totalHarga});

  //untuk membuat PDF
  Future<void> _generateAndDownloadPDF() async{

    //menambahkan ke PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Toko Mama Suka', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Jl. Raya Kepanjen No.42, Penarukan', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),
              pw.Divider(),
              pw.Text('Produk yang Dibeli', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),

              //Daftar Produk Yang dibeli pelanggan
              ...selectedProduk.map((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text(item['NamaProduk'], style: pw.TextStyle(fontSize: 14))),
                    pw.Text('Jumlah: ${item['JumlahProduk']}', style: pw.TextStyle(fontSize: 14)),
                    pw.Text('Rp ${item['Harga'] * item['JumlahProduk']}', style: pw.TextStyle(fontSize: 14)),
                  ],
                );
              }).toList(),
              pw.Divider(),
              //total harga
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Harga', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rp $totalHarga', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Terimakasih atas kunjungan anda, \n barang yang sudah dibeli tidak bisa ditukar lagii.....',
                  style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic),
                  textAlign: pw.TextAlign.center,
                )
              )
            ]
          );
        }
      )
    );

    // menyimpan PDF dan mengunduhnya
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Toko Mama Suka'
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Struk Belanja'),
      backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toko Mama Suka',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Jalan Raya Kepanjen No.42 Penarukan',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 16),
            Divider(),
            Text(
              'Produk Yang Dibeli',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: selectedProduk.map((item){
                  return ListTile(
                    title: Text(item['NamaProduk']),
                    subtitle: Text('Jumlah: ${item['JumlahProduk']}'),
                    trailing: Text('Rp ${item['Harga'] * item['JumlahProduk']}'),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Total Harga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Text('Rp $totalHarga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Divider(),
            Center(
              child: Text(
                'Terima kasih atas kunjungan anda! \n barang yang sudah dibeli tidak bisa ditukar lagi....',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateAndDownloadPDF, 
              child: Text('Unduh Stuk (PDF)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context)=> RiwayatPenjualan()),
                  );
                }, 
                child: Text('Selesai'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100]),
                )
          ],
        ),
      ),
    );
  }
}