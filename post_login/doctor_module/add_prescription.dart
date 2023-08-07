import 'dart:convert';

import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/doctor_controller.dart';
import 'package:Rakshan/main.dart';
import 'package:Rakshan/models/doctor_models/get_doctor_prescription.dart';
import 'package:Rakshan/screens/post_login/doctor_module/common_notepad_screen.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:signature/signature.dart';

class AddPrescription extends StatefulWidget {
  AddPrescription(
      {super.key,
      required this.id,
      required this.userid,
      required this.patientName});
  var id;
  var userid;
  var patientName;
  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  bool _isloading = true;
  List<dynamic> info = [];
  Uint8List? historyImage;
  Uint8List? diagnosisImage;
  Uint8List? adviceImage;
  var encodedHistoryImage;
  var encodedDiagnosisImage;
  var encodedAdviceImage;

  SignatureController historycontroller = SignatureController(
    penStrokeWidth: 1.0,
    penColor: Colors.black87,
    exportBackgroundColor: Colors.white70,
  );
  SignatureController diagnosiscontroller = SignatureController(
    penStrokeWidth: 1.0,
    penColor: Colors.black87,
    exportBackgroundColor: Colors.white70,
  );
  SignatureController advicecontroller = SignatureController(
    penStrokeWidth: 1.0,
    penColor: Colors.black87,
    exportBackgroundColor: Colors.white70,
  );

  @override
  void initState() {
    _isloading = true;
    fetch();
    super.initState();
  }

