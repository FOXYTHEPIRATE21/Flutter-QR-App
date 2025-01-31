import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'QR Code Scanner',
      home: ScanQRCode(),
    ),
  );
}

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String qrResult = 'Scan your QR Code';
  final MobileScannerController cameraController = MobileScannerController();

  void _onQRCodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          qrResult = barcode.rawValue!; // Actualiza el resultado del escaneo
        });
        break; // Detener después de encontrar el primer código QR válido
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onQRCodeDetect,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              qrResult,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose(); // Liberar recursos de la cámara
    super.dispose();
  }
}