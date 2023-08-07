import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/bloodpressure.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/bp_analysis.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/bp_table.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/diabetes_analysis.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/diabetes_table.dart';
import 'package:Rakshan/screens/post_login/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/first_page_of_health_tracker.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/ht_controller.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import 'add_reminder_title.dart';
import 'diabetes.dart';
// import 'Bloodpressure.dart';

class htReminders extends StatefulWidget {
  static String id = 'htReminders';

  @override
  State<htReminders> createState() => _htRemindersState();
}

class _htRemindersState extends State<htReminders> {
  List<dynamic> items = [];

  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setData();
    getHealthTrackerReminders();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'radiobutton', (Route<dynamic> route) => false);
              return true;
            },
            child: Scaffold(
              backgroundColor: const Color(0xff82B445),
              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'radiobutton', (Route<dynamic> route) => false);
                  }, // Handle your on tap here.
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: const Color(0xfffcfcfc),
                title: const Text(
                  'Rakshan',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Color(0xff2e66aa),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          getHealthTrackerReminders();
                        });
                      },
                      icon: const Icon(Icons.replay_outlined),
                    ),
                  ),
                ],
                iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
              ),
              body: Column(
                children: [
                  Container(
                    padding: kScreenPadding,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Health Tracker Reminders',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'OpeanSans'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border.symmetric(),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.0)),
                          color: Color(0xffFBFBFB)),
                      padding: kScreenPadding,
                      child: FutureBuilder<List<HealthTrackerReminder?>?>(
                        future: getHealthTrackerReminders(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<HealthTrackerReminder?>?>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<HealthTrackerReminder?> wData = snapshot.data!;
                            print('aaaaaaa${wData.length}');
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return ListView.builder(
                                itemCount: wData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  HealthTrackerReminder? info = wData[index];
                                  final currentScheduleId = info?.scheduleId;
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextButton(
                                                    onPressed: (() {
                                                      print(info!.illnessId);
                                                      if (info.illnessName ==
                                                          "DIABETIES") {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => diabetes(
                                                                    illnessTypeId:
                                                                        info
                                                                            .illnessId,
                                                                    measureId: info
                                                                        .scheduleId)));
                                                      } else {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    //This navigates to BloodPressure page
                                                                    BloodPressure(
                                                                      illnessTypeId:
                                                                          info.illnessId,
                                                                      measureId:
                                                                          info.scheduleId,
                                                                    )));
                                                      }
                                                    }),
                                                    child: Text(
                                                      // '${items[index]['title']}',
                                                      '${info?.title}',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'OpeanSans',
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Text(
                                                    info?.illnessName ==
                                                            "DIABETIES"
                                                        ? 'Diabeties'
                                                        : 'BloodPressure',
                                                    style: const TextStyle(
                                                      color: Color(0xFF757575),
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        if (info?.illnessName ==
                                                            "DIABETIES") {
                                                          //TABLE
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder:
                                                          //             (context) =>
                                                          //                 diabetesTable(
                                                          //                   illnessTypeId:
                                                          //                       info!.illnessId,
                                                          //                   measureId:
                                                          //                       info.scheduleId,
                                                          //                 )));
                                                          //GRAPH & TABLE
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          diabetesAnalysis(
                                                                            illnessTypeId:
                                                                                info!.illnessId,
                                                                            measureId:
                                                                                info.scheduleId,
                                                                          )));
                                                        } else {
                                                          // TABLE
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder:
                                                          //             (context) =>
                                                          //                 bpTable(
                                                          //                   illnessTypeId:
                                                          //                       info!.illnessId,
                                                          //                   measureId:
                                                          //                       info.scheduleId,
                                                          //                 )));
                                                          //GRAPH
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          BpAnalysis(
                                                                            illnessTypeId:
                                                                                info!.illnessId,
                                                                            measureId:
                                                                                info.scheduleId,
                                                                          )));
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.bar_chart)),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  '${info?.title}'),
                                                              content: const Text(
                                                                  "Are you sure do you want to delete this reminder ?"),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          "No"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                TextButton(
                                                                    child: const Text(
                                                                        "Yes"),
                                                                    onPressed:
                                                                        () {
                                                                      deleteUserDocument(
                                                                          currentScheduleId!);

                                                                      HealthTrackerReminder();

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();

                                                                      setState(
                                                                          () {});
                                                                    }),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        // Navigator.pushNamed(context,
                                                        //     diabetesAnalysisScreen);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete))
                                                ],
                                              ),
                                            ],
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
                                      "No Reminders ",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: BlueButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => htRemindersTitle()));
                  // Navigator.pushNamed(context, htWeeklyDailyMonthlyReminderScreen);
                },
                title: 'Add New Reminder',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
  }

  Future<List<HealthTrackerReminder?>?> getHealthTrackerReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/HealthTracker/GetHealthTrackerSchedule?UserId=$userId'),
        // '$BASE_URL/api/HealthTracker/GetHealthTrackerSchedule?UserId=301'),
        headers: header);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      print('htmain List${res.body}');
      // print("hashirama${data['data']}");
      // print("Tobyrama${data['title']}");
      List<HealthTrackerReminder> dataList = (data['data'] as List)
          .map<HealthTrackerReminder>((e) => HealthTrackerReminder.fromJson(e))
          .toList();
      // print("dataList$dataList");
      return dataList;
      //return GetHomeModelclass.fromJson(data);
    } else {
      throw Exception('Failed to load post');
    }
  }

  deleteUserDocument(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    // print('sanjii${userId}');
    var response = await http.delete(
        Uri.parse(
            '$BASE_URL/api/HealthTracker/DeleteHealthTrackerSchedule?HealthTrackerId=$id&UserId=$userId'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
        });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print('lufyy${data}');
      final bool isSuccess = data["isSuccess"];
      return isSuccess;
    } else {
      print('Error in getUserDocumentList');
      return false;
    }
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';