  fetch() async {
    var data = await DoctorController().getDoctorPrescriptionHeader(widget.id);
    info.addAll(data.data);
    _isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIndividual(title: 'Add Prescription'),
      body: _isloading == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Loading ...")
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ExpansionTile(
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          collapsedBackgroundColor: darkBlue,
                          backgroundColor: darkBlue,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${widget.patientName}',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                              if (info[0].age.toString() != null &&
                                  info[0].age.toString() != 'null')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${info[0].age.toString()} Years',
                                    style: kPrimaryWhiteTextStyle,
                                  ),
                                ),
                              if (info[0].gender.toString() != null &&
                                  info[0].gender.toString() != 'null')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    info[0].gender.toString(),
                                    // 'DOB : ',
                                    style: kPrimaryWhiteTextStyle,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (info[0].height.toString() != null &&
                                      info[0].height.toString() != 'null')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Height :  ${info[0].height.toString()}',
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    ),
                                  if (info[0].weight.toString() != null &&
                                      info[0].weight.toString() != 'null')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Weight :  ${info[0].weight.toString()}',
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // diabetic
                                  if (info[0].isdiabeticpatient.toString() !=
                                          null &&
                                      info[0].isdiabeticpatient.toString() !=
                                          'null' &&
                                      info[0].isdiabeticpatient.toString() !=
                                          'NA')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        info[0].isdiabeticpatient.toString(),
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    ),
                                  //heart patient
                                  if (info[0].isheartpatient.toString() !=
                                          null &&
                                      info[0].isheartpatient.toString() !=
                                          'null' &&
                                      info[0].isheartpatient.toString() != 'NA')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        info[0].isheartpatient.toString(),
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    ),
                                  //bloodgroup
                                  if (info[0].bloodgroup.toString() != null &&
                                      info[0].bloodgroup.toString() != 'null' &&
                                      info[0].bloodgroup.toString() != 'NA')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        info[0].bloodgroup.toString(),
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[200]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'BP as on',
                                              style: kPrimaryBlueTextStyle,
                                            ),
                                          ),
                                          if (info[0].lastBpDate.toString() !=
                                                  null &&
                                              info[0].lastBpDate.toString() !=
                                                  'null')
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                info[0].lastBpDate.toString(),
                                                style: kPrimaryBlueTextStyle,
                                              ),
                                            ),
                                          if (info[0].lastBpTime.toString() !=
                                                  null &&
                                              info[0].lastBpTime.toString() !=
                                                  'null')
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                info[0].lastBpTime.toString(),
                                                // 'DOB : ',
                                                style: kPrimaryBlueTextStyle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Sys High',
                                                  style: kPrimaryBlueTextStyle,
                                                ),
                                                if (info[0]
                                                            .sysHigh
                                                            .toString() !=
                                                        null &&
                                                    info[0]
                                                            .sysHigh
                                                            .toString() !=
                                                        'null')
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      info[0]
                                                          .sysHigh
                                                          .toString(),
                                                      // 'DOB : ',
                                                      style:
                                                          kPrimaryBlueTextStyle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Sys Low',
                                                  style: kPrimaryBlueTextStyle,
                                                ),
                                                if (info[0]
                                                            .dialLow
                                                            .toString() !=
                                                        null &&
                                                    info[0]
                                                            .dialLow
                                                            .toString() !=
                                                        'null')
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      info[0]
                                                          .dialLow
                                                          .toString(),
                                                      // 'DOB : ',
                                                      style:
                                                          kPrimaryBlueTextStyle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Pulse',
                                                  style: kPrimaryBlueTextStyle,
                                                ),
                                                if (info[0].pulse.toString() !=
                                                        null &&
                                                    info[0].pulse.toString() !=
                                                        'null')
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      info[0].pulse.toString(),
                                                      // 'DOB : ',
                                                      style:
                                                          kPrimaryBlueTextStyle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        color: darkBlue,
                                        indent: 5,
                                        endIndent: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Sugar as on',
                                              style: kPrimaryBlueTextStyle,
                                            ),
                                          ),
                                          if (info[0].lastBsDate.toString() !=
                                                  null &&
                                              info[0].lastBsDate.toString() !=
                                                  'null')
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                info[0].lastBsDate.toString(),
                                                style: kPrimaryBlueTextStyle,
                                              ),
                                            ),
                                          if (info[0].lastBsTime.toString() !=
                                                  null &&
                                              info[0].lastBsTime.toString() !=
                                                  'null')
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                info[0].lastBsTime.toString(),
                                                style: kPrimaryBlueTextStyle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Pre Meal : ',
                                                  style: kPrimaryBlueTextStyle,
                                                ),
                                                if (info[0]
                                                            .glucose
                                                            .toString() !=
                                                        null &&
                                                    info[0]
                                                            .glucose
                                                            .toString() !=
                                                        'null')
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      info[0]
                                                          .glucose
                                                          .toString(),
                                                      style:
                                                          kPrimaryBlueTextStyle,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Post Meal : ',
                                                    style:
                                                        kPrimaryBlueTextStyle,
                                                  ),
                                                  if (info[0]
                                                              .dialLow
                                                              .toString() !=
                                                          null &&
                                                      info[0]
                                                              .dialLow
                                                              .toString() !=
                                                          'null')
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        info[0]
                                                            .glucose
                                                            .toString(),
                                                        style:
                                                            kPrimaryBlueTextStyle,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'History',
                              style: kAppBarTextstyle,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  historycontroller.clear();
                                },
                                child: const Text(
                                  "Clear",
                                  style: TextStyle(fontSize: 14),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          darkBlue),
                                  // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  //     RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(18.0),
                                  //         side: BorderSide(color: darkBlue)))
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: darkBlue, width: 1),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Signature(
                          controller: historycontroller,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 500,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Diagnosis',
                                style: kAppBarTextstyle,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    diagnosiscontroller.clear();
                                  },
                                  child: const Text(
                                    "Clear",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            darkBlue),
                                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    //     RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(18.0),
                                    //         side: BorderSide(color: darkBlue)))
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: darkBlue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Signature(
                          controller: diagnosiscontroller,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 500,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),

                      // Container(
                      //   height: 100,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: darkBlue, width: 1),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      // ),
                      // TextFormField(
                      //   // controller: clientName,
                      //   // keyboardType: TextInputType.name,
                      //   decoration: kBigtextfieldDecoration('Tap to Add Cause'),
                      //   // validator: (value) {
                      //   //   if (value!.length > 1) {
                      //   //     return null;
                      //   //   } else {
                      //   //     return 'Enter Name';
                      //   //   }
                      //   // }
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Advice',
                                style: kAppBarTextstyle,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    advicecontroller.clear();
                                  },
                                  child: const Text(
                                    "Clear",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            darkBlue),
                                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    //     RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(18.0),
                                    //         side: BorderSide(color: darkBlue)))
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: darkBlue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Signature(
                          controller: advicecontroller,
                          // width: MediaQuery.of(context).size.width * 0.8,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 800,
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      // Container(
                      //   height: 100,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: darkBlue, width: 1),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      // ),
                      // TextFormField(
                      //   // controller: clientName,
                      //   // keyboardType: TextInputType.name,
                      //   decoration:
                      //       kBigtextfieldDecoration('Tap to Add'),
                      //   // validator: (value) {
                      //   //   if (value!.length > 1) {
                      //   //     return null;
                      //   //   } else {
                      //   //     return 'Enter Name';
                      //   //   }
                      //   // }
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      BlueButton(
                          onPressed: () async {
                            if (historycontroller.value.isNotEmpty) {
                              historyImage =
                                  await historycontroller.toPngBytes();
                              encodedHistoryImage =
                                  base64.encode(historyImage!);
                              print(encodedHistoryImage);
                              // historycontroller.clear();
                            } else {
                              encodedHistoryImage = '';
                            }
// >>>>>>>>>>>>>>>>>>>>
                            if (diagnosiscontroller.value.isNotEmpty) {
                              diagnosisImage =
                                  await diagnosiscontroller.toPngBytes();
                              encodedDiagnosisImage =
                                  base64.encode(diagnosisImage!);
                              print(encodedDiagnosisImage);
                              // diagnosiscontroller.clear();
                            } else {
                              encodedDiagnosisImage = '';
                            }
// >>>>>>>>>>>>>>>>>>>>
                            if (advicecontroller.value.isNotEmpty) {
                              adviceImage = await advicecontroller.toPngBytes();
                              encodedAdviceImage = base64.encode(adviceImage!);
                              print(encodedAdviceImage);
                              // advicecontroller.clear();
                            } else {
                              encodedAdviceImage = '';
                            }
                            // image = await controller.toImage();
                            var bpMeasureId = (info[0].bpMeasureIdNo !=
                                        'null' &&
                                    info[0].bpMeasureIdNo != null)
                                ? int.parse(info[0].bpMeasureIdNo.toString())
                                : 0;
                            var sugarMeasureId = (info[0].sugarMeasureIdNo !=
                                        'null' &&
                                    info[0].sugarMeasureIdNo != null)
                                ? int.parse(info[0].sugarMeasureIdNo.toString())
                                : 0;
                            print(info[0].sugarMeasureIdNo.toString());
                            print(info[0].bpMeasureIdNo.toString());
                            DoctorController()
                                .saveDoctorPrescription(
                                    prescriptionId: 1,
                                    appointmentId: widget.id,
                                    patientId: widget.userid,
                                    bpMeasureId: bpMeasureId,
                                    sugarMeasureId: sugarMeasureId,
                                    historyPath: encodedHistoryImage,
                                    diagnosisPath: encodedDiagnosisImage,
                                    advicePath: encodedAdviceImage,
                                    context: context)
                                .whenComplete((() {
                              historycontroller.clear();
                              diagnosiscontroller.clear();
                              advicecontroller.clear();
                              Navigator.pop(context);
                            }));
                          },
                          title: 'Save Prescription',
                          height: 45,
                          width: double.infinity),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
