import 'package:client_restaurant/models/Comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/rating.dart';

class CardUserReview extends StatelessWidget {
  final Comment comment;
  final Rating rating;

  const CardUserReview({super.key, required this.comment, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with avatar and user name
        Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage('assets/splash/logo_client.png'),),
            Gap(10),
            Text('Phạm Văn Nhí', style: Theme.of(context).textTheme.bodyMedium),
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
          ],
        ),
        Gap(10),

        // Rating bar and comment time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingBarIndicator(
              itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.blue),
              rating: rating.ratingStar.toDouble(),
              itemSize: 20,
              unratedColor: Colors.grey,
            ),
            Text(DateFormat('dd/MM/yyyy HH:mm').format(comment.commentTime),
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Gap(10),

        // Comment text with "Read more" feature
        Align(
          alignment: Alignment.centerLeft,
          child: ReadMoreText(
            comment.commentText,
            trimLines: 1,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Xem thêm',
            trimExpandedText: 'Thu gọn',
            moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ),
        Gap(10),

        // Images under the comment (if any)
        if (comment.images != null && comment.images!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                // Display the first two images normally
                for (int i = 0; i < 2 && i < comment.images!.length; i++)
                  GestureDetector(
                    onTap: () {
                      // Handle image tap (show full-screen with PhotoView)
                      _showImageZoom(context, i);
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(comment.images![i]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                // The third image (showing the placeholder with a plus sign)
                if (comment.images!.length > 2)
                  GestureDetector(
                    onTap: () {
                      // Show full-screen view with PhotoView
                      _showImageZoom(context, 2);
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5), // Semi-transparent
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        Gap(10),
      ],
    );
  }

  // Function to show image zoom with PhotoView
  void _showImageZoom(BuildContext context, int startIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: PhotoViewGallery.builder(
            itemCount: comment.images!.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(comment.images![index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: startIndex),
          ),
        );
      },
    );
  }
}
