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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const InventoryScreen(),  
    const AddPokemonScreen(),  
    const ProfileScreen(),    
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
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.redAccent, 
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Catch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Trainer',
          ),
        ],
      ),
    );
  }
}