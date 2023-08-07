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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants/padding.dart';
import '../../../widgets/pre_login/blue_button.dart';
import '../../../widgets/toast.dart';
import 'add_med.dart';

class everyNumberOfDays extends StatefulWidget {
  static String id = 'medicine_medicineHowOftenDoYouTake1';
  String? medicineName;
  int? prescriptionId;
  String? medicineTypeId;
  String? quantity;
  String? medicineTypeName;
  File? image;
  String? type;

  everyNumberOfDays(
      {Key? key,
      this.medicineName,
      this.prescriptionId,
      this.medicineTypeId,
      this.quantity,
      this.medicineTypeName,
      this.image,
      this.type})
      : super(key: key);
  @override
  State<everyNumberOfDays> createState() => _everyNumberOfDaysState();
}

class _everyNumberOfDaysState extends State<everyNumberOfDays> {
  bool isLoad = false;
  String? time1;
  int _currentValue = 3;

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
      "Everyday": "Other",
      "Time1": time1 ?? DateTime.now().toString(),
      "Time2": null,
      "Time3": null,
      "Time4": null,
      "Time5": null,
      "TimeDay1": null,
      "TimeDay2": null,
      "TimeDay3": null,
      "TimeDay4": null,
      "TimeDay5": null,
      "Weekday": "",
      "Recurrencyday": _currentValue,
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
      "Everyday": "Other",
      "Time1": time1,
      "Time2": null,
      "Time3": null,
      "Time4": null,
      "Time5": null,
      "TimeDay1": null,
      "TimeDay2": null,
      "TimeDay3": null,
      "TimeDay4": null,
      "TimeDay5": null,
      "Weekday": "",
      "Recurrencyday": _currentValue,
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
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => addMed(widget.prescriptionId)));

        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, prescriptionScreen);
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
