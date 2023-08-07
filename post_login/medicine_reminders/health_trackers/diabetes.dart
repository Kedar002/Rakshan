import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/padding.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import '../../../../widgets/toast.dart';
import 'ht_reminders.dart';

class diabetes extends StatefulWidget {
  static String id = 'diabetes';

  var illnessTypeId;
  var measureId;
  diabetes({this.illnessTypeId, this.measureId});

  @override
  State<diabetes> createState() => _diabetesState();
}

class _diabetesState extends State<diabetes> {
  String? timeInDay1;
  String? time;
  List listItem = [
    'Pre Breakfast',
    'Post Breakfast',
    'Pre Lunch',
    'Post Lunch',
    'Pre Dinner',
    'PostDinner',
  ];
  String? valueServiceProvideName;

  final _controller = TextEditingController();
  bool isLoad = false;
  final _formKey = GlobalKey<FormState>();

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
                          'Diabetes',
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
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Container(
                            padding: kScreenPadding,
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Blood Glucose';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: _controller,
                                    decoration:
                                        ktextfieldDecoration('Blood glucose'),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                Text(
                                  'mmol/L',
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 20, bottom: 20),
                            child: Column(children: [
                              // dropDownForTimeOfDose(),
                              DropdownButton(
                                hint: const Text(
                                  'Select meal time',
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
                                    timeInDay1 = newValue.toString();
                                    print('luffyy$timeInDay1');
                                  });
                                },
                                items: listItem.map((valueItem) {
                                  return DropdownMenuItem(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (value) {
                                    time = DateFormat('hh:mm a').format(value);
                                  },
                                  initialDateTime: DateTime.now(),
                                ),
                              ),
                              Divider(color: Colors.grey),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: BlueButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  setSaveData();
                } //Navigator.pushNamed(context, moreSettingsScreen);
              },
              title: 'Done',
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.3,
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

    DateTime date = DateTime.now();

    // String time1 = DateFormat('hh:mm a').format(date);
    String currentDate = DateFormat('dd/MM/yyyy').format(date);

    Map d = {
      "MesureId": 0,
      "MesureReminderId": widget.measureId,
      "IllnessnId": widget.illnessTypeId, //2,
      "MesureDate": currentDate,
      "MesureTime": time ?? DateTime.now().toString(),
      "SystolicHigh": "0",
      "DiastolicLow": "0",
      "BloodGlucose": _controller.text.trim(),
      "DiabetesHigh": timeInDay1??"-",
      "DiabetesLow": "0",
      "Pulse": 0,
      "UserId": int.parse(userId as String)
    };

    print(d.toString());
    var response = await http.post(
        Uri.parse('$BASE_URL/api/HealthTracker/SaveHealthTracker'),
        body: jsonEncode(d),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
          HttpHeaders.contentTypeHeader: "application/json"
        });
    print('respo$response.status');
    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print('luffyyy$data.toString()');

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

  DropdownButton<Object> dropDownForTimeOfDose() {
    var timeInDay1;
    List listItem = [
      'Pre Breakfast',
      'Post Breakfast',
      'Pre Lunch',
      'Post Lunch',
      'Pre Dinner',
      'PostDinner',
    ];
    return DropdownButton(
      hint: const Text(
        'Breakfast',
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
}
