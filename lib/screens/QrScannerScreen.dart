import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quét mã QR')),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture barcodeCapture) {
          // Check if any barcodes are detected
          if (barcodeCapture.barcodes.isNotEmpty) {
            // Get the first barcode detected
            final barcode = barcodeCapture.barcodes.first;
            final String? code = barcode.rawValue;

            if (code != null) {
              Navigator.pop(context, code); // Return the detected code
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ensure the controller is initialized before toggling torch
          if (cameraController.autoStart) {
            cameraController.toggleTorch();
          } else {
            print("Controller is not initialized yet");
          }
        },
        child: Icon(Icons.flash_on),
      ),
    );
  }
}
