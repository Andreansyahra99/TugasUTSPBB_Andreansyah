import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import 'dart:math'; 

class BookingFormPage extends StatefulWidget {
  final Flight flight;
  final int passengerCount;
  final List<String> selectedSeats;

  const BookingFormPage({
    Key? key,
    required this.flight,
    required this.passengerCount,
    required this.selectedSeats,
  }) : super(key: key);

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  String _paymentMethod = "transfer"; 
  bool _isProcessing = false;
  
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> idControllers = [];
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.passengerCount; i++) {
      nameControllers.add(TextEditingController());
      idControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in nameControllers) controller.dispose();
    for (var controller in idControllers) controller.dispose();
    super.dispose();
  }

  void _validateForm() {
    bool isValid = true;
    for (int i = 0; i < widget.passengerCount; i++) {
      if (nameControllers[i].text.trim().isEmpty || 
          idControllers[i].text.trim().isEmpty) {
        isValid = false;
        break;
      }
    }
    setState(() {
      _isFormValid = isValid;
    });
  }

  String _generatePNR() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Penumpang & Bayar"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Data Penumpang", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.passengerCount,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Penumpang ${index + 1} (Kursi: ${widget.selectedSeats[index]})", 
                             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                        SizedBox(height: 8),
                        
                        TextField(
                          controller: nameControllers[index],
                          onChanged: (_) => _validateForm(),
                          decoration: InputDecoration(
                            labelText: "Nama Lengkap", 
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        TextField(
                          controller: idControllers[index],
                          onChanged: (_) => _validateForm(),
                          decoration: InputDecoration(
                            labelText: "No. KTP / Paspor", 
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),

            Text("Metode Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: Column(
                children: [
                  RadioListTile(
                    title: Text("Transfer Bank (BCA, Mandiri, BRI)"),
                    value: "transfer",
                    groupValue: _paymentMethod,
                    onChanged: (val) { setState(() { _paymentMethod = val.toString(); }); },
                  ),
                  RadioListTile(
                    title: Text("E-Wallet (GoPay, OVO, Dana)"),
                    value: "ewallet",
                    groupValue: _paymentMethod,
                    onChanged: (val) { setState(() { _paymentMethod = val.toString(); }); },
                  ),
                  RadioListTile(
                    title: Text("Kartu Kredit / Debit"),
                    value: "cc",
                    groupValue: _paymentMethod,
                    onChanged: (val) { setState(() { _paymentMethod = val.toString(); }); },
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (_isFormValid && !_isProcessing) ? _processPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                  disabledForegroundColor: Colors.white70,
                ),
                child: _isProcessing 
                  ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text("Bayar Sekarang - Rp ${_formatPrice(widget.flight.price * widget.passengerCount)}", 
                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() { _isProcessing = true; });
    await Future.delayed(Duration(seconds: 3));
    setState(() { _isProcessing = false; });

    if (!mounted) return;

    String pnrCode = _generatePNR();
    int totalPrice = widget.flight.price * widget.passengerCount;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        
        title: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text("Pembayaran Berhasil!", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tiket elektronik telah dikirim ke email Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            
            SizedBox(height: 15),
            Divider(),
            SizedBox(height: 15),

            _buildDetailRow("Kode Booking (PNR)", pnrCode, isPNR: true),
            _buildDetailRow("Maskapai", widget.flight.airline),
            _buildDetailRow("Kursi", widget.selectedSeats.join(', ')),
            _buildDetailRow("Total Bayar", "Rp ${_formatPrice(totalPrice)}", isPrice: true),
          ],
        ),
        
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst); 
            },
            child: Text("Kembali ke Beranda", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPNR = false, bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label + ":", style: TextStyle(color: Colors.grey[700])),
          Text(
            value, 
            style: TextStyle(
              fontWeight: isPNR || isPrice ? FontWeight.bold : FontWeight.normal,
              color: isPNR ? Colors.red[700] : (isPrice ? Colors.blue[900] : Colors.black),
              fontSize: isPNR ? 15 : 14,
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