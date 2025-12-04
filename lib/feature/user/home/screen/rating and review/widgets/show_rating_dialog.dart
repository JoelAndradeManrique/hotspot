import 'package:flutter/Material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/feature/shared/Model/disply_items_model.dart';
import 'package:hotspot/feature/user/home/screen/rating%20and%20review/service/review_and_rating_service.dart';

class ShowRatingDialog extends ConsumerWidget {
  final Hotspot hotspot;
  const ShowRatingDialog({super.key, required this.hotspot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ratingNotifierProvider);
    final notifier = ref.read(ratingNotifierProvider.notifier);
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Rating an review", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            allowHalfRating: true,
            initialRating: state.rating,
            minRating: 1,
            itemCount: 5,
            itemSize: 30,
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: notifier.updateRating,
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 400,
            child: TextField(
              decoration: InputDecoration(
                hint: Text(
                  "Share you own experience at this place",
                  style: TextStyle(color: Colors.black54),
                ),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: notifier.updateReview,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            notifier.reset();
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.blueAccent,
          ),
          onPressed: state.rating == 0 || state.isLoading
              ? null
              : () => notifier.submitRating(
                  ref: ref,
                  context: context,
                  hotspot: hotspot,
                ),
          child: state.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  "Sambit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ],
    );
  }
}
