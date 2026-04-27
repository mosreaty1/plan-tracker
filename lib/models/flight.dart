class Flight {
  final String flightNumber;
  final String origin;
  final String originCode;
  final String destination;
  final String destinationCode;
  final String departureTime;
  final String arrivalTime;
  final String status;
  final String gate;
  final String terminal;
  final String aircraft;
  final String duration;
  final String date;
  final int? delayMinutes;
  final String statusColor;

  const Flight({
    required this.flightNumber,
    required this.origin,
    required this.originCode,
    required this.destination,
    required this.destinationCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
    required this.gate,
    required this.terminal,
    required this.aircraft,
    required this.duration,
    required this.date,
    this.delayMinutes,
    required this.statusColor,
  });
}
