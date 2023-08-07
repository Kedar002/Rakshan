import 'dart:convert';

import 'package:Rakshan/utills/notification_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int selectedValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkInternet();
    // _checkVersion();
  }

  // Future<bool> checkInternet() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi) {
  //     print(connectivityResult.toString());
  //     return isAlertSet = false;
  //   } else {
  //     print('no internet');
  //     return isAlertSet = true;
  //   }
  // }

  // showAlertBox() => AlertDialog(
  //       title: const Text(
  //         'No Internet Connection',
  //         style: kGreyTextstyle,
  //       ),
  //       content: const Text('Please check your internet connectivity',
  //           style: kBlueTextstyle),
  //       elevation: 2,
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.pop(context, 'Cancel');
  //             setState(() => isAlertSet = false);
  //             checkInternet();
  //             if (isAlertSet == true) {
  //               showAlertBox();
  //               // setState(() => isAlertSet = true);
  //             }
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     );

//alert dialog for IOS
  // showDialogBox() => showCupertinoDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: const Text('No Connection'),
  //         content: const Text('Please check your internet connectivity'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.pop(context, 'Cancel');
  //               setState(() => isAlertSet = false);
  //               checkInternet();
  //               if (isAlertSet == true) {
  //                 showDialogBox();
  //                 // setState(() => isAlertSet = true);
  //               }
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );

  // void _checkVersion() async {
  //   final newVersion = NewVersion(
  //     androidId: 'com.rakshan.metier',
  //   );
  //   // newVersion.showAlertIfNecessary(context: context);
  //   final status = await newVersion.getVersionStatus();
  //   newVersion.showUpdateDialog(
  //     context: context,
  //     versionStatus: status!,
  //     dialogTitle: "UPDATE!!!",
  //     dismissButtonText: "Skip",
  //     dialogText: "Please update the app from " +
  //         "${status.localVersion}" +
  //         " to " +
  //         "${status.storeVersion}",
  //     dismissAction: () {
  //       SystemNavigator.pop();
  //     },
  //     updateButtonText: "Lets update",
  //   );

  //   print("DEVICE : " + status.localVersion);
  //   print("STORE : " + status.storeVersion);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Metier',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 22,
                            color: Color(0xff215DA5),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Apurv',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                      height: 140,
                      width: 140,
                      child: Image(
                          image: AssetImage('assets/images/welcome_image.png')))
                ],
              ),
              Text(
                'Please provide us with some more info',
                style: kGreyTextstyle,
              ),
              Row(
                children: [
                  Text('Weight', style: kGreyTextstyle),
                  SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 128,
                    child: TextField(
                      decoration: ktextfieldDecoration(''),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Height',
                    style: kGreyTextstyle,
                  ),
                  SizedBox(
                    width: 34,
                  ),
                  SizedBox(
                    width: 128,
                    child: TextField(
                      decoration: ktextfieldDecoration(''),
                    ),
                  )
                ],
              ),
              Row(children: [
                Text(
                  'Diabetic',
                  style: kGreyTextstyle,
                ),
                RadioButtons(),
              ]),
              Row(children: [
                Text(
                  'Heart Patient',
                  style: kGreyTextstyle,
                ),
                RadioButtons(),
              ]),
              Row(
                children: [
                  Icon(
                    Icons.add_box_outlined,
                    color: Color(0xff215DA5),
                    size: 28,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Add Element', style: kGreyTextstyle),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      BlueButton(
                          onPressed: () {
                            Navigator.pushNamed(context, homescreen);
                          },
                          title: 'Save',
                          height: 45,
                          width: 160),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, homescreen);
                      //   },
                      //   child: Text(
                      //     'Save',
                      //   ),
                      // ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, homescreen);
                        },
                        child: Text(
                          'Skip',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class RadioButtons extends StatefulWidget {
  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  late String radioButtonItem;
  int id = 0;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 1,
          groupValue: id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = 'Yes';
              id = 1;
            });
          },
        ),
        Text(
          'Yes',
          style: new TextStyle(fontSize: 17.0),
        ),
        Radio(
          value: 2,
          groupValue: id,
          onChanged: (val) {
            setState(() {
              radioButtonItem = 'No';
              id = 2;
            });
          },
        ),
        Text(
          'No',
          style: new TextStyle(
            fontSize: 17.0,
          ),
        ),
      ],
    );
  }
}
