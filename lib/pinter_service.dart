import 'dart:math';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';

class PrinterService {
  bool connected = false;

  PrinterService();

  bool getConnectedState() {
    return connected;
  }

  Future<void> setConnect(String ipAddress) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect(ipAddress, port: 9100);
    connected = res == PosPrintResult.success;

    if (!connected) {
      // Handle connection failure
    }
  }

  Future<void> printText() async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect('192.168.100.26', port: 9100);
    if (res == PosPrintResult.success) {
      await _printSampleText(printer);
      printer.disconnect();
    }
  }

  Future<void> printTicket() async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect('192.168.100.26', port: 9100);
    if (res == PosPrintResult.success) {
      await _printSampleTicket(printer);
      printer.disconnect();
    }
  }

  Future<void> printGraphics() async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect('192.168.100.26', port: 9100);
    if (res == PosPrintResult.success) {
      await _printSampleGraphics(printer);
      printer.disconnect();
    }
  }

  Future<void> printImage() async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect('192.168.100.26', port: 9100);
    if (res == PosPrintResult.success) {
      await _printSampleImage(printer);
      printer.disconnect();
    }
  }

  Future<void> _printSampleText(NetworkPrinter printer) async {
    final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());
    List<int> bytes = [];

    bytes += generator.feed(1);
    bytes += generator.hr(ch: '-', linesAfter: 0);
    bytes += generator.text("Impresion de texto de prueba", styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '-', linesAfter: 0);
    bytes += generator.feed(4);

    printer.rawBytes(bytes);
  }

  Future<void> _printSampleTicket(NetworkPrinter printer) async {
    final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());
    List<int> bytes = [];
    var rng = Random();
    int sum = 0;
    int randomInt;

    final ByteData data = await rootBundle.load('assets/images/logo.png');
    final Uint8List byteses = data.buffer.asUint8List();
    var image = decodeImage(byteses);
    bytes += generator.image(image!);

    bytes += generator.text("Ecuador, Guayaquil", styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('+532 5543522237', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.feed(1);
    bytes += generator.text('Cliente #', styles: const PosStyles(align: PosAlign.left));
    sum += rng.nextInt(1000);
    bytes += generator.row([
      PosColumn(
          text: 'Producto 1',
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "$sum  ",
          width: 7,
          styles: const PosStyles(
            align: PosAlign.right,
          )),
    ]);
    randomInt = rng.nextInt(1000);
    sum += randomInt;
    bytes += generator.row([
      PosColumn(
          text: 'Producto 2',
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "$randomInt  ",
          width: 7,
          styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
              height: PosTextSize.size1
          )),
    ]);
    randomInt = rng.nextInt(1000);
    sum += randomInt;
    bytes += generator.row([
      PosColumn(
          text: 'Producto 3',
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "$randomInt  ",
          width: 7,
          styles: const PosStyles(
              align: PosAlign.right,
              bold: true
          )),
    ]);

    bytes += generator.row([
      PosColumn(
          text: 'Total',
          width: 5,
          styles: const PosStyles(
            align: PosAlign.left,
          )),
      PosColumn(
          text: "$sum  ",
          width: 7,
          styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
              height: PosTextSize.size3
          )),
    ]);

    bytes += generator.feed(4);
    bytes += generator.hr(ch: '-', linesAfter: 0);
    bytes += generator.text('Firma', styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.feed(1);
    bytes += generator.text("${DateFormat.yMd().format(DateTime.now())} ${DateFormat.jm().format(DateTime.now())}",
        styles: const PosStyles(align: PosAlign.center), linesAfter: 0);
    bytes += generator.feed(5);

    printer.rawBytes(bytes);
  }

  Future<void> _printSampleGraphics(NetworkPrinter printer) async {
    final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());
    List<int> bytes = [];

    bytes += generator.qrcode('https://bluicesoftware.com/');
    bytes += generator.hr();
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.feed(3);

    printer.rawBytes(bytes);
  }

  Future<void> _printSampleImage(NetworkPrinter printer) async {
    final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());
    List<int> bytes = [];

    final ByteData data = await rootBundle.load('assets/images/logo.png');
    final Uint8List byteses = data.buffer.asUint8List();
    var image = decodeImage(byteses);
    bytes += generator.image(image!);
    bytes += generator.feed(3);

    printer.rawBytes(bytes);
  }
}
