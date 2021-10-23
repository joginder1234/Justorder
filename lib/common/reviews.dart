class AllReviews {
  String id;
  String userId;
  String hotelId;
  double rating;
  String comment;
  String image;
  DateTime dateOfReview;
  AllReviews(
    this.id,
    this.userId,
    this.hotelId,
    this.rating,
    this.comment,
    this.image,
    this.dateOfReview,
  );

  AllReviews.fromJson(Map<String, dynamic> reviewsAll)
      : id = reviewsAll['_id'],
        userId = reviewsAll['user'],
        hotelId = reviewsAll['hotelId'],
        rating = reviewsAll['ratings'],
        comment = reviewsAll['review'],
        image = reviewsAll['image'],
        dateOfReview = reviewsAll['createdAt'];
}
