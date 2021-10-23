import 'dart:core';

class Restaurant {
  String id;
  String image;
  String description;
  bool collectStatus;
  bool deliveryStatus;
  bool acceptCardStatus;
  bool isActive;
  bool status;
  double deliveryCharge;
  double serviceCharge;
  int orderLimit;
  String restaurantName;
  String restaurantEmail;
  String restaurantAddress;
  String country;
  String city;
  String region;
  String restaurantCode;
  List<Coupons> coupons;
  List<Timing> timing;
  Restaurant(
      this.id,
      this.image,
      this.description,
      this.collectStatus,
      this.deliveryStatus,
      this.acceptCardStatus,
      this.isActive,
      this.status,
      this.deliveryCharge,
      this.serviceCharge,
      this.orderLimit,
      this.restaurantName,
      this.restaurantEmail,
      this.restaurantAddress,
      this.country,
      this.city,
      this.region,
      this.restaurantCode,
      this.coupons,
      this.timing);
  Restaurant.fromJson(Map<String, dynamic> data)
      : id = data['_id'] ?? '',
        image = data['image'] ?? '',
        description = data['description'] ?? '',
        collectStatus = data['collectStatus'],
        deliveryStatus = data['deliveryStatus'],
        acceptCardStatus = data['acceptCardStatus'],
        isActive = data['isActive'],
        status = data['status'],
        deliveryCharge = data['deliveryCharge'] + 0.0,
        serviceCharge = data['serviceCharge'] + 0.0,
        orderLimit = data['orderLimit'],
        restaurantName = data['name'] ?? '',
        restaurantEmail = data['email'] ?? '',
        restaurantAddress = data['address'] ?? '',
        country = data['country'] ?? '',
        city = data['city'] ?? '',
        region = data['region'] ?? '',
        restaurantCode = data['code'] ?? '',
        coupons =
            (data['coupons'] as List).map((e) => Coupons.fromJson(e)).toList(),
        timing =
            (data['timing'] as List).map((e) => Timing.fromJson(e)).toList();
}

class Coupons {
  int discount;
  String offerId;
  String discountCode;
  Coupons(this.discount, this.offerId, this.discountCode);
  Coupons.fromJson(Map<String, dynamic> _discount)
      : discount = _discount['discount'],
        offerId = _discount['_id'],
        discountCode = _discount['code'];
}

class Timing {
  bool dayOff;
  String id;
  String day;
  String from;
  String to;
  Timing(this.dayOff, this.id, this.day, this.from, this.to);
  Timing.fromJson(Map<String, dynamic> _timing)
      : dayOff = _timing['dayOff'],
        id = _timing['_id'],
        day = _timing['day'],
        from = _timing['from'],
        to = _timing['to'];
}
