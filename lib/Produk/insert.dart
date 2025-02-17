import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Produk/index.dart';

class addproduk extends StatefulWidget {
  const addproduk({super.key});

  @override
  State<addproduk> createState() => _addprodukState();
}

class _addprodukState extends State<addproduk> {
  final TextEditingController NamaProdukController = TextEditingController();
  final TextEditingController HargaController = TextEditingController();
  final TextEditingController StokController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    NamaProdukController.dispose();
    HargaController.dispose() ;
    StokController.dispose();
    super.dispose();   
  }

  Future<void> tambahProduk() async {
    if (_formKey.currentState!.validate()) {
      final String NamaProduk = NamaProdukController.text.trim();
      final int? Harga = int.tryParse(HargaController.text.trim());
      final int? Stok = int.tryParse(StokController.text.trim());

      if (Harga == null || Stok == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harga dan Stok harus berupa angka')),
        );
        return;
      }

      try {
        final response = await Supabase.instance.client.from('produk').insert({
          'NamaProduk': NamaProduk,
          'Harga': Harga,
          'Stok': Stok,
      }).select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk Berhasil ditambahkan'),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context)=>ProdukIndex()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan produk'),
          )
        );
      }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('terjadi kesalahan silahkan coba lagi'))
        );
      }
    }
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: NamaProdukController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Produk Wajib Diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: HargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga Wajib Diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: StokController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok Wajib Diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              ElevatedButton(
                onPressed: tambahProduk, 
                child: Text('Tambah'),
              )
            ],
          )
        ),
        ),
    );
  }
}
