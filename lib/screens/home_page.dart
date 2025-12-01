import 'package:flutter/material.dart';
import 'flight_booking_page.dart';
import 'grid_page.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildHomeContent(context, isMobile: true),
      tablet: _buildHomeContent(context, isMobile: false),
      desktop: _buildHomeContent(context, isMobile: false),
    );
  }

  Widget _buildHomeContent(BuildContext context, {required bool isMobile}) {
    double contentWidth = isMobile ? double.infinity : 700;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Flight Booking App',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: contentWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.airplane_ticket,
                        size: isMobile ? 100 : 150,
                        color: Colors.blue[900],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mau terbang kemana hari ini?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FlightBookingPage()),
                          );
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Cari Tiket Pesawat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GridPage()),
                          );
                        },
                        icon: const Icon(Icons.grid_view),
                        label: const Text('Lihat Katalog Penerbangan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue[900],
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          side: BorderSide(color: Colors.blue[900]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
                const Divider(),
                const SizedBox(height: 20),

                const Text(
                  "✈️ Destinasi Populer Minggu Ini", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 15),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDestinationCard("Denpasar", "Bali", "bali.jpg"), 
                      _buildDestinationCard("Yogyakarta", "Jawa", "yogyakarta.jpg"),
                      _buildDestinationCard("Makassar", "Sulawesi", "makasar.jpg"),
                      _buildDestinationCard("Jakarta", "Ibukota", "jakarta.jpg"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard(String city, String region, String imageFileName) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.blue[100], 
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage('assets/images/$imageFileName'), 
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('Error loading image $imageFileName: $exception');
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            city,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            region,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}