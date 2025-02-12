import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> with SingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  String qrResult = 'Scan a QR code';
  bool hasScanned = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start offscreen at the bottom
      end: Offset.zero, // End at the center
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid URL format'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onQRCodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && !hasScanned) {
        setState(() {
          qrResult = barcode.rawValue!;
          hasScanned = true;
        });
        HapticFeedback.mediumImpact();
        _animationController.forward(); // Slide the panel up
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onQRCodeDetect,
          ),
          // Overlay with semi-transparent background
          Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
          ),
          // Scanner cutout
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  // Corner decorations
                  ...List.generate(4, (index) {
                    final isTop = index < 2;
                    final isLeft = index.isEven;
                    return Positioned(
                      top: isTop ? -2 : null,
                      bottom: !isTop ? -2 : null,
                      left: isLeft ? -2 : null,
                      right: !isLeft ? -2 : null,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.blue, width: isTop ? 4 : 0),
                            bottom: BorderSide(color: Colors.blue, width: !isTop ? 4 : 0),
                            left: BorderSide(color: Colors.blue, width: isLeft ? 4 : 0),
                            right: BorderSide(color: Colors.blue, width: !isLeft ? 4 : 0),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Top controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: Icon(
                        isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isFlashOn = !isFlashOn;
                          cameraController.toggleTorch();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom result panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.qr_code, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Scan Result',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                qrResult,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (hasScanned) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: qrResult)).then((_) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              });
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _launchUrl(qrResult);
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                hasScanned = false;
                                qrResult = 'Scan a QR code';
                              });
                              _animationController.reverse(); // Slide the panel down
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Scan Again'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}