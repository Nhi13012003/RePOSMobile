import 'package:client_restaurant/screens/paymentMethodScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../widgets/cardTable.dart';

class TableScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TableScreenState();
  }
}

class TableScreenState extends State<TableScreen> {
  List<bool> isBooked = List.generate(15, (index) => false); // Danh sách trạng thái đặt bàn
  List<Map<String, String>> bookingData = []; // Danh sách dữ liệu đặt bàn

  // Hàm để hiển thị dialog khi nhấn vào CardTable
  void _showBookingDialog(BuildContext context, String tableNumber, int index) {
    TimeOfDay? _startTime;
    TimeOfDay? _endTime;

    final TextEditingController _startTimeController = TextEditingController();
    final TextEditingController _endTimeController = TextEditingController();
    final TextEditingController _peopleCountController = TextEditingController();

    // Hàm mở Time Picker để chọn thời gian
    Future<void> _selectTime(BuildContext context, bool isStart, StateSetter setState) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null) {
        setState(() {
          if (isStart) {
            _startTime = picked;
            _startTimeController.text = _startTime!.format(context); // Cập nhật giá trị trong TextField
          } else {
            _endTime = picked;
            _endTimeController.text = _endTime!.format(context); // Cập nhật giá trị trong TextField
          }
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Đặt bàn số $tableNumber'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectTime(context, true, setState); // Chọn thời gian bắt đầu
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Thời gian bắt đầu',
                          hintText: 'VD: 14:00',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _selectTime(context, false, setState); // Chọn thời gian kết thúc
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _endTimeController,
                        decoration: InputDecoration(
                          labelText: 'Thời gian kết thúc',
                          hintText: 'VD: 16:00',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _peopleCountController,
                    decoration: InputDecoration(
                      labelText: 'Số lượng người',
                      hintText: 'VD: 4',
                    ),
                    keyboardType: TextInputType.number, // Chỉ cho phép nhập số
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Chặn ký tự không phải số
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý khi nhấn "Xác nhận" và đóng dialog
                    String peopleCount = _peopleCountController.text;

                    // Bạn có thể xử lý logic đặt bàn ở đây với thời gian đã chọn (_startTime, _endTime)
                    print('Số lượng người: $peopleCount');
                    print('Thời gian bắt đầu: ${_startTimeController.text}');
                    print('Thời gian kết thúc: ${_endTimeController.text}');

                    setState(() {
                      isBooked[index] = true; // Cập nhật trạng thái đặt bàn
                      bookingData.add({
                        'tableNumber': tableNumber,
                        'startTime': _startTimeController.text,
                        'endTime': _endTimeController.text,
                        'peopleCount': _peopleCountController.text,
                      }); // Lưu dữ liệu đặt bàn
                    });

                    Get.to(()=>Paymentmethodscreen());
                  },
                  child: Text('Xác nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Hàm hiển thị dialog thông tin đặt bàn
  void _showBookingInfoDialog(BuildContext context, Map<String, String> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông tin đặt bàn'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bàn số: ${data['tableNumber']}'),
              Text('Thời gian bắt đầu: ${data['startTime']}'),
              Text('Thời gian kết thúc: ${data['endTime']}'),
              Text('Số lượng người: ${data['peopleCount']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Loại bỏ nút Back
        toolbarHeight: 0, // Ẩn luôn AppBar
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columns
          crossAxisSpacing: 10, // Horizontal spacing
          mainAxisSpacing: 10,  // Vertical spacing
        ),
        itemCount: 15, // Số lượng bàn giả lập
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (isBooked[index]) {
                // Hiển thị dialog thông tin đặt bàn
                _showBookingInfoDialog(context, bookingData[index]);
              } else {
                // Hiển thị dialog đặt bàn
                _showBookingDialog(context, (index + 1).toString(), index);
              }
            },
            child: CardTable(
              icon: Icons.table_bar, // Icon của bàn
              tableNumber: (index + 1).toString(), // Số bàn
              seatNumber: '4', // Số ghế giả lập
              status: isBooked[index] ? 'Booked' : (index % 2 == 0 ? 'Available' : 'Occupied'), // Trạng thái bàn
              isBooked: isBooked[index], // Thêm thuộc tính isBooked
            ),
          );
        },
      ),
    );
  }
}