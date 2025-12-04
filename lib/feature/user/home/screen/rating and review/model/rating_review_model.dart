class RatingState {
  final double rating;
  final String review;
  final bool isLoading;

  RatingState({this.rating = 0.0, this.review = '', this.isLoading = false});

  RatingState copyWith({double? rating, String? review, bool? isLoading}) {
    return RatingState(
      rating: rating ?? this.rating,
      review: review ?? this.review,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
