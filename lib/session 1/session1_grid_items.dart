import 'package:flutter/material.dart';
import 'package:medical_dashboard/Widgets/stat_card.dart';
import 'package:medical_dashboard/constants/constant.dart';

class Session1GridItems extends StatelessWidget {
  const Session1GridItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

          return Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: const [
                  StatCard(text: 'Assisted', image: AssetImage(assistedNo)),
                  StatCard(text: 'Monsoon', image: AssetImage(monsoon)),
                  StatCard(text: 'Score', image: AssetImage(scoreS1)),
                  StatCard(
                      text: 'Session Time', image: AssetImage(sessionTimeS1)),
                ],
              ),
              const SizedBox(height: 16),
              const StatCard(
                  height: 125,
                  width: double.infinity,
                  text: 'Success Rate',
                  image: AssetImage(successRateS1)),
            ],
          );
        },
      ),
    );
  }
}
