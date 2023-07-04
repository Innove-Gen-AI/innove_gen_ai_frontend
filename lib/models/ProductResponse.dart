
class Product {
  String productId;
  String productName;
  String brandName;
  String image;

  Product({
    required this.productId,
    required this.productName,
    required this.brandName,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      brandName: json['brand_name'],
      image: json['image'],
    );
  }
}