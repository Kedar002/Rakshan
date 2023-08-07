// ignore_for_file: unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/utills/progressIndicator.dart';
import 'package:editable/commons/math_functions.dart';
import 'package:intl/intl.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/utills/utills.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/post_login/discout_offered.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic amount;
  final dynamic id;
  final String sName;
  final String subType;
  static String claimProcessoPD = 'claim_process_opd';
  // final String coupontype;

  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.id,
    required this.sName,
    required this.subType,
    // required this.coupontype
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  dynamic nAmountDeductedFromWallet = 0.0;
  dynamic netAmount;
  dynamic balance = 0.0;
  dynamic balance1 = 0.0;
  dynamic discount = 0.0;
  dynamic finalAmount = 0.0;
  dynamic couponId;
  dynamic discountType = 0.0;
  dynamic percentdiscounted = 0.0;
  dynamic paymntId = 0;
  String orderId = '';
  dynamic refrenceId = 0;
  bool checkValue = false;
  late ProcessIndicatorDialog _progressIndicator;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const platform = const MethodChannel("razorpay_flutter");
  TextEditingController coupon = TextEditingController();
  // final module = sName;
// int id = 2;
  dynamic mobileNo;
  dynamic mailId;
  late Razorpay _razorpay;

  @override
  void initState() {
    _progressIndicator = ProcessIndicatorDialog(context);
    netAmount = widget.amount;
    finalAmount = netAmount;
    getWalletHistory();
    super.initState();
    init();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNo = prefs.getString('mobileNo');
    mailId = prefs.getString('userMail');
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            'radiobutton', (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        //
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, radioButton);
            }, // Handle your on tap here.
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xfffcfcfc),
          title: const Text(
            'Payment',
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Color(0xff2e66aa),
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
        ),
        body: ListView(
          children: [
            Column(children: [
              const SizedBox(
                height: 20,
              ),
              //1st part
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Color(0xfff1f7ff),
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Text(
                        'Pay for',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.sName,
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Color(0xfff1f7ff),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        //padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Amount',
                              textAlign: TextAlign.start,
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                              maxLines: 2,
                            ),
                            Container(
                              height: 45,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.amount}',
                                  style: const TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        // padding: EdgeInsets.symmetric(vertical: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Coupon',
                              textAlign: TextAlign.start,
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                              maxLines: 2,
                            ),
                            Container(
                              height: 45,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: coupon,
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      ktextfieldDecoration('Coupon Code'),
                                  validator: ((value) {
                                    print(coupon);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: TextButton(
                            onPressed: () {
                              print(widget.sName);
                              print(widget.id);
                              print(widget.amount);

                              validate(widget.sName);
                            },
                            child: const Text(
                              "Apply Code",
                              textAlign: TextAlign.right,
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 30),
                        // padding: EdgeInsets.symmetric(vertical: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              ' Net \n Amount',
                              textAlign: TextAlign.start,
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                              maxLines: 2,
                            ),
                            Container(
                              height: 45,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  '$netAmount',
                                  style: const TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17.0, 0, 2, 0),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet),
                    const SizedBox(
                      width: 5,
                    ),
                    checkValue == false
                        ? Text(
                            "Wallet-  ${NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2).format(balance)}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14))
                        : Text(
                            "Wallet-  ${NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2).format(balance1)}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17.0, 5, 2, 0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.add_card),
                    const SizedBox(
                      width: 5,
                    ), //SizedBox
                    const Text(
                      'Pay from wallet -',
                      style: TextStyle(fontSize: 14.0),
                    ), //Text
                    const SizedBox(width: 10), //SizedBox
                    Checkbox(
                      value: checkValue,
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            checkValue = value!;
                          });
                          if (checkValue) {
                            //>>>>>>>>>>>>>>>>>>>>>>>>>rewrite the calculation code properly
                            if (balance >= netAmount) {
                              balance1 = balance - netAmount;

                              finalAmount = 0.0;
                            } else {
                              finalAmount = (netAmount - balance).abs();
                            }
                          } else {
                            finalAmount = netAmount;
                          }
                          // finalAmount = NumberFormat.simpleCurrency(
                          //         locale: 'hi-IN', decimalDigits: 2)
                          //     .format(finalAmount);
                        });
                      },
                    ), //Checkbox
                  ], //<Widget>[]
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17.0, 5, 2, 0),
                child: Row(
                  children: [
                    // const Icon(
                    //   Icons.currency_rupee,
                    //   color: Colors.blue,
                    // ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Payable Net amount -  ${NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2).format(finalAmount)}",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    )
                  ],
                ),
              ),
              BlueButton(
                  onPressed: () {
                    if (balance1 != 0.0 && checkValue == true) {
                      nAmountDeductedFromWallet = balance - balance1;
                    }
                    if (netAmount == 0.0 || finalAmount == 0.0) {
                      // this or final amount is added later on 12 march 2023 by shubham.
                      updatePayment2('Success');
                    } else {
                      updatePayment1();
                    }
                  },
                  title: 'Pay',
                  height: 50,
                  width: 360),
            ])
          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    print("pay with razor$finalAmount");
    print("pay with razor$mailId");
    var options = {
      'key': 'rzp_live_l5vWMzAZVu22Zd', //razor pay key
      'amount': finalAmount * 100,
      'reference_id': refrenceId,
      'order_id': orderId,
      // 'order_id': orderId,// this might have been the issue for razor pay. its changed but not tested, was repeated twice.
      'name': 'Payment on Rakshan App',
      'description': 'Subscription-$refrenceId',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '$mobileNo', 'email': '$mailId'},
      'external': {
        'wallets': ['paytm']
      }
    };
    debugPrint("options$options");
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('Success Response: $response');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sub = prefs.getString('subscribe');
    if (widget.sName == 'Subscription' && sub == 'Unsubscribe') {
      await prefs.setBool('isPay', true);
      prefs.setString("subscribe", "Subscribe");
      prefs.setString('subscriptionName', widget.subType.toString());
    }
    showTopSnackBar(
      dismissType: DismissType.onTap,
      displayDuration: const Duration(seconds: 3),
      context,
      const CustomSnackBar.info(
        message: "Payment Successful",
      ),
    );
    updatePayment2("Success");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error Response: $response');
    showTopSnackBar(
      dismissType: DismissType.onTap,
      displayDuration: const Duration(seconds: 3),
      context,
      const CustomSnackBar.info(
        message: "Payment Failed",
      ),
    );
    updatePayment2("Failure");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External SDK Response: $response');
  }

  void idGenerator() {
    final now = DateTime.now();
    refrenceId = now.microsecondsSinceEpoch.toString().substring(4, 12);
    print("refrenceId${refrenceId}");
  }

  Future updatePayment1() async {
    try {
      idGenerator();
      final DateFormat formatter = DateFormat('dd/MM/yyy');
      final String formatted = formatter.format(DateTime.now());
      const url = '$BASE_URL/api/Payment/SaveUpdatePayment';
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var userToken = sharedPreferences.getString('data');
      final userID = sharedPreferences.get("userId");
      final myObj = {
        "PaymentId": 0,
        "ReferenceId": int.tryParse(refrenceId),
        "UserId": int.tryParse(userID.toString()),
        "subscriptionId": 2,
        "TransctionAmount":
            checkValue ? finalAmount.toString() : netAmount.toString(),
        "TransctionDate": formatted,
        "CouponId": couponId ?? 0,
        "CouponAmount": discount.toString(),
        "TransctionNumber": widget.id.toString(),
        "TransctionStatus": "Pending",
        "WalletAmount":
            checkValue ? nAmountDeductedFromWallet.toStringAsFixed(2) : "0",
        "Type": widget.sName.toString(),
        "PaymentMethod": "online"
      };
      print("update1$myObj");
      _progressIndicator.show();
      final body = jsonEncode(myObj);
      var res = await http.post(
        Uri.parse(url),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      _progressIndicator.hide();
      final data = jsonDecode(res.body);
      print(data);
      if (res.statusCode == 200) {
        if (data["isSuccess"] == true) {
          orderId = data['extraInfo'];
          print('Order ID -> $orderId');
          paymntId = data['id'];
          orderId = data['extraInfo'];

          print("extra Info === ${data['extraInfo']}");
          print("refrence id === ${refrenceId}");
          print("order id === ${orderId}");

          // if(netAmount == 0.0){

          // }
          if (checkValue) {
            if (balance >= netAmount) {
              updatePayment2("Success");
            } else {
              openCheckout();
            }
          } else if (netAmount == 0.0) {
            updatePayment2('Success');
          } else {
            openCheckout();
          }
        } else {
          // ignore: use_build_context_synchronously
          showTopSnackBar(
            dismissType: DismissType.onTap,
            displayDuration: const Duration(seconds: 3),
            context,
            CustomSnackBar.info(
              message: data['message'],
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 3),
          context,
          const CustomSnackBar.info(
            message: "Something went wrong",
          ),
        );
      }
    } catch (e) {
      print("error $e");
      _progressIndicator.hide();
    }
  }

  Future updatePayment2(String status) async {
    if (netAmount == 0.0 || finalAmount == 0.0) {
      // this or final amount is added later on 12 march 2023 by shubham.
      idGenerator();
    }
    print("pay metier");
    final DateFormat formatter = DateFormat('dd/MM/yyy');
    final String formatted = formatter.format(DateTime.now());
    const url = '$BASE_URL/api/Payment/SaveUpdatePayment';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userID = sharedPreferences.get("userId");
    final myObj = {
      "PaymentId": paymntId,
      "ReferenceId": int.tryParse(refrenceId),
      "UserId": int.tryParse(userID.toString()),
      "subscriptionId": 2,
      "TransctionAmount": checkValue
          ? nAmountDeductedFromWallet.toStringAsFixed(2)
          : netAmount
              .toString(), //if save payment has any issues regarding payment amount, change ndeductedamount back to finalamount in if ternery.
      "TransctionDate": formatted,
      "CouponId": couponId ?? 0,
      "CouponAmount": discountType == 'Percentage'
          ? percentdiscounted.toString()
          : discount.toString(),
      "TransctionNumber": widget.id.toString(),
      "TransctionStatus": status,
      "WalletAmount": checkValue ? nAmountDeductedFromWallet.toString() : "0.0",
      "Type": widget.sName.toString(),
      //"Type": "Subscription Plan",
      "PaymentMethod": "Wallet"
    };
    print("update2$myObj");
    final body = jsonEncode(myObj);
    var res = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userToken',
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );
    debugPrint(res.body);
    final data = jsonDecode(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      // if (data["isSuccess"] == true && data['id'] != null) {
      if (data["isSuccess"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var sub = prefs.getString('subscribe');
        if (widget.sName == 'Subscription' &&
            sub == 'Unsubscribe' &&
            status == 'Success') {
          await prefs.setBool('isPay', true);
          prefs.setString("subscribe", "Subscribe");
          prefs.setString('subscriptionName', widget.subType.toString());
        }
        // ignore: use_build_context_synchronously
        showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 3),
          context,
          CustomSnackBar.success(
            message: data['message'],
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            context, radioButton, (route) => false);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            context, radioButton, (route) => false);
      }
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 3),
        context,
        const CustomSnackBar.info(
          message: "Something went wrong",
        ),
      );
    }
  }

  Future validate(String module) async {
    print(module);
    if (coupon.text.isEmpty) {
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 3),
        context,
        const CustomSnackBar.success(
          message: "Please Enter Coupon Code",
        ),
      );
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/Common/ValidateCoupon?UserId=$userId&CouponCode=${coupon.text}&Module=$module'),
        headers: header);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      print("Coupan Data ${data['data']}");
      if (data['isSuccess']) {
        discount = data['data']['discount'];
        couponId = data['data']['couponId'];
        discountType = data['data']['discountType'];

        // ignore: duplicate_ignore
        if (discountType == 'Percentage') {
          showTopSnackBar(
            dismissType: DismissType.onTap,
            displayDuration: const Duration(seconds: 3),
            context,
            CustomSnackBar.success(
              message: 'Coupon applied for $discount % discount',
            ),
          );
        } else {
          showTopSnackBar(
            dismissType: DismissType.onTap,
            displayDuration: const Duration(seconds: 3),
            context,
            CustomSnackBar.success(
              message: 'Coupon applied for ₹ $discount',
            ),
          );
        }

        setState(() {
          if (discountType == 'Percentage') {
            percentdiscounted = widget.amount * discount / 100;
            netAmount = widget.amount - percentdiscounted;
          } else if (discount >= widget.amount) {
            netAmount = 0.0;
          } else {
            netAmount = widget.amount - discount;
          }

          finalAmount = netAmount;
        });
      } else {
        setState(() {
          netAmount = widget.amount;
        });
        showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 3),
          context,
          CustomSnackBar.success(
            message: data['message'],
          ),
        );
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  void getWalletHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse('$BASE_URL/api/Common/GetWalletDetails?UserId=$userId'),
        headers: header);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      print("dataaaa wallet${data['data']}");
      if (data['data'] != null) {
        setState(() {
          balance = data['data']['walletAmount'];
        });
      }
    } else {
      throw Exception('Failed to load');
    }
  }
}

// finalamount = 499
// finalamount = finalamount - coupon
// String('Net Amount') finalamount;

// pay from wallet
// finalamount = finalamount - wallet

// razorpay finalamount
