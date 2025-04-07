import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math' as math;
import 'package:uuid/uuid.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final String uniqueCode = const Uuid().v4();
  bool _isScanned = false; // Track whether the QR code has been scanned

  // Simulate QR code scan
  void _simulateScan() {
    setState(() {
      _isScanned = true;
    });
    // Optional: Show a confirmation to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code has been scanned successfully!'),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String qrData = "https://bizmart-connectivity.lovable.app/";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Referral Program',
                    style: TextStyle(color: Colors.black),
                  ),
                  content: const Text(
                    'Share this QR code with friends. When they scan it, they\'ll receive special rewards and you\'ll earn points toward exclusive discounts!',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Got it',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Share your referral code',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your friends will get special rewards!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              // Add a tap handler to the QR code to simulate scanning
              onTap: _simulateScan,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData,
                      size: 200.0,
                      backgroundColor: Colors.white,
                      embeddedImage: AssetImage('assets/app_logo.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: const Size(40, 40),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Show a hint for debugging/demo purposes
                    const Text(
                      'Tap QR to simulate scan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Show reward button only when QR is scanned
            if (_isScanned)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CongratulationsScreen(referralCode: uniqueCode),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Claim Your Reward',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  'Waiting for scan...',
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Your Code: ${uniqueCode.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}

class CongratulationsScreen extends StatefulWidget {
  final String referralCode;

  const CongratulationsScreen({
    super.key,
    required this.referralCode,
  });

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _reward = '';
  bool _isSpinning = false;
  bool _showReward = false;
  int _selectedRewardIndex = 0;

  final List<String> _rewards = [
    '10% OFF',
    '15% OFF',
    '30% OFF',
    '20% OFF',
    '35% OFF',
    '5% OFF',
    'Free delivery',
    '25% OFF',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSpinning = false;
          _showReward = true;
          // Make sure we display the reward that corresponds to where the wheel stopped
          _reward = _rewards[_selectedRewardIndex];
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (!_isSpinning) {
      final random = math.Random();
      // Store the selected index for later use
      _selectedRewardIndex = random.nextInt(_rewards.length);

      // Calculate how many complete rotations plus the portion to the selected segment
      final spinRotations =
          5 + random.nextDouble() * 3; // Random number of complete rotations

      // Calculate the final angle that corresponds to the selected reward
      // We need to offset to make sure the pointer stops at the middle of the segment
      final segmentAngle = 2 * math.pi / _rewards.length;
      final targetAngle =
          (_selectedRewardIndex * segmentAngle) + (segmentAngle / 2);

      // Calculate the total rotation (complete rotations + target angle)
      final totalRotation = (spinRotations * 2 * math.pi) + targetAngle;

      _controller.reset();
      _animation = Tween<double>(
        begin: 0,
        end: totalRotation,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ));

      setState(() {
        _isSpinning = true;
        _showReward = false;
      });

      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Congratulations!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.celebration,
                    size: 50,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'You were referred by a friend (Code: ${widget.referralCode.substring(0, 8).toUpperCase()})',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Spin the wheel to claim your reward!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: _animation.value,
                          child: Container(
                            width: 280,
                            height: 280,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: CustomPaint(
                              painter: WheelPainter(_rewards),
                            ),
                          ),
                        ),
                        // Stationary pointer
                        Transform.rotate(
                          angle: 0, // Always points up
                          child: Container(
                            width: 20,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.touch_app,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (_showReward)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Reward:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _reward,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Saved to your account!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _isSpinning ? null : _spinWheel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor: Colors.black38,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isSpinning ? 'Spinning...' : 'SPIN THE WHEEL',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<String> rewards;

  WheelPainter(this.rewards);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sectionAngle = 2 * math.pi / rewards.length;

    // Black and white colors for wheel sections
    final colors = [
      Colors.black,
      Colors.white,
    ];

    for (int i = 0; i < rewards.length; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      final startAngle = i * sectionAngle;
      final sweepAngle = sectionAngle;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final borderPaint = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Text color based on section color
      final textColor = colors[i % colors.length] == Colors.black
          ? Colors.white
          : Colors.black;

      final textPainter = TextPainter(
        text: TextSpan(
          text: rewards[i],
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final textAngle = startAngle + (sweepAngle / 2);
      final textRadius = radius * 0.7;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(textAngle + math.pi / 2);
      canvas.translate(0, -textRadius);
      canvas.rotate(-math.pi / 2);

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }

    final outerCirclePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, outerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
