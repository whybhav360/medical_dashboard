import 'package:flutter/material.dart';
import 'package:medical_dashboard/below_graph.dart';

import 'custom_line_chart.dart';

class MovementData extends StatefulWidget {
  const MovementData({super.key});

  @override
  State<MovementData> createState() => _MovementDataState();
}

class _MovementDataState extends State<MovementData> {
  bool isMcpSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMcpSelected = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isMcpSelected ? Colors.lightBlue : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'MCP',
                      style: TextStyle(
                        color: isMcpSelected ? Colors.white : Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMcpSelected = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !isMcpSelected ? Colors.lightBlue : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'PIP',
                      style: TextStyle(
                        color: !isMcpSelected ? Colors.white : Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Index Finger',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'ROM',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: isMcpSelected ? 0.2 : 0.5,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.lightBlue),
                      ),
                    ),
                    Text(
                      isMcpSelected ? '20°' : '50°',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(
                    height: 580,
                    width: double.infinity,
                    child: CustomLineChart())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
