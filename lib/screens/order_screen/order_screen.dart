import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/components/components.dart';
import 'package:meal_app/screens/food_item/food_item.dart';
import 'package:meal_app/screens/summary/summary.dart';

class OrderScreen extends StatefulWidget {
  final double dailyCalories;
  OrderScreen({required this.dailyCalories});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final Map<String, int> selectedItems = {};

  // final List<FoodItem> vegetables = [
  //   FoodItem(name: 'Broccoli', calories: 55, imageUrl: 'https://cdn.britannica.com/25/78225-050-1781F6B7/broccoli-florets.jpg', price: 5),
  //   FoodItem(name: 'Spinach', calories: 23, imageUrl: 'https://www.daysoftheyear.com/cdn-cgi/image/dpr=1%2Cf=auto%2Cfit=cover%2Cheight=650%2Cq=40%2Csharpen=1%2Cwidth=956/wp-content/uploads/fresh-spinach-day.jpg', price: 4),
  //   FoodItem(name: 'Carrot', calories: 41, imageUrl: 'https://cdn11.bigcommerce.com/s-kc25pb94dz/images/stencil/1280x1280/products/271/762/Carrot__40927.1634584458.jpg?c=2', price: 3),
  //   FoodItem(name: 'Bell Pepper', calories: 31, imageUrl: 'https://i5.walmartimages.com/asr/5d3ca3f5-69fa-436a-8a73-ac05713d3c2c.7b334b05a184b1eafbda57c08c6b8ccf.jpeg', price: 4),
  // ];

  // final List<FoodItem> carbs = [
  //   FoodItem(name: 'Brown Rice', calories: 111, imageUrl: 'https://assets-jpcust.jwpsrv.com/thumbnails/k98gi2ri-720.jpg', price: 6),
  //   FoodItem(name: 'Oats', calories: 389, imageUrl: 'https://media.post.rvohealth.io/wp-content/uploads/2020/03/oats-oatmeal-732x549-thumbnail.jpg', price: 7),
  //   FoodItem(name: 'Sweet Corn', calories: 86, imageUrl: 'https://m.media-amazon.com/images/I/41F62-VbHSL._AC_UF1000,1000_QL80_.jpg', price: 5),
  //   FoodItem(name: 'Black Beans', calories: 132, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwxSM9Ib-aDXTUIATZlRPQ6qABkkJ0sJwDmA&usqp=CAU', price: 6),
  // ];

  // final List<FoodItem> meats = [
  //   FoodItem(name: 'Chicken Breast', calories: 165, imageUrl: 'https://www.savorynothings.com/wp-content/uploads/2021/02/airy-fryer-chicken-breast-image-8.jpg', price: 8),
  //   FoodItem(name: 'Salmon', calories: 206, imageUrl: 'https://cdn.apartmenttherapy.info/image/upload/f_jpg,q_auto:eco,c_fill,g_auto,w_1500,ar_1:1/k%2F2023-04-baked-salmon-how-to%2Fbaked-salmon-step6-4792', price: 10),
  //   FoodItem(name: 'Lean Beef', calories: 250, imageUrl: 'https://www.mashed.com/img/gallery/the-truth-about-lean-beef/l-intro-1621886574.jpg', price: 9),
  //   FoodItem(name: 'Turkey', calories: 135, imageUrl: 'https://fox59.com/wp-content/uploads/sites/21/2022/11/white-meat.jpg?w=2560&h=1440&crop=1', price: 8),
  // ];

@override
void initState() {
  super.initState();
  fetchIngredients();
}

Future<void> fetchIngredients() async {
  final snapshot = await FirebaseFirestore.instance.collection('ingredients').get();
  final data = snapshot.docs.map((doc) {
    final d = doc.data();
    return FoodItem(
      name: d['name'],
      calories: d['calories'],
      imageUrl: d['imageUrl'],
      price: d['price'], category: d['category'],
    
      
    );
  }).toList();

  setState(() {
    allItems = data;
  });
}
  List<FoodItem> allItems = [];
List<FoodItem> get vegetables => allItems.where((item) => item.category == 'vegetable').toList();
List<FoodItem> get carbs => allItems.where((item) => item.category == 'carb').toList();
List<FoodItem> get meats => allItems.where((item) => item.category == 'meat').toList();

  FoodItem _getItemByName(String name) {
    return [...vegetables, ...carbs, ...meats].firstWhere(
      (item) => item.name == name,
      orElse: () => FoodItem(name: name, calories: 0, imageUrl: '', price: 0,category: ''),
    );
  }

  int get totalCalories => selectedItems.entries.fold(0, (total, entry) {
    final item = _getItemByName(entry.key);
    return total + (entry.value * item.calories);
  });

  int get totalPrice => selectedItems.entries.fold(0, (total, entry) {
    final item = _getItemByName(entry.key);
    return total + (entry.value * item.price);
  });

  bool get canPlaceOrder =>
      totalCalories >= 0.9 * widget.dailyCalories &&
      totalCalories <= 1.1 * widget.dailyCalories;

  void goToSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SummaryScreen(
          selected: selectedItems,
          allItems: [...vegetables, ...carbs, ...meats],
        ),
      ),
    );
  }

  Widget buildSection(String title, List<FoodItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              return FoodCard(
                item: item,
                quantity: selectedItems[item.name] ?? 0,
                onAdd: () {
                  setState(() {
                    selectedItems[item.name] = (selectedItems[item.name] ?? 0) + 1;
                  });
                },
                onRemove: () {
                  if ((selectedItems[item.name] ?? 0) > 0) {
                    setState(() {
                      selectedItems[item.name] = selectedItems[item.name]! - 1;
                    });
                  }
                },
                dailyCalories: widget.dailyCalories,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create your order"), centerTitle: true),
      body: Column(
        children: [
         
          Expanded(
            child: ListView(
              children: [
                buildSection("Vegetables", vegetables),
                buildSection("Meats", meats),
                buildSection("Carbs", carbs),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "$totalCalories Cal out of ${widget.dailyCalories.toInt()} Cal",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "Total Price: $totalPrice",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: canPlaceOrder ? goToSummary : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canPlaceOrder ? Colors.deepOrangeAccent : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Place Order", style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
