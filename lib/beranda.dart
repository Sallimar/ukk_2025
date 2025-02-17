import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Pelanggan/index.dart';
import 'package:ukk_2025/Penjualan/index.dart';
import 'package:ukk_2025/Produk/index.dart';
import 'package:ukk_2025/User/indexuser.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/main.dart';

class Beranda extends StatefulWidget {
  const Beranda ({super.key});

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProdukIndex(),
    Pelangganview(),
    PenjualanTab(),
    Center(child: Text("Detail Penjualan Page")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: const Text('Halaman Utama'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Center(
                child: Text('Beranda'),
              ),
              ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: Text('User'),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context)=>UserIndex()),);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context)=>MyHomePage()),
                  );
                },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "produk"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Pelanggan"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Penjualan"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Detail"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}