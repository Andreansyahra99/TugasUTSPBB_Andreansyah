// Import package testing flutter
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import file main.dart dari aplikasi Anda.
// PENTING: Jika tulisan 'package:flutter_application_uts/main.dart' merah,
// ganti 'flutter_application_uts' sesuai dengan 'name:' di file pubspec.yaml Anda.
import 'package:flight_booking_app/main.dart';

void main() {
  testWidgets('Aplikasi berhasil dijalankan dan menampilkan Home', (WidgetTester tester) async {
    // 1. Build aplikasi Anda (MyApp)
    await tester.pumpWidget(MyApp());

    // 2. Verifikasi bahwa aplikasi menampilkan judul di AppBar
    // Kita mencari teks 'Flight Booking App' yang ada di AppBar HomePage
    expect(find.text('Flight Booking App'), findsOneWidget);

    // 3. Verifikasi bahwa ada Icon Pesawat di AppBar
    expect(find.byIcon(Icons.flight_takeoff), findsWidgets);

    // 4. Verifikasi bahwa tombol cari ada (Icon Search)
    // Sesuai dengan tombol "Cari Tiket Pesawat" di HomePage
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}