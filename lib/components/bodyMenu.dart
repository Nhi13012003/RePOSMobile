import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_restaurant/apis/promotionAPI.dart';
import 'package:client_restaurant/apis/ratingAPI.dart';
import 'package:client_restaurant/screens/detailFoodScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../apis/dish.dart';
import '../apis/dishType.dart';
import '../models/dish.dart';
import '../models/dishType.dart';
import '../models/rating.dart';
import '../screens/listDishScreen.dart';
import '../screens/searchDishesScreen.dart';
import '../sizeConfig.dart';

class BodyMenu extends StatefulWidget {
  const BodyMenu({super.key});

  @override
  State<BodyMenu> createState() => _BodyMenuState();
}

class _BodyMenuState extends State<BodyMenu> {
  int currentSlide = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildNewsDrawer(),
      body: SafeArea(

          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10
          ),
          child: Column(
            children: [
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: SizeConfig.screenWidth * 0.6,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      onTap: ()
                      {
                        Get.to(()=> SearchScreen());
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Tìm kiếm",
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: SizeConfig().getScreenWidth(20),
                          vertical: SizeConfig().getScreenHeight(10)
                      ),
                    ),
                  )),
                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(100),
                    child: Stack(
                      children: [
                        Container(
                          height: SizeConfig().getScreenHeight(50),
                          width: SizeConfig().getScreenWidth(50),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle
                          ),
                          child: IconButton(
                            icon: Icon(Icons.doorbell),
                            onPressed: () {  _scaffoldKey.currentState?.openEndDrawer();},),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            height: SizeConfig().getScreenHeight(20),
                            width: SizeConfig().getScreenWidth(20),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(width: 1.5, color: Colors.white)
                            ),
                            child: Center(
                              child: Text("3",
                              style: TextStyle(
                                fontSize: 10,
                                height: 1,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                              ),),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Gap(20),
              Stack(
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: PageView(
                    onPageChanged: (value)
                    {
                      setState(() {
                        currentSlide=value;
                      });
                    },
                    scrollDirection: Axis.horizontal,allowImplicitScrolling: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      Image.asset("assets/banner/banner1.jpg",fit: BoxFit.cover,),
                      Image.asset("assets/banner/banner2.webp",fit: BoxFit.cover,),
                      Image.asset("assets/banner/banner3.jpg",fit: BoxFit.cover,),
                      Image.asset("assets/banner/banner4.jpg",fit: BoxFit.cover,),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                  bottom: 10,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      List.generate(4, (index)
                      => buildDot(index: index)
                      )
                      ,
                    ),
                  ))
            ],
          ),
              Gap(20),
              FutureBuilder(
                future: DishTypeAPI().fetchDishTypes(),
                builder: (context,snapshot)
                {
                  if(snapshot.hasData)
                    {
                      List<DishType> dishTypes = snapshot.data!;
                      return SizedBox(height: 100,
                        child: ListView.separated(
                            separatorBuilder: (context,index) => SizedBox(width: 20,),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: ()
                                {
                                  Get.to(()=>ListDishScreen(dishType: dishTypes[index]));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 65,
                                      width: 65,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(image: AssetImage("assets/splash/logo_client.png"),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(dishTypes[index].DishTypeName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold

                                      ),)
                                  ],
                                ),
                              );
                            },
                            itemCount: dishTypes.length),);
                    }
                  else if(snapshot.hasError)
                    {
                      print(snapshot.error);
                      return Text('${snapshot.error}');
                    }
                  return const CircularProgressIndicator();
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Gợi ý cho bạn",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800
                ),),
                  Text("Tất cả",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                  ),)
              ],),
              Gap(20),
              FutureBuilder(
                future: DishAPI().fetchDishes('all'),
                builder: (context,snapshot)
                {
                  if(snapshot.hasData)
                    {
                      List<Dish> dishes = snapshot.data!;
                      return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dishes.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.78,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              crossAxisCount: 2),
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                Get.to(()=>const DetailFoodScreen(), arguments: [dishes[index].id,dishes[index].dishType]);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                        )],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 130,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20), // Add rounded corners
                                            child: CachedNetworkImage(
                                              imageUrl: dishes[index].images![0].Link==""?
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgtod8euL8NioWZK9pC5KlDsyS2E4NTSkZP7dVXqY4o5Hr_dXKMN7uSPBBjwl76OUHcLI&usqp=CAU"
                                                :dishes[index].images![0].Link
                                              ,
                                              fit: BoxFit.cover, // Adjust fit as needed
                                              placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0), // Add padding
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                dishes[index].name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                '${NumberFormat("#,##0", "en_US").format(dishes[index].costs![0].cost)} đồng',                                                 style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),)
                                ],
                              ),
                            );
                          });
                    }
                  else if(snapshot.hasError)
                    {
                      return Text('${snapshot.error}');
                    }
                  else return CircularProgressIndicator();
                },
              )

            ],
          ),
        ),
      )),
    );
  }
  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentSlide == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentSlide == index ? Colors.deepOrange : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
  Widget _buildNewsDrawer() {
    return Drawer(
      child: FutureBuilder(
        future: PromotionAPI().fetchPromotions(),
        builder: (context,snapshot)
        {
          if(snapshot.hasData)
            {
              return ListView(
                children: [
                  AppBar(
                    title: Text('Tin tức',style: TextStyle(color: Colors.white),),
                    automaticallyImplyLeading: false, // Hide back button
                    backgroundColor: Colors.blue, // Custom background color
                  ),
                  ListTile(
                    leading: Icon(Icons.event), // Add icon
                    title: Text('Giảm giá theo sự kiện'),
                    onTap: () {
                      // Handle event discount news tap
                    },
                  ),
                  Divider(), // Add divider
                  ListTile(
                    leading: Icon(Icons.celebration), // Add icon
                    title: Text('Giảm giá theo lễ'),
                    onTap: () {
                      // Handle holiday discount news tap
                    },
                  ),
                  Divider(), // Add divider
                  ListTile(
                    leading: Icon(Icons.percent), // Add icon
                    title: Text('Giảm giá sốc món ăn'),
                    onTap: () {
                      // Handle flash sale news tap
                    },
                  ),
                  ListTile(
                    // ...
                    title: RichText(
                      text: TextSpan(
                        text: 'Giảm giá ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.black),
                        children: [
                          TextSpan(
                            text: '20%',
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(text: ' cho tất cả các món canh!'),
                        ],
                      ),
                    ),
                    // ...
                  )
                ],
              );
            }
          else if(snapshot.hasError)
            {
              return Text('${snapshot.error}');
            }
          else return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
