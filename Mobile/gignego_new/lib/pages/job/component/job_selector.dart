import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  String selectedDay = '8'; 

  final List<Map<String, String>> dates = [
    {'day': '1', 'label': 'Senin'},
    {'day': '2', 'label': 'Selasa'},
    {'day': '3', 'label': 'Rabu'},
    {'day': '4', 'label': 'Kamis'},
    {'day': '5', 'label': 'Jumat'},
    {'day': '6', 'label': 'Sabtu'},
    {'day': '7', 'label': 'Minggu'},
    {'day': '8', 'label': 'Senin'},
    {'day': '9', 'label': 'Selasa'},
    {'day': '10', 'label': 'Rabu'},
    {'day': '11', 'label': 'Kamis'},
    {'day': '12', 'label': 'Jumat'},
    {'day': '13', 'label': 'Sabtu'},
    {'day': '14', 'label': 'Minggu'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: dates.map((date) {
            final bool isSelected = date['day'] == selectedDay;

            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDay = date['day']!;
                  });

                  // Optional: tampilkan log tanggal terpilih
                  debugPrint('Tanggal dipilih: ${date['day']} - ${date['label']}');
                },
                child: Column(
                  children: [
                    const Text('Maret'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.purple : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.purple : Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            date['day']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            date['label']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
