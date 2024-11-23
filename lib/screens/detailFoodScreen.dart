import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_restaurant/apis/dish.dart';
import 'package:client_restaurant/apis/dishType.dart';
import 'package:client_restaurant/models/Comment.dart';
import 'package:client_restaurant/models/dishType.dart';
import 'package:client_restaurant/screens/ratingReviewScreen.dart';
import 'package:client_restaurant/screens/writeRatingReviewScreen.dart';
import 'package:client_restaurant/widgets/cardUserReview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../apis/CommentAPI.dart';
import '../apis/ratingAPI.dart';
import '../models/dish.dart';
import '../models/rating.dart';

class DetailFoodScreen extends StatefulWidget {

  const DetailFoodScreen({super.key});

  @override
  State<DetailFoodScreen> createState() => _DetailFoodScreenState();
}

class _DetailFoodScreenState extends State<DetailFoodScreen> {
  final dishId =Get.arguments[0];
  final dishTypeId = Get.arguments[1];
  @override
  Widget build(BuildContext context) {
  Future<List<dynamic>> fetchData() {
    return Future.wait([
      RatingAPI().fetchRatingsWithDishId(dishId),
      CommentAPI().fetchCommentsWithDishId(dishId),
      DishAPI().fetDishById(dishId),
      DishTypeAPI().fetchDishTypeWithId(dishTypeId)
    ]);
  }
  void reloadData() {
    setState(() {
      // Gọi lại fetchData() để load lại dữ liệu
      fetchData();
    });
  }
  return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot)
            {
              if(snapshot.hasData)
                {
                  List<Rating> ratings = snapshot.data![0];
                  List<Comment> comments = snapshot.data![1];
                  Dish dish = snapshot.data![2];
                  DishType dishType = snapshot.data![3];
                  final totalLength = (ratings.length>=comments.length?ratings.length:comments.length);
                  final totalRating = ratings.fold(0, (sum, rating) => sum + rating.ratingStar);
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        systemOverlayStyle:
                        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                        expandedHeight: 275.0,
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: CarouselSlider(
                            options: CarouselOptions(
                              height: 275.0,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                              autoPlay: true,
                            ),
                            items: dish.images?.map((image) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: image.Link,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          stretchModes: [
                            StretchMode.blurBackground,
                            StretchMode.zoomBackground
                          ],
                        ),
                        elevation: 0.0,
                        bottom: PreferredSize(
                            preferredSize: Size.fromHeight(0.0),
                            child: Container(
                              height: 32.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32),
                                      topRight: Radius.circular(32))),
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )),
                        leadingWidth: 60,
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 24),
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Container(
                                  height: 56,
                                  width: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.arrow_back_ios),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dish.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Gap(10),
                              Row(
                                children: [
                                  Text(dishType.DishTypeName),
                                  Gap(5),
                                  Container(
                                    height: 5,
                                    width: 5,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: Colors.red),
                                  )
                                ],
                              ),
                              Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${NumberFormat("#,##0", "en_US").format(dish.costs![0].cost)}',                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${totalRating/5}',
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Gap(10),
                              Divider(
                                height: 1,
                              ),
                              Gap(10),
                              Text("Mô tả", style: Theme.of(context).textTheme.titleLarge),
                              Gap(10),
                              Text(
                                  dish.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Color(0xFF3C58D7))),
                              Gap(10),
                              Divider(
                                height: 1,
                              ),
                              Gap(20),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue
                                ),
                                  onPressed: ()async{
                                final result = await Get.to(() => WriteRatingReviewScreen(dishID: dish.id, clientID: '6725ccd24181c8ab27973002',
                                    onDataUpdated: reloadData));
                                if (result == true) { // Kiểm tra result
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Cảm ơn bạn đã đánh giá', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min, // Giữ cho Column nhỏ gọn
                                        children: [
                                          Text('Đánh giá của bạn sẽ giúp mọi người quyết định đúng đắn hơn khi lựa chọn món ăn.'),
                                          SizedBox(height: 8), // Khoảng cách giữa hai dòng text
                                          Text('Cảm ơn bạn đã đóng góp cho cộng đồng!', style: TextStyle(fontSize: 16, color: Colors.grey)), // Dòng text mới
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Đóng dialog
                                          },
                                          child: Text('Đóng', style: TextStyle(fontSize: 18)),
                                        ),
                                      ],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Bo tròn góc dialog
                                      elevation: 5, // Thêm shadow cho dialog
                                    ),
                                  );
                                }
                              },
                                  child: Text('Viết bài đánh giá',
                                  style: TextStyle(color: Colors.white),)),
                              Gap(10),
                              Text('Điểm xếp hạng và đánh giá', style: Theme.of(context).textTheme.titleLarge),
                              if (ratings.isEmpty && comments.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      'Chưa có đánh giá hoặc bình luận nào cho món ăn này.',
                                      style: TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: ratings.isEmpty || comments.isEmpty ? 0 : (totalLength < 3 ? totalLength : 3), // Adjust the count based on available data
                                  itemBuilder: (context, index) {
                                    // Ensure that you don't access invalid indices
                                    if (index < comments.length && index < ratings.length) {
                                      return CardUserReview(comment: comments[index], rating: ratings[index]);
                                    } else {
                                      return SizedBox.shrink(); // Return an empty widget if the index is out of range
                                    }
                                  },
                                )
                              ,
                              if (ratings.isNotEmpty || comments.isNotEmpty) // Kiểm tra xem có rating hoặc comment hay không
                                InkWell(
                                  onTap: () {
                                    Get.to(() => RatingReviewScreen(), arguments: dish.id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Xem tất cả các bài đánh giá',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              Gap(20),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
              else if(snapshot.hasError)
                {
                  return Text('Error: ${snapshot.error}');
                }
              else return Center(child: CircularProgressIndicator(),);
            }
        ),
      ),
    );
  }
}
