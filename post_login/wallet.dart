import 'dart:convert';
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/utills/progressIndicator.dart';
import 'package:http/http.dart' as http;
import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/wallet_history.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/textfield.dart';

class Wallet extends StatefulWidget {
  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late ProcessIndicatorDialog _progressIndicator;
  dynamic balance = 0.0;
  @override
  void initState() {
    _progressIndicator = ProcessIndicatorDialog(context);
    // TODO: implement initState
    super.initState();
    getWalletHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'Wallet'),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: kScreenPadding,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
              Container(
                padding: kScreenPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 253, 253, 253),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey.shade100,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Text(
                        '₹ $balance',
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              BlueButton(
                  onPressed: () {
                    Navigator.pushNamed(context, walletHistory);
                  },
                  title: 'Wallet History',
                  height: 45,
                  width: 160),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getWalletHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userToken = prefs.getString('data');
      var userId = prefs.getString('userId');
      final header = {'Authorization': 'Bearer $userToken'};
      _progressIndicator.show();
      var res = await http.get(
          Uri.parse('$BASE_URL/api/Common/GetWalletDetails?UserId=$userId'),
          headers: header);
      _progressIndicator.hide();
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print("dataaaa${data['data']}");
        setState(() {
          balance = data['data']['walletAmount'];
        });
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      _progressIndicator.hide();
    }
  }
}
