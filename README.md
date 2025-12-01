# LAPORAN TUGAS UTS
## Aplikasi Pemesanan Tiket Pesawat (Flight Booking App)
---
## IDENTITAS MAHASISWA

*Nama*: Andreansyah Rahmattullah
*NIM*: 240102015
*Kelas*: IF23B
*Mata Kuliah*: Pemrograman Perangkat Bergerak
*Dosen Pengampu*: 1. Fajar Winata S.Kom., M.T.
                  2. Rizky Kharisma N. E. P. S.Tr.Kom., M.T.
*Link GitHub*: (Isi Link GitHub Anda)
*Email*: andreansyah.ra@gmail.com

---

## DESKRIPSI APLIKASI

*Flight Booking App* adalah aplikasi simulasi mobile berbasis Flutter yang menampilkan alur lengkap pemesanan tiket pesawat. Aplikasi ini mencakup fitur pencarian penerbangan, pemilihan kelas kursi (Ekonomi, Bisnis, Eksekutif) yang dinamis, penentuan kursi, hingga simulasi pembayaran dengan *enhanced receipt*.

Aplikasi ini dibuat untuk memenuhi *Tugas Besar UTS Pemrograman Perangkat Bergerak* dengan spesifikasi:

*Implementasi 5 jenis layout* (Dasar, Multi-Child, Kompleks, Scrollable, Responsif)
*3 halaman utama* (Home Page, Detail Page, Grid Page) sesuai requirement
*Custom widget* yang reusable (`CustomAppBar`, `FlightCard`, `ResponsiveLayout`)
*ThemeData* untuk konsistensi UI
*Struktur folder* rapi dan terorganisir
*Responsive design* dengan `MediaQuery` dan `LayoutBuilder`
*Tambahan* (Dynamic Pricing, PNR Generation, Seat Mapping, Dynamic Facilities)

Aplikasi ini mendemonstrasikan pemahaman mendalam tentang Flutter layout system, manajemen state lokal, dan *best practices* dalam pengembangan aplikasi mobile yang responsif dan fungsional.

## TEKNOLOGI YANG DIGUNAKAN

| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| Flutter SDK | Latest | Framework utama |
| Dart | Latest | Bahasa pemrograman |
| Material Design 3 | Latest | UI Components & theming |
| dart:math | - | Pembangkitan kode PNR acak (Booking Code) |

---

## STRUKTUR FOLDER PROJECT

flight_booking_app/
├── assets/
│   └── images/                # Logo maskapai, gambar destinasi (bali.jpg, dll.)
├── lib/
│   ├── main.dart                  # Entry point aplikasi
│   ├── models/
│   │   └── flight_model.dart      # Model data penerbangan
│   ├── screens/
│   │   ├── home_page.dart         # Halaman utama (HOME PAGE)
│   │   ├── flight_booking_page.dart # Halaman pencarian dan daftar tiket
│   │   ├── grid_page.dart         # Halaman katalog (GRID PAGE)
│   │   ├── detail_page.dart       # Halaman detail (DETAIL PAGE)
│   │   ├── seat_selection_page.dart # Halaman pemilihan kursi (FITUR TAMBAHAN)
│   │   └── booking_form_page.dart   # Halaman form dan pembayaran (FITUR TAMBAHAN)
│   └── widgets/
│       ├── custom_app_bar.dart    # Custom widget AppBar (CUSTOM WIDGET 1)
│       ├── flight_card.dart       # Custom widget card tiket (CUSTOM WIDGET 2)
│       └── responsive_layout.dart  # Custom widget penyesuai layar (LAYOUT RESPONSIVE)
└── pubspec.yaml                   # Dependencies


