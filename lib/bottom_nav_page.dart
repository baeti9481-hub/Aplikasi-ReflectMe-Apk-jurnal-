import 'package:flutter/material.dart'; 
class BottomNavPage extends StatefulWidget { 
const BottomNavPage({super.key}); 
@override 
State<BottomNavPage> createState() => _BottomNavPageState(); 
} 
class _BottomNavPageState extends State<BottomNavPage> { 
int _selectedIndex = 0; 
// List widget untuk setiap tab 
final List<Widget> _halaman = const [ 
Center(child: Icon(Icons.home, size: 100)), 
Center(child: Icon(Icons.search, size: 100)), 
Center(child: Icon(Icons.person, size: 100)), 
]; 

@override 
Widget build(BuildContext context) { 
return Scaffold( 
appBar: AppBar( 
title: const Text("Bottom Nav"), 
backgroundColor: Colors.blue, 
foregroundColor: Colors.white, 
), 
body: _halaman[_selectedIndex], 
bottomNavigationBar: BottomNavigationBar( 
currentIndex: _selectedIndex, 
onTap: (index) { 
setState(() { 
_selectedIndex = index; 
}); 
}, 
items: const [ 
BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), 
BottomNavigationBarItem(icon: Icon(Icons.search), label: "Cari"), 
BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"), 
], 
), 
); 
} 
} 