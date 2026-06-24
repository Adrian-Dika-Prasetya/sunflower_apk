import 'package:flutter/material.dart';
import 'setting.dart';  
import 'about.dart';
import 'profile.dart';
import 'dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mencatat halaman aktif saat ini
  int _currentIndex = 0;

  // Daftar isi body yang akan ditampilkan sesuai tab yang dipilih
  final List<Widget> _halamanBody = [
    const DashboardPage(),
    const SettingPage(),
    const AboutPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunflower'),
        backgroundColor: const Color.fromARGB(255, 255, 200, 0),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 200, 0),
              ),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() { _currentIndex = 0; });
                Navigator.pop(context); // Menutup drawer otomatis
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() { _currentIndex = 1; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                setState(() { _currentIndex = 2; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                setState(() { _currentIndex = 3; });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      
      // 👇 Konten body berubah secara dinamis sesuai index navigasi
      body: _halamanBody[_currentIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 255, 200, 0),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex, // 👇 Mengikuti halaman yang aktif
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // 👇 Mengubah halaman saat ikon diklik
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}