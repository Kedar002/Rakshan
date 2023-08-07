import 'dart:convert';

import 'package:Rakshan/config/api_url_mapping.dart';
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/controller/user_prescription_controller.dart';
import 'package:Rakshan/screens/post_login/doctor_module/add_prescription.dart';
import 'package:Rakshan/screens/post_login/home_screen.dart';
import 'package:Rakshan/widgets/post_login/appMenuForDoctor.dart';
import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/wHistoryModal.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/doctor_controller.dart';
import 'user_prescription_details.dart';

class PrescriptionListScreen extends StatefulWidget {
  @override
  State<PrescriptionListScreen> createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  List<dynamic> info = [];
  @override
  void initState() {
    getData();
    setState(() {});
    // var data = await DoctorController().getDoctorPrescription();
    // info.addAll(data.data);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfffcfcfc),
        title: const Text(
          'Prescriptions',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Color(0xff2e66aa),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
      ),
      body: ListView.builder(
        itemCount: info.length,
        itemBuilder: ((context, index) {
          return Card(
            color: Colors.white,
            shadowColor: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
              // title: Text(
              //   info[index].patientName.toString(),
              //   style: kLabelTextStyle,
              // ),
              subtitle: Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPrescriptionDetail(
                                documentName: 'History',
                                documentPath:
                                    ('${info[index].historyPath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Text("history"),
                            const SizedBox(
                              height: 5,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  '$kBaseUrl/${info[index].historyPath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPrescriptionDetail(
                                documentName: 'Diagnosis',
                                documentPath:
                                    ('${info[index].diagnosisPath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Text("Diagnosis"),
                            const SizedBox(
                              height: 5,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  '$kBaseUrl/${info[index].diagnosisPath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPrescriptionDetail(
                                documentName: 'Advice',
                                documentPath:
                                    ('${info[index].advicePath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            const Text("Advice"),
                            const SizedBox(
                              height: 5,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  '$kBaseUrl/${info[index].advicePath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void getData() async {
    var data;
    data = await UserPrescriptionController()
        .getDoctorPrescriptionList(1); // send in booking id here

    info.addAll(data.data);
    print("zoro $data");
    setState(() {});
  }
}
//  '${info[index].patientName}', 
// CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(
//                       '$kBaseUrl/${info[index].historyPath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
//                 ),