// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/internet_cubit.dart';
import 'package:Rakshan/models/GetVersion.dart';
import 'package:Rakshan/screens/post_login/notification_screen.dart';
import 'package:Rakshan/utills/notification_utils.dart';
import 'package:Rakshan/widgets/dialogue.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/gradient.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/internet_cubit.dart';
import 'package:Rakshan/models/GetVersion.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/notification_screen.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:Rakshan/widgets/pre_login/logo.dart';

// import '../../internet_not_connected.dart';

class RadioButton extends StatefulWidget {
  static String id = 'radiobutton';

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  int selectedValue = -1;
  Connectivity _connectivity = Connectivity();
  NotificationUtils? _notificationUtils;
  String status = "Waiting...";

  double? appVersionOnServer;
  double? appVersionOnServerIOS;
  num? totalSaving;
  num? suretyLetterCount;

  static const APP_STORE_URL =
      'https://apps.apple.com/us/app/rakshan/id1643447299?platform=iphone';
  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.rakshan.metier';

  void initNotificationServices() async {
    _notificationUtils = context.read<NotificationUtils>();
    _notificationUtils!.initNotificationServices(
        initMessage: initReceiveNotificationMessage,
        onMessage: onReceiveNotificationMessage,
        onMessageOpenedApp: onReceiveNotificationMessage);
    _notificationUtils!
        .initLocalNotifications(selectNotification: selectNotification);
    // _notificationUtils!.listenForTokenRefresh(session);
  }

  void onReceiveNotificationMessage(RemoteMessage message) {
    debugPrint('onReceiveNotificationMessage():data=${message.data}');
    debugPrint(
        'onReceiveNotificationMessage():notification=${message.notification}');
    if (mounted && message.data != null) {
      print("mounted status");
      _notificationUtils!
          .handleNotificationMessage(context, message.data, save: true);
    }
  }

  void initReceiveNotificationMessage(RemoteMessage? message) {
    debugPrint(
        'when open on tap notification initReceiveNotificationMessage Message data Part: ${message?.data}');
    debugPrint(
        'initReceiveNotificationMessage Message Notification Part: ${message?.notification}');
    if (message?.notification != null) {
      debugPrint(
          'Message notification: title=${message!.notification!.title}; body=${message.notification!.body}');
    }
    if (message?.data != null) {
      _notificationUtils!.handleNotificationMessage(context, message!.data);
    }
  }

