import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import 'detail_page.dart';
import '../widgets/custom_app_bar.dart'; 

class GridPage extends StatefulWidget {
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  String _selectedClass = "Ekonomi";
  final List<String> cabinClasses = ["Ekonomi", "Bisnis", "Eksekutif"];

  final List<Flight> flights = [
    Flight(id: "1", airline: "Garuda Indonesia", route: "SUB - KNO", departure: "08:00", arrival: "11:00", duration: "3j 0m", price: 1250000, image: "garuda", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 12),
    Flight(id: "2", airline: "Lion Air", route: "SUB - KNO", departure: "12:30", arrival: "15:30", duration: "3j 0m", price: 999000, image: "lion_air", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 8),
    Flight(id: "3", airline: "Citilink", route: "SUB - KNO", departure: "18:45", arrival: "21:45", duration: "3j 0m", price: 750000, image: "citilink", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 15),
    Flight(id: "4", airline: "Batik Air", route: "SUB - KNO", departure: "06:15", arrival: "09:15", duration: "3j 0m", price: 950000, image: "batik_air", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 20),
    Flight(id: "5", airline: "Garuda Indonesia", route: "SUB - KNO", departure: "14:20", arrival: "17:20", duration: "3j 0m", price: 1350000, image: "garuda", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 5),
    Flight(id: "6", airline: "AirAsia", route: "SUB - KNO", departure: "20:30", arrival: "23:30", duration: "3j 0m", price: 699000, image: "airasia", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 18),
  ];

  int _calculatePrice(int basePrice) {
    if (_selectedClass == "Bisnis") return (basePrice * 1.5).round();
    if (_selectedClass == "Eksekutif") return (basePrice * 2.0).round();
    return basePrice;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    return Scaffold(
      appBar: const CustomAppBar(title: "Katalog Penerbangan"),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pilih Kelas Penerbangan:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: cabinClasses.map((kelas) {
                    bool isSelected = _selectedClass == kelas;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(kelas),
                          selected: isSelected,
                          selectedColor: Colors.blue[900],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (bool selected) {
                            if (selected) {
                              setState(() {
                                _selectedClass = kelas;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: flights.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.80, 
                ),
                itemBuilder: (context, index) {
                  final originalFlight = flights[index];
                  bool isLowSeat = originalFlight.availableSeats < 10;
                  
                  final updatedFlight = Flight(
                    id: originalFlight.id,
                    airline: originalFlight.airline,
                    route: originalFlight.route,
                    departure: originalFlight.departure,
                    arrival: originalFlight.arrival,
                    duration: originalFlight.duration,
                    price: _calculatePrice(originalFlight.price),
                    image: originalFlight.image,
                    airportFrom: originalFlight.airportFrom,
                    airportTo: originalFlight.airportTo,
                    date: originalFlight.date,
                    availableSeats: originalFlight.availableSeats,
                  );

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => DetailPage(
                          flight: updatedFlight,
                          cabinClass: _selectedClass,
                        ))
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 4, 
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20), 
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  ),
                                  child: Center(
                                    child: Image.asset('assets/images/${updatedFlight.image}.png', fit: BoxFit.contain)
                                  ),
                                ),

                                Positioned(
                                  top: 8, right: 8,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isLowSeat ? Colors.orange[50] : Colors.green[50],
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: isLowSeat ? Colors.orange : Colors.green, width: 0.5)
                                    ),
                                    child: Text(
                                      "Sisa ${updatedFlight.availableSeats}", 
                                      style: TextStyle(
                                        fontSize: 10, 
                                        fontWeight: FontWeight.bold, 
                                        color: isLowSeat ? Colors.orange[800] : Colors.green[800]
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  Text(updatedFlight.airline, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  
                                  SizedBox(height: 4), 
                                  
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 12, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text("${updatedFlight.departure} - ${updatedFlight.arrival}", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                    ],
                                  ),

                                  SizedBox(height: 12), 

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_selectedClass, style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
                                      Text("Rp ${_formatPrice(updatedFlight.price)}", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}