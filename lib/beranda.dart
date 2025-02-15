import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Produk/index.dart';
import 'package:ukk_2025/User/indexuser.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/main.dart';

class Beranda extends StatefulWidget {
  const Beranda ({super.key});

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda>with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    setState(() {
      _tabController.index=index;
      Navigator.pop(context);
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
              child: Center(
                child: Text('Beranda'),
              ),
              ),
            ListTile(
              leading: const Icon(Icons.category),
                title: const Text('Produk'),
                onTap: () => _changeTab (0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
                title: const Text('Pelanggan'),
                onTap: () => _changeTab (1),
            ),
           ListTile(
              leading: const Icon(Icons.receipt_long),
                title: const Text('Penjualan'),
                onTap: () => _changeTab (2),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
                title: const Text('Detail Penjualan'),
                onTap: () => _changeTab (3),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: Text('User'),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context)=>UserTab()),);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context)=>MyHomePage()),);
                },
            ),
          ],
        ),
      ),
    );
  }
}