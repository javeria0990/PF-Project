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
  TextEditingController billConsumerNo = TextEditingController();

  FocusNode buttonFocus = FocusNode();
  FocusNode tidFocus = FocusNode();
  FocusNode receiverNameFocus = FocusNode();
  FocusNode receiverNumberFocus = FocusNode();
  FocusNode withrawButtonFocus = FocusNode();

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

  final List<String> swapCurrency = ["BTC", "USD"];

  final Map<String, List<String>> bills = {
    "Electricity": ["MEPCO", "LESCO", "K-ELECTRIC"],
    "Water": ["LWASA", "BWASA", "CDA"],
    "Gas": ["SSGC", "SNGPL"],
    "Internet": ["OPTIX", "SB-LINK", "NAYATEL"],
    "1Bill Payments": ["1Bill INVOICES", "1BILL TOP UP"],
  };

  String? selectedMethod;
  String? selectedCurrency;
  String? selectedReceiverMethod;
  String? selectedBill;
  String? selectedSP;

  //user details
  String? userName, email;
  int? userID;
  bool isLoading = false;
  @override
  void initState() {
    currentUser();
    super.initState();
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
                  Text(
                    "PKR 76,000,000",
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w600),
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
                        "UID:Px$userID",
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
                    addMoney();
                  },
                  child: actionCard(Icons.add, "Add Money", Colors.green),
                ),
                InkWell(
                  onTap: () {
                    swapMoney();
                  },
                  child: actionCard(Icons.swap_vert, "Swap", Colors.blue),
                ),
                InkWell(
                  onTap: () {
                    withrawMoney();
                  },
                  child: actionCard(Icons.remove_sharp, "Withraw", Colors.red),
                ),
                InkWell(
                  onTap: () {
                    billPayments();
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
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: smallInfoCard(
                    "Withdrawals",
                    "PKR 0",
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

  void billPayments() {
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
                    controller: billConsumerNo,
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
                      Utils().flutterToast("Bill Paid Successfully!", context);
                      billConsumerNo.clear();
                      selectedBill = null;
                      selectedSP = null;
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

  void withrawMoney() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Withraw Money",
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
                  onChanged: (value) {},
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
                    if ((p0 == "Paynix") && (p0.length < 6 || p0.length > 6)) {
                      return "Paynix UID must be 6 characters!";
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
                form.button(
                  focusnode: withrawButtonFocus,
                  text: Text("Send", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    if (!_key3.currentState!.validate()) {
                      return;
                    }
                    Navigator.pop(context);
                    Utils().flutterToast("Transaction Successful!", context);
                    receiverName.clear();
                    receiverNumber.clear();
                    selectedReceiverMethod = null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void swapMoney() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Swap Money",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          content: Form(
            key: _key2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                form.signInTf(
                  controller: swapAmountController,
                  icon: Icon(Icons.money),
                  hint: "Enter amount to swap",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please enter amount to swap!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                  value: selectedCurrency,
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
                  onChanged: (value) {},
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Exchange Rate:"), Text("280")],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Exchange fee:"), Text("200")],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Swaped amount:"), Text("1200")],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Remaining Balance:"), Text("1000")],
                ),
                SizedBox(height: 10),
                form.button(
                  text: Text("Confirm", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    if (!_key2.currentState!.validate()) {
                      return;
                    }
                    Navigator.pop(context);
                    Utils().flutterToast(
                      "Amount Swaped Successfully!",
                      context,
                    );
                    swapAmountController.clear();
                    selectedCurrency = null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addMoney() {
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
                form.signInTf(
                  controller: moneyController,
                  icon: Icon(Icons.money),
                  hint: "Enter amount you sent",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Sent amount is required!";
                    }
                    return null;
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
                  onChanged: (value) {},
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
                  hint: "Enter TID",
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "TID is required!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                form.button(
                  focusnode: buttonFocus,
                  text: Text("Confirm", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    if (!_key.currentState!.validate()) {
                      return;
                    }
                    Navigator.pop(context);
                    Utils().flutterToast(
                      "After Confirmation your balance will be updated!",
                      context,
                    );
                    moneyController.clear();
                    tidController.clear();
                    selectedMethod = null;
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
              await Future.delayed(Duration(seconds: 3));
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
    String value,
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
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          backgroundColor: color.withOpacity(0.2),
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
            switch (decide) {
              case -1:
                {
                  Utils().flutterToast(
                    "Error in fetching user details!",
                    context,
                  );
                  debugPrint("file opening error!");
                }
                break;
              case 5:
                {
                  debugPrint(
                    "unexpected error in fetching details from users file!",
                  );
                  Utils().flutterToast(
                    "Error in fetching user details!",
                    context,
                  );
                }
                break;
              default:
                {
                  debugPrint("unexpected error!");
                }
                break;
            }
            final output = details.stdout.toString().trim();
            final line = output.split('\n');
            if (output.isNotEmpty) {
              setState(() {
                userName = line[0];
                email = line[1];
              });
            }
          }
          break;
      }
    } catch (e) {
      debugPrint("error in current user!");
    }
  }
}
