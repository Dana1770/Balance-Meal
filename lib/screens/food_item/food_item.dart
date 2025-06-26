class FoodItem {
  final String name;
  final int calories;
  final String imageUrl;
  final int price;
  final String category; // ⬅️ أضيفي هذا

  FoodItem({
    required this.name,
    required this.calories,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}
