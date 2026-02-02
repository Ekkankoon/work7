import 'package:flutter/material.dart';
import '../widgets/food_item.dart';
import 'cart_page.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: const Text(
          "MENU",
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w300, color: Color(0xFF424242)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const CartPage())
            ).then((_) => setState(() {})),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSectionHeader("SAVORY / อาหารคาว"),
              const SizedBox(height: 30),
              Wrap(
                spacing: 30,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: const [
                  FoodItem(name: "กระเพราหมูสับ", imagePath: "assets/images/cow1.jpg"),
                  FoodItem(name: "ส้มตำ", imagePath: "assets/images/cow2.jpg"),
                  FoodItem(name: "ยำวุ้นเส้น", imagePath: "assets/images/cow3.jpg"),
                  FoodItem(name: "สลัด", imagePath: "assets/images/cow4.jpg"),
                ],
              ),
              const SizedBox(height: 60),
              _buildSectionHeader("DESSERT / ของหวาน"),
              const SizedBox(height: 30),
              Wrap(
                spacing: 30,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: const [
                  // แก้ชื่อให้ตรงกับฐานข้อมูล FoodData เพื่อให้กดเข้าดูได้
                  FoodItem(name: "เค้กช็อกโกแลตฟองดอง", imagePath: "assets/images/Sweet1.jpg"),
                  FoodItem(name: "ถังหูลู่", imagePath: "assets/images/sweet2.jpg"),
                  FoodItem(name: "ทองหยอด", imagePath: "assets/images/sweet3.jpg"),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(width: 40, height: 1, color: Colors.grey[300]),
      ],
    );
  }
}