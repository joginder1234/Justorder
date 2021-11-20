class RoomsData {
  String hotelId;
  String roomId;
  SingleType singleType;
  DoubleType doubleType;
  DuplexType duplexType;
  DeluxeType deluxeType;
  RoomsData(this.hotelId, this.roomId, this.singleType, this.doubleType,
      this.duplexType, this.deluxeType);

  RoomsData.fromJson(Map<String, dynamic> allRooms)
      : hotelId = allRooms['hotelId'],
        roomId = allRooms['_id'],
        singleType = SingleType.fromJson(allRooms['single']),
        doubleType = DoubleType.fromJson(allRooms['double']),
        duplexType = DuplexType.fromJson(allRooms['duplex']),
        deluxeType = DeluxeType.fromJson(allRooms['deluxe']);
}

class SingleType {
  String roomtype;
  int kids;
  int adults;
  String image;
  double price;
  SingleType(
    this.roomtype,
    this.kids,
    this.adults,
    this.image,
    this.price,
  );
  SingleType.fromJson(Map<String, dynamic> roomsType)
      : roomtype = 'Single Room',
        kids = roomsType['kid'],
        adults = roomsType['adults'],
        image = roomsType['image'],
        price = roomsType['Price'] + 0.0;
}

class DoubleType {
  String roomType;
  int kids;
  int adults;
  String image;
  double price;
  DoubleType(
    this.roomType,
    this.kids,
    this.adults,
    this.image,
    this.price,
  );
  DoubleType.fromJson(Map<String, dynamic> roomsType)
      : roomType = 'Double Room',
        kids = roomsType['kid'],
        adults = roomsType['adults'],
        image = roomsType['image'],
        price = roomsType['Price'] + 0.0;
}

class DuplexType {
  String roomtype;
  int kids;
  int adults;
  String image;
  double price;
  DuplexType(
    this.roomtype,
    this.kids,
    this.adults,
    this.image,
    this.price,
  );
  DuplexType.fromJson(Map<String, dynamic> roomsType)
      : roomtype = 'Duplex Room',
        kids = roomsType['kid'],
        adults = roomsType['adults'],
        image = roomsType['image'],
        price = roomsType['Price'] + 0.0;
}

class DeluxeType {
  String roomtype;
  int kids;
  int adults;
  String image;
  double price;
  DeluxeType(
    this.roomtype,
    this.kids,
    this.adults,
    this.image,
    this.price,
  );
  DeluxeType.fromJson(Map<String, dynamic> roomsType)
      : roomtype = 'Deluxe Room',
        kids = roomsType['kid'],
        adults = roomsType['adults'],
        image = roomsType['image'],
        price = roomsType['Price'] + 0.0;
}
