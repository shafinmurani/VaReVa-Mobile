class Books {
  final String name;
  final String path;
  final String imagePath;
  final String docId;
  final int price;
  final int purchasedCount;

  Books({
    required this.name,
    required this.path,
    required this.price,
    required this.imagePath,
    required this.docId,
    required this.purchasedCount,
  });
}
