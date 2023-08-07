import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/bloodpressure.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/diabetes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/reminder_strip_doze.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/how_often_do_you_takeit.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/how_often_do_you_takeit_1.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/how_often_do_you_takeit_2.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/padding.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import 'ht_week_daily_monthly_reminder.dart';

class firstPageHT extends StatefulWidget {
  static String id = 'firstpage_of_H_T';

  String? reminderTitle;
  firstPageHT(this.reminderTitle);

  @override
  State<firstPageHT> createState() => _firstPageHTState();
}

class _firstPageHTState extends State<firstPageHT> {
  int? illnessId;
  final _controller1 = TextEditingController();

  List<dynamic> illnessList = [];

  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xff82B445),
            appBar: AppBarIndividual(title: 'Rakshan'),
            body: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: kScreenPadding,
                  child: Column(
                    children: const [
                      Center(
                        child: Text(
                          'What would you like to track ?',
                          style: TextStyle(
                            fontSize: 20,
                          ),
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
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: ListView(children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Illness Type';
                            }
                            return null;
                          },
                          controller: _controller1,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Illness Type',
                            hintStyle: const TextStyle(
                              fontFamily: 'OpenSans',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff325CA2), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff325CA2), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            suffixIcon: PopupMenuButton(
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              ),
                              itemBuilder: (context) {
                                return List.generate(illnessList.length,
                                    (index) {
                                  return PopupMenuItem(
                                      child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller1.text =
                                            illnessList[index]['name'];
                                        illnessId = illnessList[index]['id'];
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        height: 40,
                                        color: Colors.white,
                                        alignment: Alignment.centerLeft,
                                        child:
                                            Text(illnessList[index]['name'])),
                                  ));
                                });
                              },
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: BlueButton(
              onPressed: () {
                if (illnessId == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => htWeeklyDailyMonthlyReminder(
                                reminderName: widget.reminderTitle,
                                illnessId: illnessId,
                                diabetesStrips: "",
                                insulinDozeQuantity: "",
                              )));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => reminderStripDoze(
                                reminderName: widget.reminderTitle,
                                illnessId: illnessId,
                              )));
                }
              },
              title: 'Next',
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );

    // return Scaffold(
    //
    //   appBar: AppBarIndividual(title: 'Rakshan'),
    //   body: Container(
    //     color: Color(0xffffffff),
    //     child: Column(
    //       children: [
    //         Container(
    //           alignment: Alignment.center,
    //           height: MediaQuery.of(context).size.height * 0.1,
    //           width: MediaQuery.of(context).size.width * 1,
    //           decoration: const BoxDecoration(color: Color(0xff82B445)),
    //           child: const Text('Health Trackers'),
    //         ),
    //         Container(
    //           color: const Color(0xff82B445),
    //           height: MediaQuery.of(context).size.height * 0.2,
    //           child: Container(
    //             decoration: const BoxDecoration(
    //                 border: Border.symmetric(),
    //                 borderRadius:
    //                     BorderRadius.vertical(top: Radius.circular(30.0)),
    //                 color: Color(0xffffffff)),
    //             padding: EdgeInsets.only(left: 70, right: 70),
    //             alignment: Alignment.centerLeft,
    //             height: MediaQuery.of(context).size.height * 0.1,
    //             width: MediaQuery.of(context).size.width * 1,
    //             child: Padding(
    //               padding:
    //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //               child: Container(
    //                 alignment: Alignment.center,
    //                 padding: const EdgeInsets.only(left: 15, right: 15),
    //                 decoration: BoxDecoration(
    //                   color: const Color(0xffffffff),
    //                   border: Border.all(color: Colors.white, width: 1),
    //                   borderRadius: BorderRadius.circular(5),
    //                 ),
    //                 child: DropdownButton<String>(
    //                   value: _selectedGender,
    //                   items: _dropDownItem(),
    //                   onChanged: (value) {
    //                     _selectedGender = value;
    //                     switch (value) {
    //                       case "Blood Pressure":
    //                         // Navigator.push(
    //                         //   context,
    //                         //   MaterialPageRoute(
    //                         //       builder: (context) =>
    //                         //           medicineHowOftenDoYouTake1()),
    //                         // );
    //                         break;
    //                       case "Diabetes":
    //                         // Navigator.push(
    //                         //   context,
    //                         //   MaterialPageRoute(
    //                         //       builder: (context) =>
    //                         //           medicineHowOftenDoYouTake2()),
    //                         // );
    //                         break;
    //                     }
    //                   },
    //                   hint: Text('Blood Pressure'),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: BlueButton(
    //     onPressed: () {
    //       // Navigator.pushNamed(context, medicineHowOften1Screen);
    //     },
    //     title: 'Next',
    //     height: MediaQuery.of(context).size.height * 0.05,
    //     width: MediaQuery.of(context).size.width * 0.5,
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    // );
  }

  setData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    var response = await http
        .get(Uri.parse('$BASE_URL/api/HealthTracker/GetIllnessList'), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
    });

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['isSuccess'] = true) {
        for (int i = 0; i < data['data'].length; i++) {
          illnessList.add(data['data'][i]);
        }
      }

      setState(() {
        isLoad = false;
      });

      print("data" + data.toString());
    } else {
      setState(() {
        isLoad = false;
      }); // toast('Something went wrong');
    }
  }
}
