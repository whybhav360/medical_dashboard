import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';

class UserWelcome extends StatefulWidget {
  final String selectedSession;
  final ValueChanged<String> onSessionChanged;

  const UserWelcome(
      {super.key, required this.selectedSession, required this.onSessionChanged});

  @override
  State<UserWelcome> createState() => UserWelcomeState();
}

class UserWelcomeState extends State<UserWelcome> {
  DateTime selectedDate = DateTime.now();
  final List<String> _sessions = [
    "Session 1",
    "Session 2",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello,',
                      style: TextStyle(fontSize: 20, color: Color(0xff6B7280)),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Mr.Vaibhav, ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff0284C7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'here is your performance',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  var datePicked = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3090),
                    dateFormat: "dd-MMMM-yyyy",
                    locale: DateTimePickerLocale.en_us,
                    looping: true,
                  );
                  if (datePicked != null) {
                    setState(() {
                      selectedDate = datePicked;
                    });
                  }
                },
                child: Text(
                  DateFormat('dd MMM yyyy').format(selectedDate),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Select Session'),
                        children: _sessions.map((session) {
                          return SimpleDialogOption(
                            onPressed: () {
                              widget.onSessionChanged(session);
                              Navigator.pop(context);
                            },
                            child: Text(session),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
                child: Text(widget.selectedSession),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
