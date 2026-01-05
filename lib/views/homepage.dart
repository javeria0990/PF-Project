import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pf_project/core/utils.dart';
import 'package:pf_project/viewmodels/theme_viewmodel.dart';
import 'package:pf_project/views/SignIn_screen.dart';
import 'package:pf_project/views/about_app.dart';
import 'package:pf_project/views/contact_us.dart';
import 'package:pf_project/views/helper%20%20widgets/custom_widgets.dart';
import 'package:pf_project/views/privacy_policies.dart';
import 'package:pf_project/views/transactions_history.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CustomWidgets form = CustomWidgets();

  TextEditingController moneyController = TextEditingController();
  TextEditingController tidController = TextEditingController();
  TextEditingController swapAmountController = TextEditingController();
  TextEditingController receiverNumber = TextEditingController();
  TextEditingController receiverName = TextEditingController();
  TextEditingController amountToSend = TextEditingController();
  TextEditingController billConsumerNo = TextEditingController();
  TextEditingController billConsumerName = TextEditingController();
  TextEditingController billAmountController = TextEditingController();

  FocusNode buttonFocus = FocusNode();
  FocusNode tidFocus = FocusNode();
  FocusNode receiverNameFocus = FocusNode();
  FocusNode receiverNumberFocus = FocusNode();
  FocusNode amountToSendFocus = FocusNode();
  FocusNode withrawButtonFocus = FocusNode();
  FocusNode moneyFocus = FocusNode();
  FocusNode consumerNameFocus = FocusNode();
  FocusNode consumerIDFocus = FocusNode();
  FocusNode billAmountFocus = FocusNode();

  final _key = GlobalKey<FormState>();
  final _key2 = GlobalKey<FormState>();
  final _key3 = GlobalKey<FormState>();
  final _key4 = GlobalKey<FormState>();

  final List<String> paymentMethods = [
    "Binance",
    "JazzCash",
    "EasyPaisa",
    "NayaPay",
    "SadaPay",
  ];

  final List<String> receiverMethods = [
    "Paynix",
    "Binance",
    "JazzCash",
    "EasyPaisa",
    "NayaPay",
    "SadaPay",
  ];

  final List<String> currency = ["PKR", "USD"];
  final List<String> swapCurrency = ["PKR", "USD"];

  final Map<String, List<String>> bills = {
    "Electricity": ["MEPCO", "LESCO", "K-ELECTRIC"],
    "Water": ["LWASA", "BWASA", "CDA"],
    "Gas": ["SSGC", "SNGPL"],
    "Internet": ["OPTIX", "SB-LINK", "NAYATEL"],
    "1Bill Payments": ["1Bill INVOICES", "1BILL TOP UP"],
  };

  String? selectedMethod;
  String? selectedExchangeCurrency;
  String? selectedReceiverMethod;
  String? selectedBill;
  String? selectedSP;
  String? selectedCurrencyToAdd;
  String? selectedCurrencyToSend;

  //user details
  String? userName, email;
  int? userID;
  double totalPkrBalance = 0, totalUsdBalance = 0;
  bool isLoading = false;
  double gasFee = 0;
  double exchangedAmount = 0;
  double remainingBalance = 0;
  int perUSDpkr = 280;
  double perPKRusd = 0.0036;
  double transferFee = 0;

  @override
  void initState() {
    currentUser();
    super.initState();
  }

  @override
  void dispose() {
    moneyController.dispose();
    tidController.dispose();
    swapAmountController.dispose();
    receiverNumber.dispose();
    receiverName.dispose();
    amountToSend.dispose();
    billConsumerNo.dispose();
    billConsumerName.dispose();
    billAmountController.dispose();

    buttonFocus.dispose();
    tidFocus.dispose();
    receiverNameFocus.dispose();
    receiverNumberFocus.dispose();
    amountToSendFocus.dispose();
    withrawButtonFocus.dispose();
    moneyFocus.dispose();
    consumerNameFocus.dispose();
    consumerIDFocus.dispose();
    billAmountFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 8),
            child: CircleAvatar(backgroundImage: AssetImage("assets/logo.png")),
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
              "Paynix",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: EndDrawerButton(color: Colors.black),
            ),
          ],
        ),
      ),
      endDrawer: endDrawer(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff136a8a), Color(0xff57C785)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Available Balance", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PKR:$totalPkrBalance",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "USD:$totalUsdBalance\$",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last updated • Just now",
                        style: TextStyle(fontSize: 14),
                      ),
                      SelectableText(
                        "UID:Px0$userID",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    addMoneyCard();
                  },
                  child: actionCard(Icons.add, "Add Money", Colors.green),
                ),
                InkWell(
                  onTap: () {
                    exchangeMoneyCard();
                  },
                  child: actionCard(Icons.swap_vert, "Exchange", Colors.blue),
                ),
                InkWell(
                  onTap: () {
                    transferMoneyCard();
                  },
                  child: actionCard(Icons.trending_up, "Transfer", Colors.red),
                ),
                InkWell(
                  onTap: () {
                    billPaymentsCard();
                  },
                  child: actionCard(
                    Icons.receipt_long,
                    "Bill Payment",
                    Color(0xFF546E7A),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsHistory(),
                      ),
                    );
                  },
                  child: actionCard(
                    Icons.history,
                    "Transactions",
                    Color.fromARGB(255, 2, 39, 162),
                  ),
                ),
              ],
            ),

            SizedBox(height: 35),
            Text(
              "Account Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: smallInfoCard(
                    "Deposits",
                    "PKR 0",
                    "USD 0",
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: smallInfoCard(
                    "Withdrawals",
                    "PKR 0",
                    "USD 0",
                    Icons.arrow_downward,
                    Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15),
            transactionItem(
              "Added Money",
              "+5000",
              "11 Jan 2025",
              Colors.green,
            ),
            transactionItem("Withdrawal", "-1200", "10 Jan 2025", Colors.red),
            transactionItem("Transfer", "-2000", "09 Jan 2025", Colors.blue),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void billPaymentsCard() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Center(
              child: Text(
                "Bill Payment",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            content: Form(
              key: _key4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 0,
                      ),
                      label: Text('--Select Bill Payment--'),
                      labelStyle: TextStyle(fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xff57C785),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                    value: selectedBill,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a Bill to pay!';
                      }
                      return null;
                    },
                    items: bills.keys.map((bill) {
                      return DropdownMenuItem<String>(
                        value: bill,
                        child: Text(
                          bill,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBill = value;
                        selectedSP = null;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 0,
                      ),
                      label: Text('--Select Service Provider--'),
                      labelStyle: TextStyle(fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xff57C785),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                    value: selectedSP,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a Service Provider!';
                      }
                      return null;
                    },
                    items: selectedBill == null
                        ? []
                        : bills[selectedBill]!.map((bill) {
                            return DropdownMenuItem<String>(
                              value: bill,
                              child: Text(
                                bill,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    onChanged: selectedBill == null
                        ? null
                        : (String? value) {
                            setState(() {
                              selectedSP = value;
                            });
                          },
                  ),
                  SizedBox(height: 10),
                  form.signInTf(
                    focus: consumerNameFocus,
                    onsubmitted: (p0) {
                      FocusScope.of(context).requestFocus(consumerIDFocus);
                    },
                    controller: billConsumerName,
                    icon: Icon(Icons.numbers),
                    hint: "Enter Consumer Name",
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Consumer name is required!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  form.signInTf(
                    controller: billConsumerNo,
                    focus: consumerIDFocus,
                    onsubmitted: (p0) {
                      FocusScope.of(context).requestFocus(billAmountFocus);
                    },
                    icon: Icon(Icons.numbers),
                    hint: "Enter Consumer ID",
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Consumer ID is required!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  form.signInTf(
                    controller: billAmountController,
                    focus: billAmountFocus,
                    onsubmitted: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.money),
                    hint: "Enter amount to be paid",
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return "Amount is required!";
                      }
                      double maxLimit = double.tryParse(p0) ?? 0;
                      if (maxLimit > 100000000) {
                        return "Max allowed limit is 100000000 PKR";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  form.button(
                    text: Text(
                      "Pay Bill",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      if (!_key4.currentState!.validate()) {
                        return;
                      }
                      Navigator.pop(context);
                      double bAmount =
                          double.tryParse(billAmountController.text.trim()) ??
                          0;
                      if (bAmount > totalPkrBalance) {
                        Utils().flutterToast(
                          "Insufficient PKR balance!",
                          context,
                        );
                        return;
                      }
                      billStats(bAmount);
                      billPaymentConfirmation();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void billStats(double billAmount) {
    remainingBalance = totalPkrBalance - billAmount;
    setState(() {
      remainingBalance = remainingBalance;
    });
  }

  void billPaymentConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text("Stats", style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Consumer Name:"),
                  Text(billConsumerName.text.trim()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Consumer ID:"),
                  Text(billConsumerNo.text.trim()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bill Type:"),
                  Text("$selectedBill-$selectedSP"),
                ],
              ),
              SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Payment fee:"), Text("0.00")],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Amount to pay:"),
                  Text(billAmountController.text.trim()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Remaining Balance:${"PKR"}"),
                  Text("$remainingBalance"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                  ),
                  form.button(
                    text: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      Utils().flutterToast("Bill Paid Successfully!", context);
                      await Future.delayed(Duration(seconds: 1));
                      await payBill(
                        userID.toString(),
                        billAmountController.text.trim(),
                      );
                      await billPaymentHistory(
                        userID.toString(),
                        selectedBill!,
                        selectedSP!,
                        billConsumerName.text.trim(),
                        billConsumerNo.text.trim(),
                        billAmountController.text.trim(),
                      );
                      await currentUser();
                      setState(() {
                        selectedSP = null;
                        billAmountController.clear();
                        billConsumerName.clear();
                        billConsumerNo.clear();
                        selectedBill = null;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void transferMoneyCard() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Transfer Money",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          content: Form(
            key: _key3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 0,
                    ),
                    label: Text('--Select Currency--'),
                    labelStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xff57C785),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  value: selectedCurrencyToSend,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select any currency!';
                    }
                    return null;
                  },
                  items: swapCurrency.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(
                        currency,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCurrencyToSend = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 0,
                    ),
                    label: Text('--Select Payment Method--'),
                    labelStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xff57C785),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  value: selectedReceiverMethod,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a payment method!';
                    }
                    return null;
                  },
                  items: receiverMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(
                        method,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedReceiverMethod = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                form.signInTf(
                  focus: receiverNumberFocus,
                  taction: TextInputAction.next,
                  onsubmitted: (p0) {
                    FocusScope.of(context).requestFocus(receiverNameFocus);
                  },
                  controller: receiverNumber,
                  icon: Icon(Icons.credit_card),
                  hint: selectedReceiverMethod == "Paynix"
                      ? "Enter Paynix UID"
                      : "Enter account number",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return selectedReceiverMethod == "Paynix"
                          ? "Paynix UID is required!"
                          : "Account number is required!";
                    }
                    if ((selectedReceiverMethod == "Paynix") &&
                        (p0.length < 3)) {
                      return "Paynix UID must be greater than 3 characters!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                form.signInTf(
                  focus: receiverNameFocus,
                  taction: TextInputAction.next,
                  onsubmitted: (p0) {
                    FocusScope.of(context).requestFocus(withrawButtonFocus);
                  },
                  controller: receiverName,
                  icon: Icon(Icons.person),
                  hint: "Enter receiver name",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Receiver name is required!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                form.signInTf(
                  focus: amountToSendFocus,
                  taction: TextInputAction.next,
                  onsubmitted: (p0) {
                    FocusScope.of(context).requestFocus(withrawButtonFocus);
                  },
                  controller: amountToSend,
                  icon: Icon(Icons.money),
                  hint: "Enter amount",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Amount is required!";
                    }
                    double maxLimit = double.tryParse(p0) ?? 0;
                    if (maxLimit > 100000000) {
                      return "Max allowed limit is 100000000${selectedCurrencyToSend == " PKR" ? " \$" : "\$"}";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                form.button(
                  focusnode: withrawButtonFocus,
                  text: Text("Send", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    if (!_key3.currentState!.validate()) {
                      return;
                    }
                    if ((selectedCurrencyToSend == "USD" &&
                            selectedReceiverMethod != "Binance") &&
                        (selectedCurrencyToSend == "USD" &&
                            selectedReceiverMethod != "Paynix")) {
                      Navigator.pop(context);
                      Utils().flutterToast(
                        "USD Transaction can't be done except Binance Method!",
                        context,
                      );
                    } else if ((selectedCurrencyToSend == "PKR" &&
                        selectedReceiverMethod == "Binance")) {
                      Navigator.pop(context);
                      Utils().flutterToast(
                        "PKR Transaction can't be done through Binance!",
                        context,
                      );
                    } else {
                      double totalB = 0;
                      double amount =
                          double.tryParse(amountToSend.text.trim()) ?? 0;
                      if (selectedCurrencyToSend == "PKR") {
                        totalB = totalPkrBalance;
                      } else {
                        totalB = totalUsdBalance;
                      }
                      transferFeeDeduction();
                      transferStats(
                        selectedCurrencyToSend.toString(),
                        totalB,
                        amount,
                      );
                      Navigator.pop(context);
                      transferConfirmation();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double transferFeeDeduction() {
    double amount = double.tryParse(amountToSend.text.trim()) ?? 0;
    if (selectedCurrencyToSend == "PKR") {
      if (amount < 5000) {
        transferFee = 0;
      } else if (amount < 10000) {
        transferFee = 10;
      } else if (amount < 100000) {
        transferFee = 100;
      } else if (amount < 1000000) {
        transferFee = 500;
      } else if (amount < 10000000) {
        transferFee = 1000;
      } else if (amount < 100000000) {
        transferFee = 2000;
      }
    } else {
      if (amount < 50) {
        transferFee = 0;
      } else if (amount < 100) {
        transferFee = 3;
      } else if (amount < 100000) {
        transferFee = 10;
      } else if (amount < 1000000) {
        transferFee = 50;
      } else if (amount < 10000000) {
        transferFee = 100;
      } else if (amount < 100000000) {
        transferFee = 200;
      }
    }
    setState(() {
      transferFee;
    });
    return transferFee;
  }

  void transferStats(
    String balanceType,
    double totalBalance,
    double amountToSend,
  ) {
    if (balanceType == "PKR") {
      remainingBalance = totalBalance - (amountToSend + transferFee);
    } else {
      remainingBalance = totalBalance - (amountToSend + transferFee);
    }
    setState(() {
      remainingBalance = remainingBalance;
    });
  }

  void transferConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text("Stats", style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Receiver Name:"),
                  Text(receiverName.text.trim()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Receiver Number/UID:"),
                  Text(receiverNumber.text.trim()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Transfer fee:"), Text("$transferFee")],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Amount to transfer:"),
                  Text(amountToSend.text.trim()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remaining Balance:${selectedCurrencyToSend == "PKR" ? "PKR" : "USD"}",
                  ),
                  Text("$remainingBalance"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                  ),
                  form.button(
                    text: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      Utils().flutterToast(
                        "Amount Sent Successfully!",
                        context,
                      );
                      await Future.delayed(Duration(seconds: 1));
                      int balType = 0;
                      if (selectedCurrencyToSend == "PKR") {
                        balType = 1;
                      } else if (selectedCurrencyToSend == "USD") {
                        balType = 2;
                      }
                      await transferMoney(
                        userID.toString(),
                        balType.toString(),
                        amountToSend.text.trim(),
                      );
                      await transferHistory(
                        userID.toString(),
                        selectedCurrencyToSend!,
                        selectedReceiverMethod!,
                        receiverNumber.text.trim(),
                        receiverName.text.trim(),
                        amountToSend.text.trim(),
                      );
                      await currentUser();
                      setState(() {
                        selectedReceiverMethod = null;
                        amountToSend.clear();
                        receiverName.clear();
                        receiverNumber.clear();
                        selectedCurrencyToSend = null;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void exchangeMoneyCard() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Exchange Money",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          content: Form(
            key: _key2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 0,
                    ),
                    label: Text('--Select Currency--'),
                    labelStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xff57C785),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  value: selectedExchangeCurrency,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a currency!';
                    }
                    return null;
                  },
                  items: swapCurrency.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(
                        currency,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedExchangeCurrency = value;
                  },
                ),
                SizedBox(height: 5),
                form.signInTf(
                  controller: swapAmountController,
                  icon: Icon(Icons.money),
                  hint: "Enter amount to swap",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please enter amount to swap!";
                    }
                    double maxLimit = double.tryParse(p0) ?? 0;
                    if (maxLimit > 100000000) {
                      return "Max allowed limit is 100000000${selectedMethod == "USD" ? "\$" : "PKR"}";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                form.button(
                  text: Text("Exchange", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    if (!_key2.currentState!.validate()) {
                      return;
                    }
                    double totalB = 0;
                    double amount =
                        double.tryParse(swapAmountController.text.trim()) ?? 0;
                    if (selectedExchangeCurrency == "PKR") {
                      totalB = totalPkrBalance;
                    } else {
                      totalB = totalUsdBalance;
                    }

                    gasFeeDeduction();
                    stats(selectedExchangeCurrency.toString(), totalB, amount);
                    Navigator.pop(context);
                    exchangeConfirmation();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void exchangeConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text("Stats", style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Exchange Rate:"),
                  Text(
                    selectedExchangeCurrency == "USD"
                        ? "$perPKRusd "
                        : "$perUSDpkr\$",
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Exchange fee:"), Text("$gasFee")],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Exchanged amount:"), Text("$exchangedAmount")],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remaining Balance:${selectedExchangeCurrency == "USD" ? "USD" : "PKR"}",
                  ),
                  Text("$remainingBalance"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                  ),
                  form.button(
                    text: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      Utils().flutterToast(
                        "Amount exchanged Successfully!",
                        context,
                      );
                      await Future.delayed(Duration(seconds: 1));
                      int balType = 0;
                      if (selectedExchangeCurrency == "PKR") {
                        balType = 1;
                      } else if (selectedExchangeCurrency == "USD") {
                        balType = 2;
                      }
                      await exchangeMoney(
                        userID.toString(),
                        balType.toString(),
                        swapAmountController.text.trim().trim(),
                      );
                      await exchangeHistory(
                        userID.toString(),
                        selectedExchangeCurrency!,
                        swapAmountController.text,
                      );
                      await currentUser();
                      setState(() {
                        selectedExchangeCurrency = null;
                        swapAmountController.clear();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void stats(String balanceType, double totalBalance, double amountToExchange) {
    if (balanceType == "PKR") {
      remainingBalance = totalBalance - (amountToExchange + gasFee);
      exchangedAmount = amountToExchange * perPKRusd;
    } else {
      remainingBalance = totalBalance - (amountToExchange + gasFee);
      exchangedAmount = amountToExchange * perUSDpkr;
    }
    setState(() {
      remainingBalance = remainingBalance;
      exchangedAmount = exchangedAmount;
    });
  }

  double gasFeeDeduction() {
    double amount = double.tryParse(swapAmountController.text.trim()) ?? 0;
    if (selectedExchangeCurrency == "PKR") {
      if (amount < 5000) {
        gasFee = 50;
      } else if (amount < 10000) {
        gasFee = 100;
      } else if (amount < 100000) {
        gasFee = 1000;
      } else if (amount < 1000000) {
        gasFee = 5000;
      } else if (amount < 10000000) {
        gasFee = 10000;
      } else if (amount < 100000000) {
        gasFee = 20000;
      }
    } else {
      if (amount < 50) {
        gasFee = 3;
      } else if (amount < 100) {
        gasFee = 5;
      } else if (amount < 100000) {
        gasFee = 100;
      } else if (amount < 1000000) {
        gasFee = 500;
      } else if (amount < 10000000) {
        gasFee = 1000;
      } else if (amount < 100000000) {
        gasFee = 2000;
      }
    }
    setState(() {});
    return gasFee;
  }

  void addMoneyCard() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Add Money",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          content: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select any currency!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 0,
                    ),
                    label: Text('--Select Currency--'),
                    labelStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xff57C785),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  value: selectedCurrencyToAdd,
                  items: currency.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(
                        currency,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCurrencyToAdd = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a payment method!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 0,
                    ),
                    label: Text('--Select Payment Method--'),
                    labelStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xff57C785),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  value: selectedMethod,
                  items: paymentMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(
                        method,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                form.signInTf(
                  controller: moneyController,
                  focus: moneyFocus,
                  onsubmitted: (p0) {
                    FocusScope.of(context).requestFocus(tidFocus);
                  },
                  icon: Icon(Icons.money),
                  hint: "Enter amount you sent",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Sent amount is required!";
                    }
                    double maxLimit = double.tryParse(p0) ?? 0;
                    if (maxLimit > 100000000) {
                      return "Max allowed limit is 100000000${selectedMethod == "USD" ? "\$" : "PKR"}";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                form.signInTf(
                  focus: tidFocus,
                  taction: TextInputAction.next,
                  onsubmitted: (p0) {
                    FocusScope.of(context).requestFocus(buttonFocus);
                  },
                  controller: tidController,
                  icon: Icon(Icons.numbers),
                  hint: "Enter TID/UID",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "TID/UID is required!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                form.button(
                  focusnode: buttonFocus,
                  text: Text("Confirm", style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    if (!_key.currentState!.validate()) {
                      return;
                    }
                    if (selectedCurrencyToAdd == "USD" &&
                        selectedMethod != "Binance" &&
                        selectedMethod != "Paynix") {
                      Navigator.pop(context);
                      Utils().flutterToast(
                        "USD Transaction can't be done except Binance Method!",
                        context,
                      );
                    } else if ((selectedCurrencyToAdd == "PKR" &&
                        selectedMethod == "Binance")) {
                      Navigator.pop(context);
                      Utils().flutterToast(
                        "PKR Transaction can't be done through Binance!",
                        context,
                      );
                    } else {
                      Navigator.pop(context);
                      Utils().flutterToast(
                        "After Confirmation your balance will be updated!",
                        context,
                      );
                      if (selectedMethod == "Binance") {
                        await Future.delayed(Duration(seconds: 2));
                        await addMoney(
                          userID.toString(),
                          2.toString(),
                          moneyController.text.trim(),
                        );
                        await currentUser();
                      } else {
                        await Future.delayed(Duration(seconds: 2));
                        await addMoney(
                          userID.toString(),
                          1.toString(),
                          moneyController.text.trim(),
                        );
                        await currentUser();
                      }
                    }
                    setState(() {
                      moneyController.clear();
                      tidController.clear();
                      selectedMethod = null;
                      selectedCurrencyToAdd = null;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget endDrawer(BuildContext context) {
    double widthx = MediaQuery.of(context).size.width;
    double heightx = MediaQuery.of(context).size.height;
    return Drawer(
      width: widthx * 0.3,
      child: ListView(
        children: [
          SizedBox(
            height: 200,
            width: widthx * 0.3,

            child: Image.asset('assets/image.png', fit: BoxFit.cover),
          ),
          SizedBox(height: heightx * 0.01),
          SizedBox(
            height: heightx * 0.27,
            child: Column(
              children: [
                Text(
                  'Paynix',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                SizedBox(height: heightx * 0.01),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    'Username',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    userName ?? "Loading",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.email)),
                  title: Text(
                    'Email',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    email ?? "Loading",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Consumer<ThemeViewmodel>(
            builder: (context, val, child) => ListTile(
              trailing: Transform.scale(
                scale: 0.75,
                child: Switch.adaptive(
                  value: val.isDark,
                  onChanged: (value) {
                    val.updateTheme(value);
                  },
                ),
              ),
              leading: Icon(Icons.dark_mode, size: 20),
              title: Text(
                'Dark Theme',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
            leading: Icon(Icons.privacy_tip, size: 20),
            title: Text(
              'Privacy Policies',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutAppPage()),
              );
            },
            leading: Icon(Icons.info, size: 20),
            title: Text(
              'About App',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsPage()),
              );
            },
            leading: Icon(Icons.contact_mail, size: 20),
            title: Text(
              'Contact Us',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              isLoading ? 'Logging out....' : 'Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurpleAccent,
              ),
            ),
            onTap: () async {
              Provider.of<ThemeViewmodel>(
                context,
                listen: false,
              ).setLightMode();
              setState(() {
                isLoading = true;
              });
              await Future.delayed(Duration(seconds: 2));
              await logout();
              isLoading = false;
            },
          ),
        ],
      ),
    );
  }

  Widget actionCard(IconData icon, String label, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget smallInfoCard(
    String title,
    String pkr,
    String usd,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pkr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  usd,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionItem(
    String title,
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
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      final result = await Process.run(
        "logout.exe",
        [],
        workingDirectory: Directory.current.path,
      );
      int decide = result.exitCode;
      switch (decide) {
        case 0:
          {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          }
          break;
        default:
          Utils().flutterToast("Internal Error", context);
          Navigator.pop(context);
          break;
      }
    } catch (e) {
      debugPrint("Error in logout :$e");
    }
  }

  Future<void> currentUser() async {
    try {
      final result = await Process.run(
        "get_uid.exe",
        [],
        workingDirectory: Directory.current.path,
      );
      int uid = result.exitCode;
      switch (uid) {
        case -1:
          {
            debugPrint("file opening error!");
            if (!mounted) return;
            Utils().flutterToast("Error in fetching user details!", context);
          }
          break;
        case -2:
          {
            debugPrint("Empty session file");
          }
          break;
        case -3:
          {
            debugPrint("invalid format or currupted file");
          }
          break;
        default:
          {
            setState(() {
              userID = uid;
            });
            final details = await Process.run("get_user_info.exe", [
              userID.toString(),
            ], workingDirectory: Directory.current.path);
            int decide = details.exitCode;
            debugPrint("decide :$decide");
            switch (decide) {
              case -1:
                {
                  if (!mounted) return;
                  Utils().flutterToast(
                    "Error in fetching user details!",
                    context,
                  );
                  debugPrint("file opening error! -1");
                }
                break;
              case 5:
                {
                  debugPrint(
                    "unexpected error in fetching details from users file!",
                  );
                  if (!mounted) return;
                  Utils().flutterToast(
                    "Error in fetching user details!",
                    context,
                  );
                }
                break;
              case -4:
                {
                  debugPrint("file opening error! -4");
                }
                break;
              case 0:
                {
                  debugPrint("Get user info succesfully!");
                }
                break;
              default:
                {
                  debugPrint("unexpected error  ...!");
                }
                break;
            }
            final output = details.stdout.toString().trim();
            final line = output.split('\n');
            if (output.isNotEmpty) {
              setState(() {
                userName = line[0];
                email = line[1];
                double tPKRB = double.tryParse(line[2]) ?? 0;
                double tUSDB = double.tryParse(line[3]) ?? 0;
                totalPkrBalance = tPKRB;
                totalUsdBalance = tUSDB;
              });
            }
          }
          break;
      }
    } catch (e) {
      debugPrint("error in current user!");
    }
  }

  Future<void> addMoney(String uid, String amountType, String amount) async {
    try {
      final result = await Process.run("add_balance.exe", [
        uid,
        amountType,
        amount,
      ], workingDirectory: Directory.current.path);
      int decide = result.exitCode;
      switch (decide) {
        case 0:
          {
            debugPrint("Added Balance Successfully!");
            await addBalanceHistory(
              uid,
              selectedCurrencyToAdd!,
              amount,
              tidController.text.trim(),
              selectedMethod!,
            );
          }
          break;
        case 1:
          {
            debugPrint("Empty wallet file");
          }
          break;
        case -1:
          {
            debugPrint("Wallet file opening error!");
          }
          break;
        default:
      }
    } catch (e) {
      debugPrint("Error in add money function: $e");
    }
  }

  Future<void> exchangeMoney(
    String uid,
    String amountType,
    String amount,
  ) async {
    try {
      final resultx = await Process.run("exchange.exe", [
        uid,
        amountType,
        amount,
      ], workingDirectory: Directory.current.path);
      int decide = resultx.exitCode;
      debugPrint("exchange decide code: $decide");
      switch (decide) {
        case 0:
          {
            debugPrint("Exchanged money sucessfully!");
            await Future.delayed(Duration(seconds: 1));
            await currentUser();
          }
          break;
        case -7:
          {
            if (!mounted) {
              return;
            }
            Utils().flutterToast(
              "Insufficient Balance for this action!",
              context,
            );
          }
          break;
        case -1:
          {
            debugPrint("File opening error in exchange funtion!");
          }
        default:
          {
            debugPrint("Error in exchange money function cpp");
          }
      }
    } catch (e) {
      debugPrint("Error in exchang money function $e");
    }
  }

  Future<void> transferMoney(
    String uid,
    String amountType,
    String amount,
  ) async {
    try {
      final resultx = await Process.run("money_transfer.exe", [
        uid,
        amountType,
        amount,
      ], workingDirectory: Directory.current.path);
      int decide = resultx.exitCode;
      debugPrint("transfer decide code: $decide");
      switch (decide) {
        case 0:
          {
            debugPrint("transferred money sucessfully!");
            await Future.delayed(Duration(seconds: 1));
            await currentUser();
          }
          break;
        case -7:
          {
            if (!mounted) {
              return;
            }
            Utils().flutterToast(
              "Insufficient Balance for this action!",
              context,
            );
          }
          break;
        case -1:
          {
            debugPrint("File opening error in transfer funtion!");
          }
        default:
          {
            debugPrint("Error in transfer money function cpp");
          }
      }
    } catch (e) {
      debugPrint("Error in transfer money function $e");
    }
  }

  Future<void> payBill(String uid, String amount) async {
    try {
      final resultx = await Process.run("bill_payments.exe", [
        uid,
        amount,
      ], workingDirectory: Directory.current.path);
      int decide = resultx.exitCode;
      debugPrint("billPayment decide code: $decide");
      switch (decide) {
        case 0:
          {
            debugPrint("bill paid sucessfully!");
            await Future.delayed(Duration(seconds: 1));
            await currentUser();
          }
          break;
        case -7:
          {
            if (!mounted) {
              return;
            }
            Utils().flutterToast(
              "Insufficient Balance for this action!",
              context,
            );
          }
          break;
        case -1:
          {
            debugPrint("File opening error in bill payment funtion!");
          }
        default:
          {
            debugPrint("Error in bill payment function cpp");
            Utils().flutterToast("Unexpected error", context);
          }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint("Error in billpayment function $e");
      Utils().flutterToast("Unexpected error while processing!", context);
    }
  }

  Future<void> addBalanceHistory(
    String uid,
    String blanceType,
    String amount,
    String method,
    String tID,
  ) async {
    try {
      final history = await Process.run("addBalanceHistory.exe", [
        uid,
        blanceType,
        amount,
        method,
        tID,
      ], workingDirectory: Directory.current.path);
      int decide = history.exitCode;
      switch (decide) {
        case 0:
          {
            debugPrint("Added blanance add history sucessfully!");
            await Future.delayed(Duration(seconds: 1));
            await currentUser();
          }
          break;
        case -1:
          {
            if (!mounted) {
              return;
            }
            Utils().flutterToast("Internal error occured!", context);
            debugPrint("file opening error in addblnc history");
          }
          break;
        case -6:
          {
            debugPrint("incorrect arguments!");
          }
        default:
          {
            debugPrint("Error in add balance history function cpp");
            Utils().flutterToast("Unexpected error", context);
          }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint("Error in  add balance history function cpp: $e");
      Utils().flutterToast("Unexpected error while processing!", context);
    }
  }

  Future<void> exchangeHistory(
    String uid,
    String toBeExchangedCurrency,
    String exchangeamount,
  ) async {
    try {
      final history = await Process.run("exchangeHistory.exe", [
        uid,
        toBeExchangedCurrency,
        exchangeamount,
      ], workingDirectory: Directory.current.path);
      int decide = history.exitCode;
      switch (decide) {
        case 0:
          {
            debugPrint("Added exchange history sucessfully!");
            await Future.delayed(Duration(seconds: 1));
            await currentUser();
          }
          break;
        case -1:
          {
            if (!mounted) {
              return;
            }
            Utils().flutterToast("Internal error occured!", context);
            debugPrint("file opening error in exchange history");
          }
          break;
        case -6:
          {
            debugPrint("incorrect arguments in exhchange history!");
          }
        default:
          {
            debugPrint("Error in exchange history function cpp");
            Utils().flutterToast("Unexpected error", context);
          }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint("Error in exchange history history function cpp: $e");
      Utils().flutterToast("Unexpected error while processing!", context);
    }
  }

  Future<void> transferHistory(
    String uid,
    String transferedCurrency,
    String method,
    String accountNumber,
    String receiverName,
    String sentAmount,
  ) async {
    try {
      final history = await Process.run("transferHistory.exe", [
        uid,
        transferedCurrency,
        method,
        accountNumber,
        receiverName,
        sentAmount,
      ], workingDirectory: Directory.current.path);
      int decide = history.exitCode;
      switch (decide) {
        case 0:
          {
            debugPrint("Added transfer history sucessfully!");
          }
          break;
        case -1:
          {
            if (!mounted) {
              return;
            }
            Utils().flutterToast("Internal error occured!", context);
            debugPrint("file opening error in transfer history");
          }
          break;
        case -6:
          {
            debugPrint("incorrect arguments in transfer history!");
          }
        default:
          {
            debugPrint("Error in transfer history function cpp");
            Utils().flutterToast("Unexpected error!", context);
          }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint("Error in transfer history function cpp: $e");
      Utils().flutterToast("Unexpected error while processing!", context);
    }
  }

  Future<void> billPaymentHistory(
    String uid,
    String billType,
    String serviceProvider,
    String consumerName,
    String consumerID,
    String paidAmount,
  ) async {
    try {
      final history = await Process.run("billPaymentHistory.exe", [
        uid,
        billType,
        serviceProvider,
        consumerName,
        consumerID,
        paidAmount,
      ], workingDirectory: Directory.current.path);
      int decide = history.exitCode;
      switch (decide) {
        case 0:
          {
            debugPrint("Added bill Payment history sucessfully!");
          }
          break;
        case -1:
          {
            if (!mounted) {
              return;
            }
            Utils().flutterToast("Internal error occured!", context);
            debugPrint("file opening error in bill Payment history");
          }
          break;
        case -6:
          {
            debugPrint("incorrect arguments in transfer history!");
          }
        default:
          {
            debugPrint("Error in bill Payment history function cpp");
            Utils().flutterToast("Unexpected error!", context);
          }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      debugPrint("Error in bill Payment history function cpp: $e");
      Utils().flutterToast("Unexpected error while processing!", context);
    }
  }
}
