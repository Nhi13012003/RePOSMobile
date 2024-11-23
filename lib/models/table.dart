class Table{
 String id;
 int tableNumber;
 String tableStatus;
 int seatNumber;

 Table({
   required this.id,
   required this.tableNumber,
   required this.tableStatus,
   required this.seatNumber
});
  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      tableNumber: json['tableNumber'],
      tableStatus: json['tableStatus'],
      seatNumber: json['seatNumber'],
    );
  }
}