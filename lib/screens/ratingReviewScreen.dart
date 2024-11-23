import 'package:client_restaurant/apis/CommentAPI.dart';
import 'package:client_restaurant/apis/ratingAPI.dart';
import 'package:client_restaurant/components/bodyMenu.dart';
import 'package:client_restaurant/widgets/cardUserReview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../models/Comment.dart';
import '../models/rating.dart';
import '../sizeConfig.dart';

class RatingReviewScreen extends StatelessWidget {
  const RatingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.arguments;
    SizeConfig().init(context);

    // Kết hợp hai Future thành một Future<List<dynamic>>
    Future<List<dynamic>> fetchData() {
      return Future.wait([
        RatingAPI().fetchRatingsWithDishId(id),
        CommentAPI().fetchCommentsWithDishId(id),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bài đánh giá'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Lấy dữ liệu từ snapshot
                List<Rating> ratings = snapshot.data![0];
                List<Comment> comments = snapshot.data![1];

                // Tính toán tổng điểm và số sao cho mỗi mức
                final totalRating = ratings.fold(0, (sum, rating) => sum + rating.ratingStar);
                final oneStar = ratings.where((rating) => rating.ratingStar == 1).length;
                final twoStar = ratings.where((rating) => rating.ratingStar == 2).length;
                final threeStar = ratings.where((rating) => rating.ratingStar == 3).length;
                final fourStar = ratings.where((rating) => rating.ratingStar == 4).length;
                final fiveStar = ratings.where((rating) => rating.ratingStar == 5).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Điểm xếp hạng và bài đánh giá đã được xác minh và do những người sử dụng cùng loại thiết bị với bạn đưa ra'),
                    Gap(10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${(totalRating / ratings.length).toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              RatingProgressIndicator(text: '5', value: fiveStar / ratings.length),
                              RatingProgressIndicator(text: '4', value: fourStar / ratings.length),
                              RatingProgressIndicator(text: '3', value: threeStar / ratings.length),
                              RatingProgressIndicator(text: '2', value: twoStar / ratings.length),
                              RatingProgressIndicator(text: '1', value: oneStar / ratings.length),
                            ],
                          ),
                        ),
                      ],
                    ),
                    RatingBarIndicator(
                      itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.blue),
                      rating: totalRating / ratings.length,
                      itemSize: 20,
                      unratedColor: Colors.grey,
                    ),
                    Text('${ratings.length} đánh giá', style: Theme.of(context).textTheme.bodySmall),
                    Gap(20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) => CardUserReview(comment: comments[index], rating: ratings[index],),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class RatingProgressIndicator extends StatelessWidget {
  const RatingProgressIndicator({
    super.key,
    required this.text,
    required this.value,
  });

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: SizeConfig.screenWidth * 0.8,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
