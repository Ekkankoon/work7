import 'package:flutter/material.dart';
import '../service/cart_service.dart';
import '../service/sale_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final items = CartService.items;
    int total = items.fold(0, (sum, i) => sum + i.total);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("CART", style: TextStyle(letterSpacing: 2, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty 
              ? const Center(child: Text("Empty Cart", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text("฿${item.price}"),
                        trailing: Container(
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(item.qty > 1 ? Icons.remove : Icons.delete_outline, color: Colors.grey),
                                onPressed: () => setState(() {
                                  if (item.qty > 1) CartService.decrease(item.name);
                                  else CartService.removeItem(item.name);
                                }),
                              ),
                              Text("${item.qty}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.grey),
                                onPressed: () => setState(() => CartService.increase(item.name)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TOTAL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text("฿$total", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[850], // สีเทาเข้มเกือบดำ
                      shape: const StadiumBorder(),
                    ),
                    onPressed: items.isEmpty ? null : () async {
                      await SaleService.saveCart(items);
                      CartService.clear();
                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text("CONFIRM ORDER", style: TextStyle(color: Colors.white, letterSpacing: 1)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}