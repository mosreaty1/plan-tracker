import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/flight_service.dart';
import '../models/flight.dart';
import 'flight_detail_screen.dart';
import 'itinerary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  bool _loading = false;
  String? _notFound;

  static const _navyBlue = Color(0xFF1A2D6B);

  Future<void> _search() async {
    final code = _searchCtrl.text.trim();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() { _loading = true; _notFound = null; });

    // Check if it's a ticket number first
    if (FlightService.isTicketNumber(code)) {
      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ItineraryScreen()),
      );
      return;
    }

    final flight = await FlightService.lookupFlight(code);
    if (!mounted) return;
    setState(() => _loading = false);

    if (flight == null) {
      setState(() => _notFound = 'No flight found for "$code".\nPlease check the flight number and try again.');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FlightDetailScreen(flight: flight)),
      );
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: _navyBlue,
        elevation: 0,
        title: Image.asset(
          'assets/egyptair_logo.png',
          height: 34,
          errorBuilder: (_, __, ___) => Text(
            'EGYPTAIR',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top search card
            Container(
              color: _navyBlue,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track Your Flight',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your flight number to get live status',
                    style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        const Icon(Icons.flight_takeoff, color: Color(0xFF1A2D6B), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1A2D6B),
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. MS001 or EF 381-7612834521',
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onSubmitted: (_) => _search(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          child: ElevatedButton(
                            onPressed: _loading ? null : _search,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navyBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              elevation: 0,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(
                                    'Search',
                                    style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_notFound != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFCC80)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFFE65100), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _notFound!,
                              style: GoogleFonts.roboto(fontSize: 13, color: const Color(0xFFE65100)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Quick-access flights
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Today's Flights",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2D6B),
                ),
              ),
            ),
            const SizedBox(height: 14),
            ..._quickFlights.map((item) => _QuickFlightTile(
              flightCode: item['code']!,
              route: item['route']!,
              time: item['time']!,
              status: item['status']!,
              onTap: () {
                _searchCtrl.text = item['code']!;
                _search();
              },
            )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

const _quickFlights = [
  {'code': 'MS001', 'route': 'Cairo → London', 'time': '08:30', 'status': 'On Time'},
  {'code': 'MS700', 'route': 'Cairo → Dubai', 'time': '16:45', 'status': 'Boarding'},
  {'code': 'MS100', 'route': 'Cairo → New York', 'time': '02:15', 'status': 'Delayed'},
  {'code': 'MS600', 'route': 'Cairo → Riyadh', 'time': '09:30', 'status': 'On Time'},
  {'code': 'MS300', 'route': 'Cairo → Frankfurt', 'time': '07:00', 'status': 'Cancelled'},
];

class _QuickFlightTile extends StatelessWidget {
  final String flightCode;
  final String route;
  final String time;
  final String status;
  final VoidCallback onTap;

  const _QuickFlightTile({
    required this.flightCode,
    required this.route,
    required this.time,
    required this.status,
    required this.onTap,
  });

  Color get _statusColor {
    switch (status) {
      case 'Delayed': return const Color(0xFFE65100);
      case 'Cancelled': return const Color(0xFFE53935);
      case 'Boarding': return const Color(0xFF1565C0);
      default: return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2D6B).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flight_takeoff, color: Color(0xFF1A2D6B), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        flightCode,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF1A2D6B),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        route,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Departs $time',
                    style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _statusColor,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
