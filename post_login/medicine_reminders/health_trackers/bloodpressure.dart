import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/padding.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import '../../../../widgets/toast.dart';
import 'ht_reminders.dart';

class BloodPressure extends StatefulWidget {
  static String id = 'diabates';

  var illnessTypeId;
  var measureId;
  BloodPressure({this.illnessTypeId, this.measureId});

  @override
  State<BloodPressure> createState() => _BloodPressureState();
}

class _BloodPressureState extends State<BloodPressure> {
  String? valueServiceProvideName;
  String? time;

  bool isLoad = false;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

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
                          'Blood Pressure',
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
                                    controller: _controller,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Sys(High)';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        ktextfieldDecoration('Sys(high)'),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    controller: _controller1,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Dia (Low)';
                                      }
                                      return null;
                                    },
                                    decoration:
                                        ktextfieldDecoration('Dia(low)'),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                Text(
                                  'mm Hg',
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: kScreenPadding,
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    controller: _controller2,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Pulse';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: ktextfieldDecoration('Pulse'),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text(
                                  'bpm',
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (value) {
                                time = DateFormat('hh:mm a').format(value);
                              },
                              initialDateTime: DateTime.now(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Wrap(children: [
              // BlueButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, diabetesAnalysisScreen);
              //     // Navigator.pushNamed(context, medicineReasonScreen);
              //   },
              //   title: 'Analysis',
              //   height: MediaQuery.of(context).size.height * 0.05,
              //   width: MediaQuery.of(context).size.width * 0.3,
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.15,
              // ),
              BlueButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    setSaveData();
                  }
                },
                title: 'Done',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
    // Scaffold(
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
    //           decoration: BoxDecoration(color: Colors.green),
    //           child: const Text('3'), //'How often do you take it ?'),
    //         ),
    //         Container(
    //           color: Colors.green,
    //           height: MediaQuery.of(context).size.height * 0.2,
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 border: const Border.symmetric(),
    //                 borderRadius:
    //                     BorderRadius.vertical(top: Radius.circular(30.0)),
    //                 color: Color(0xffffffff)),
    //             padding: EdgeInsets.only(left: 70, right: 70),
    //             alignment: Alignment.center,
    //             height: MediaQuery.of(context).size.height * 0.1,
    //             width: MediaQuery.of(context).size.width * 1,
    //             child: Padding(
    //               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //               child: Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.only(left: 16, right: 16),
    //                 decoration: BoxDecoration(
    //                   color: Color(0xffffffff),
    //                   border: Border.all(color: Colors.white, width: 1),
    //                   borderRadius: BorderRadius.circular(5),
    //                 ),
    //                 child: DropdownButton(
    //                   hint: Text(
    //                     'Once a week',
    //                     style: TextStyle(
    //                         fontFamily: 'OpenSans',
    //                         //fontWeight: FontWeight.bold,
    //                         color: Colors.black),
    //                   ),
    //                   dropdownColor: Colors.white,
    //                   icon: Icon(Icons.arrow_drop_down),
    //                   iconSize: 36,
    //                   isExpanded: true,
    //                   underline: SizedBox(),
    //                   style: TextStyle(
    //                     color: Colors.black,
    //                     fontSize: 18,
    //                   ),
    //                   value: valueServiceProvideName,
    //                   onChanged: (newValue) {
    //                     setState(() {
    //                       valueServiceProvideName = newValue as String?;
    //                     });
    //                   },
    //                   items: listItem.map((valueItem) {
    //                     return DropdownMenuItem(
    //                       value: valueItem,
    //                       child: Text(valueItem),
    //                     );
    //                   }).toList(),
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
    //       Navigator.pushNamed(context, medicineTimeScreen);
    //     },
    //     title: 'Next',
    //     height: MediaQuery.of(context).size.height * 0.05,
    //     width: MediaQuery.of(context).size.width * 0.5,
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    // );
  }

  setSaveData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");

    DateTime date = DateTime.now();

    String time1 = DateFormat('hh:mm a').format(date);
    String currentDate = DateFormat('dd/MM/yyyy').format(date);

    Map d = {
      "MesureId": 0,
      "MesureReminderId": widget.measureId,
      "IllnessnId": widget.illnessTypeId, //1,
      "MesureDate": currentDate,
      "MesureTime": time ?? DateTime.now().toString(),
      "SystolicHigh": _controller.text.trim(),
      "DiastolicLow": _controller1.text.trim(),
      "BloodGlucose": _controller2.text.trim(),
      "DiabetesHigh": "0",
      "DiabetesLow": "0",
      "Pulse": int.parse(_controller2.text.trim()),
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

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      print('res for VP${data}');

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
