import 'package:flutter/material.dart';
import 'package:medical_dashboard/Widgets/movement_data.dart';
import 'package:medical_dashboard/session 1/session1_grid_items.dart';
import 'package:medical_dashboard/session 2/session2_grid_items.dart';
import 'package:medical_dashboard/Widgets/user_welcome.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedSession = "Session 1";

  Future<void> _generatePDF() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final boundary =
    _pdfKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    final pdf = pw.Document();
    final pdfImage = pw.MemoryImage(pngBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  final GlobalKey _pdfKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  void _onSessionChanged(String session) {
    setState(() {
      _selectedSession = session;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: FloatingActionButton(
          elevation: 2,
          onPressed: () {
            _generatePDF();
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.picture_as_pdf),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            UserWelcome(
              selectedSession: _selectedSession,
              onSessionChanged: _onSessionChanged,
            ),
            Expanded(
              child: RepaintBoundary(
                key: _pdfKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      if (_selectedSession == "Session 1")
                        const Session1GridItems()
                      else
                        const Session2GridItems(),
                      Transform.scale(
                        scaleX: 1.17,
                        child: const Image(
                          image: AssetImage('assets/images/hand_middle.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const MovementData(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
