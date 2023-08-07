import 'dart:convert';
import 'dart:io';
import 'package:Rakshan/constants/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:Rakshan/config/api_url_mapping.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/doctor_controller.dart';
import 'package:Rakshan/controller/user_prescription_controller.dart';
import 'package:Rakshan/models/doctor_models/get_doctor_prescription.dart';
import 'package:Rakshan/screens/post_login/doctor_module/common_notepad_screen.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

class UserPrescriptionInfo extends StatefulWidget {
  UserPrescriptionInfo({
    super.key,
    required this.id,
  });
  var id;
  @override
  State<UserPrescriptionInfo> createState() => _UserPrescriptionInfoState();
}

class _UserPrescriptionInfoState extends State<UserPrescriptionInfo> {
  var name;
  var userId;
  bool _isloading = true;
  List<dynamic> info = [];
  List<dynamic> imageData = [];
  Uint8List? historyImage;
  Uint8List? diagnosisImage;
  Uint8List? adviceImage;
  var encodedHistoryImage;
  var encodedDiagnosisImage;
  var encodedAdviceImage;

  var imagepath;
  var imagehistorypath;
  var imagediagnosispath;
  var imageadvicepath;

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
    fetch();
    super.initState();
  }

  fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('userName');
    userId = prefs.getString('userId');
    var data = await DoctorController().getDoctorPrescriptionHeader(widget.id);
    info.addAll(data.data);
    var getimages =
        await UserPrescriptionController().getDoctorPrescriptionList(widget.id);
    imageData.addAll(getimages.data);
    print(getimages);
    imagehistorypath = imageData[0].historyPath ??
        "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg";
    imagediagnosispath = imageData[0].diagnosisPath ??
        "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg";
    imageadvicepath = imageData[0].advicePath ??
        "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg";
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
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              name,
                              style: kPrimaryWhiteTextStyle,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (info[0].age.toString() != null &&
                                      info[0].age.toString() != 'null')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Age :  ${info[0].age.toString()}',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    ),
                                  if (info[0].gender.toString() != null &&
                                      info[0].gender.toString() != 'null')
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 40.0),
                                      child: Text(
                                        'Gender :  ${info[0].gender.toString()}',
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    ),
                                ],
                              ),
                              Row(
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
                                      padding:
                                          const EdgeInsets.only(left: 40.0),
                                      child: Text(
                                        'weight :  ${info[0].weight.toString()}',
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    )
                                ],
                              ),
                              Row(
                                children: [
                                  if (info[0].isdiabeticpatient.toString() !=
                                          null &&
                                      info[0].isdiabeticpatient.toString() !=
                                          'null')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Diabetic :  ${info[0].isdiabeticpatient.toString()}',
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    ),
                                  if (info[0].isheartpatient.toString() !=
                                          null &&
                                      info[0].isheartpatient.toString() !=
                                          'null')
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 40.0),
                                      child: Text(
                                        'B.P :  ${info[0].isheartpatient.toString()}',
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    )
                                ],
                              ),
                              Row(
                                children: [
                                  if (info[0].bloodgroup.toString() != null &&
                                      info[0].bloodgroup.toString() != 'null')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'B.P :  ${info[0].bloodgroup.toString()}',
                                        // 'DOB : ',
                                        style: kPrimaryWhiteTextStyle,
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                          children: [
                            if (info[0].lastBpDate.toString() != null &&
                                info[0].lastBpDate.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Last B.P Measure Date :  ${info[0].lastBpDate.toString()}',
                                  // 'DOB : ',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                            if (info[0].lastBpTime.toString() != null &&
                                info[0].lastBpTime.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Last B.P Measure Time :  ${info[0].lastBpTime.toString()}',
                                  // 'DOB : ',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                            if (info[0].sysHigh.toString() != null &&
                                info[0].sysHigh.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sys High :  ${info[0].sysHigh.toString()}',
                                  // 'DOB : ',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                            if (info[0].dialLow.toString() != null &&
                                info[0].dialLow.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sys Low :  ${info[0].dialLow.toString()}',
                                  // 'DOB : ',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                            if (info[0].pulse.toString() != null &&
                                info[0].pulse.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Pulse :  ${info[0].pulse.toString()}',
                                  // 'DOB : ',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                            if (info[0].lastBsDate.toString() != null &&
                                info[0].lastBsDate.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Last BS Date :  ${info[0].lastBsDate.toString()}',
                                  // 'DOB : ',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                            if (info[0].lastBsTime.toString() != null &&
                                info[0].lastBsTime.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Last BS Time :  ${info[0].lastBsTime.toString()}',
                                  // 'DOB : ',
                                  style: kPrimaryWhiteTextStyle,
                                ),
                              ),
                            if (info[0].glucose.toString() != null &&
                                info[0].glucose.toString() != 'null')
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Glucose :  ${info[0].glucose.toString()}',
                                      // 'DOB : ',
                                      style: kPrimaryWhiteTextStyle,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    if (info[0].prePostMeal.toString() !=
                                            null &&
                                        info[0].prePostMeal.toString() !=
                                            'null')
                                      Text(
                                        info[0].prePostMeal.toString(),
                                        style: kPrimaryTextStyle,
                                      )
                                  ],
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
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: darkBlue),
                                  onPressed: () {
                                    shareImage(imagehistorypath);
                                  },
                                  icon: const Icon(Icons.share),
                                  label: const Text('Share')),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: darkBlue, width: 1),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: ClipRRect(
                          child: Image.network(
                            '$kBaseUrl/$imagehistorypath',
                            fit: BoxFit.contain,
                          ),
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
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: darkBlue),
                                    onPressed: () {
                                      shareImage(imagediagnosispath);
                                    },
                                    icon: const Icon(Icons.share),
                                    label: const Text('Share')),
                              ),
                            ]),
                      ),
                      Container(
                        height: 500,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: darkBlue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          child: Image.network(
                            '$kBaseUrl/$imagediagnosispath',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: darkBlue),
                                    onPressed: () {
                                      shareImage(imageadvicepath);
                                    },
                                    icon: const Icon(Icons.share),
                                    label: const Text('Share')),
                              ),
                            ]),
                      ),
                      Container(
                        height: 600,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: darkBlue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          child: Image.network(
                            '$kBaseUrl/$imageadvicepath',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
//                       BlueButton(
//                           onPressed: () async {
//                             historyImage = await historycontroller.toPngBytes();
//                             encodedHistoryImage = base64.encode(historyImage!);
//                             print(encodedHistoryImage);
//                             // historycontroller.clear();
// // >>>>>>>>>>>>>>>>>>>>
//                             diagnosisImage =
//                                 await diagnosiscontroller.toPngBytes();
//                             encodedDiagnosisImage =
//                                 base64.encode(diagnosisImage!);
//                             print(encodedDiagnosisImage);
//                             // diagnosiscontroller.clear();
// // >>>>>>>>>>>>>>>>>>>>
//                             adviceImage = await advicecontroller.toPngBytes();
//                             encodedAdviceImage = base64.encode(adviceImage!);
//                             print(encodedAdviceImage);
//                             // advicecontroller.clear();
//                             // image = await controller.toImage();

//                             DoctorController()
//                                 .saveDoctorPrescription(
//                                     prescriptionId: 1,
//                                     appointmentId: widget.id,
//                                     patientId: userId,
//                                     bpMeasureId: int.parse(
//                                         info[0].bpMeasureIdNo.toString()),
//                                     sugarMeasureId: int.parse(
//                                         info[0].sugarMresureIdNo.toString()),
//                                     historyPath: encodedHistoryImage,
//                                     diagnosisPath: encodedDiagnosisImage,
//                                     advicePath: encodedAdviceImage,
//                                     context: context)
//                                 .whenComplete((() {
//                               historycontroller.clear();
//                               diagnosiscontroller.clear();
//                               advicecontroller.clear();
//                             }));
//                             setState(() {});
//                           },
//                           title: 'Save Prescription',
//                           height: 45,
//                           width: double.infinity),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  shareImage(documentPath) async {
    final urlImage = '$kBaseUrl/$documentPath';
    final url = Uri.parse(urlImage);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: '');
  }
}
