import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3IncomeState createState() => _Page3IncomeState();
}

class _Page3IncomeState extends State<Page3> {
  String selectedPeriod = 'Day'; // ตัวแปรสำหรับเก็บค่าตัวเลือก
  DateTime currentDate = DateTime.now(); // วันที่ปัจจุบัน
  String? selectedDate; // ตัวแปรสำหรับเก็บวันที่เลือก
  List<Map<String, dynamic>> transactionData = []; // ตัวแปรสำหรับเก็บข้อมูลธุรกรรม
  double totalIncome = 0.0; // ตัวแปรสำหรับเก็บยอดรวมรายได้
  
  @override
  void initState() {
    super.initState();
    fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลเมื่อเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center, // จัดตำแหน่งชิดซ้าย
          child: Text('Income List'),
        ),
        elevation: 1.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 217, 217, 217),
            height: 1.0,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedPeriod = value; // อัปเดตตัวแปรเมื่อเลือก
                fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลเมื่อเลือกตัวเลือกใหม่
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Day', child: Text('Day')),
                PopupMenuItem(value: 'Month', child: Text('Month')),
                PopupMenuItem(value: 'Year', child: Text('Year')),
                PopupMenuItem(value: 'Custom', child: Text('Custom')),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // รูป wallet ที่กึ่งกลางด้านบนสุด
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset(
              'assets/wallet_color.png',
              width: 200,
              height: 200,
            ),
          ),
          // แสดงยอดรวมรายได้ทั้งหมด
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Total Income: ${totalIncome.toStringAsFixed(2)}', // แสดงยอดรวมรายได้
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (selectedPeriod == 'Day') ...[
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  DateTime date = currentDate.subtract(Duration(days: index));
                  bool isSelected = selectedDate == DateFormat('yyyy-MM-dd').format(date);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM-dd').format(date);
                        fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลใหม่เมื่อเลือกวันที่
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.pink : Colors.pinkAccent,
                      ),
                      child: Text(
                        DateFormat('EEE d').format(date),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (selectedPeriod == 'Month') ...[
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 36,
                itemBuilder: (context, index) {
                  DateTime monthDate = DateTime(currentDate.year, currentDate.month - index);
                  bool isSelected = selectedDate == DateFormat('yyyy-MM').format(monthDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM').format(monthDate);
                        fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลใหม่เมื่อเลือกเดือน
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.greenAccent : Colors.green,
                      ),
                      child: Text(
                        DateFormat('MMM yyyy').format(monthDate),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (selectedPeriod == 'Year') ...[
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  int year = currentDate.year - index;
                  bool isSelected = selectedDate == year.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = year.toString();
                        fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลใหม่เมื่อเลือกปี
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.pink : Colors.pinkAccent,
                      ),
                      child: Text(
                        year.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          // Center(
          //   child: Text(
          //     'Selected Period: $selectedPeriod',
          //     style: TextStyle(fontSize: 24),
          //   ),
          // // ),
          // if (selectedDate != null) ...[
          //   Text(
          //     'Selected Date: $selectedDate',
          //     style: TextStyle(fontSize: 20),
          //   ),
          // ],
          Expanded(
            child: transactionData.isEmpty
                ? Center(
              child: Text(
                'No found data', // ข้อความเมื่อไม่มีข้อมูล
                style: TextStyle(fontSize: 20),
              ),
            )
                : ListView.builder(
              itemCount: transactionData.length,
              itemBuilder: (context, index) {
                final transaction = transactionData[index];
                return ListTile(
                  title: Row(
                    children: [
                      // รูปภาพ wallet_color.png อยู่ทางซ้าย
                      Image.asset(
                        'assets/money.png',
                        width: 60, // ขนาดรูปภาพ
                        height: 60,
                      ),
                      SizedBox(width: 10), // ระยะห่างระหว่างรูปภาพกับข้อมูล
                      // ข้อมูลยอดเงินและวันที่อยู่ทางขวา
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateFormat('d MMM yyyy').format(DateTime.parse(transaction['date_user']))}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+ ${transaction['amount_transaction']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    final db = await openDatabase('transaction.db');
    List<Map<String, dynamic>> results;
    print('Selected Date: $selectedDate');

    // คิวรีเพื่อดึงข้อมูลทั้งหมดจากตาราง Transactions
    results = await db.rawQuery('SELECT * FROM Transactions');

    // ปริ้นค่า date_user สำหรับแต่ละแถว
    for (var row in results) {
      print('Date User: ${row['date_user']}'); // ปริ้น date_user ของแต่ละแถว
    }

    if (selectedPeriod == 'Day' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT date_user, amount_transaction FROM Transactions '
              'WHERE date_user LIKE ? AND type_expense = 0',
          ['${selectedDate}%']
      );
    } else if (selectedPeriod == 'Month' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT date_user, amount_transaction FROM Transactions '
              'WHERE date_user LIKE ? AND type_expense = 0',
          ['${selectedDate}%']
      );
    } else if (selectedPeriod == 'Year' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT date_user, amount_transaction FROM Transactions '
              'WHERE strftime("%Y", date_user) = ? AND type_expense = 0 ',
          [selectedDate]
      );
    } else {
      results = []; // คืนค่าลิสต์ว่างถ้าไม่มีการเลือก
    }

    // ปริ้นข้อมูลที่ได้จากการคิวรี
    print('Results: $results');

    // อัปเดตยอดรวมรายได้ทั้งหมด
    double total = results.fold(0.0, (sum, item) => sum + (item['amount_transaction'] as double));
    setState(() {
      transactionData = results;
      totalIncome = total; // อัปเดตยอดรวมรายได้ทั้งหมด
    });
  }
}
