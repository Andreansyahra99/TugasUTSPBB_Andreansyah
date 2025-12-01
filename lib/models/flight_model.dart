class Flight {
  final String id;
  final String airline;
  final String route;
  final String departure;
  final String arrival;
  final String duration;
  final int price;
  final String image;
  final String airportFrom;
  final String airportTo;
  final String date;
  final int availableSeats;

  Flight({
    required this.id,
    required this.airline,
    required this.route,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.price,
    required this.image,
    required this.airportFrom,
    required this.airportTo,
    required this.date,
    required this.availableSeats,
  });
}