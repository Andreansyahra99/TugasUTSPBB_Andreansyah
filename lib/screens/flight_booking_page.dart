import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import 'detail_page.dart';
import 'grid_page.dart';

class FlightBookingPage extends StatefulWidget {
  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  // --- STATE DATA ---
  String _fromCity = "Medan (KNO)";
  String _toCity = "Surabaya (SUB)";
  String _departureDate = "4 Des 2025";
  
  String _cabinClass = "Ekonomi"; 
  final List<String> cabinClasses = ["Ekonomi", "Bisnis", "Eksekutif"];

  final List<String> cities = ["Medan (KNO)", "Surabaya (SUB)", "Jakarta (CGK)", "Denpasar (DPS)", "Yogyakarta (YIA)", "Makassar (UPG)"];
  List<String> airlines = ["Semua", "Garuda", "Lion Air", "Citilink", "Batik Air", "AirAsia"];
  String selectedAirline = "Semua";
  bool showFilter = false;
  int minPrice = 0;
  int maxPrice = 5000000;
  String sortBy = "harga"; 

  List<Flight> flights = [
    Flight(id: "1", airline: "Garuda Indonesia", route: "SUB - KNO", departure: "08:00", arrival: "11:00", duration: "3j 0m", price: 1250000, image: "garuda", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 12),
    Flight(id: "2", airline: "Lion Air", route: "SUB - KNO", departure: "12:30", arrival: "15:30", duration: "3j 0m", price: 999000, image: "lion_air", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 8),
    Flight(id: "3", airline: "Citilink", route: "SUB - KNO", departure: "18:45", arrival: "21:45", duration: "3j 0m", price: 750000, image: "citilink", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 15),
    Flight(id: "4", airline: "Batik Air", route: "SUB - KNO", departure: "06:15", arrival: "09:15", duration: "3j 0m", price: 950000, image: "batik_air", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 20),
    Flight(id: "5", airline: "Garuda Indonesia", route: "SUB - KNO", departure: "14:20", arrival: "17:20", duration: "3j 0m", price: 1350000, image: "garuda", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 5),
    Flight(id: "6", airline: "AirAsia", route: "SUB - KNO", departure: "20:30", arrival: "23:30", duration: "3j 0m", price: 699000, image: "airasia", airportFrom: "Juanda", airportTo: "Kualanamu", date: "4 Des 2025", availableSeats: 18),
  ];

  int _calculatePrice(int basePrice) {
    if (_cabinClass == "Bisnis") return (basePrice * 1.5).round(); 
    if (_cabinClass == "Eksekutif") return (basePrice * 2.0).round(); 
    return basePrice; 
  }

  List<Flight> get filteredFlights {
    List<Flight> result = flights.where((flight) {
      bool airlineMatch = selectedAirline == "Semua" || flight.airline.contains(selectedAirline);
      int realPrice = _calculatePrice(flight.price);
      bool priceMatch = realPrice >= minPrice && realPrice <= maxPrice;
      return airlineMatch && priceMatch;
    }).toList();

    if (sortBy == "harga") {
      result.sort((a, b) => _calculatePrice(a.price).compareTo(_calculatePrice(b.price)));
    } else if (sortBy == "waktu") {
      result.sort((a, b) => a.departure.compareTo(b.departure));
    }
    return result;
  }

  void _showCitySelector(bool isFrom) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isFrom ? "Pilih Kota Asal" : "Pilih Kota Tujuan"),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cities[index]),
                  onTap: () {
                    setState(() {
                      if (isFrom) _fromCity = cities[index];
                      else _toCity = cities[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        _departureDate = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }

  void _swapCities() {
    setState(() {
      String temp = _fromCity;
      _fromCity = _toCity;
      _toCity = temp;
    });
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesan Tiket"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () { setState(() { showFilter = !showFilter; }); },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _showCitySelector(true),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dari", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                Text(_fromCity, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.swap_horiz, color: Colors.blue[900]), onPressed: _swapCities),
                        Expanded(
                          child: InkWell(
                            onTap: () => _showCitySelector(false),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Ke", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                Text(_toCity, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: _selectDate,
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month, color: Colors.blue[900], size: 20),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Tanggal", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    Text(_departureDate, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(width: 1, height: 40, color: Colors.grey[300]),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kelas", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _cabinClass,
                                  isDense: true,
                                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue[900], size: 18),
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                                  onChanged: (String? newValue) {
                                    setState(() { _cabinClass = newValue!; });
                                  },
                                  items: cabinClasses.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(value: value, child: Text(value));
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () { setState(() { sortBy = "harga"; }); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sortBy == "harga" ? Colors.blue[900] : Colors.grey[200],
                      foregroundColor: sortBy == "harga" ? Colors.white : Colors.black,
                      elevation: 0,
                    ),
                    child: Text("Harga Terendah"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () { setState(() { sortBy = "waktu"; }); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sortBy == "waktu" ? Colors.blue[900] : Colors.grey[200],
                      foregroundColor: sortBy == "waktu" ? Colors.white : Colors.black,
                      elevation: 0,
                    ),
                    child: Text("Waktu Berangkat"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: airlines.map((airline) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(airline),
                      selected: selectedAirline == airline,
                      onSelected: (bool selected) {
                        setState(() { selectedAirline = selected ? airline : "Semua"; });
                      },
                      selectedColor: Colors.blue[100],
                      checkmarkColor: Colors.blue[900],
                    ),
                  );
                }).toList(),
              ),
            ),
            
            if (showFilter) 
              Card(
                color: Colors.blue[50],
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rentang Harga Maksimal: Rp ${_formatPrice(maxPrice)}", style: TextStyle(fontWeight: FontWeight.bold)),
                      Slider(
                        value: maxPrice.toDouble(),
                        min: 500000,
                        max: 10000000,
                        divisions: 50,
                        label: _formatPrice(maxPrice),
                        onChanged: (val) { setState(() { maxPrice = val.round(); }); },
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Text("Daftar Penerbangan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), 
                TextButton(
                  onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => GridPage())); }, 
                  child: Text("Lihat Semua")
                )
              ]
            ),
            
            SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredFlights.length,
              itemBuilder: (context, index) {
                final originalFlight = filteredFlights[index];
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
                
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => DetailPage(
                          flight: updatedFlight,
                          cabinClass: _cabinClass,
                        ))
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/${updatedFlight.image}.png', width: 40, height: 40),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(updatedFlight.airline, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    // --- PENAMBAHAN INFO KURSI ---
                                    SizedBox(height: 4),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: updatedFlight.availableSeats < 10 ? Colors.orange[50] : Colors.green[50],
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: updatedFlight.availableSeats < 10 ? Colors.orange : Colors.green, width: 0.5)
                                      ),
                                      child: Text(
                                        "Sisa ${updatedFlight.availableSeats} Kursi", 
                                        style: TextStyle(
                                          fontSize: 10, 
                                          fontWeight: FontWeight.bold, 
                                          color: updatedFlight.availableSeats < 10 ? Colors.orange[800] : Colors.green[800]
                                        )
                                      ),
                                    ),
                                    // -----------------------------
                                  ],
                                ),
                              ),
                              Text("Rp ${_formatPrice(updatedFlight.price)}", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(updatedFlight.departure, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text("Berangkat", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(updatedFlight.duration, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Icon(Icons.flight_takeoff, color: Colors.blue[300], size: 20),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(updatedFlight.arrival, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text("Tiba", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}