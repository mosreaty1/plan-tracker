import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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

  static const _navy = Color(0xFF1A2D6B);

  Future<void> _search() async {
    final code = _searchCtrl.text.trim();
    if (code.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() { _loading = true; _notFound = null; });

    if (FlightService.isTicketNumber(code)) {
      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ItineraryScreen()));
      return;
    }

    await Future.delayed(const Duration(milliseconds: 800));
    final flight = await FlightService.lookupFlight(code);
    if (!mounted) return;
    setState(() => _loading = false);

    if (flight == null) {
      setState(() => _notFound = 'No flight found for "$code".\nPlease check the number and try again.');
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FlightDetailScreen(flight: flight)));
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url'), backgroundColor: _navy),
        );
      }
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
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 0,
        title: Image.asset(
          'assets/logo_white.png',
          height: 36,
          errorBuilder: (_, __, ___) => Text(
            'EGYFLY',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              fontSize: 20,
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

            // ── Search banner ──────────────────────────────
            Container(
              color: _navy,
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
                    'Enter a flight code or e-ticket number',
                    style: GoogleFonts.roboto(color: Colors.white60, fontSize: 13),
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
                        const Icon(Icons.flight_takeoff, color: _navy, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: _navy,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. MS001 or EF 381-7612834521',
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.grey.shade400,
                                fontSize: 13,
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
                              backgroundColor: _navy,
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

            const SizedBox(height: 24),

            // ── EgyFly logo + branding card ────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    Image.asset(
                      'assets/logo_blue.png',
                      height: 60,
                      errorBuilder: (_, __, ___) => Text(
                        'EGYFLY',
                        style: GoogleFonts.roboto(
                          color: _navy,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your Egyptian Low-Cost Carrier',
                      style: GoogleFonts.roboto(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Official Websites ──────────────────────────
            _SectionHeader(title: 'Official Websites'),
            _LinkTile(
              icon: Icons.language_outlined,
              label: 'Main Site',
              subtitle: 'www.flyegypt.com',
              onTap: () => _launch('https://www.flyegypt.com'),
            ),
            _LinkTile(
              icon: Icons.airplane_ticket_outlined,
              label: 'Book a Flight',
              subtitle: 'www.flyegypt.com/book',
              onTap: () => _launch('https://www.flyegypt.com/book'),
            ),
            _LinkTile(
              icon: Icons.edit_calendar_outlined,
              label: 'Manage Booking',
              subtitle: 'www.flyegypt.com/manage',
              onTap: () => _launch('https://www.flyegypt.com/manage'),
            ),
            _LinkTile(
              icon: Icons.link,
              label: 'Short URL',
              subtitle: 'www.fly.eg',
              onTap: () => _launch('https://www.fly.eg'),
              isLast: true,
            ),

            const SizedBox(height: 20),

            // ── Social Media ───────────────────────────────
            _SectionHeader(title: 'Social Media'),
            _LinkTile(
              icon: Icons.facebook_outlined,
              iconColor: const Color(0xFF1877F2),
              label: 'Facebook',
              subtitle: 'flyegyptairlines',
              onTap: () => _launch('https://www.facebook.com/flyegyptairlines'),
            ),
            _LinkTile(
              icon: Icons.work_outline,
              iconColor: const Color(0xFF0A66C2),
              label: 'LinkedIn',
              subtitle: 'company/flyegypt',
              onTap: () => _launch('https://www.linkedin.com/company/flyegypt'),
              isLast: true,
            ),

            const SizedBox(height: 20),

            // ── Contact ────────────────────────────────────
            _SectionHeader(title: 'Contact'),
            _LinkTile(
              icon: Icons.phone_outlined,
              iconColor: const Color(0xFF2E7D32),
              label: 'Customer Service',
              subtitle: '15290',
              onTap: () => _launch('tel:15290'),
              isLast: true,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Reusable widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A2D6B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLast;

  const _LinkTile({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1A2D6B);
    final effectiveIconColor = iconColor ?? navy;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 0 : 1),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(0),
          topRight: const Radius.circular(0),
          bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.only(
            bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: effectiveIconColor, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.open_in_new, size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
