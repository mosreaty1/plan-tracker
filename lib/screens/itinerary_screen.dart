import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  bool _downloading = false;
  String? _downloadMessage;

  static const _navy = Color(0xFF1A2D6B);
  static const _accent = Color(0xFF2B5BAA);
  static const _lightBlue = Color(0xFFE8EEF8);

  Future<void> _downloadPdf() async {
    setState(() { _downloading = true; _downloadMessage = null; });
    try {
      final bytes = await rootBundle.load('assets/Mohamed_Alsariti_Itinerary.pdf');
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/Mohamed_Alsariti_Itinerary.pdf');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      setState(() { _downloading = false; _downloadMessage = 'Saved to: ${file.path}'; });
      await OpenFile.open(file.path);
    } catch (e) {
      setState(() { _downloading = false; _downloadMessage = 'Download failed. Please try again.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFFF2F4F8),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Color(0xFF1A2D6B),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F8),
        appBar: AppBar(
          backgroundColor: _navy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Itinerary',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            // ── Header banner ──────────────────────────────
            Container(
              color: _navy,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Trip',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'EgyFly Itinerary',
                          style: GoogleFonts.roboto(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Booking Ref',
                        style: GoogleFonts.roboto(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'B7X3KL',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'Issued: 13 April 2026',
                        style: GoogleFonts.roboto(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Traveler ──────────────────────────────────
            _buildCard(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _lightBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person_outline, color: _navy, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Traveler',
                        style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey.shade500),
                      ),
                      Text(
                        'Mohamed Alsariti',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _navy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Section label ─────────────────────────────
            _sectionLabel('Sunday, 3 May 2026'),

            // ── Outbound flight card ──────────────────────
            _FlightCard(
              flightLabel: 'EgyFly  EF 004',
              tag: 'Outbound',
              tagColor: const Color(0xFF1565C0),
              fromCode: 'CAI',
              fromCity: 'Cairo',
              fromAirport: 'Cairo International Airport',
              fromTerminal: 'Terminal 1',
              fromTime: '04:30',
              fromDate: '3 May 2026',
              toCode: 'DXB',
              toCity: 'Dubai',
              toAirport: 'Dubai International Airport',
              toTerminal: 'Terminal 3',
              toTime: '08:00',
              toDate: '3 May 2026',
              duration: '3h 30m',
              details: const [
                _Detail('Booking Status', 'Confirmed', Icons.check_circle_outline, Color(0xFF2E7D32)),
                _Detail('Class', 'Economy (Y)', Icons.airline_seat_recline_normal_outlined, null),
                _Detail('Baggage', '1 Piece(s)', Icons.luggage_outlined, null),
                _Detail('Aircraft', 'Boeing 737-800', Icons.airplanemode_active, null),
                _Detail('Flight Meal', 'Full Meal', Icons.restaurant_outlined, null),
              ],
            ),

            const SizedBox(height: 14),
            _sectionLabel('Friday, 18 April 2026'),

            // ── Return flight card ────────────────────────
            _FlightCard(
              flightLabel: 'EgyFly  EF 005',
              tag: 'Return',
              tagColor: const Color(0xFF6A1B9A),
              fromCode: 'DXB',
              fromCity: 'Dubai',
              fromAirport: 'Dubai International Airport',
              fromTerminal: 'Terminal 3',
              fromTime: '16:00',
              fromDate: '18 Apr 2026',
              toCode: 'CAI',
              toCity: 'Cairo',
              toAirport: 'Cairo International Airport',
              toTerminal: 'Terminal 1',
              toTime: '19:30',
              toDate: '18 Apr 2026',
              duration: '3h 30m',
              details: const [
                _Detail('Booking Status', 'Confirmed', Icons.check_circle_outline, Color(0xFF2E7D32)),
                _Detail('Class', 'Economy (Y)', Icons.airline_seat_recline_normal_outlined, null),
                _Detail('Baggage', '1 Piece(s)', Icons.luggage_outlined, null),
                _Detail('Aircraft', 'Boeing 737-800', Icons.airplanemode_active, null),
                _Detail('Flight Meal', 'Full Meal', Icons.restaurant_outlined, null),
              ],
            ),

            const SizedBox(height: 14),
            _sectionLabel('Thursday, 6 Aug 2026'),

            // ── Cairo → Jeddah flight card ────────────────
            _FlightCard(
              flightLabel: 'EgyFly  EF 012',
              tag: 'Outbound',
              tagColor: const Color(0xFF1565C0),
              fromCode: 'CAI',
              fromCity: 'Cairo',
              fromAirport: 'Cairo International Airport',
              fromTerminal: 'Terminal 1',
              fromTime: '06:00',
              fromDate: '6 Aug 2026',
              toCode: 'JED',
              toCity: 'Jeddah',
              toAirport: 'King Abdulaziz International Airport',
              toTerminal: 'Terminal 1',
              toTime: '08:30',
              toDate: '6 Aug 2026',
              duration: '2h 30m',
              details: const [
                _Detail('Booking Status', 'Confirmed', Icons.check_circle_outline, Color(0xFF2E7D32)),
                _Detail('Class', 'Economy (Y)', Icons.airline_seat_recline_normal_outlined, null),
                _Detail('Baggage', '1 Piece(s)', Icons.luggage_outlined, null),
                _Detail('Aircraft', 'Boeing 737-800', Icons.airplanemode_active, null),
                _Detail('Flight Meal', 'Full Meal', Icons.restaurant_outlined, null),
              ],
            ),

            const SizedBox(height: 14),
            _sectionLabel('Thursday, 20 Aug 2026'),

            // ── Cairo → Casablanca flight card ───────────
            _FlightCard(
              flightLabel: 'EgyFly  EF 018',
              tag: 'Outbound',
              tagColor: const Color(0xFF1565C0),
              fromCode: 'CAI',
              fromCity: 'Cairo',
              fromAirport: 'Cairo International Airport',
              fromTerminal: 'Terminal 1',
              fromTime: '08:00',
              fromDate: '20 Aug 2026',
              toCode: 'CMN',
              toCity: 'Casablanca',
              toAirport: 'Mohammed V International Airport',
              toTerminal: 'Terminal 1',
              toTime: '13:30',
              toDate: '20 Aug 2026',
              duration: '5h 30m',
              details: const [
                _Detail('Booking Status', 'Confirmed', Icons.check_circle_outline, Color(0xFF2E7D32)),
                _Detail('Class', 'Economy (Y)', Icons.airline_seat_recline_normal_outlined, null),
                _Detail('Baggage', '1 Piece(s)', Icons.luggage_outlined, null),
                _Detail('Aircraft', 'Airbus A320', Icons.airplanemode_active, null),
                _Detail('Flight Meal', 'Full Meal', Icons.restaurant_outlined, null),
              ],
            ),

            const SizedBox(height: 14),

            // ── Ticket details ────────────────────────────
            _buildCard(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardTitle('Ticket Details', Icons.confirmation_number_outlined),
                  const Divider(height: 1),
                  _infoRow('E-Ticket', 'EF 381-7612834521'),
                  _infoRow('Passenger', 'Mohamed Alsariti'),
                  _infoRow('Airline', 'EgyFly (EF)'),
                  _infoRow('Booking Ref', 'B7X3KL'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Ecological info ───────────────────────────
            _buildCard(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardTitle('Ecological Information', Icons.eco_outlined),
                  const Divider(height: 1),
                  _infoRow('CO₂ Emission', '115.11 kg / person'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      'Source: ICAO Carbon Emissions Calculator',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Download button ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _downloading ? null : _downloadPdf,
                      icon: _downloading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download_rounded, size: 20),
                      label: Text(
                        _downloading ? 'Preparing PDF...' : 'Download Itinerary PDF',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _navy.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  if (_downloadMessage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _downloadMessage!.startsWith('Saved')
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _downloadMessage!.startsWith('Saved')
                              ? const Color(0xFFA5D6A7)
                              : const Color(0xFFFFCC80),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _downloadMessage!.startsWith('Saved')
                                ? Icons.check_circle_outline
                                : Icons.warning_amber_outlined,
                            size: 16,
                            color: _downloadMessage!.startsWith('Saved')
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFE65100),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _downloadMessage!,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: _downloadMessage!.startsWith('Saved')
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFE65100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _accent,
            letterSpacing: 0.3,
          ),
        ),
      );

  static Widget _buildCard({required Widget child, EdgeInsets? margin}) => Container(
        margin: margin ?? EdgeInsets.zero,
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
        child: child,
      );

  static Widget _cardTitle(String title, IconData icon) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
      );

  static Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

// ── Flight card widget ─────────────────────────────────────────────────────────

class _Detail {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  const _Detail(this.label, this.value, this.icon, this.valueColor);
}

class _FlightCard extends StatefulWidget {
  final String flightLabel;
  final String tag;
  final Color tagColor;
  final String fromCode, fromCity, fromAirport, fromTerminal, fromTime, fromDate;
  final String toCode, toCity, toAirport, toTerminal, toTime, toDate;
  final String duration;
  final List<_Detail> details;

  const _FlightCard({
    required this.flightLabel,
    required this.tag,
    required this.tagColor,
    required this.fromCode,
    required this.fromCity,
    required this.fromAirport,
    required this.fromTerminal,
    required this.fromTime,
    required this.fromDate,
    required this.toCode,
    required this.toCity,
    required this.toAirport,
    required this.toTerminal,
    required this.toTime,
    required this.toDate,
    required this.duration,
    required this.details,
  });

  @override
  State<_FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<_FlightCard> {
  bool _expanded = false;

  static const _navy = Color(0xFF1A2D6B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _navy.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.flight_takeoff, color: _navy, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.flightLabel,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: _navy,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.tagColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.tag,
                    style: GoogleFonts.roboto(
                      color: widget.tagColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Route row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Origin
                _AirportCol(
                  code: widget.fromCode,
                  city: widget.fromCity,
                  time: widget.fromTime,
                  date: widget.fromDate,
                  align: CrossAxisAlignment.start,
                ),
                // Line
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.duration,
                        style: GoogleFonts.roboto(fontSize: 10, color: Colors.grey.shade400),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle)),
                          Expanded(child: Container(height: 1, color: Colors.grey.shade200)),
                          const Icon(Icons.airplanemode_active, size: 16, color: _navy),
                          Expanded(child: Container(height: 1, color: Colors.grey.shade200)),
                          Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle)),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Non-stop',
                        style: GoogleFonts.roboto(fontSize: 10, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),
                // Destination
                _AirportCol(
                  code: widget.toCode,
                  city: widget.toCity,
                  time: widget.toTime,
                  date: widget.toDate,
                  align: CrossAxisAlignment.end,
                ),
              ],
            ),
          ),

          // Expandable details
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.vertical(
                  bottom: _expanded ? Radius.zero : const Radius.circular(14),
                ),
                border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _expanded ? 'Hide Details' : 'Show Details',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, color: _navy, size: 18),
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            const Divider(height: 1),
            // Airport details
            _expandedRow(Icons.flight_takeoff, 'Departure Airport',
                '${widget.fromAirport}\n${widget.fromTerminal}'),
            _expandedRow(Icons.flight_land, 'Arrival Airport',
                '${widget.toAirport}\n${widget.toTerminal}'),
            const Divider(height: 1, indent: 16, endIndent: 16),
            ...widget.details.map(
              (d) => _expandedRow(d.icon, d.label, d.value, valueColor: d.valueColor),
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }

  Widget _expandedRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? const Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AirportCol extends StatelessWidget {
  final String code, city, time, date;
  final CrossAxisAlignment align;

  const _AirportCol({
    required this.code,
    required this.city,
    required this.time,
    required this.date,
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
            fontWeight: FontWeight.w800,
            fontSize: 26,
            color: const Color(0xFF1A2D6B),
          ),
        ),
        Text(
          city,
          style: GoogleFonts.roboto(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color(0xFF1F2937),
          ),
        ),
        Text(
          date,
          style: GoogleFonts.roboto(fontSize: 10, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}
