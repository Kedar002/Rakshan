import 'dart:convert';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/screens/post_login/home_screen.dart';
import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/wHistoryModal.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/textfield.dart';

class WalletHistory extends StatefulWidget {
  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<walletHistory?>?> getWalletHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse('$BASE_URL/api/Common/GetWalletDetails?UserId=$userId'),
        headers: header);
    print('naruto${res.body}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      print("hashirama${data['data']}");
      print("Tobyrama${data['data']['transctionDetails']}");
      List<walletHistory> dataList = (data['data']['transctionDetails'] as List)
          .map<walletHistory>((e) => walletHistory.fromJson(e))
          .toList();
      print("dataList$dataList");
      return dataList;
      //return GetHomeModelclass.fromJson(data);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'Wallet History'),
      body: Column(
        children: [
          // Container(
          //   padding: kScreenPadding,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       const Text(
          //         'History',
          //         style: TextStyle(
          //           fontFamily: 'OpenSans',
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       IconButton(
          //           onPressed: () {
          //             setState(() {});
          //           },
          //           icon: Icon(Icons.replay_outlined)),
          //     ],
          //   ),
          // ),
          Expanded(
            child: FutureBuilder<List<walletHistory?>?>(
              future: getWalletHistory(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<walletHistory?>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<walletHistory?> wData = snapshot.data!;
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: wData.length,
                      itemBuilder: (BuildContext context, int i) {
                        walletHistory? info = wData[i];
                        return Card(
                          color: Colors.white,
                          shadowColor: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            title: Text(
                              '${info!.walleType.toString()}',
                              style: kLabelTextStyle,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 7),
                                Text('${info.paymentDetails}'),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xfff5f5f5)),
                                    child: Text(
                                      '${info.walletTransctionDate.toString()}',
                                    )),
                                Text(
                                  '₹ ${info.walletTransAmount.toString()}',
                                  style: const TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "No Data Found",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