  selectNotification(String? payload) {
    print("selection called$payload");
    // String data = jsonDecode(payload!);
    // debugPrint("Local Notification selectNotification(): data=$data");
    // _notificationUtils?.handleNotificationMessage(
    //   context,
    //   data,
    // );
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationScreen(),
        ));
  }

  getVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    final header = {'Authorization': 'Bearer $userToken'};
    var res = await http.get(
        Uri.parse('$BASE_URL/api/Common/GetApplicationVersionDetails'),
        headers: header);
    var data = jsonDecode(res.body.toString());
    print(data);
    if (res.statusCode == 200) {
      print('API HIT');
      appVersionOnServerIOS = data["data"]["AppVersion"];
      appVersionOnServer = data["data"]["AndroidVersion"];
      print('sever version saved');
      final PackageInfo info = await PackageInfo.fromPlatform();
      print('current build version=${info.version}');
      double currentVersion = double.parse(info.version.split('.').first);
      print('current version after parse=$currentVersion');
      var newVersion = appVersionOnServer!;
      var newVersionIOS = appVersionOnServerIOS!;
      print('New Version for andriod = $newVersion');
      print('New Version for IOS = $newVersionIOS');
      if (Platform.isAndroid) {
        print('IsAndriod');
        if (newVersion > currentVersion) {
          print('New veriosn for andriod is available');
          _showVersionDialog(context);
        }
      }
      if (Platform.isIOS) {
        print('IsIOS');
        if (newVersionIOS > currentVersion) {
          print('New veriosn for IOS is available');
          // ignore: use_build_context_synchronously
          _showVersionDialog(context);
        }
      }
      return GetVersion.fromJson(data);
    } else {
      throw Exception('Failed to Get Version from Server');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New App Update Available";
        String message =
            "There is a newer version of app available please update the app.";
        String btnLabel = "Update Now";
        // String btnLabelCancel = "Later";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(APP_STORE_URL),
                  ),
                  // TextButton(
                  //   child: Text(btnLabelCancel),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(PLAY_STORE_URL),
                  ),
                  // TextButton(
                  //   child: Text(btnLabelCancel),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              );
      },
    );
  }

  // >>>>>>>>>>>>>>> internet Chceck code.

  var internetStatus;

  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    internetStatus = connectionResult;
    if (connectionResult == ConnectivityResult.mobile) {
      status = "MobileData";
    } else if (connectionResult == ConnectivityResult.wifi) {
      status = "Wifi";
    } else {
      _showInternetDialog(context);
      status = "Not Connected";
    }
  }

  _showInternetDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Internet connection unavailable.";
        String message = "Please connect to internet.";
        String btnLabel = "Retry";
        // String btnLabelCancel = "Later";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () {
                      Navigator.pop(context);
                      checkConnectivity();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () {
                      Navigator.pop(context);
                      checkConnectivity();
                    },
                  ),
                ],
              );
      },
    );
  }

  // >>>>>>>>>>>>>>> internet check code ends.

  getTotalSavings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.get("userId");
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse('$BASE_URL/api/Common/GetTotalSavings?UserId=$userId'),
        headers: header);
    print(res.body);
    var data = jsonDecode(res.body.toString());
    if (res.statusCode == 200) {
      setState(() {
        totalSaving = data['data']['totalSaving'];
        suretyLetterCount = data['data']['suretyLetterCount'];
      });
      print("daaataaaa${data['data']}");
      print(totalSaving);
      print(suretyLetterCount);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    checkConnectivity();
    getVersion();
    getTotalSavings();
    initNotificationServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const Menu(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfffcfcfc),
        title: const Text(
          '',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Color(0xff2e66aa),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ));
                },
                icon: Icon(
                  Icons.notifications_on_rounded,
                  color: darkBlue,
                  size: 28,
                )),
          )
        ],
        iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: kgradientgreenscreen,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Logo()],
          ),
          Positioned(
              left: 10,
              right: 10,
              bottom: 0,
              top: 140,
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 0.5,
                    child: totalSaving == null
                        ? SizedBox.shrink()
                        : Text(
                            'You saved till now : $totalSaving',
                            style: const TextStyle(
                                fontFamily: 'OpenSans',
                                color: Color(0xff82B445),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 0.5,
                    child: suretyLetterCount == null
                        ? SizedBox.shrink()
                        : Text(
                            'Surety Letters Used : $suretyLetterCount',
                            style: const TextStyle(
                                fontFamily: 'OpenSans',
                                color: Color(0xff215DA5),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: MyItems(
                        Icons.local_hospital,
                        'Search Hospital',
                        0xff325CA2,
                        (() => Navigator.pushNamed(context, homescreen))),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: MyItems(
                        Icons.content_paste_go,
                        'Book Appointment',
                        0xff325CA2,
                        (() => Navigator.pushNamed(context, appointment))),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: MyItems1(
                        Icons.fact_check_outlined,
                        'Payment / Claim \nBenefits',
                        0xff325CA2,
                        (() => Navigator.pushNamed(context, claimProcessIPD))),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: MyItems(
                        Icons.access_time_filled,
                        ' Medicine Reminder',
                        0xff325CA2,
                        (() =>
                            Navigator.pushNamed(context, prescriptionScreen))),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: MyItems(
                        Icons.monitor_heart,
                        'Health Tracker',
                        0xff325CA2,
                        (() => Navigator.pushNamed(context, htReminderScreen))),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: MyItems(Icons.shopping_cart_outlined, 'Shop',
                        0xff325CA2, (() => showAlertDialog(context))),
                  ),
                ],
              )),
          Center(
            child: BlocConsumer<InternetCubit, InternetState>(
              builder: (context, state) {
                if (state == InternetState.Gained) {
                  return const Text("");
                } else if (state == InternetState.Lost) {
                  return const Text("");
                } else {
                  return const Text("");
                }
              },
              listener: (context, state) {
                if (state == InternetState.Gained) {
                  print("from consumer");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Connected to Internet"),
                    backgroundColor: Colors.green,
                  ));
                } else if (state == InternetState.Lost) {
                  print("from consumer lost");

                  showDialog<String>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      String title = "No Internet Connection!";
                      String message = "Please connect to internet";
                      String btnLabel = "Retry";

                      return Platform.isIOS
                          ? CupertinoAlertDialog(
                              title: Text(title),
                              content: Text(message),
                              actions: <Widget>[
                                TextButton(
                                    child: Text(btnLabel),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      checkConnectivity();
                                    }),
                              ],
                            )
                          : AlertDialog(
                              title: Text(title),
                              content: Text(message),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(btnLabel),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    checkConnectivity();
                                  },
                                ),
                              ],
                            );
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("No Internet Connection!"),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Loading"),
                    backgroundColor: Colors.yellow,
                  ));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

