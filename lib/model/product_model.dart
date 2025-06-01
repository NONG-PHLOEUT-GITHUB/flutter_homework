class MaleProduct {
  final String imgPath;
  final String title;
  final String currentPrice;
  final String oldPrice;

  MaleProduct({
    required this.imgPath,
    required this.title,
    required this.currentPrice,
    required this.oldPrice,
  });

  factory MaleProduct.fromJson(Map<String, dynamic> json) {
    return MaleProduct(
      imgPath: json['imgPath'],
      title: json['title'],
      currentPrice: json['currentPrice'],
      oldPrice: json['oldPrice'],
    );
  }
}
