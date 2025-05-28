import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final Widget? statusWidget; 
  final Color color;
  final IconData icon;
  final Image image;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.statusWidget,
    required this.color,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: image,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    // Menampilkan status jika ada
                    statusWidget ?? const Text(
                      'Status tidak tersedia',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
