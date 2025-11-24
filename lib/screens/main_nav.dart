import 'package:flutter/material.dart';
import 'home/inventory_screen.dart';
import 'forms/add_pokemon_screen.dart';
import 'profile/profile_screen.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  // 1. Index halaman yang sedang dipilih (0 = My PC, 1 = Catch, 2 = Profile)
  int _selectedIndex = 0;

  // 2. Daftar Halaman (Urutannya harus sesuai dengan icon di bawah)
  final List<Widget> _screens = [
    const InventoryScreen(),   // Halaman 0: List Pokemon
    const AddPokemonScreen(),  // Halaman 1: Form Tambah
    const ProfileScreen(),     // Halaman 2: Profil & Logout
  ];

  // 3. Fungsi saat tombol navigasi ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berubah sesuai index yang dipilih
      body: _screens[_selectedIndex],
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.redAccent, // Merah Pokemon saat aktif
        unselectedItemColor: Colors.grey,    // Abu-abu saat tidak aktif
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Supaya labelnya muncul terus
        items: const [
          // Menu 1: My PC (Inventory)
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Inventory',
          ),
          // Menu 2: Catch (Tambah Data)
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon), // Atau Icons.add_circle
            label: 'Catch',
          ),
          // Menu 3: Trainer (Profile)
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Trainer',
          ),
        ],
      ),
    );
  }
}