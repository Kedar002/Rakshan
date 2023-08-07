import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/how_often_do_you_takeit.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/how_often_do_you_takeit_1.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/how_often_do_you_takeit_2.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/how_often_do_you_takeit_others.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/padding.dart';
import '../../../widgets/post_login/app_bar.dart';
import '../../../widgets/pre_login/blue_button.dart';
import '../../../widgets/toast.dart';
import 'add_med.dart';

class medicineEveryday extends StatefulWidget {
  static String id = 'medicine_everyday';

  String? medicineName;
  int? prescriptionId;
  String? medicineTypeId;
  String? quantity;
  String? timeOfMedicine;
  String? medicineTypeName;
  File? image;

  medicineEveryday(
      {Key? key,
      this.medicineName,
      this.prescriptionId,
      this.timeOfMedicine,
      this.medicineTypeId,
      this.quantity,
      this.medicineTypeName,
      this.image})
      : super(key: key);

  @override
  State<medicineEveryday> createState() => _medicineEverydayState();
}

class _medicineEverydayState extends State<medicineEveryday> {
  String? valueServiceProvideName;

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Yes", "No", "Other", "Only When Needed"];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  bool isLoad = false;
  String? _selectedGender = "Yes";

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
                          'Do you need to take this everyday ?',
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
                    child: ListView(children: [
                      Container(
                        padding: const EdgeInsets.all(80),
                        child: DropdownButton<String>(
                          value: _selectedGender,
                          items: _dropDownItem(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                            switch (value) {
                              case "Yes":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          medicineHowOftenDoYouTake1(
                                            medicineTypeName:
                                                widget.medicineTypeName,
                                            medicineTypeId:
                                                widget.medicineTypeId,
                                            medicineName: widget.medicineName,
                                            prescriptionId:
                                                widget.prescriptionId,
                                            quantity: widget.quantity,
                                            image: widget.image,
                                          )),
                                );
                                break;
                              case "No":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          medicineHowOftenDoYouTake2(
                                            medicineTypeName:
                                                widget.medicineTypeName,
                                            medicineTypeId:
                                                widget.medicineTypeId,
                                            medicineName: widget.medicineName,
                                            prescriptionId:
                                                widget.prescriptionId,
                                            quantity: widget.quantity,
                                            image: widget.image,
                                          )),
                                );
                                break;
                              case "Other":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          medicineHowOftenDoYouTakeOthers(
                                            medicineTypeName:
                                                widget.medicineTypeName,
                                            medicineTypeId:
                                                widget.medicineTypeId,
                                            medicineName: widget.medicineName,
                                            prescriptionId:
                                                widget.prescriptionId,
                                            quantity: widget.quantity,
                                            image: widget.image,
                                          )),
                                );
                                break;
                              case "Only When Needed":
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           medicineHowOftenDoYouTake(
                                //             medicineTypeName: widget.medicineTypeName,
                                //             medicineTypeId: widget.medicineTypeId,
                                //             medicineName: widget.medicineName,
                                //             prescriptionId: widget.prescriptionId,
                                //             quantity: widget.quantity,
                                //             image: widget.image,
                                //           )),
                                // );

                                break;
                            }
                          },
                          hint: Text('Select Option'),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            floatingActionButton: BlueButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => medicineHowOftenDoYouTake1(
                            medicineTypeName: widget.medicineTypeName,
                            medicineTypeId: widget.medicineTypeId,
                            medicineName: widget.medicineName,
                            prescriptionId: widget.prescriptionId,
                            quantity: widget.quantity,
                            image: widget.image,
                          )),
                );
              },
              title: 'Next',
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
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
      "ScheduleType": "Only When Needed",
      "Everyday": "Only When Needed",
      "Time1": null,
      "Time2": null,
      "Time3": null,
      "Time4": null,
      "Time5": null,
      "TimeDay1": null,
      "TimeDay2": null,
      "TimeDay3": null,
      "TimeDay4": null,
      "TimeDay5": null,
      "Weekday": null,
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
}