// import 'package:Rakshan/constants/api.dart';
// import 'package:Rakshan/constants/theme.dart';
// import 'package:Rakshan/screens/post_login/welcome_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:Rakshan/constants/padding.dart';
// import 'package:Rakshan/constants/textfield.dart';
// import 'package:Rakshan/routes/app_routes.dart';
// import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/first_page_of_health_tracker.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../models/ht_controller.dart';
// import '../../../../widgets/post_login/app_bar.dart';
// import '../../../../widgets/pre_login/blue_button.dart';
// import 'add_reminder_title.dart';
// import 'diabetes.dart';
// import 'Bloodpressure.dart';

// class htReminders extends StatefulWidget {
//   static String id = 'htReminders';

//   @override
//   State<htReminders> createState() => _htRemindersState();
// }

// class _htRemindersState extends State<htReminders> {
//   List<dynamic> items = [];

//   bool isLoad = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // setData();
//     getHealthTrackerReminders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoad
//         ? const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           )
//         : Scaffold(
//             backgroundColor: const Color(0xff82B445),
//             appBar: AppBar(
//               elevation: 0,
//               leading: IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pushNamedAndRemoveUntil(
//                       'radiobutton', (Route<dynamic> route) => false);
//                 }, // Handle your on tap here.
//                 icon: const Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.black,
//                 ),
//               ),
//               backgroundColor: const Color(0xfffcfcfc),
//               title: const Text(
//                 'Rakshan',
//                 style: TextStyle(
//                   fontFamily: 'OpenSans',
//                   color: Color(0xff2e66aa),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
//             ),
//             body: Column(
//               children: [
//                 Container(
//                   padding: kScreenPadding,
//                   child: Column(
//                     children: const [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Center(
//                         child: Text(
//                           'Health Tracker Reminders',
//                           style:
//                               TextStyle(fontSize: 20, fontFamily: 'OpeanSans'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//                 Expanded(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                         border: Border.symmetric(),
//                         borderRadius:
//                             BorderRadius.vertical(top: Radius.circular(30.0)),
//                         color: Color(0xffFBFBFB)),
//                     padding: kScreenPadding,
//                     child: FutureBuilder<List<HealthTrackerReminder?>?>(
//                       future: getHealthTrackerReminders(),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<List<HealthTrackerReminder?>?>
//                               snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           List<HealthTrackerReminder?> wData = snapshot.data!;
//                           print('aaaaaaa${wData.length}');
//                           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                             return ListView.builder(
//                               itemCount: wData.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 HealthTrackerReminder? info = wData[index];
//                                 final currentScheduleId = info?.scheduleId;
//                                 return Card(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 10),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 bottom: 10),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 TextButton(
//                                                   onPressed: (() {
//                                                     if (info?.illnessName ==
//                                                         "DIABETIES") {
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   diabetes(wData[
//                                                                       index])));
//                                                     } else {
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   Diabetes(
//                                                                       //This navigates to BloodPressure page
//                                                                       items[
//                                                                           index])));
//                                                     }
//                                                   }),
//                                                   child: Text(
//                                                     // '${items[index]['title']}',
//                                                     '${info?.title}',
//                                                     style: const TextStyle(
//                                                         fontFamily: 'OpeanSans',
//                                                         fontSize: 16),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   info?.illnessName ==
//                                                           "DIABETIES"
//                                                       ? 'Diabeties'
//                                                       : 'BloodPressure',
//                                                   style: const TextStyle(
//                                                     color: Color(0xFF757575),
//                                                     fontFamily: 'OpenSans',
//                                                     fontSize: 12,
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 IconButton(
//                                                     onPressed: () {
//                                                       if (wData[index] ==
//                                                           "DIABETIES") {
//                                                         Navigator.pushNamed(
//                                                             context,
//                                                             diabetesAnalysisScreen);
//                                                       } else {
//                                                         Navigator.pushNamed(
//                                                             context,
//                                                             BpAnalysisScreen);
//                                                       }
//                                                     },
//                                                     icon: const Icon(
//                                                         Icons.bar_chart)),
//                                                 IconButton(
//                                                     onPressed: () {
//                                                       showDialog(
//                                                         context: context,
//                                                         builder: (BuildContext
//                                                             context) {
//                                                           return AlertDialog(
//                                                             title: Text(
//                                                                 '${info?.title}'),
//                                                             content: const Text(
//                                                                 "Are you sure do you want to delete this reminder ?"),
//                                                             actions: <Widget>[
//                                                               TextButton(
//                                                                 child:
//                                                                     const Text(
//                                                                         "No"),
//                                                                 onPressed: () {
//                                                                   Navigator.of(
//                                                                           context)
//                                                                       .pop();
//                                                                 },
//                                                               ),
//                                                               TextButton(
//                                                                   child:
//                                                                       const Text(
//                                                                           "Yes"),
//                                                                   onPressed:
//                                                                       () {
//                                                                     deleteUserDocument(
//                                                                         currentScheduleId!);

//                                                                     HealthTrackerReminder();

//                                                                     Navigator.of(
//                                                                             context)
//                                                                         .pop();

//                                                                     setState(
//                                                                         () {});
//                                                                   }),
//                                                             ],
//                                                           );
//                                                         },
//                                                       );
//                                                       // Navigator.pushNamed(context,
//                                                       //     diabetesAnalysisScreen);
//                                                     },
//                                                     icon: const Icon(
//                                                         Icons.delete))
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           } else {
//                             return Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   Text(
//                                     "No Reminders ",
//                                     style: TextStyle(
//                                         fontSize: 14.0, color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                         } else {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             floatingActionButton: BlueButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => htRemindersTitle()));
//                 // Navigator.pushNamed(context, htWeeklyDailyMonthlyReminderScreen);
//               },
//               title: 'Add New Reminder',
//               height: MediaQuery.of(context).size.height * 0.05,
//               width: MediaQuery.of(context).size.width * 0.5,
//             ),
//             floatingActionButtonLocation:
//                 FloatingActionButtonLocation.centerFloat,
//           );
//   }

//   // setData() async {
//   //   setState(() {
//   //     isLoad = true;
//   //   });
//   //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   //   var userToken = sharedPreferences.getString('data');
//   //   final userId = sharedPreferences.getString("userId");
//   //   print('zorooo$userId');
//   //   var response = await http.get(
//   //       Uri.parse(
//   //           '$BASE_URL/api/HealthTracker/GetHealthTrackerSchedule?UserId=$userId'),
//   //       headers: {
//   //         HttpHeaders.contentTypeHeader: "application/json",
//   //         HttpHeaders.authorizationHeader: 'Bearer $userToken',
//   //       });

//   //   // log(response.body);
//   //   if (response.statusCode == 200) {
//   //     var data = jsonDecode(response.body);

//   //     if (data['isSuccess'] = true) {
//   //       for (int i = 0; i < data['data'].length; i++) {
//   //         items.add(data['data'][i]);
//   //       }
//   //     }

//   //     setState(() {
//   //       isLoad = false;
//   //     });

//   //     log("data" + data.toString());
//   //   } else {
//   //     setState(() {
//   //       isLoad = false;
//   //     }); // toast('Something went wrong');
//   //   }
//   // }

//   Future<List<HealthTrackerReminder?>?> getHealthTrackerReminders() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userToken = prefs.getString('data');
//     var userId = prefs.getString('userId');
//     final header = {'Authorization': 'Bearer $userToken'};

//     var res = await http.get(
//         Uri.parse(
//             '$BASE_URL/api/HealthTracker/GetHealthTrackerSchedule?UserId=$userId'),
//         headers: header);
//     print('naruto${res.body}');
//     if (res.statusCode == 200) {
//       var data = jsonDecode(res.body.toString());
//       print("hashirama${data['data']}");
//       print("Tobyrama${data['title']}");
//       List<HealthTrackerReminder> dataList = (data['data'] as List)
//           .map<HealthTrackerReminder>((e) => HealthTrackerReminder.fromJson(e))
//           .toList();
//       print("dataList$dataList");
//       return dataList;
//       //return GetHomeModelclass.fromJson(data);
//     } else {
//       throw Exception('Failed to load post');
//     }
//   }

//   deleteUserDocument(int id) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var userToken = sharedPreferences.getString('data');
//     final userId = sharedPreferences.getString("userId");
//     print('sanjii${userId}');
//     var response = await http.delete(
//         Uri.parse(
//             '$BASE_URL/api/HealthTracker/DeleteHealthTrackerSchedule?HealthTrackerId=$id&UserId=$userId'),
//         headers: {
//           HttpHeaders.contentTypeHeader: "application/json",
//           HttpHeaders.authorizationHeader: 'Bearer $userToken',
//         });

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       print('lufyy${data}');
//       final bool isSuccess = data["isSuccess"];
//       return isSuccess;
//     } else {
//       print('Error in getUserDocumentList');
//       return false;
//     }
//   }
// }
