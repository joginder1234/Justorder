class Hotel {
  String id;
  bool isAdmin;
  String addedBy;
  int addedId;
  HotelDetails hotelDetail;
  OwnerDetail ownerDetail;
  Services services;
  Hotel(this.id, this.isAdmin, this.addedBy, this.addedId, this.hotelDetail,
      this.ownerDetail, this.services);
  Hotel.fromJson(Map<String, dynamic> hotelData)
      : id = hotelData['_id'] ?? '',
        isAdmin = hotelData['isAdmin'] ?? false,
        addedBy = hotelData['addedBy'] ?? '',
        addedId = hotelData['id'] ?? 0,
        hotelDetail = HotelDetails.fromJson(hotelData['hotel']),
        ownerDetail = OwnerDetail.fromJson(hotelData['owner']),
        services = Services.fromJson(hotelData['service']);
}

class Services {
  int rating;
  bool status;
  bool parking;
  bool balcony;
  bool bed;
  bool breakfast;
  Services(this.rating, this.status, this.parking, this.balcony, this.bed,
      this.breakfast);
  Services.fromJson(Map<String, dynamic> serviceData)
      : rating = serviceData['rating'] ?? 0,
        status = serviceData['status'] ?? false,
        parking = serviceData['parking'] ?? false,
        balcony = serviceData['balcony'] ?? false,
        bed = serviceData['bed'] ?? false,
        breakfast = serviceData['breakfast'] ?? false;
}

class OwnerDetail {
  String email;
  String phone;
  OwnerDetail(this.email, this.phone);

  OwnerDetail.fromJson(Map<String, dynamic> ownerDetail)
      : email = ownerDetail['email'] ?? '',
        phone = ownerDetail['phone'] ?? '';
}

class HotelDetails {
  String hotelImage;
  String hotelName;
  String city;
  String country;
  String region;
  String hotelAddress;
  String hotelDescription;
  String hotelDistance;
  String phone;

  HotelDetails(
    this.hotelImage,
    this.hotelName,
    this.city,
    this.country,
    this.region,
    this.hotelAddress,
    this.hotelDescription,
    this.hotelDistance,
    this.phone,
  );
  HotelDetails.fromJson(Map<String, dynamic> hotelDetail)
      : hotelImage = hotelDetail['image'] ?? '',
        hotelName = hotelDetail['name'] ?? '',
        city = hotelDetail['city'] ?? '',
        country = hotelDetail['country'] ?? '',
        region = hotelDetail['region'] ?? '',
        hotelAddress = hotelDetail['address'] ?? '',
        hotelDescription = hotelDetail['description'] ?? '',
        hotelDistance = hotelDetail['cityDistance'] ?? '',
        phone = hotelDetail['phone'] ?? '';
}

class HotelFeatures {
  String feature;
  HotelFeatures(this.feature);
}

class HotelPhotos {
  String image;
  HotelPhotos(this.image);
}

class HotelBookingHistoryModel {
  String bookingId;
  String hotelId;
  String name;
  DateTime checkin;
  DateTime checkout;
  String roomtype;
  int totalRooms;
  int adults;
  int kids;
  bool paymentStatus;
  String txnId;
  double discount;
  double totalCharge;
  double roomCharge;
  DateTime dateOfBooking;
  HotelBookingHistoryModel(
      this.bookingId,
      this.hotelId,
      this.name,
      this.checkin,
      this.checkout,
      this.roomtype,
      this.totalRooms,
      this.adults,
      this.kids,
      this.paymentStatus,
      this.txnId,
      this.discount,
      this.totalCharge,
      this.roomCharge,
      this.dateOfBooking);
  HotelBookingHistoryModel.fromJson(Map<String, dynamic> booking)
      : bookingId = booking['_id'],
        hotelId = booking['hotelId'],
        name = booking['name'] ?? '',
        checkin = DateTime.parse(booking['checkin']),
        checkout = DateTime.parse(booking['checkout']),
        roomtype = booking['roomtype'],
        totalRooms = booking['quantity'],
        adults = booking['adults'],
        kids = booking['children'],
        paymentStatus = booking['status'],
        txnId = booking['txnId'].toString(),
        discount = booking['discount'] + 0.0 ?? 0.0,
        totalCharge = booking['charges'] + 0.0 ?? 0.0,
        roomCharge = booking['roomPrice'] ?? 0.0,
        dateOfBooking = DateTime.parse(booking['createdAt']);
}
