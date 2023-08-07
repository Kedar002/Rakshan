import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/first_page_of_health_tracker.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';

import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import 'ht_week_daily_monthly_reminder.dart';

class reminderStripDoze extends StatefulWidget {
  // static String id = 'htReminders';
  String? reminderName;
  int? illnessId;

  reminderStripDoze({
    Key? key,
    this.reminderName,
    this.illnessId,
  }) : super(key: key);
  @override
  State<reminderStripDoze> createState() => _reminderStripDozeState();
}

class _reminderStripDozeState extends State<reminderStripDoze> {
  List<String> items = [
    'Reminder 1',
  ];

  final _stripController = TextEditingController();
  final _dozeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff82B445),
      appBar: AppBarIndividual(title: 'Rakshan'),
      body: Column(
        children: [
          Container(
            padding: kScreenPadding,
            child: Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Add Health Tracker Reminder Title',
                    style: TextStyle(fontSize: 20, fontFamily: 'OpeanSans'),
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
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Diabetes Strips';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: _stripController,
                      decoration: ktextfieldDecoration('Diabetes Strips'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Insulin Doze Quantity';
                        }
                        return null;
                      },
                      controller: _dozeController,
                      keyboardType: TextInputType.number,
                      decoration: ktextfieldDecoration('Insulin Doze Quantity'),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => htWeeklyDailyMonthlyReminder(
                          reminderName: widget.reminderName,
                          illnessId: widget.illnessId,
                          diabetesStrips: _stripController.text.trim(),
                          insulinDozeQuantity: _dozeController.text.trim(),
                        )));
          }
        },
        title: 'Next',
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
