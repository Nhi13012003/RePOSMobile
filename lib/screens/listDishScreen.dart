import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_restaurant/screens/detailFoodScreen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../apis/dish.dart';
import '../models/dish.dart';
import '../models/dishType.dart';

class ListDishScreen extends StatefulWidget {
  final DishType dishType;

  const ListDishScreen({Key? key, required this.dishType}) : super(key: key);

  @override
  State<ListDishScreen> createState() => _ListDishScreenState();
}

class _ListDishScreenState extends State<ListDishScreen> {

  List<Dish> filteredDishes = [];
  String? selectedSort; // Biến lưu trữ lựa chọn sắp xếp
  double? selectedRating; // Biến lưu trữ lựa chọn đánh giá

  @override
  void initState() {
    super.initState();
  }
  List<Dish> filterDishes(List<Dish> dishes) {
    // Lọc theo giá
    if (selectedSort != null) {
      if (selectedSort == 'price_asc') {
        dishes.sort((a, b) => a.costs![0].cost.compareTo(b.costs![0].cost));
      } else if (selectedSort == 'price_desc') {
        dishes.sort((a, b) => b.costs![0].cost.compareTo(a.costs![0].cost));
      }
    }

    // Lọc theo đánh giá (giả sử bạn có thuộc tính rating trong model Dish)
    // if (selectedRating != null) {
    //   dishes = dishes.where((dish) => dish.rating! >= selectedRating!).toList();
    // }

    return dishes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dishType.DishTypeName),
        actions: [
          // Nút lọc dạng icon
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (String result) {
              setState(() {
                if (result.contains('price')) {
                  selectedSort = result;
                } else {
                  selectedRating = double.parse(result); // Chuyển đánh giá thành double
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // Menu lọc giá
              const PopupMenuItem<String>(
                value: 'price_asc',
                child: Text('Giá: Thấp đến cao'),
              ),
              const PopupMenuItem<String>(
                value: 'price_desc',
                child: Text('Giá: Cao đến thấp'),
              ),
              // Divider giữa phần lọc giá và đánh giá
              const PopupMenuDivider(),
              // Menu lọc theo đánh giá
              const PopupMenuItem<String>(
                value: '4.0',
                child: Text('Đánh giá: 4 sao trở lên'),
              ),
              const PopupMenuItem<String>(
                value: '4.5',
                child: Text('Đánh giá: 4.5 sao trở lên'),
              ),
              const PopupMenuItem<String>(
                value: '5.0',
                child: Text('Đánh giá: 5 sao'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: DishAPI().fetchDishes(widget.dishType.id),
        builder: (context,snapshot)
          {
            if(snapshot.hasData)
              {
                List<Dish> dishesWithFilter = snapshot.data!;
                dishesWithFilter = filterDishes(dishesWithFilter);
                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.75, // Điều chỉnh tỷ lệ khung hình của item
                  ),
                  itemCount: dishesWithFilter.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(()=>const DetailFoodScreen(), arguments: [dishesWithFilter[index].id,dishesWithFilter[index].dishType]);
                      },
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                              child: CachedNetworkImage(
                                imageUrl: dishesWithFilter[index].images![0].Link,
                                height: 120.0,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dishesWithFilter[index].name,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Gap(4.0),
                                  Text(
                                    '${NumberFormat("#,##0", "en_US").format(dishesWithFilter[index].costs![0].cost)} đồng',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            else if(snapshot.hasError)
              {
                return Text('${snapshot.error}');
              }
            else return const CircularProgressIndicator();
          }
      ),
    );
  }
}
