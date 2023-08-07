import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/specific_days_of_th_week.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/padding.dart';
import '../../../widgets/post_login/app_bar.dart';
import '../../../widgets/pre_login/blue_button.dart';
import '../../../widgets/toast.dart';

class medicineHowOftenDoYouTake2 extends StatefulWidget {
  static String id = 'medicine_medicineHowOftenDoYouTake2';
  String? medicineName;
  int? prescriptionId;
  String? medicineTypeId;
  String? quantity;
  String? medicineTypeName;
  File? image;
  medicineHowOftenDoYouTake2(
      {Key? key,
      this.medicineName,
      this.prescriptionId,
      this.medicineTypeId,
      this.quantity,
      this.medicineTypeName,
      this.image})
      : super(key: key);

  @override
  State<medicineHowOftenDoYouTake2> createState() =>
      _medicineHowOftenDoYouTake2State();
}

class _medicineHowOftenDoYouTake2State
    extends State<medicineHowOftenDoYouTake2> {
  String? valueServiceProvideName = 'Once a week';

  List listItem = [
    'Once a week',
    'Twice a week',
    'Thrice a week',
    '4 Days a week',
    '5 Days a week',
    '6 Days a week',
  ];
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
                children: [
                  Container(
                    padding: EdgeInsets.all(80),
                    child: DropdownButton(
                      hint: Text(
                        'Once a week',
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
                builder: (context) => specificDaysOfTheWeek(
                      medicineTypeName: widget.medicineTypeName,
                      medicineTypeId: widget.medicineTypeId,
                      medicineName: widget.medicineName,
                      prescriptionId: widget.prescriptionId,
                      quantity: widget.quantity,
                      image: widget.image,
                      type: valueServiceProvideName,
                      time: valueServiceProvideName == "Once a week"
                          ? 1
                          : valueServiceProvideName == "Twice a week"
                              ? 2
                              : valueServiceProvideName == "Thrice a week"
                                  ? 3
                                  : valueServiceProvideName == "4 Days a week"
                                      ? 4
                                      : valueServiceProvideName ==
                                              "5 Days a week"
                                          ? 5
                                          : valueServiceProvideName ==
                                                  "6 Days a week"
                                              ? 6
                                              : 1,
                    )),
          );
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
    //           child: const Text('2'), //'How often do you take it ?'),
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

  setData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");

    Map d = {
      "PrescriptionDetailId": 0,
      "PrescriptionScheduleId": 0,
      "PrescriptionId": widget.prescriptionId,
      "MedicineName": widget.medicineName,
      "MedicineId": 0,
      "MedicineTypeId": widget.medicineTypeId,
      "MedicineUnitId": 0,
      "MedicineQuantity": int.parse(widget.quantity.toString()),
      "BeforeAfterFood": "Before Food",
      "ScheduleDate": "25/12/2022",
      "ScheduleTime": "15:30:00",
      "ScheduleType": "Specific Days of the week",
      "Everyday": "Other",
      "Time1": null,
      "Time2": null,
      "Time3": null,
      "Time4": null,
      "Time5": null,
      "Weekday": "Monday,Friday,Sturday,Sunday",
      "Recurrencyday": null,
      "ImageBase64": "",
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) => addMed(data['id'])));

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
