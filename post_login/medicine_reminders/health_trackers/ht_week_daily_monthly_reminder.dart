import 'package:flutter/material.dart';

import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/weekly_reminder.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';

import '../../../../constants/padding.dart';
import 'daily_reminder.dart';
import 'monthly_reminder.dart';

class htWeeklyDailyMonthlyReminder extends StatefulWidget {
  static String id = 'medicine_medicineHowOftenDoYouTake1';
  String? reminderName;
  int? illnessId;
  String? diabetesStrips;
  String? insulinDozeQuantity;

  htWeeklyDailyMonthlyReminder({
    Key? key,
    this.reminderName,
    this.illnessId,
    this.diabetesStrips,
    this.insulinDozeQuantity,
  }) : super(key: key);

  @override
  State<htWeeklyDailyMonthlyReminder> createState() =>
      _htWeeklyDailyMonthlyReminderState();
}

class _htWeeklyDailyMonthlyReminderState
    extends State<htWeeklyDailyMonthlyReminder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff82B445),
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
                    'How often do you want to be reminded ?',
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
                          // Navigator.pushNamed(context, htDailyReminderScreen);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => htDailyReminder(
                                        reminderName: widget.reminderName,
                                        insulinDozeQuantity:
                                            widget.insulinDozeQuantity,
                                        illnessId: widget.illnessId,
                                        diabetesStrips: widget.diabetesStrips,
                                      )));
                        },
                        child: const ListTile(
                          title: Text('Daily'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, htWeeklyReminderScreen);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => htWeeklyReminder(
                                        reminderName: widget.reminderName,
                                        insulinDozeQuantity:
                                            widget.insulinDozeQuantity,
                                        illnessId: widget.illnessId,
                                        diabetesStrips: widget.diabetesStrips,
                                      )));
                        },
                        child: const ListTile(
                          title: Text('Weekly'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, htMonthlyReminderScreen);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => htMonthlyReminder(
                                        reminderName: widget.reminderName,
                                        insulinDozeQuantity:
                                            widget.insulinDozeQuantity,
                                        illnessId: widget.illnessId,
                                        diabetesStrips: widget.diabetesStrips,
                                      )));
                        },
                        child: const ListTile(
                          title: Text('Monthly'),
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
