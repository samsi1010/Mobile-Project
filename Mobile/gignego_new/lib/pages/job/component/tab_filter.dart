import 'package:flutter/material.dart';
import 'package:flutter_application/pages/job/available_jobs_page.dart';
import 'package:flutter_application/pages/job/process_jobs_page.dart';
import 'package:flutter_application/pages/job/all_jobs_page.dart';
import 'package:flutter_application/pages/job/job_list_page.dart';

class TabFilter extends StatefulWidget {
  const TabFilter({super.key});

  @override
  State<TabFilter> createState() => _TabFilterState();
}

class _TabFilterState extends State<TabFilter> {
  String selectedStatus = "Semua";

  final List<String> statuses = ["Semua", "Tersedia", "Dalam Proses", "Selesai"];

  void _onChipTap(String status) {
    setState(() {
      selectedStatus = status;
    });

    // Navigasi ke halaman sesuai status
    switch (status) {
      case "Semua":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const JobListPage()));
        break;
      case "Tersedia":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AvailableJobsPage()));
        break;
      case "Dalam Proses":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProcessJobsPage()));
        break;
      case "Selesai":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AllJobsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: statuses.map((status) {
          final bool isSelected = status == selectedStatus;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                status,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => _onChipTap(status),
              selectedColor: const Color.fromARGB(255, 194, 51, 219),
              backgroundColor: Colors.grey.shade200,
              elevation: isSelected ? 4 : 0,
              pressElevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(
                color: isSelected ? Colors.purple : Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }
}
