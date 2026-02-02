import 'package:flutter/material.dart';
import '../data/food_data.dart';
import '../service/location_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../service/cart_service.dart';

class FoodDetailPage extends StatefulWidget {
  final String name;
  const FoodDetailPage({super.key, required this.name});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  String gpsText = "กำลังคำนวณระยะทาง...";
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    loadLocation();
    final food = FoodData.foods[widget.name]!;
    _controller = VideoPlayerController.asset(food["video"])
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadLocation() async {
    final food = FoodData.foods[widget.name]!;
    try {
      final pos = await LocationService.getCurrentLocation();
      final dist = LocationService.distanceKm(pos.latitude, pos.longitude, food["lat"], food["lng"]);
      setState(() {
        gpsText = "📍 พิกัดร้าน: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}\n🚗 ระยะทางห่างจากคุณ ${dist.toStringAsFixed(2)} กม.";
      });
    } catch (e) {
      setState(() => gpsText = "ไม่สามารถระบุตำแหน่งพิกัดได้");
    }
  }

  // ฟังก์ชันแสดงวิดีโอแบบ Pop-up กึ่งกลางจอ
  void _showVideoDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                shape: const StadiumBorder(),
              ),
              icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
              label: Text(_controller.value.isPlaying ? "หยุดวิดีโอ" : "เล่นวิดีโอ", style: const TextStyle(color: Colors.white)),
              onPressed: () => setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
                Navigator.pop(context);
                _showVideoDialog();
              }),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = FoodData.foods[widget.name]!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.grey[850], // สีบาร์เทาเข้ม
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // ส่วนวัตถุดิบ
            _buildExpansionSection("🥬 วัตถุดิบประกอบอาหาร", food["ingredients"]),
            // ส่วนวิธีทำ
            _buildExpansionSection("👨‍🍳 ขั้นตอนการทำ", food["steps"]),
            
            const SizedBox(height: 40),

            // --- ปุ่มวงรีโทนสีเทาทั้งหมด ---
            
            // 1. ปุ่มวิดีโอ - เทาเข้ม
            _buildOvalGreyButton(Icons.videocam, "กดดูวิดีโอสอนทำ", Colors.grey[800]!, _showVideoDialog),
            const SizedBox(height: 15),

            // 2. ปุ่มนำทาง - เทากลาง
            _buildOvalGreyButton(Icons.map, "กดนำทางไปที่ร้าน", Colors.grey[700]!, () async {
              final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${food["lat"]},${food["lng"]}");
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }),
            const SizedBox(height: 15),

            // 3. ปุ่มสั่งอาหาร - เทาอ่อน (แต่ดูแข็งแรง)
            _buildOvalGreyButton(Icons.add_shopping_cart, "เพิ่มลงตะกร้า • ${food["price"]} บาท", Colors.grey[600]!, () {
              CartService.addItem(widget.name, food["price"]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("เพิ่มเมนูลงตะกร้าแล้วเรียบร้อย 🛒", style: TextStyle(color: Colors.white)), backgroundColor: Colors.black87),
              );
            }),

            const SizedBox(height: 60),

            // --- ระยะทางอยู่ล่างสุด ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                gpsText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับ ExpansionTile (วัตถุดิบ/วิธีทำ)
  Widget _buildExpansionSection(String title, List items) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
        children: items.map((item) => ListTile(
          leading: const Icon(Icons.check_circle_outline, color: Colors.grey, size: 20),
          title: Text(item.toString()),
        )).toList(),
      ),
    );
  }

  // ฟังก์ชันสร้างปุ่มวงรีสีเทา
  Widget _buildOvalGreyButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const StadiumBorder(),
          elevation: 2,
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
      ),
    );
  }
}