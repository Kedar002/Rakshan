import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/padding.dart';
import '../../../widgets/post_login/app_bar.dart';
import '../../../widgets/pre_login/blue_button.dart';
import '../../../widgets/toast.dart';
import 'add_med.dart';

class medicineTime extends StatefulWidget {
  static String id = 'medicine_time';
  String? medicineName;
  int? prescriptionId;
  String? medicineTypeId;
  String? quantity;
  String? medicineTypeName;
  File? image;
  String? type;
  int? time;
  medicineTime(
      {Key? key,
      this.medicineName,
      this.prescriptionId,
      this.medicineTypeId,
      this.quantity,
      this.medicineTypeName,
      this.image,
      this.type,
      this.time})
      : super(key: key);
  @override
  State<medicineTime> createState() => _medicineTimeState();
}

class _medicineTimeState extends State<medicineTime> {
  String? valueServiceProvideName;

  List listItem = [
    'BreakFast',
    'Lunch',
    'Dinner',
  ];

  bool isLoad = false;

  DateTime _dateTime = DateTime.now();

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
                          'At what time of day do you take the first reading ?',
                          style:
                              TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
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
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        widget.time == 1
                            ? Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 80, right: 80),
                                    child: DropdownButton(
                                      hint: const Text(
                                        'BreakFast',
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
                                        print(value.toString());
                                        time1 =
                                            DateFormat('hh:mm a').format(value);
                                      },
                                      initialDateTime: DateTime.now(),
                                    ),
                                  )
                                ],
                              )
                            : widget.time == 2
                                ? Column(
                                    children: [
                                      const Center(
                                        child: Text(
                                          'First Reading',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'OpenSans'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 80, right: 80),
                                        child: DropdownButton(
                                          hint: const Text(
                                            'BreakFast',
                                            style: const TextStyle(
                                                fontFamily: 'OpenSans',
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          dropdownColor: Colors.white,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
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
                                            time1 = DateFormat('hh:mm a')
                                                .format(value);
                                          },
                                          initialDateTime: DateTime.now(),
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          'Second Reading',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'OpenSans'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 80, right: 80),
                                        child: DropdownButton(
                                          hint: const Text(
                                            'BreakFast',
                                            style: const TextStyle(
                                                fontFamily: 'OpenSans',
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          dropdownColor: Colors.white,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 36,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                          value: timeDay2,
                                          onChanged: (newValue) {
                                            setState(() {
                                              timeDay2 = newValue as String?;
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
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
                                            time2 = DateFormat('hh:mm a')
                                                .format(value);
                                          },
                                          initialDateTime: DateTime.now(),
                                        ),
                                      ),
                                    ],
                                  )
                                : widget.time == 3
                                    ? Column(
                                        children: [
                                          const Center(
                                            child: Text(
                                              'First Reading',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 80, right: 80),
                                            child: DropdownButton(
                                              hint: const Text(
                                                'BreakFast',
                                                style: const TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    //fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              dropdownColor: Colors.white,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
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
                                                  timeDay1 =
                                                      newValue as String?;
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            // child: CupertinoDatePicker(
                                            //     initialDateTime: _dateTime,
                                            //     onDateTimeChanged: (dateTime) {
                                            //       print(dateTime);
                                            //       setState(() {
                                            //         _dateTime = dateTime;
                                            //       });
                                            //     }),
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.time,
                                              onDateTimeChanged: (value) {
                                                time1 = DateFormat('hh:mm a')
                                                    .format(value);
                                              },
                                              initialDateTime: DateTime.now(),
                                            ),
                                          ),
                                          const Center(
                                            child: Text(
                                              'Second Reading',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 80, right: 80),
                                            child: DropdownButton(
                                              hint: const Text(
                                                'BreakFast',
                                                style: const TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    //fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              dropdownColor: Colors.white,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 36,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                              value: timeDay2,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  timeDay2 =
                                                      newValue as String?;
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            // child: CupertinoDatePicker(
                                            //     initialDateTime: _dateTime,
                                            //     onDateTimeChanged: (dateTime) {
                                            //       print(dateTime);
                                            //       setState(() {
                                            //         _dateTime = dateTime;
                                            //       });
                                            //     }),
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.time,
                                              onDateTimeChanged: (value) {
                                                time2 = DateFormat('hh:mm a')
                                                    .format(value);
                                              },
                                              initialDateTime: DateTime.now(),
                                            ),
                                          ),
                                          const Center(
                                            child: Text(
                                              'Third Reading',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 80, right: 80),
                                            child: DropdownButton(
                                              hint: const Text(
                                                'BreakFast',
                                                style: const TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    //fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              dropdownColor: Colors.white,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              iconSize: 36,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                              value: timeDay3,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  timeDay3 =
                                                      newValue as String?;
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            // child: CupertinoDatePicker(
                                            //     initialDateTime: _dateTime,
                                            //     onDateTimeChanged: (dateTime) {
                                            //       print(dateTime);
                                            //       setState(() {
                                            //         _dateTime = dateTime;
                                            //       });
                                            //     }),
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.time,
                                              onDateTimeChanged: (value) {
                                                time3 = DateFormat('hh:mm a')
                                                    .format(value);
                                              },
                                              initialDateTime: DateTime.now(),
                                            ),
                                          ),
                                        ],
                                      )
                                    : widget.time == 4
                                        ? Column(
                                            children: [
                                              const Center(
                                                child: Text(
                                                  'First Reading',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'OpenSans'),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 80, right: 80),
                                                child: DropdownButton(
                                                  hint: const Text(
                                                    'BreakFast',
                                                    style: const TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        //fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  dropdownColor: Colors.white,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
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
                                                      timeDay1 =
                                                          newValue as String?;
                                                    });
                                                  },
                                                  items:
                                                      listItem.map((valueItem) {
                                                    return DropdownMenuItem(
                                                      value: valueItem,
                                                      child: Text(valueItem),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                // child: CupertinoDatePicker(
                                                //     initialDateTime: _dateTime,
                                                //     onDateTimeChanged: (dateTime) {
                                                //       print(dateTime);
                                                //       setState(() {
                                                //         _dateTime = dateTime;
                                                //       });
                                                //     }),
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  onDateTimeChanged: (value) {
                                                    time1 =
                                                        DateFormat('hh:mm a')
                                                            .format(value);
                                                  },
                                                  initialDateTime:
                                                      DateTime.now(),
                                                ),
                                              ),
                                              const Center(
                                                child: Text(
                                                  'Second Reading',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'OpenSans'),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 80, right: 80),
                                                child: DropdownButton(
                                                  hint: const Text(
                                                    'BreakFast',
                                                    style: const TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        //fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  dropdownColor: Colors.white,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 36,
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                  value: timeDay2,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      timeDay2 =
                                                          newValue as String?;
                                                    });
                                                  },
                                                  items:
                                                      listItem.map((valueItem) {
                                                    return DropdownMenuItem(
                                                      value: valueItem,
                                                      child: Text(valueItem),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                // child: CupertinoDatePicker(
                                                //     initialDateTime: _dateTime,
                                                //     onDateTimeChanged: (dateTime) {
                                                //       print(dateTime);
                                                //       setState(() {
                                                //         _dateTime = dateTime;
                                                //       });
                                                //     }),
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  onDateTimeChanged: (value) {
                                                    time2 =
                                                        DateFormat('hh:mm a')
                                                            .format(value);
                                                  },
                                                  initialDateTime:
                                                      DateTime.now(),
                                                ),
                                              ),
                                              const Center(
                                                child: Text(
                                                  'Third Reading',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'OpenSans'),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 80, right: 80),
                                                child: DropdownButton(
                                                  hint: const Text(
                                                    'BreakFast',
                                                    style: const TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        //fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  dropdownColor: Colors.white,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 36,
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                  value: timeDay3,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      valueServiceProvideName =
                                                          newValue as String?;
                                                    });
                                                  },
                                                  items:
                                                      listItem.map((valueItem) {
                                                    return DropdownMenuItem(
                                                      value: valueItem,
                                                      child: Text(valueItem),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                // child: CupertinoDatePicker(
                                                //     initialDateTime: _dateTime,
                                                //     onDateTimeChanged: (dateTime) {
                                                //       print(dateTime);
                                                //       setState(() {
                                                //         _dateTime = dateTime;
                                                //       });
                                                //     }),
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  onDateTimeChanged: (value) {
                                                    time3 =
                                                        DateFormat('hh:mm a')
                                                            .format(value);
                                                  },
                                                  initialDateTime:
                                                      DateTime.now(),
                                                ),
                                              ),
                                              const Center(
                                                child: Text(
                                                  'Fourth Reading',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'OpenSans'),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 80, right: 80),
                                                child: DropdownButton(
                                                  hint: const Text(
                                                    'BreakFast',
                                                    style: const TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        //fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  dropdownColor: Colors.white,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 36,
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                  value: timeDay4,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      timeDay4 =
                                                          newValue as String?;
                                                    });
                                                  },
                                                  items:
                                                      listItem.map((valueItem) {
                                                    return DropdownMenuItem(
                                                      value: valueItem,
                                                      child: Text(valueItem),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                // child: CupertinoDatePicker(
                                                //     initialDateTime: _dateTime,
                                                //     onDateTimeChanged: (dateTime) {
                                                //       print(dateTime);
                                                //       setState(() {
                                                //         _dateTime = dateTime;
                                                //       });
                                                //     }),
                                                child: CupertinoDatePicker(
                                                  mode: CupertinoDatePickerMode
                                                      .time,
                                                  onDateTimeChanged: (value) {
                                                    time4 =
                                                        DateFormat('hh:mm a')
                                                            .format(value);
                                                  },
                                                  initialDateTime:
                                                      DateTime.now(),
                                                ),
                                              ),
                                            ],
                                          )
                                        : widget.time == 5
                                            ? Column(
                                                children: [
                                                  const Center(
                                                    child: Text(
                                                      'First Reading',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 80, right: 80),
                                                    child: DropdownButton(
                                                      hint: const Text(
                                                        'BreakFast',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            //fontWeight: FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      dropdownColor:
                                                          Colors.white,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 36,
                                                      isExpanded: true,
                                                      underline:
                                                          const SizedBox(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                      value: timeDay1,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          timeDay1 = newValue
                                                              as String?;
                                                        });
                                                      },
                                                      items: listItem
                                                          .map((valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child:
                                                              Text(valueItem),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    // child: CupertinoDatePicker(
                                                    //     initialDateTime: _dateTime,
                                                    //     onDateTimeChanged: (dateTime) {
                                                    //       print(dateTime);
                                                    //       setState(() {
                                                    //         _dateTime = dateTime;
                                                    //       });
                                                    //     }),
                                                    child: CupertinoDatePicker(
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .time,
                                                      onDateTimeChanged:
                                                          (value) {
                                                        time1 = DateFormat(
                                                                'hh:mm a')
                                                            .format(value);
                                                      },
                                                      initialDateTime:
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                      'Second Reading',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 80, right: 80),
                                                    child: DropdownButton(
                                                      hint: const Text(
                                                        'BreakFast',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            //fontWeight: FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      dropdownColor:
                                                          Colors.white,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 36,
                                                      isExpanded: true,
                                                      underline:
                                                          const SizedBox(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                      value: timeDay2,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          timeDay2 = newValue
                                                              as String?;
                                                        });
                                                      },
                                                      items: listItem
                                                          .map((valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child:
                                                              Text(valueItem),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    // child: CupertinoDatePicker(
                                                    //     initialDateTime: _dateTime,
                                                    //     onDateTimeChanged: (dateTime) {
                                                    //       print(dateTime);
                                                    //       setState(() {
                                                    //         _dateTime = dateTime;
                                                    //       });
                                                    //     }),
                                                    child: CupertinoDatePicker(
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .time,
                                                      onDateTimeChanged:
                                                          (value) {
                                                        time2 = DateFormat(
                                                                'hh:mm a')
                                                            .format(value);
                                                      },
                                                      initialDateTime:
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                      'Third Reading',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 80, right: 80),
                                                    child: DropdownButton(
                                                      hint: const Text(
                                                        'BreakFast',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            //fontWeight: FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      dropdownColor:
                                                          Colors.white,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 36,
                                                      isExpanded: true,
                                                      underline:
                                                          const SizedBox(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                      value: timeDay3,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          timeDay3 = newValue
                                                              as String?;
                                                        });
                                                      },
                                                      items: listItem
                                                          .map((valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child:
                                                              Text(valueItem),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    // child: CupertinoDatePicker(
                                                    //     initialDateTime: _dateTime,
                                                    //     onDateTimeChanged: (dateTime) {
                                                    //       print(dateTime);
                                                    //       setState(() {
                                                    //         _dateTime = dateTime;
                                                    //       });
                                                    //     }),
                                                    child: CupertinoDatePicker(
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .time,
                                                      onDateTimeChanged:
                                                          (value) {
                                                        time3 = DateFormat(
                                                                'hh:mm a')
                                                            .format(value);
                                                      },
                                                      initialDateTime:
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                      'Fourth Reading',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 80, right: 80),
                                                    child: DropdownButton(
                                                      hint: const Text(
                                                        'BreakFast',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            //fontWeight: FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      dropdownColor:
                                                          Colors.white,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 36,
                                                      isExpanded: true,
                                                      underline:
                                                          const SizedBox(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                      value: timeDay4,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          timeDay4 = newValue
                                                              as String?;
                                                        });
                                                      },
                                                      items: listItem
                                                          .map((valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child:
                                                              Text(valueItem),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    // child: CupertinoDatePicker(
                                                    //     initialDateTime: _dateTime,
                                                    //     onDateTimeChanged: (dateTime) {
                                                    //       print(dateTime);
                                                    //       setState(() {
                                                    //         _dateTime = dateTime;
                                                    //       });
                                                    //     }),
                                                    child: CupertinoDatePicker(
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .time,
                                                      onDateTimeChanged:
                                                          (value) {
                                                        time4 = DateFormat(
                                                                'hh:mm a')
                                                            .format(value);
                                                      },
                                                      initialDateTime:
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                      'Fifth Reading',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'OpenSans'),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 80, right: 80),
                                                    child: DropdownButton(
                                                      hint: const Text(
                                                        'BreakFast',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            //fontWeight: FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      dropdownColor:
                                                          Colors.white,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 36,
                                                      isExpanded: true,
                                                      underline:
                                                          const SizedBox(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                      value: timeDay5,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          timeDay5 = newValue
                                                              as String?;
                                                        });
                                                      },
                                                      items: listItem
                                                          .map((valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child:
                                                              Text(valueItem),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    // child: CupertinoDatePicker(
                                                    //     initialDateTime: _dateTime,
                                                    //     onDateTimeChanged: (dateTime) {
                                                    //       print(dateTime);
                                                    //       setState(() {
                                                    //         _dateTime = dateTime;
                                                    //       });
                                                    //     }),
                                                    child: CupertinoDatePicker(
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .time,
                                                      onDateTimeChanged:
                                                          (value) {
                                                        time5 = DateFormat(
                                                                'hh:mm a')
                                                            .format(value);
                                                      },
                                                      initialDateTime:
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 80, right: 80),
                                                    child: DropdownButton(
                                                      hint: const Text(
                                                        'BreakFast',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'OpenSans',
                                                            //fontWeight: FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      dropdownColor:
                                                          Colors.white,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 36,
                                                      isExpanded: true,
                                                      underline:
                                                          const SizedBox(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                      value: timeDay1,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          timeDay1 = newValue
                                                              as String?;
                                                        });
                                                      },
                                                      items: listItem
                                                          .map((valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child:
                                                              Text(valueItem),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    // child: CupertinoDatePicker(
                                                    //     initialDateTime: _dateTime,
                                                    //     onDateTimeChanged: (dateTime) {
                                                    //       print(dateTime);
                                                    //       setState(() {
                                                    //         _dateTime = dateTime;
                                                    //       });
                                                    //     }),
                                                    child: CupertinoDatePicker(
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .time,
                                                      onDateTimeChanged:
                                                          (value) {
                                                        time1 = DateFormat(
                                                                'hh:mm a')
                                                            .format(value);
                                                      },
                                                      initialDateTime:
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Wrap(children: [
              BlueButton(
                onPressed: () {
                  setData();
                },
                title: 'Save & Add More',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
              ),
              BlueButton(
                onPressed: () {
                  // Navigator.pushNamed(context, moreSettingsScreen);
                  setSaveData();
                },
                title: 'Save',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  setData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    List<int> imageBytes = widget.image!.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    Map d = {
      "PrescriptionDetailId": 0,
      "PrescriptionScheduleId": 0,
      "PrescriptionId": widget.prescriptionId,
      "MedicineName": widget.medicineName,
      "MedicineId": 0,
      "MedicineTypeId": int.parse(widget.medicineTypeId.toString()),
      "MedicineUnitId": 0,
      "MedicineQuantity": int.parse(widget.quantity.toString()),
      "BeforeAfterFood": "Before Food",
      "ScheduleDate": "",
      "ScheduleTime": "",
      "ScheduleType": widget.type,
      "Everyday": "Yes",
      "Time1": time1 ?? DateTime.now().toString(),
      "Time2": time2,
      "Time3": time3,
      "Time4": time4,
      "Time5": time5,
      "TimeDay1": timeDay1,
      "TimeDay2": timeDay2,
      "TimeDay3": timeDay3,
      "TimeDay4": timeDay4,
      "TimeDay5": timeDay5,
      "Weekday": "",
      "Recurrencyday": null,
      "ImageBase64": base64Image,
      "DocumentPath": widget.image!.path,
      "UserId": int.parse(userId as String)
    };

    print(d.toString());
    var response = await http.post(
        Uri.parse('$BASE_URL/api/Medicine/SavePrescriptionDetails'),
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => addMed(widget.prescriptionId)));

        // Navigator.pushNamed(context, addMedicineScreen);
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

  setSaveData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    List<int> imageBytes = widget.image!.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    Map d = {
      "PrescriptionDetailId": 0,
      "PrescriptionScheduleId": 0,
      "PrescriptionId": widget.prescriptionId,
      "MedicineName": widget.medicineName,
      "MedicineId": 0,
      "MedicineTypeId": int.parse(widget.medicineTypeId.toString()),
      "MedicineUnitId": 0,
      "MedicineQuantity": int.parse(widget.quantity.toString()),
      "BeforeAfterFood": "Before Food",
      "ScheduleDate": "",
      "ScheduleTime": "",
      "ScheduleType": widget.type,
      "Everyday": "Yes",
      "Time1": time1 ?? DateTime.now().toString(),
      "Time2": time2,
      "Time3": time3,
      "Time4": time4,
      "Time5": time5,
      "TimeDay1": timeDay1,
      "TimeDay2": timeDay2,
      "TimeDay3": timeDay3,
      "TimeDay4": timeDay4,
      "TimeDay5": timeDay5,
      "Weekday": "",
      "Recurrencyday": null,
      "ImageBase64": base64Image,
      "DocumentPath": widget.image!.path,
      "UserId": int.parse(userId as String)
    };

    print(d.toString());
    var response = await http.post(
        Uri.parse('$BASE_URL/api/Medicine/SavePrescriptionDetails'),
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) => addMed(widget.prescriptionId)));

        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, prescriptionScreen);
        setState(() {
          isLoad = false;
        });
      }
      setState(() {
        isLoad = false;
        toast('Medicine Saved Sucessfully');
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
