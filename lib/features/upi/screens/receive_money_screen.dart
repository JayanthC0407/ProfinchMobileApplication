import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import '../provider/upi_provider.dart';

class ReceiveMoneyScreen extends StatelessWidget {
  const ReceiveMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UpiProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Receive Money',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Share UPI ID
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            // ── Profile + UPI card ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF42001E), Color(0xFFE01A37)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      provider.myName
                          .split(' ')
                          .map((e) => e[0])
                          .take(2)
                          .join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.myName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.myUpiId,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── QR Code ────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Scan to Pay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── QR code placeholder ────────────────────────
                  // TODO: Replace with real QR using qr_flutter package
                  // QrImageView(data: provider.myUpiId, size: 200)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.primaryDark, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Corner decorations
                        ..._buildQrCorners(),
                        // Center content
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.account_balance,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'ProFinch Pay',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add qr_flutter\nto show QR',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Show this QR code to receive payment',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── UPI ID copy card ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.alternate_email_rounded,
                        color: AppColors.primaryDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your UPI ID',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.myUpiId,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: provider.myUpiId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('UPI ID copied!'),
                          backgroundColor: Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(Icons.copy_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── QR corner decorators ───────────────────────────────────────
  static List<Widget> _buildQrCorners() {
    const size = 20.0;
    const thickness = 3.0;
    const color = Color(0xFF42001E);

    Widget corner(AlignmentGeometry align, double rotateAngle) =>
        Positioned.fill(
          child: Align(
            alignment: align,
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _CornerPainter(rotateAngle, color, thickness),
              ),
            ),
          ),
        );

    return [
      corner(Alignment.topLeft, 0),
      corner(Alignment.topRight, 90),
      corner(Alignment.bottomRight, 180),
      corner(Alignment.bottomLeft, 270),
    ];
  }
}

class _CornerPainter extends CustomPainter {
  final double angle;
  final Color color;
  final double thickness;

  _CornerPainter(this.angle, this.color, this.thickness);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle * 3.14159 / 180);
    canvas.translate(-size.width / 2, -size.height / 2);

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}