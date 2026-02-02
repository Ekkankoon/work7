import 'package:flutter/material.dart';
import '../pages/food_detail_page.dart';

class FoodItem extends StatelessWidget {
  final String name;
  final String imagePath;

  const FoodItem({super.key, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, // กำหนดความกว้างให้คงที่เพื่อความกึ่งกลางที่เป๊ะ
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // รูปภาพทรงกลมพร้อมเงาจางๆ
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // ชื่ออาหาร
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF454545),
            ),
          ),
          const SizedBox(height: 8),
          // ปุ่ม "กดดู" สีเทา Minimal
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200], // สีเทาอ่อนมาก
              foregroundColor: Colors.grey[700], // สีตัวอักษรเทาเข้ม
              elevation: 0,
              shape: const StadiumBorder(),
              minimumSize: const Size(80, 30),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FoodDetailPage(name: name)),
              );
            },
            child: const Text(
              "กดดู",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}