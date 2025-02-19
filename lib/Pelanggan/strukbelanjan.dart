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
              pw.Text('Toko Mama Suka', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 8),
              pw.Text('Jl. Raya Kepanjen No.42, Penarukan', style: pw.TextStyle(fontSize: 16), textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 8),
              pw.Text('Terima kasih telah datang di Toko Mama Suka \n kepuasan pelanggan adalah prioritas kami', style: pw.TextStyle(fontSize:14), textAlign: pw.TextAlign.center),
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
      backgroundColor: const Color.fromARGB(255, 252, 216, 255),
      appBar: AppBar(title: const Text('Struk Belanja'),
      backgroundColor: const Color.fromARGB(255, 252, 216, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Toko Mama Suka',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Jalan Raya Kepanjen No.42 Penarukan',
              style: TextStyle(fontSize: 19, color: Colors.black), textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Terima kasih telah datang di Toko Mama Suka \n kepuasan pelanggan adalah prioritas kami',
              style: TextStyle(fontSize: 15, color: Colors.black, fontStyle: FontStyle.italic), textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'Produk Yang Dibeli',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: selectedProduk.map((item){
                  return ListTile(
                    title: Text(item['NamaProduk'], style: TextStyle(fontSize: 16),),
                    subtitle: Text('Jumlah: ${item['JumlahProduk']}', style: TextStyle(color: Colors.black, fontSize: 16),),
                    trailing: Text('Rp ${item['Harga'] * item['JumlahProduk']}', style: TextStyle(fontSize: 16),),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Total Harga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Text('Rp $totalHarga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            const Center(
              child: Text(
                'Terima kasih atas kunjungan anda! \n barang yang sudah dibeli tidak bisa ditukar lagi....',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateAndDownloadPDF, 
              child: Text('Unduh Struk (PDF)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100]),
              ),
              const SizedBox(height: 16),
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