### Penjelasan Struktur:
- *models/*: Berisi class model untuk data `Flight`.
- *screens/*: Berisi semua halaman utama aplikasi, termasuk alur booking lengkap.
- *widgets/*: Berisi Custom Widget yang reusable (`AppBar`, `FlightCard`, `ResponsiveLayout`).

---

## IMPLEMENTASI 5 JENIS LAYOUT FLUTTER

### 1. Layout Dasar (Single Child)

*Widget yang Digunakan:* Container, Center, Padding, Align

*Lokasi Implementasi:* Digunakan di hampir semua card dan wrapper (`FlightCard`, `DetailPage`).

---

### 2. Layout Multi-Child (Row/Column)

*Widget yang Digunakan:* Row, Column, Expanded, Spacer

*Lokasi Implementasi:*
- **`flight_booking_page.dart`**: Pengaturan layout filter dan tombol sortir.
- **`flight_card.dart`**: Pengaturan detail waktu penerbangan (`Row` untuk Berangkat, Durasi, Tiba).

---

### 3. Layout Kompleks

*Widget yang Digunakan:* Stack, Positioned

*Lokasi Implementasi:*
- **`detail_page.dart`**: Digunakan untuk menumpuk gambar logo maskapai dengan gradient overlay dan label kelas kursi.

---

### 4. Layout Scrollable

*Widget yang Digunakan:* ListView, GridView, SingleChildScrollView

*Lokasi Implementasi:*
- **`grid_page.dart`**: `GridView.builder` untuk katalog tiket.
- **`flight_booking_page.dart`**: `ListView.builder` untuk daftar tiket dan `SingleChildScrollView` untuk wrapper utama.
- **`seat_selection_page.dart`**: `ListView.builder` untuk denah kursi.

---

### 5. Layout Responsif/Adaptif

*Widget yang Digunakan:* MediaQuery, LayoutBuilder, Flexible

*Lokasi Implementasi:*
- **`widgets/responsive_layout.dart`**: Menggunakan `LayoutBuilder` untuk menentukan layout mana yang akan ditampilkan (mobile, tablet, desktop).
- **`grid_page.dart`**: Menggunakan `MediaQuery` untuk mengatur `crossAxisCount` (jumlah kolom grid) sesuai lebar layar.

---

## SPESIFIKASI HALAMAN & FITUR UTAMA

### 1. Home Page (home_page.dart)

*Requirement:* Header, Ikon, Tombol Navigasi.

*Fitur:*
- Tombol navigasi ke Search dan Katalog.
- **[FITUR TAMBAHAN]** Section *Destinasi Populer* dengan horizontal scroll cards (menggunakan image assets).

---

### 2. Detail Page (detail_page.dart)

*Requirement:* Stack overlay dan Scrollable content.

*Fitur:*
- Header image dengan Stack dan label kelas kursi (`cabinClass`).
- Quantity selector untuk Penumpang.
- **[FITUR TAMBAHAN]** Informasi **Fasilitas Dinamis** (Bagasi, Meal, Seat) yang berubah sesuai kelas yang dipilih.
- **[LOGIC FIX]** Menerima object `Flight` lengkap dari halaman sebelumnya untuk menjaga konsistensi harga (Ekonomi/Bisnis/Eksekutif).

---

### 3. Grid Page (grid_page.dart)

*Requirement:* `GridView` dengan 6+ item, nama, dan gambar.

*Fitur:*
- **[FITUR TAMBAHAN]** Filter Kelas (Ekonomi/Bisnis/Eksekutif) menggunakan `ChoiceChip`.
- **[FITUR TAMBAHAN]** Harga tiket di Grid **berubah secara real-time** sesuai kelas yang dipilih.
- Desain card yang rapat dan responsif (`childAspectRatio: 0.80`).

---

## FITUR TAMBAHAN KRUSIAL

Fitur-fitur di bawah ini ditambahkan untuk meningkatkan fungsionalitas dan memenuhi *best practices* aplikasi travel:

### 1. Dynamic Pricing & Filtering
- Harga tiket dikalikan **1.5x (Bisnis)** dan **2.0x (Eksekutif)**.
- Filter harga di halaman pencarian disesuaikan dengan range harga yang sudah dikalikan kelas.

### 2. Seat Map Logic
- **`seat_selection_page.dart`** menampilkan denah 60 kursi.
- Kursi yang diblokir (abu-abu/terisi) dihitung dan disebarkan secara acak berdasarkan kuota `availableSeats` yang tersisa.

### 3. Enhanced Booking Receipt
- **`booking_form_page.dart`** (Dialog Sukses Bayar) kini menampilkan:
    - **Kode Booking (PNR)** 6 digit yang di-generate secara acak (`dart:math`).
    - Konfirmasi Total Harga Final yang dibayarkan.
    - Tombol aksi **"Kembali ke Beranda"** yang jelas.

---

## KONTAK

*Nama:* Andreansyah Rahmattullah
*NIM:* 240102015
*Kelas:* IF23B
*Email:* andreansyah.ra@gmail.com
*GitHub:* (Isi Link GitHub Anda)