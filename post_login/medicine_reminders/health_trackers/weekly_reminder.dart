import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/padding.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import '../../../../widgets/toast.dart';
import 'ht_reminders.dart';

class htWeeklyReminder extends StatefulWidget {
  static String id = 'specificDaysOfTheWeek';
  String? reminderName;
  int? illnessId;
  String? diabetesStrips;
  String? insulinDozeQuantity;

  htWeeklyReminder({
    Key? key,
    this.reminderName,
    this.illnessId,
    this.diabetesStrips,
    this.insulinDozeQuantity,
  }) : super(key: key);

  @override
  State<htWeeklyReminder> createState() => _htWeeklyReminderState();
}

class _htWeeklyReminderState extends State<htWeeklyReminder> {
  bool isLoad = false;

  List<String> week = [];
  String? valueServiceProvideName;

  List listItem = [
    'BreakFast',
    'Lunch',
    'Dinner',
  ];
  String? time1;
  String? time2;
  String? time3;
  String? time4;
  String? time5;

  String? timeDay1;
  String? timeDay2;
  String? timeDay3;
  String? timeDay4;
  String? timeDay5;

  bool isSunday = false;
  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  bool isSaturday = false;

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
                          'On which days(s) do yoou need to take the med ? ',
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
                      child: ListView(
                        padding: kScreenPadding,
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: [
                            GestureDetector(
                              onTap: () {
                                if (week.contains("Sunday")) {
                                  week.removeWhere(
                                      (element) => element == "Sunday");
                                  setState(() {
                                    isSunday = false;
                                  });

                                  print(week.toString());
                                } else {
                                  week.add("Sunday");
                                  setState(() {
                                    isSunday = true;
                                  });
                                  print(week.toString());
                                }
                              },
                              child: isSunday
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Sunday"),
                                          Icon(Icons.check_box)
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Sunday"),
                                          Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (week.contains("Monday")) {
                                  week.removeWhere(
                                      (element) => element == "Monday");
                                  setState(() {
                                    isMonday = false;
                                  });

                                  print(week.toString());
                                } else {
                                  week.add("Monday");
                                  setState(() {
                                    isMonday = true;
                                  });
                                  print(week.toString());
                                }
                              },
                              child: isMonday
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Monday"),
                                          Icon(Icons.check_box)
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Monday"),
                                          Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (week.contains("Tuesday")) {
                                  week.removeWhere(
                                      (element) => element == "Tuesday");
                                  setState(() {
                                    isTuesday = false;
                                  });

                                  print(week.toString());
                                } else {
                                  week.add("Tuesday");
                                  setState(() {
                                    isTuesday = true;
                                  });
                                  print(week.toString());
                                }
                              },
                              child: isTuesday
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Tuesday"),
                                          Icon(Icons.check_box)
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Tuesday"),
                                          Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (week.contains("Wednesday")) {
                                  week.removeWhere(
                                      (element) => element == "Wednesday");
                                  setState(() {
                                    isWednesday = false;
                                  });

                                  print(week.toString());
                                } else {
                                  week.add("Wednesday");
                                  setState(() {
                                    isWednesday = true;
                                  });
                                  print(week.toString());
                                }
                              },
                              child: isWednesday
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Wednesday"),
                                          Icon(Icons.check_box)
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Wednesday"),
                                          Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (week.contains("Thursday")) {
                                  week.removeWhere(
                                      (element) => element == "Thursday");
                                  setState(() {
                                    isThursday = false;
                                  });

                                  print(week.toString());
                                } else {
                                  week.add("Thursday");
                                  setState(() {
                                    isThursday = true;
                                  });
                                  print(week.toString());
                                }
                              },
                              child: isThursday
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Thursday"),
                                          Icon(Icons.check_box)
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Thursday"),
                                          Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (week.contains("Friday")) {
                                  week.removeWhere(
                                      (element) => element == "Friday");
                                  setState(() {
                                    isFriday = false;
                                  });

                                  print(week.toString());
                                } else {
                                  week.add("Friday");
                                  setState(() {
                                    isFriday = true;
                                  });
                                  print(week.toString());
                                }
                              },
                              child: isFriday
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Friday"),
                                          Icon(Icons.check_box)
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Friday"),
                                          Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (week.contains("Saturday")) {
                                  week.removeWhere(
                                      (element) => element == "Saturday");
                                  setState(() {
                                    isSaturday = false;
                                  });

                                  print(week.toString());
                                } else {
                                  week.add("Saturday");
                                  setState(() {
                                    isSaturday = true;
                                  });
                                  print(week.toString());
                                }
                              },
                              child: isSaturday
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Saturday"),
                                          Icon(Icons.check_box)
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Saturday"),
                                          Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(0.0)),
                                  color: Color(0xffFBFBFB)),
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 50, right: 50),
                                    child: DropdownButton(
                                      hint: const Text(
                                        'Select Meal Time',
                                        style: const TextStyle(
                                            fontFamily: 'OpenSans',
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      dropdownColor: Colors.white,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 36,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      value: timeDay1,
                                      onChanged: (newValue) {
                                        setState(() {
                                          timeDay1 = newValue as String?;
                                        });
                                      },
                                      items: listItem.map((valueItem) {
                                        return DropdownMenuItem(
                                          value: valueItem,
                                          child: Text(valueItem),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    // child: CupertinoDatePicker(
                                    //     initialDateTime: _dateTime,
                                    //     onDateTimeChanged: (dateTime) {
                                    //       print(dateTime);
                                    //       setState(() {
                                    //         _dateTime = dateTime;
                                    //       });
                                    //     }),
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      onDateTimeChanged: (value) {
                                        time1 =
                                            DateFormat('hh:mm a').format(value);
                                      },
                                      initialDateTime: DateTime.now(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).toList(),
                      )),
                ),
              ],
            ),
            floatingActionButton: BlueButton(
              onPressed: () {
                setSaveData();
              },
              title: 'Save',
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  setSaveData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    String data = week.join(",");

    Map d = {
      "ScheduleId": 0,
      "UserId": int.parse(userId as String),
      "IllnessId": widget.illnessId,
      "Title": widget.reminderName,
      "ScheduleType": "Weekly",
      "WeekDays": data,
      "MonthScheduleDay": 0,
      "MonthDate": null,
      "FamilyId": 0,
      "Time1": time1 ?? DateTime.now().toString(),
      "Time2": null,
      "Time3": null,
      "TimeDay1": timeDay1,
      "TimeDay2": null,
      "TimeDay3": null,
      "DiabetesStrips": widget.diabetesStrips.toString() == ""
          ? 0
          : int.parse(widget.diabetesStrips.toString()),
      "InsulinDozeQuantity": widget.insulinDozeQuantity.toString() == ""
          ? 0
          : int.parse(widget.insulinDozeQuantity.toString())
    };

    print(d.toString());
    var response = await http.post(
        Uri.parse('$BASE_URL/api/HealthTracker/SaveHealthTrackerSchedule'),
        body: jsonEncode(d),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
          HttpHeaders.contentTypeHeader: "application/json"
        });

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print(data.toString());

      if (data['isSuccess'] = true) {
        // ignore: use_build_context_synchronously
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => addMed(widget.prescriptionId)));

        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return htReminders();
        })));
        setState(() {
          isLoad = false;
        });
      }
      setState(() {
        isLoad = false;
      });
    } else {
      toast('Something went wrong');
      print(response.statusCode.toString());
      print(response.body.toString());
      setState(() {
        isLoad = false;
      });
    }
  }
}
