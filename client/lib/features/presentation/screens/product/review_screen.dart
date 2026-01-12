import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../domain/entity/review_entity.dart';
import '../../blocs/review/review_bloc.dart';

class ProductReviewScreen extends StatelessWidget {
  static route(String productId) => MaterialPageRoute(
        builder: (context) => ProductReviewScreen(
          productId: productId,
        ),
      );
  final String productId;

  const ProductReviewScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    context.read<ReviewBloc>().add(GetReviewsEvent(productId));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Reviews"),
        centerTitle: true,
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewLoaded) {
            return state.reviews.isEmpty
                ? const Center(
                    child: Text("No reviews yet. Be the first to review!"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.reviews.length,
                    itemBuilder: (context, index) {
                      final review = state.reviews[index];
                      return ReviewCard(review: review);
                    },
                  );
          } else if (state is ReviewFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: () {
          _showReviewDialog(context);
        },
        child: const Text(
          'Give a Review',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReviewDialog(
          productId: productId,
        );
      },
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < review.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              review.comment,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              "${review.timestamp}".split(' ')[0],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewDialog extends StatefulWidget {
  final String productId;

  const ReviewDialog({super.key, required this.productId});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<double> _ratingNotifier = ValueNotifier<double>(5);

  @override
  void dispose() {
    _controller.dispose();
    _ratingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<ReviewBloc>().add(GetReviewsEvent(widget.productId));
          Navigator.pop(context);
        } else if (state is ReviewFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        backgroundColor: AppColor.placeholderBg,
        title: const Center(
          child: Text(
            'Give a Review',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _ratingNotifier,
              builder: (context, rating, child) {
                return RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (newRating) {
                    _ratingNotifier.value = newRating;
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            TextField(
              cursorColor: AppColor.green,
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.green),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColor.green,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ReviewBloc>().add(AddReviewEvent(
                    productId: widget.productId,
                    rating: _ratingNotifier.value,
                    comment: _controller.text.trim(),
                  ));
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: AppColor.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