Material MyItems(
    IconData icon, String Heading, int color, VoidCallback? navigate) {
  return Material(
    color: Colors.white,
    elevation: 14,
    shadowColor: const Color(0x802196F3),
    borderRadius: BorderRadius.circular(24),
    child: Center(
      child: GestureDetector(
        onTap: navigate,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Heading,
                      style: TextStyle(color: new Color(color), fontSize: 15),
                    ),
                  ),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Material MyItems1(
    IconData icon, String Heading, int color, VoidCallback? navigate) {
  return Material(
    color: Colors.white,
    elevation: 14,
    shadowColor: const Color(0x802196F3),
    borderRadius: BorderRadius.circular(24),
    child: Center(
      child: GestureDetector(
        onTap: navigate,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0, top: 3),
                    child: Text(
                      Heading,
                      style: TextStyle(color: new Color(color), fontSize: 15),
                    ),
                  ),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = BlueButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      title: 'OK',
      height: 10,
      width: MediaQuery.of(context).size.width * 0.8);

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Center(
        child: Text(
      "Coming soon",
      style: TextStyle(fontFamily: 'OpenSans'),
    )),
    //content: Text("Coming soon"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



// // ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
// import 'package:Rakshan/constants/theme.dart';
// import 'package:Rakshan/widgets/dialogue.dart';
// import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'package:Rakshan/constants/gradient.dart';

// import 'package:Rakshan/routes/app_routes.dart';
// import 'package:Rakshan/widgets/post_login/app_bar.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';
// import 'package:Rakshan/widgets/pre_login/app_bar_auth.dart';
// import 'package:Rakshan/widgets/pre_login/logo.dart';

// import '../../constants/textfield.dart';

// class RadioButton extends StatefulWidget {
//   static String id = 'radiobutton';

//   @override
//   State<RadioButton> createState() => _RadioButtonState();
// }

// class _RadioButtonState extends State<RadioButton> {
//   int selectedValue = -1;
//   // late bool isAlertSet;

//   // Future<bool> checkInternet() async {
//   //   var connectivityResult = await (Connectivity().checkConnectivity());
//   //   if (connectivityResult == ConnectivityResult.mobile ||
//   //       connectivityResult == ConnectivityResult.wifi) {
//   //     print(connectivityResult.toString());
//   //     return isAlertSet = false;
//   //   } else {
//   //     print('no internet');
//   //     return isAlertSet = true;
//   //   }
//   // }

//   // showAlertBox() => AlertDialog(
//   //       title: const Text(
//   //         'No Connection',
//   //         style: kGreyTextstyle,
//   //       ),
//   //       content: const Text('Please check your internet connectivity',
//   //           style: kBlueTextstyle),
//   //       elevation: 2,
//   //       actions: <Widget>[
//   //         TextButton(
//   //           onPressed: () async {
//   //             Navigator.pop(context, 'Cancel');
//   //             setState(() => isAlertSet = false);
//   //             checkInternet();
//   //             if (isAlertSet == true) {
//   //               showAlertBox();
//   //               // setState(() => isAlertSet = true);
//   //             }
//   //           },
//   //           child: const Text('OK'),
//   //         ),
//   //       ],
//   //     );

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // checkInternet();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       drawer: const Menu(),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xfffcfcfc),
//         title: const Text(
//           '',
//           style: TextStyle(
//             fontFamily: 'OpenSans',
//             color: Color(0xff2e66aa),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: kgradientgreenscreen,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [const Logo()],
//           ),
//           Positioned(
//               left: 10,
//               right: 10,
//               bottom: 0,
//               top: 200,
//               child: StaggeredGrid.count(
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//                 children: [
//                   StaggeredGridTile.count(
//                     crossAxisCellCount: 2,
//                     mainAxisCellCount: 1.5,
//                     child: MyItems(
//                         Icons.local_hospital,
//                         'Search Hospital',
//                         0xff325CA2,
//                         (() => Navigator.pushNamed(context, homescreen))),
//                   ),
//                   StaggeredGridTile.count(
//                     crossAxisCellCount: 2,
//                     mainAxisCellCount: 1.5,
//                     child: MyItems(
//                         Icons.content_paste_go,
//                         'Book Appointment',
//                         0xff325CA2,
//                         (() => Navigator.pushNamed(context, appointment))),
//                   ),
//                   StaggeredGridTile.count(
//                     crossAxisCellCount: 2,
//                     mainAxisCellCount: 1.5,
//                     child: MyItems(
//                         Icons.fact_check_outlined,
//                         'Claim Benefits',
//                         0xff325CA2,
//                         (() => Navigator.pushNamed(context, claimProcessIPD))),
//                   ),
//                   StaggeredGridTile.count(
//                     crossAxisCellCount: 2,
//                     mainAxisCellCount: 1.5,
//                     child: MyItems(
//                         Icons.access_time_filled,
//                         ' Medicine Reminder',
//                         0xff325CA2,
//                         (() =>
//                             Navigator.pushNamed(context, prescriptionScreen))),
//                   ),
//                   StaggeredGridTile.count(
//                     crossAxisCellCount: 2,
//                     mainAxisCellCount: 1.5,
//                     child: MyItems(
//                         Icons.monitor_heart,
//                         'Health Tracker',
//                         0xff325CA2,
//                         (() => Navigator.pushNamed(context, htReminderScreen))),
//                   ),
//                   StaggeredGridTile.count(
//                     crossAxisCellCount: 2,
//                     mainAxisCellCount: 1.5,
//                     child: MyItems(Icons.shopping_cart_outlined, 'Shop',
//                         0xff325CA2, (() => showAlertDialog(context))),
//                   ),
//                 ],
//               )
//               // Column(
//               //   children: [
//               //     Wrap(
//               //       spacing: 80,
//               //       children: [
//               //         iconCard(
//               //           icon: Icons.content_paste_go,
//               //           Name: 'Book Appointment',
//               //         ),
//               //         // SizedBox(
//               //         //   width: MediaQuery.of(context).size.width * 0.23,
//               //         // ),
//               //         iconCard(
//               //           icon: Icons.local_hospital,
//               //           Name: ' Medicine Reminder',
//               //         ),
//               //       ],
//               //     ),
//               //     SizedBox(
//               //       height: MediaQuery.of(context).size.height * 0.04,
//               //     ),
//               //     iconCard(
//               //       icon: Icons.fact_check_outlined,
//               //       Name: 'Calim Management',
//               //     ),
//               //     SizedBox(
//               //       height: MediaQuery.of(context).size.height * 0.04,
//               //     ),
//               //     Wrap(
//               //       spacing: 80,
//               //       children: [
//               //         iconCard(
//               //           icon: Icons.monitor_heart,
//               //           Name: 'Health Tracker',
//               //         ),
//               //         // SizedBox(
//               //         //   width: MediaQuery.of(context).size.width * 0.12,
//               //         // ),
//               //         iconCard(
//               //           icon: Icons.shopping_cart_outlined,
//               //           Name: 'Shop',
//               //         ),
//               //       ],
//               //     ),
//               //   ],
//               // ),
//               )
//         ],
//       ),
//     );
//   }
// }

// // class iconCard extends StatelessWidget {
// //   IconData icon;
// //   String Name;
// //   iconCard({
// //     Key? key,
// //     required this.icon,
// //     required this.Name,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: MediaQuery.of(context).size.height * 0.14,
// //       width: MediaQuery.of(context).size.width * 0.35,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(12),
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.5),
// //             spreadRadius: 5,
// //             blurRadius: 7,
// //             offset: Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Container(
// //             height: MediaQuery.of(context).size.height * 0.07,
// //             width: MediaQuery.of(context).size.width * 0.35,
// //             padding: const EdgeInsets.all(12),
// //             child: Icon(
// //               icon,
// //               size: 25,
// //               color: Color(0xff325CA2),
// //             ),
// //           ),
// //           Container(
// //             height: MediaQuery.of(context).size.height * 0.07,
// //             width: MediaQuery.of(context).size.width * 0.35,
// //             alignment: Alignment.center,
// //             decoration: const BoxDecoration(
// //                 color: Color(0xff325CA2),
// //                 borderRadius: BorderRadius.only(
// //                     bottomRight: Radius.circular(12),
// //                     bottomLeft: Radius.circular(12))),
// //             child: Text(
// //               Name,
// //               style: TextStyle(
// //                 color: Colors.white,
// //               ),
// //             ),
// //             // padding: const EdgeInsets.all(12),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //}

// // Appointment()       Book an Appointment
// // ClaimProcessIPD()   Calim Management
// // firstPage()         Medicine Reminder
// // firstPageHT()       Health Tracker
// // Color(0xff325CA2),

// Material MyItems(
//     IconData icon, String Heading, int color, VoidCallback? navigate) {
//   return Material(
//     color: Colors.white,
//     elevation: 14,
//     shadowColor: const Color(0x802196F3),
//     borderRadius: BorderRadius.circular(24),
//     child: Center(
//       child: GestureDetector(
//         onTap: navigate,
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       Heading,
//                       style: TextStyle(color: new Color(color), fontSize: 15),
//                     ),
//                   ),
//                   Material(
//                     color: new Color(color),
//                     borderRadius: BorderRadius.circular(24),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Icon(
//                         icon,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

// showAlertDialog(BuildContext context) {
//   // Create button
//   Widget okButton = BlueButton(
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//       title: 'OK',
//       height: 10,
//       width: MediaQuery.of(context).size.width * 0.8);

//   // Create AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: const Center(
//         child: Text(
//       "Coming soon",
//       style: TextStyle(fontFamily: 'OpenSans'),
//     )),
//     //content: Text("Coming soon"),
//     actions: [
//       okButton,
//     ],
//   );

//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
