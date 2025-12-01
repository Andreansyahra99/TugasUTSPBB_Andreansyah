import 'package:flutter/material.dart';
// Pastikan folder screens dan file home_page.dart sudah benar
import 'screens/home_page.dart'; 

// --- BAGIAN INI SANGAT PENTING (JANGAN DIHAPUS) ---
void main() {
  runApp(MyApp());
}
// --------------------------------------------------

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galeri Alam Indonesia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        useMaterial3: false,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
        ),
      ),
      home: HomePage(),
    );
  }
}