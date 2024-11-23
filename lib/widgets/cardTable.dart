import 'package:flutter/material.dart';

class CardTable extends StatefulWidget {
  final IconData icon;
  final String tableNumber;
  final String seatNumber;
  final String status;
  final bool isBooked;

  const CardTable({
    Key? key,
    required this.icon,
    required this.tableNumber,
    required this.seatNumber,
    required this.status,
    required this.isBooked,
  }) : super(key: key);

  @override
  _CardTableState createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isBooked ? Colors.lightGreenAccent : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 20,
              color: Colors.blue,
            ),
            Text(
              'Bàn số: ${widget.tableNumber}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Số ghế: ${widget.seatNumber}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              widget.status,
              style: TextStyle(
                fontSize: 14,
                color: widget.status == 'Available' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
