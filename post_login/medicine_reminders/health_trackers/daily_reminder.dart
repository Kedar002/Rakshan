import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/padding.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import 'package:http/http.dart' as http;

import '../../../../widgets/toast.dart';
import 'ht_reminders.dart';

class htDailyReminder extends StatefulWidget {
  static String id = 'medicine_time';
  String? reminderName;
  int? illnessId;
  String? diabetesStrips;
  String? insulinDozeQuantity;

  htDailyReminder({
    Key? key,
    this.reminderName,
    this.illnessId,
    this.diabetesStrips,
    this.insulinDozeQuantity,
  }) : super(key: key);
  @override
  State<htDailyReminder> createState() => _htDailyReminderState();
}

class _htDailyReminderState extends State<htDailyReminder> {
  String? valueServiceProvideName = "1";

  String? timeInDay1;
  String? timeInDay2;
  String? timeInDay3;
  String? timeInDay4;
  String? timeInDay5;
  String? timeInDay6;
  String? timeInDay7;
  String? time1;
  String? time2;
  String? time3;
  String? time4;
  String? time5;
  String? time6;
  String? time7;

  List listItem = [
    'Breakfast',
    'Lunch',
    'Dinner',
  ];

  List listItem1 = [
    '1',
    '2',
    '3',
  ];

  bool isLoad = false;
  final now = new DateTime.now();
  late String formatter = DateFormat('yyyy-MM-dd').format(now);
  late final DateTime _dateTime = DateTime.parse("$formatter 08:30:00");
  late final DateTime _dateTime1 = DateTime.parse("$formatter 14:00:00");
  late final DateTime _dateTime2 = DateTime.parse("$formatter 20:00:00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'At what time of day do you take the first reading ?',
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
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  const Center(
                    child: Text(
                      'Frequency',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 80, right: 80, top: 20, bottom: 20),
                    child: DropdownButton(
                      hint: const Text(
                        'Select Frequency',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            //fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      value: valueServiceProvideName,
                      onChanged: (newValue) {
                        setState(() {
                          valueServiceProvideName = newValue as String?;
                        });
                      },
                      items: listItem1.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                  valueServiceProvideName == "1"
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 80, right: 80),
                              child: dropDownForTimeOfDose1(),
                            ),
                            clock1(context),
                          ],
                        )
                      : valueServiceProvideName == "2"
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80, right: 80),
                                  child: dropDownForTimeOfDose1(),
                                ),
                                clock1(context),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80, right: 80),
                                  child: dropDownForTimeOfDose2(),
                                ),
                                clock2(context),
                              ],
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80, right: 80),
                                  child: dropDownForTimeOfDose1(),
                                ),
                                clock1(context),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80, right: 80),
                                  child: dropDownForTimeOfDose2(),
                                ),
                                clock2(context),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80, right: 80),
                                  child: dropDownForTimeOfDose3(),
                                ),
                                clock3(context),
                              ],
                            ),
                  BlueButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, moreSettingsScreen);
                      setSaveData();
                    },
                    title: 'Save',
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox clock1(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: (value) {
          time1 = DateFormat('hh:mm a').format(value);
          print('sanji$_dateTime');
          print('sanju$timeInDay1');
          print('sanjo$formatter');
        },
        initialDateTime: _dateTime,
      ),
    );
  }

  SizedBox clock2(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: (value) {
          time2 = DateFormat('hh:mm a').format(value);
          print('luffy$time1');
        },
        initialDateTime: _dateTime1,
      ),
    );
  }

  SizedBox clock3(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5,
      child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (value) {
            time3 = DateFormat('hh:mm a').format(value);
            print('luffy$time1');
          },
          initialDateTime: _dateTime2),
    );
  }

  DropdownButton<Object> dropDownForTimeOfDose1() {
    return DropdownButton(
      hint: const Text(
        'Select Meal Time',
        style: TextStyle(
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
      value: timeInDay1,
      onChanged: (newValue) {
        setState(() {
          timeInDay1 = newValue as String?;
        });
      },
      items: listItem.map((valueItem) {
        return DropdownMenuItem(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
    );
  }

  DropdownButton<Object> dropDownForTimeOfDose2() {
    return DropdownButton(
      hint: const Text(
        'Select Meal Time',
        style: TextStyle(
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
      value: timeInDay2,
      onChanged: (newValue) {
        setState(() {
          timeInDay2 = newValue as String?;
        });
      },
      items: listItem.map((valueItem) {
        return DropdownMenuItem(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
    );
  }

  DropdownButton<Object> dropDownForTimeOfDose3() {
    return DropdownButton(
      hint: const Text(
        'Select Meal Time',
        style: TextStyle(
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
      value: timeInDay3,
      onChanged: (newValue) {
        setState(() {
          timeInDay3 = newValue as String?;
        });
      },
      items: listItem.map((valueItem) {
        return DropdownMenuItem(
          value: valueItem,
          child: Text(valueItem),
        );
      }).toList(),
    );
  }

  setSaveData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");

    print("dd" + widget.diabetesStrips.toString());

    Map d = {
      "ScheduleId": 0,
      "UserId": int.parse(userId as String),
      "IllnessId": widget.illnessId,
      "Title": widget.reminderName,
      "ScheduleType": "Daily",
      "WeekDays": null,
      "MonthDate": null,
      "MonthScheduleDay": 0,
      "FamilyId": 0,
      "Time1": time1 ?? _dateTime.toString(),
      "Time2": (time2 == null &&
              (valueServiceProvideName == "2" ||
                  valueServiceProvideName == "3"))
          ? _dateTime1.toString()
          : time2,
      "Time3": (time3 == null && valueServiceProvideName == "3")
          ? _dateTime2.toString()
          : time3,
      "TimeDay1": timeInDay1,
      "TimeDay2": timeInDay2,
      "TimeDay3": timeInDay3,
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
