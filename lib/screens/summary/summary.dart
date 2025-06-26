import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_app/components/components.dart';
import 'package:meal_app/screens/food_item/food_item.dart';
import 'package:meal_app/screens/welcome_page/welcome_page.dart';

class SummaryScreen extends StatefulWidget {
  final Map<String, int> selected;
  final List<FoodItem> allItems;

  SummaryScreen({required this.selected, required this.allItems});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Map<String, int> selected;

  @override
  void initState() {
    super.initState();
    selected = Map<String, int>.from(widget.selected); // make editable copy
  }

  FoodItem _getItemByName(String name) {
    return widget.allItems.firstWhere(
      (item) => item.name == name,
      orElse: () => FoodItem(name: name, calories: 0, imageUrl: '', price: 0, category: ''),
    );
  }

  int get totalCalories => selected.entries.fold(0, (total, entry) {
    final item = _getItemByName(entry.key);
    return total + (entry.value * item.calories);
  });

  int get totalPrice => selected.entries.fold(0, (total, entry) {
    final item = _getItemByName(entry.key);
    return total + (entry.value * item.price);
  });

  void _increaseQuantity(String name) {
    setState(() {
      selected[name] = (selected[name] ?? 0) + 1;
    });
  }

  void _decreaseQuantity(String name) {
    setState(() {
      if (selected[name] != null && selected[name]! > 0) {
        selected[name] = selected[name]! - 1;
      }
    });
  }

  Future<void> sendOrder(BuildContext context) async {
    final items = selected.entries.map((e) {
      final item = _getItemByName(e.key);
      return {
        "name": e.key,
        "total_price": e.value * item.price,
        "quantity": e.value,
      };
    }).toList();

    final response = await http.post(
      Uri.parse("https://uz8if7.buildship.run/placeOrder"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"items": items}),
    );

    if (response.statusCode == 200 && response.body.contains("true")) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order summary"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selected.length,
              itemBuilder: (context, index) {
                String name = selected.keys.elementAt(index);
                int quantity = selected[name]!;
                final item = _getItemByName(name);
                return OrderItemTile(
                  item: item,
                  quantity: quantity,
                  onAdd: () => _increaseQuantity(name),
                  onRemove: () => _decreaseQuantity(name),
                );
              },
            ),
          ),
          OrderSummaryFooter(
            totalCalories: totalCalories,
            totalPrice: totalPrice,
            onConfirm: () => sendOrder(context),
          ),
        ],
      ),
    );
  }
}
