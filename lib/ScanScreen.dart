import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; 
import 'PaymentScreen.dart';
import 'utils.dart';
import 'main.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera(); // Prevent multiple scans
      _handleScannedCode(scanData.code ?? '');
    });
  }

  void _handleScannedCode(String code) async {
  if (code.trim() == 'Garderobe 1') {
    final userId = await getUserId(); // Get or generate local user ID

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          userId: userId,
          garderobe: code,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid QR code')),
    );
    controller?.resumeCamera(); // Resume scanning if code is not valid
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.deepOrange,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 8,
            cutOutSize: 250,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Optional: mark Home as selected
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst); // Go to Home
          } else if (index == 1) {
            Navigator.popUntil(context, (route) => route.isFirst); // Reset stack
            navKey.currentState?.switchTab(1); // Switch to My Tickets tab
         }
        },
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'My tickets',
          ),
        ],
      ),
    );
  }
}
