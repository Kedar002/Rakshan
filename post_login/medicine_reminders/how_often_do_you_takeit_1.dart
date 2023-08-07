import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/time_of_dose.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/padding.dart';
import '../../../widgets/pre_login/blue_button.dart';
import '../../../widgets/toast.dart';

class medicineHowOftenDoYouTake1 extends StatefulWidget {
  static String id = 'medicine_medicineHowOftenDoYouTake1';
  String? medicineName;
  int? prescriptionId;
  String? medicineTypeId;
  String? quantity;
  String? medicineTypeName;
  File? image;

  medicineHowOftenDoYouTake1(
      {Key? key,
      this.medicineName,
      this.prescriptionId,
      this.medicineTypeId,
      this.quantity,
      this.medicineTypeName,
      this.image})
      : super(key: key);

  @override
  State<medicineHowOftenDoYouTake1> createState() =>
      _medicineHowOftenDoYouTake1State();
}

class _medicineHowOftenDoYouTake1State
    extends State<medicineHowOftenDoYouTake1> {
  String? valueServiceProvideName = "Once Daily";
  bool isLoad = false;
  List listItem = [
    'Once Daily',
    'Twice Daily',
    '3',
    '4',
    '5',
    'Every 6 Hours',
  ];

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
                    'How often do you take it ?',
                    style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
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
                  Container(
                    padding: EdgeInsets.all(80),
                    child: DropdownButton(
                      hint: Text(
                        'Once Daily',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            //fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      value: valueServiceProvideName,
                      onChanged: (newValue) {
                        setState(() {
                          valueServiceProvideName = newValue as String?;
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
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BlueButton(
        onPressed: () {
          // Navigator.pushNamed(context, medicineTimeScreen);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => medicineTime(
                        medicineTypeName: widget.medicineTypeName,
                        medicineTypeId: widget.medicineTypeId,
                        medicineName: widget.medicineName,
                        prescriptionId: widget.prescriptionId,
                        quantity: widget.quantity,
                        image: widget.image,
                        type: valueServiceProvideName,
                        time: valueServiceProvideName == "Once Daily"
                            ? 1
                            : valueServiceProvideName == "Twice Daily"
                                ? 2
                                : valueServiceProvideName == "3"
                                    ? 3
                                    : valueServiceProvideName == "4"
                                        ? 4
                                        : valueServiceProvideName == "5"
                                            ? 5
                                            : valueServiceProvideName ==
                                                    "Every 6 Hours"
                                                ? 4
                                                : 1,
                      )));
        },
        title: 'Next',
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
    //           child: const Text('1'), //'How often do you take it ?'),
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
    //                     'Once Daily',
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
}
