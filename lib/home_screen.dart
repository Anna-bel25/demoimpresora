import 'package:demoimpresora/pinter_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String printerIp = '192.168.100.26'; // Dirección IP de la impresora
  bool connected = false;
  PrinterService printerService = PrinterService();

  void connectPrinter() async {
    await printerService.setConnect(printerIp);
    setState(() {
      connected = printerService.getConnectedState();
    });

    if (!connected) {
      showSnackBar('No se pudo conectar a la impresora');
    }
  }

  void showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        margin: const EdgeInsets.all(50),
        elevation: 1,
        duration: const Duration(milliseconds: 800),
        backgroundColor: const Color(0xFF08919C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00398f),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: const Text('Demo impresora IP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widthScreen,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 17),
                  backgroundColor: const Color(0xFF00398f),
                ),
                onPressed: connectPrinter,
                child: const Text('Conectar impresora'),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: widthScreen,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 17),
                  backgroundColor: const Color(0xFF08919C),
                ),
                onPressed: connected ? () => printerService.printText() : null,
                child: const Text('Texto'),
              ),
            ),
            SizedBox(
              width: widthScreen,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 17),
                  backgroundColor: const Color(0xFF08919C),
                ),
                onPressed: connected ? () => printerService.printTicket() : null,
                child: const Text('Ticket'),
              ),
            ),
            SizedBox(
              width: widthScreen,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 17),
                  backgroundColor: const Color(0xFF08919C),
                ),
                onPressed: connected ? () => printerService.printGraphics() : null,
                child: const Text('Gráficos'),
              ),
            ),
            SizedBox(
              width: widthScreen,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 17),
                  backgroundColor: const Color(0xFF08919C),
                ),
                onPressed: connected ? () => printerService.printImage() : null,
                child: const Text('Imagen'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

