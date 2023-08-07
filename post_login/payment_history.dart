import 'dart:convert';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/models/PaymentHistoryModel.dart';
import 'package:Rakshan/models/paymentHistory.dart';

import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  Future<PaymentHistoryModel> getPaymentHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    final response = await http.get(
        Uri.parse(
            '$BASE_URL/api/Payment/GetPaymentTransactionList?UserId=$userId'),
        headers: header);

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      //  List<PaymentHistoryModel> dataList = (data['data'] as List)
      //     .map<PaymentHistoryModel>((e) => PaymentHistoryModel.fromJson(e))
      //     .toList();
      // List<PaymentHistoryModel> reversedDataList = dataList.reversed.toList();
      return PaymentHistoryModel.fromJson(data);
    } else {
      print('failed');
      return PaymentHistoryModel.fromJson(data);
    }
  }

  // Future<List<PaymentHistoryList?>?> getPaymentHistory() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userToken = prefs.getString('data');
  //   var userId = prefs.getString('userId');
  //   final header = {'Authorization': 'Bearer $userToken'};

  //   var res = await http.get(
  //       Uri.parse('$BASE_URL/api/Common/GetWalletDetails?UserId=236'),
  //       headers: header);
  //   print('luffy${res.body}');

  //   if (res.statusCode == 200) {
  //     var data = jsonDecode(res.body.toString());
  //     print("sanji${data['data']}");
  //     List<PaymentHistoryList> dataList =
  //         (data['data']['transctionDetails'] as List)
  //             .map<PaymentHistoryList>((e) => PaymentHistoryList.fromJson(e))
  //             .toList();
  //     print("madara$dataList");
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load posts');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIndividual(title: 'Payment History'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<PaymentHistoryModel>(
                future: getPaymentHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data!.data!.isNotEmpty) {
                      return ListView.builder(
                        // reverse: true,
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, index) {
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
                                'Transaction Id - ${snapshot.data!.data![index].transctionId.toString()}',
                                style: kLabelTextStyle,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                      'Status - ${snapshot.data!.data![index].status.toString()}'),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Module - ${snapshot.data!.data![index].module.toString()}'),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0xfff5f5f5)),
                                      child: Text(
                                        snapshot
                                            .data!.data![index].transctionDate
                                            .toString(),
                                      )),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Amount - ${snapshot.data!.data![index].transctionAmount.toString()}'
                                        .toString(),
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
                              "You haven't made any transactions yet",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}










// import 'dart:convert';

// import 'package:Rakshan/constants/api.dart';
// import 'package:Rakshan/constants/padding.dart';
// import 'package:Rakshan/constants/theme.dart';
// import 'package:Rakshan/models/PaymentHistoryModel.dart';
// import 'package:Rakshan/models/paymentHistory.dart';

// import 'package:Rakshan/widgets/post_login/app_bar.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class PaymentHistory extends StatefulWidget {
//   const PaymentHistory({super.key});

//   @override
//   State<PaymentHistory> createState() => _PaymentHistoryState();
// }

// class _PaymentHistoryState extends State<PaymentHistory> {
//   Future<PaymentHistoryModel> getPaymentHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userToken = prefs.getString('data');
//     var userId = prefs.getString('userId');
//     final header = {'Authorization': 'Bearer $userToken'};

//     final response = await http.get(
//         Uri.parse('$BASE_URL/api/Common/GetWalletDetails?UserId=236'),
//         headers: header);
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       print(data);
//       return PaymentHistoryModel.fromJson(json);
//     } else {
//       print('failed');
//       return PaymentHistoryModel.fromJson(json);
//     }
//   }

//   // Future<List<PaymentHistoryList?>?> getPaymentHistory() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   var userToken = prefs.getString('data');
//   //   var userId = prefs.getString('userId');
//   //   final header = {'Authorization': 'Bearer $userToken'};

//   //   var res = await http.get(
//   //       Uri.parse('$BASE_URL/api/Common/GetWalletDetails?UserId=236'),
//   //       headers: header);
//   //   print('luffy${res.body}');

//   //   if (res.statusCode == 200) {
//   //     var data = jsonDecode(res.body.toString());
//   //     print("sanji${data['data']}");
//   //     List<PaymentHistoryList> dataList =
//   //         (data['data']['transctionDetails'] as List)
//   //             .map<PaymentHistoryList>((e) => PaymentHistoryList.fromJson(e))
//   //             .toList();
//   //     print("madara$dataList");
//   //     return dataList;
//   //   } else {
//   //     throw Exception('Failed to load posts');
//   //   }
//   // }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getPaymentHistory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarIndividual(title: 'Payment History'),
//       body: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<PaymentHistoryModel>(
//                 future: getPaymentHistory(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<PaymentHistoryModel> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     // <PaymentHistoryModel> = snapshot.data!;
//                     if (snapshot.hasData &&
//                         snapshot.data!.data!.transctionDetails!.isNotEmpty) {
//                       return ListView.builder(
//                         itemCount:
//                             snapshot.data!.data!.transctionDetails!.length,
//                         itemBuilder: (context, index) {
//                           // Claimhistorylist? info = aData[i];
//                           return Card(
//                             color: Colors.white,
//                             shadowColor: darkBlue,
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 6, horizontal: 10),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 10.0, horizontal: 20.0),
//                               title: Text(index.toString()),
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Text(
//                               "You haven't made any transactions yet",
//                               style: TextStyle(
//                                   fontSize: 14.0, color: Colors.black),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   } else {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                 }),
//           ),
//         ],
//       ),
//     );
//   }

//   const SizedBox(height: 7) {
//     return const SizedBox(
//       height: 8,
//     );
//   }
// }
