import 'dart:io';

import 'package:flutter/material.dart';

class TransactionsHistory extends StatefulWidget {
  final String userID;
  const TransactionsHistory({super.key, required this.userID});

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    // displayAddBalanceHistory();
    // displayExchangeHistory();
    // displayTransferHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff136a8a), Color(0xff57C785)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Transactions History",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Text(
                      "No Transaction yet!",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return transactionItem(
                        transactions[index]["action"],
                        transactions[index]["currency"],
                        transactions[index]["method"],
                        transactions[index]["accountNum"],
                        transactions[index]["name"],
                        transactions[index]["amount"],
                        transactions[index]["time"],
                        transactions[index]["color"],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> displayAddBalanceHistory() async {
    try {
      final result = await Process.run("displayAddBalanceHistory.exe", [
        widget.userID.trim(),
      ], workingDirectory: Directory.current.path);

      final output = result.stdout.toString().trim();
      if (output.isEmpty) return;

      final lines = output.split('\n');

      final List<Map<String, dynamic>> temp = [];

      for (final line in lines) {
        final parts = line.split('|');

        if (parts.length < 6) continue;

        temp.add({
          "action": "Added Money",
          "uid": parts[0],
          "currency": parts[1],
          "amount": parts[2],
          "method": parts[3],
          "tid": parts[4],
          "time": parts[5],
          "color": Colors.green,
        });
      }
      setState(() {
        transactions = temp;
      });
    } catch (e) {
      debugPrint("Error displaying add balance history: $e");
    }
  }

  Future<void> displayExchangeHistory() async {
    try {
      final result = await Process.run("displayExchangeHistory.exe", [
        widget.userID.trim(),
      ], workingDirectory: Directory.current.path);

      final output = result.stdout.toString().trim();
      if (output.isEmpty) return;

      final lines = output.split('\n');

      final List<Map<String, dynamic>> temp = [];

      for (final line in lines) {
        final parts = line.split('|');

        if (parts.length < 4) continue;

        temp.add({
          "action": "Exchanged Money",
          "uid": parts[0],
          "currency": parts[1],
          "amount": parts[2],
          "time": parts[3],
          "color": Colors.blue,
        });
      }
      setState(() {
        transactions = temp;
      });
    } catch (e) {
      debugPrint("Error displaying exchange history: $e");
    }
  }

  Future<void> displayTransferHistory() async {
    try {
      final result = await Process.run("displayTransferHistory.exe", [
        widget.userID.trim(),
      ], workingDirectory: Directory.current.path);

      final output = result.stdout.toString().trim();
      if (output.isEmpty) return;

      final lines = output.split('\n');

      final List<Map<String, dynamic>> temp = [];

      for (final line in lines) {
        final parts = line.split('|');

        if (parts.length < 7) continue;

        temp.add({
          "action": "Transferred Money",
          "currency": parts[1],
          "method": parts[2],
          "accountNum": parts[3],
          "name": parts[4],
          "amount": parts[5],
          "time": parts[6],
          "color": Colors.red,
        });
      }
      setState(() {
        transactions = temp;
      });
    } catch (e) {
      debugPrint("Error displaying transfer money history: $e");
    }
  }

  Future<void> displayBillHistory() async {
    try {
      final result = await Process.run("displayTransferHistory.exe", [
        widget.userID.trim(),
      ], workingDirectory: Directory.current.path);

      final output = result.stdout.toString().trim();
      if (output.isEmpty) return;

      final lines = output.split('\n');

      final List<Map<String, dynamic>> temp = [];

      for (final line in lines) {
        final parts = line.split('|');

        if (parts.length < 7) continue;

        temp.add({
          "action": "Transferred Money",
          "currency": parts[1],
          "method": parts[2],
          "accountNum": parts[3],
          "name": parts[4],
          "amount": parts[5],
          "time": parts[6],
          "color": Colors.red,
        });
      }
      setState(() {
        transactions = temp;
      });
    } catch (e) {
      debugPrint("Error displaying transfer money history: $e");
    }
  }
}

// Widget transactionItem(
//   String title,
//   String currency,
//   String method,
//   String tid,
//   String amount,
//   String date,
//   Color color,
// ) {
//   return Card(
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//     child: ListTile(
//       leading: CircleAvatar(
//         backgroundColor: color.withValues(alpha: 200),
//         child: Icon(Icons.account_balance_wallet, color: color),
//       ),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
//       subtitle: Row(
//         children: [
//           Text(currency),
//           SizedBox(width: 10),
//           Text(method),
//           SizedBox(width: 10),
//           Text(tid),
//           SizedBox(width: 10),
//           Text(amount),
//           SizedBox(width: 10),
//           Text(date),
//         ],
//       ),
//       trailing: Text(
//         amount,
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//     ),
//   );
// }

// Widget transactionItem(
//   String title,
//   String currency,
//   String amount,
//   String date,
//   Color color,
// ) {
//   return Card(
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//     child: ListTile(
//       leading: CircleAvatar(
//         backgroundColor: color.withValues(alpha: 200),
//         child: Icon(Icons.account_balance_wallet, color: color),
//       ),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
//       subtitle: Row(
//         children: [
//           Text("Exchanged Currency: $currency"),
//           SizedBox(width: 10),
//           SizedBox(width: 10),
//           SizedBox(width: 10),
//           Text("Exchanged Amount: $amount"),
//           SizedBox(width: 10),
//           Text(date),
//         ],
//       ),
//       trailing: Text(
//         amount,
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//     ),
//   );
// }

Widget transactionItem(
  String title,
  String currency,
  String method,
  String accountNum,
  String name,
  String amount,
  String date,
  Color color,
) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 200),
        child: Icon(Icons.account_balance_wallet, color: color),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Row(
        children: [
          Text("Currency: $currency"),
          SizedBox(width: 10),
          Text("Transacton Method: $method"),
          SizedBox(width: 10),
          Text("Account Name: $name"),
          SizedBox(width: 10),
          Text("Account No/UID: $accountNum"),
          SizedBox(width: 10),
          SizedBox(width: 10),
          Text("Time: $date"),
        ],
      ),
      trailing: Text(
        "Amount: $amount",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}
