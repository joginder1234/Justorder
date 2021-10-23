class RestaurantMenu {
  String id;
  String restId;
  String catId;
  int menuNo;
  String description;
  bool isSize;
  double discount;
  double price;
  int repeat;
  String image;
  String menuName;
  RestaurantMenu(
      this.id,
      this.restId,
      this.catId,
      this.menuNo,
      this.description,
      this.isSize,
      this.discount,
      this.price,
      this.repeat,
      this.image,
      this.menuName);
  RestaurantMenu.fromJson(Map<String, dynamic> allMenu)
      : id = allMenu['_id'] ?? '',
        restId = allMenu['restaurantId'] ?? '',
        catId = allMenu['categoryId'] ?? '',
        menuNo = allMenu['menuNo'] ?? 0,
        description = allMenu['description'] ?? '',
        isSize = allMenu['isSize'] ?? false,
        discount = allMenu['discount'] == null
            ? 0.0
            : double.parse(allMenu['discount'].toString()),
        price = allMenu['price'] == null
            ? 0.0
            : double.parse(allMenu['price'].toString()),
        repeat = allMenu['repeat'] ?? 0,
        image = allMenu['imageUrl'] ?? '',
        menuName = allMenu['name'] ?? '';
}
