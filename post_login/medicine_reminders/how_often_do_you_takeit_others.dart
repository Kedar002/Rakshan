import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/specific_days_of_th_week.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/padding.dart';
import '../../../widgets/pre_login/blue_button.dart';
import '../../../widgets/toast.dart';
import 'Every_number_of_days.dart';

class medicineHowOftenDoYouTakeOthers extends StatefulWidget {
  static String id = 'medicine_medicineHowOftenDoYouTake1';
  String? medicineName;
  int? prescriptionId;
  String? medicineTypeId;
  String? quantity;
  String? medicineTypeName;
  File? image;
  medicineHowOftenDoYouTakeOthers(
      {Key? key,
      this.medicineName,
      this.prescriptionId,
      this.medicineTypeId,
      this.quantity,
      this.medicineTypeName,
      this.image})
      : super(key: key);

  @override
  State<medicineHowOftenDoYouTakeOthers> createState() =>
      _medicineHowOftenDoYouTakeOthersState();
}

class _medicineHowOftenDoYouTakeOthersState
    extends State<medicineHowOftenDoYouTakeOthers> {
  bool isLoad = false;
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
                  padding: kScreenPadding,
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => specificDaysOfTheWeek(
                                      medicineTypeName: widget.medicineTypeName,
                                      medicineTypeId: widget.medicineTypeId,
                                      medicineName: widget.medicineName,
                                      prescriptionId: widget.prescriptionId,
                                      quantity: widget.quantity,
                                      image: widget.image,
                                      type: "Specific days of the Week",
                                      time: 7,
                                    )),
                          );
                        },
                        child: const ListTile(
                          title: Text('Specific days of the week'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => everyNumberOfDays(
                                      medicineTypeName: widget.medicineTypeName,
                                      medicineTypeId: widget.medicineTypeId,
                                      medicineName: widget.medicineName,
                                      prescriptionId: widget.prescriptionId,
                                      quantity: widget.quantity,
                                      image: widget.image,
                                      type: "Every number of days",
                                    )),
                          );
                        },
                        child: const ListTile(
                          title: Text('Every number of days'),
                        ),
                      ),
                      const ListTile(
                        title: Text(''),
                      ),
                    ],
                  ).toList(),
                )),
          ),
        ],
      ),
    );
  }
}
