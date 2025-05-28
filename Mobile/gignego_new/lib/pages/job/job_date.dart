import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobListWithDatePage extends StatefulWidget {
  const JobListWithDatePage({super.key});

  @override
  State<JobListWithDatePage> createState() => _JobListWithDatePageState();
}

class _JobListWithDatePageState extends State<JobListWithDatePage> {
  late List<Map<String, String>> dates;
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateFormat('yyyy-MM-dd').format(now); 

    dates = List.generate(14, (index) {
      final date = now.add(Duration(days: index));
      return {
        'day': DateFormat('d').format(date),
        'label': DateFormat.EEEE('id_ID').format(date),
        'dateKey': DateFormat('yyyy-MM-dd').format(date),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pekerjaan"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dates.map((date) {
                  final bool isSelected = date['dateKey'] == selectedDate;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date['dateKey']!;
                        });
                      },
                      child: Column(
                        children: [
                          Text(DateFormat.MMMM('id_ID').format(DateTime.now())),
                          const SizedBox(height: 4),
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Pekerjaan untuk tanggal: $selectedDate",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          // Contoh daftar pekerjaan
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services),
                  title: const Text("Membersihkan rumah"),
                  subtitle: Text("Tanggal: $selectedDate"),
                ),
                ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: const Text("Cuci mobil"),
                  subtitle: Text("Tanggal: $selectedDate"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
