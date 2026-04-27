import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';

class FlightDetailScreen extends StatelessWidget {
  final Flight flight;
  const FlightDetailScreen({super.key, required this.flight});

  static const _navyBlue = Color(0xFF1A2D6B);

  Color get _statusColor {
    switch (flight.statusColor) {
      case 'orange': return const Color(0xFFE65100);
      case 'red': return const Color(0xFFE53935);
      case 'blue': return const Color(0xFF1565C0);
      case 'grey': return const Color(0xFF757575);
      default: return const Color(0xFF2E7D32);
    }
  }

  IconData get _statusIcon {
    switch (flight.statusColor) {
      case 'orange': return Icons.schedule;
      case 'red': return Icons.cancel_outlined;
      case 'blue': return Icons.airline_seat_recline_normal;
      case 'grey': return Icons.flight_takeoff;
      default: return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFF5F6FA),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Color(0xFF1A2D6B),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: _navyBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Flight ${flight.flightNumber}',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero route card
            Container(
              color: _navyBlue,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _AirportBlock(
                        code: flight.originCode,
                        city: flight.origin,
                        time: flight.departureTime,
                        align: CrossAxisAlignment.start,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              flight.duration,
                              style: GoogleFonts.roboto(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const SizedBox(width: 4),
                                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
                                Expanded(child: Container(height: 1, color: Colors.white30)),
                                const Icon(Icons.airplanemode_active, color: Colors.white, size: 22),
                                Expanded(child: Container(height: 1, color: Colors.white30)),
                                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _AirportBlock(
                        code: flight.destinationCode,
                        city: flight.destination,
                        time: flight.arrivalTime,
                        align: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: _statusColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon, color: _statusColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          flight.status,
                          style: GoogleFonts.roboto(
                            color: _statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        if (flight.delayMinutes != null) ...[
                          Text(
                            ' (+${flight.delayMinutes} min)',
                            style: GoogleFonts.roboto(color: _statusColor, fontSize: 13),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SectionCard(
                    title: 'Flight Information',
                    icon: Icons.info_outline,
                    rows: [
                      _Row('Flight Number', flight.flightNumber),
                      _Row('Date', flight.date),
                      _Row('Aircraft', flight.aircraft),
                      _Row('Duration', flight.duration),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: 'Departure',
                    icon: Icons.flight_takeoff,
                    rows: [
                      _Row('Airport', '${flight.origin} (${flight.originCode})'),
                      _Row('Scheduled', flight.departureTime),
                      _Row('Terminal', flight.terminal),
                      _Row('Gate', flight.gate),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: 'Arrival',
                    icon: Icons.flight_land,
                    rows: [
                      _Row('Airport', '${flight.destination} (${flight.destinationCode})'),
                      _Row('Scheduled', flight.arrivalTime),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _Row {
  final String label;
  final String value;
  const _Row(this.label, this.value);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_Row> rows;

  const _SectionCard({required this.title, required this.icon, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF1A2D6B), size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color(0xFF1A2D6B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...rows.map((r) => _DetailRow(label: r.label, value: r.value)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey.shade500),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}

class _AirportBlock extends StatelessWidget {
  final String code;
  final String city;
  final String time;
  final CrossAxisAlignment align;

  const _AirportBlock({
    required this.code,
    required this.city,
    required this.time,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          code,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          city,
          style: GoogleFonts.roboto(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
