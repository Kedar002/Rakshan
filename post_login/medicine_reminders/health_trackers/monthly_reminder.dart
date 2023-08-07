import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/padding.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import '../../../../widgets/toast.dart';
import 'ht_reminders.dart';

class htMonthlyReminder extends StatefulWidget {
  static String id = 'medicine_medicineHowOftenDoYouTake1';
  String? reminderName;
  int? illnessId;
  String? diabetesStrips;
  String? insulinDozeQuantity;

  htMonthlyReminder({
    Key? key,
    this.reminderName,
    this.illnessId,
    this.diabetesStrips,
    this.insulinDozeQuantity,
  }) : super(key: key);
  @override
  State<htMonthlyReminder> createState() => _htMonthlyReminderState();
}

class _htMonthlyReminderState extends State<htMonthlyReminder> {
  bool isLoad = false;
  String? time1;
  int _currentValue = 3;
  List listItem = [
    'BreakFast',
    'Lunch',
    'Dinner',
  ];
  String? timeDay1;

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: const Color(0xff82B445),
            appBar: AppBarIndividual(title: 'Rakshan'),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: kScreenPadding,
                  child: Column(
                    children: const [
                      Center(
                        child: Text(
                          'How often do you take it ?',
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
                      children: [
                        const Center(
                          child: Text(
                            'Every',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff325CA2),
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        NumberPicker(
                          axis: Axis.horizontal,
                          value: _currentValue,
                          minValue: 1,
                          maxValue: 31,
                          onChanged: (value) => setState(() {
                            _currentValue = value;
                          }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                          child: Text(
                            'Days',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff325CA2),
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                          child: Text(
                            'Time Slot',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff325CA2),
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50, right: 50),
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
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.9,
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
                              print(value.toString());
                              time1 = DateFormat('hh:mm a').format(value);
                            },
                            initialDateTime: DateTime.now(),
                          ),
                        )
                      ],
                    ),
                  ),
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

    Map d = {
      "ScheduleId": 0,
      "UserId": int.parse(userId as String),
      "IllnessId": widget.illnessId,
      "Title": widget.reminderName,
      "ScheduleType": "Monthly",
      "WeekDays": null,
      "MonthScheduleDay": _currentValue,
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
