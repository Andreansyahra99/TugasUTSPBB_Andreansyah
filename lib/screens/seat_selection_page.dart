import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import 'booking_form_page.dart';
import 'dart:math';

class SeatSelectionPage extends StatefulWidget {
  final Flight flight;
  final int passengerCount;

  const SeatSelectionPage({Key? key, required this.flight, required this.passengerCount}) : super(key: key);

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  List<String> selectedSeats = [];
  List<String> bookedSeats = [];

  @override
  void initState() {
    super.initState();
    _generateBookedSeats();
  }

  void _generateBookedSeats() {
    int totalRows = 10;
    List<String> colLabels = ['A', 'B', 'C', 'D', 'E', 'F'];
    List<String> allSeats = [];

    for (int row = 1; row <= totalRows; row++) {
      for (String col in colLabels) {
        allSeats.add("$row$col");
      }
    }

    int totalSeats = allSeats.length;
    int availableTarget = widget.flight.availableSeats;
    int seatsToBlock = totalSeats - availableTarget;

    if (seatsToBlock < 0) seatsToBlock = 0;

    allSeats.shuffle();

    setState(() {
      bookedSeats = allSeats.take(seatsToBlock).toList();
    });
    
    print("Total Kursi: $totalSeats");
    print("Kuota Tersedia: $availableTarget");
    print("Kursi Diblokir: ${bookedSeats.length}");
  }

  void _toggleSeat(String seatId) {
    if (bookedSeats.contains(seatId)) {
      return;
    }

    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        if (widget.passengerCount == 1) {
          selectedSeats.clear(); 
          selectedSeats.add(seatId);
        } else {
          if (selectedSeats.length < widget.passengerCount) {
            selectedSeats.add(seatId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Maksimal ${widget.passengerCount} kursi. Hapus salah satu dulu.")),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Kursi (${widget.flight.airline})"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Penumpang: ${widget.passengerCount}", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Tersedia: ${widget.flight.availableSeats} Kursi"),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _legendItem(Colors.white, "Tersedia", true),
                _legendItem(Colors.grey, "Terisi", false),
                _legendItem(Colors.blue[900]!, "Pilihanmu", false),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: 10,
              itemBuilder: (context, rowIndex) {
                int rowNum = rowIndex + 1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSeat(rowNum, "A"),
                      _buildSeat(rowNum, "B"),
                      _buildSeat(rowNum, "C"),
                      
                      Container(
                        width: 30, 
                        child: Center(child: Text("$rowNum", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
                      ),
                      
                      _buildSeat(rowNum, "D"),
                      _buildSeat(rowNum, "E"),
                      _buildSeat(rowNum, "F"),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, 
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)]
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedSeats.length == widget.passengerCount 
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingFormPage(
                            flight: widget.flight,
                            passengerCount: widget.passengerCount,
                            selectedSeats: selectedSeats,
                          ),
                        ),
                      );
                    } 
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text("Lanjut ke Pembayaran"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(int row, String col) {
    String seatId = "$row$col";
    bool isBooked = bookedSeats.contains(seatId);
    bool isSelected = selectedSeats.contains(seatId);

    return GestureDetector(
      onTap: () => _toggleSeat(seatId),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isBooked ? Colors.grey : (isSelected ? Colors.blue[900] : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isBooked ? Colors.transparent : Colors.blue[900]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            col,
            style: TextStyle(
              color: isBooked || isSelected ? Colors.white : Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label, bool isBorder) {
    return Row(
      children: [
        Container(
          width: 20, height: 20,
          decoration: BoxDecoration(
            color: color,
            border: isBorder ? Border.all(color: Colors.blue[900]!) : null,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}