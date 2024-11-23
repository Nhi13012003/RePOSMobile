import 'package:client_restaurant/screens/detailFoodScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../apis/dish.dart';
import '../models/dish.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  List<Dish> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (text) {
            setState(() {
              _searchText = text;
              _searchDishes();
            });
          },
          decoration: InputDecoration(
            hintText: 'Tìm kiếm món ăn...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (_searchText.isEmpty) {
      return Center(child: Text('Nhập từ khóa để tìm kiếm.'));
    } else if (_searchResults.isEmpty) {
      return Center(child: Text('Không tìm thấy món ăn nào.'));
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final dish = _searchResults[index];
          return ListTile(
            title: GestureDetector(
              onTap: ()
                {
                  Get.to(()=>DetailFoodScreen(),arguments: [dish.id, dish.dishType]);
                },
                child: Text(dish.name)),
          );
        },
      );
    }
  }

  Future<void> _searchDishes() async {
    if (_searchText.isNotEmpty) {
      final results = await DishAPI().searchDishes(_searchText);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }
}
