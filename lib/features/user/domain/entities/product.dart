class Product {
  final int id;
  final String image;
  final String title;
  final String description;
  final double price;
  final String? category;
  final double? rating;

  const Product({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    this.category,
    this.rating,
  });
}
