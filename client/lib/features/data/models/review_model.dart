import '../../domain/entity/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    super.id,
    required super.userId,
    required super.username,
    required super.rating,
    required super.comment,
    required super.timestamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['reviewUserId'] ?? '',
      username: json['reviewUsername'] ?? '',
      rating: (json['reviewRating'] as num).toDouble(),
      comment: json['reviewComment'] ?? '',
      timestamp: DateTime.parse(json['reviewTimestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': id,
      'reviewUserId': userId,
      'reviewUsername': username,
      'reviewRating': rating,
      'reviewComment': comment,
      'reviewTimestamp': timestamp.toIso8601String(),
    };
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      userId: userId,
      username: username,
      rating: rating,
      comment: comment,
      timestamp: timestamp,
    );
  }
}