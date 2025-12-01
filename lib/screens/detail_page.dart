import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import 'seat_selection_page.dart';
import '../widgets/custom_app_bar.dart'; 

class DetailPage extends StatefulWidget {
  final Flight flight;
  final String cabinClass; 

  const DetailPage({
    super.key, 
    required this.flight,
    required this.cabinClass,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _passengerCount = 1;

  @override
  Widget build(BuildContext context) {
    Flight flight = widget.flight; 

    return Scaffold(
      appBar: const CustomAppBar(title: "Detail Penerbangan"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        'assets/images/${flight.image}.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                        },
                      ),
                    ),
                  ),
                ),
                
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange, 
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text(
                          widget.cabinClass.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        flight.airline,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${flight.route} • ${flight.date}",
                        style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(flight.departure, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Berangkat", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(flight.airportFrom.split('(')[0].trim(), style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(flight.duration, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Icon(Icons.flight_takeoff, color: Colors.blue),
                            Container(height: 1, width: 40, color: Colors.grey[300], margin: const EdgeInsets.symmetric(vertical: 4)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(flight.arrival, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Tiba", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(flight.airportTo.split('(')[0].trim(), style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    
                    _buildDynamicFacilities(),
                    
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Text("Bisa Reschedule & Refund", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Jumlah Penumpang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: flight.availableSeats < 10 ? Colors.red[50] : Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: flight.availableSeats < 10 ? Colors.red[200]! : Colors.blue[200]!)
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.airline_seat_recline_normal, size: 14, color: flight.availableSeats < 10 ? Colors.red[800] : Colors.blue[800]),
                              const SizedBox(width: 4),
                              Text(
                                "Sisa ${flight.availableSeats} Kursi", 
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold, 
                                  color: flight.availableSeats < 10 ? Colors.red[800] : Colors.blue[800]
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    Row(
                      children: [
                        _buildCounterButton(Icons.remove, () {
                          if (_passengerCount > 1) setState(() => _passengerCount--);
                        }),
                        const SizedBox(width: 20),
                        Text("$_passengerCount", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        _buildCounterButton(Icons.add, () {
                          if (_passengerCount < flight.availableSeats) setState(() => _passengerCount++);
                        }),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Total Harga", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(
                              "Rp ${_formatPrice(flight.price * _passengerCount)}",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionPage(
                        flight: flight,
                        passengerCount: _passengerCount,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text(
                  "Pilih Kursi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFacilities() {
    List<Widget> facilities = [];

    if (widget.cabinClass == "Eksekutif") {
      facilities = [
        _buildFacilityIcon(Icons.luggage, "Bagasi 40kg"),
        _buildFacilityIcon(Icons.restaurant_menu, "Premium Meal"),
        _buildFacilityIcon(Icons.wifi, "Wifi Gratis"),
        _buildFacilityIcon(Icons.bed, "Flatbed Seat"),
      ];
    } else if (widget.cabinClass == "Bisnis") {
      facilities = [
        _buildFacilityIcon(Icons.luggage, "Bagasi 30kg"),
        _buildFacilityIcon(Icons.restaurant, "Full Meal"),
        _buildFacilityIcon(Icons.wifi, "Wifi Gratis"),
        _buildFacilityIcon(Icons.chair, "Extra Legroom"),
      ];
    } else {
      facilities = [
        _buildFacilityIcon(Icons.luggage, "Bagasi 20kg"),
        _buildFacilityIcon(Icons.fastfood, "Snack"),
        _buildFacilityIcon(Icons.wifi_off, "No Wifi"),
        _buildFacilityIcon(Icons.event_seat, "Standard"),
      ];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: facilities,
    );
  }

  Widget _buildFacilityIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w500)),
      ],
    );
  }
  
  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}