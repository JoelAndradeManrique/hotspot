import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/user/home/screen/rating%20and%20review/service/display_review_service.dart';

class ReviewScreen extends ConsumerWidget {
  final String hotspotId;
  const ReviewScreen({super.key, required this.hotspotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsync = ref.watch(reviewProvider(hotspotId));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Review of this Area"),
      ),
      body: reviewAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(child: Text("No reviews available"));
          }
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final userId = review['userId'];
              final rating = (review['rating'] as num?)?.toDouble();
              final reviewText = review['review'] as String?;
              final timestamp = (review['timestamp'] as Timestamp?)?.toDate();

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  final userData =
                      userSnapshot.data?.data() as Map<String, dynamic>?;
                  final displayName = userData?['name'] ?? "User";
                  final photoUrl = userData?['photoUrl'] as String?;

                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: photoUrl != null
                                ? NetworkImage(photoUrl)
                                : NetworkImage(
                                    "https://picsum.photos/200/300.jpg",
                                  ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 17,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: rating!,
                                    ignoreGestures: true,
                                    allowHalfRating: true,
                                    minRating: 1,
                                    itemCount: 5,
                                    itemSize: 18,
                                    itemBuilder: (context, _) =>
                                        Icon(Icons.star, color: Colors.amber),
                                    onRatingUpdate: (value) {},
                                  ),
                                  SizedBox(width: 5),
                                  Text(formatTimeAgo(timestamp!)),
                                  Spacer(),
                                  Icon(Icons.more_vert),
                                ],
                              ),
                              if (reviewText != null)
                                Padding(
                                  padding: EdgeInsets.only(right: 35),
                                  child: Text(
                                    reviewText,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text("Error: $error")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
