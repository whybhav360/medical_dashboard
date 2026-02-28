import 'package:flutter/material.dart';
import 'package:medical_dashboard/Widgets/movement_data.dart';
import 'package:medical_dashboard/session 1/session1_grid_items.dart';
import 'package:medical_dashboard/session 2/session2_grid_items.dart';
import 'package:medical_dashboard/Widgets/user_welcome.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedSession = "Session 1";

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
    return SafeArea(
      child: Column(
        children: [
          UserWelcome(
            selectedSession: _selectedSession,
            onSessionChanged: _onSessionChanged,
          ),
          Expanded(
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
        ],
      ),
    );
  }
}
