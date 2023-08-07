import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/first_page_of_health_tracker.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';

import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';

class htRemindersTitle extends StatefulWidget {
  // static String id = 'htReminders';

  @override
  State<htRemindersTitle> createState() => _htRemindersTitleState();
}

class _htRemindersTitleState extends State<htRemindersTitle> {
  List<String> items = [
    'Reminder 1',
  ];

  final _titleController = TextEditingController();
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
                          return 'Enter Reminder title';
                        }
                        return null;
                      },
                      controller: _titleController,
                      decoration: ktextfieldDecoration('Reminder Title'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
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
                    builder: (context) =>
                        firstPageHT(_titleController.text.trim())));
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
