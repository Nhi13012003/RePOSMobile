import 'dart:io';

import 'package:client_restaurant/apis/ratingAPI.dart';
import 'package:client_restaurant/models/Comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../apis/CommentAPI.dart';
import '../models/rating.dart';
import 'detailFoodScreen.dart';

class WriteRatingReviewScreen extends StatefulWidget {
  String dishID;
  String clientID;

  final Function onDataUpdated;

  WriteRatingReviewScreen({
    super.key,
    required this.dishID,
    required this.clientID,
    required this.onDataUpdated, // Nhận callback function
  });

  @override
  State<WriteRatingReviewScreen> createState() =>
      _WriteRatingReviewScreenState();
}

class _WriteRatingReviewScreenState extends State<WriteRatingReviewScreen> {
  TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int ratingStar = 0;
  List<XFile> _images = []; // Danh sách ảnh đã chọn
  final ImagePicker _picker = ImagePicker();

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  // Hàm chụp ảnh
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Canh giữa và giãn cách
          children: [
            Text('Viết đánh giá'),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && ratingStar > 0) {
                  final rating = Rating(
                    ratingStar: ratingStar,
                    dishID: widget.dishID,
                    clientID: widget.clientID,
                  );
                  final comment = Comment(
                    commentText: _commentController.text,
                    commentTime: DateTime.now(),
                    dishID: widget.dishID,
                    clientID: widget.clientID,
                    createAt: DateTime.now(),
                    updateAt: DateTime.now(),
                    images: [], // Để trống, sẽ cập nhật sau khi lấy URL ảnh
                  );

                  // Gọi API tạo comment và upload ảnh
                  CommentAPI().createComment(comment, _images).then((_) {
                    RatingAPI().createRating(rating).then((_) {
                      Get.back(result: true);
                      widget.onDataUpdated();
                    });
                  }).catchError((error) {
                    print('Error creating rating or comment: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi tạo đánh giá')),

                    );
                  });
                }
              },
              child: Text('Đăng'),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Bài đánh giá của bạn sẽ được hiển thị công khai!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Gap(10),
              RatingBar.builder(
                glow: false,
                itemSize: 50,
                allowHalfRating: false,
                unratedColor: Colors.grey,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.blue,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    ratingStar = rating.toInt();
                  });
                },
              ),
              Gap(10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Mô tả của bạn trên điện thoại (không bắt buộc)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5, // Cho phép nhiều dòng
                ),
              ),
              Gap(10),
              // Nút chọn ảnh và chụp ảnh
              Row(
                children: [
                  // Nút chọn ảnh từ thư viện
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo_library), // Icon thư viện ảnh
                    label: Text("Chọn ảnh"),
                  ),
                  Gap(10),
                  // Nút chụp ảnh
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: Icon(Icons.camera_alt), // Icon chụp ảnh
                    label: Text("Chụp ảnh"),
                  ),
                ],
              ),
              Gap(10),
              // Hiển thị các ảnh đã chọn
              _images.isNotEmpty
                  ? SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _images.map((image) {
                    return Container(
                      width: 100, // Cố định kích thước ảnh
                      height: 100,
                      child: Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
