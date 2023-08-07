import 'dart:async';
import 'dart:convert';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/controller/update_doctor_appoitnment_controller.dart';
import 'package:Rakshan/models/doctor_models/get_doctor_prescription.dart';
import 'package:Rakshan/screens/post_login/doctor_module/add_prescription.dart';
import 'package:Rakshan/screens/post_login/doctor_module/doctor_historylist.dart';
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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/doctor_controller.dart';

class DoctorScreen extends StatefulWidget {
  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  bool _isloading = true;
  bool _dLoading = true;
  List<dynamic> info = [];

  Timer? timer;

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }

  init() {
    getData();
    setRefetchTimer();
  }

  void getData() async {
    GetDoctorPrescription data;
    info.clear();

    data = await DoctorController().getDoctorPrescription();
    info.addAll(data.data);
    print("zoro $info");
    _dLoading = false;
    if (mounted) {
      setState(() {
        // Your state change code goes here
      });
    }
  }

  setRefetchTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => getData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const AppMenuForDoctor(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xfffcfcfc),
          title: const Text(
            'My Appointments',
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Color(0xff2e66aa),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorHistoryScreen()),
                );
              },
              icon: const Icon(Icons.work_history_outlined),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  getData();
                },
                icon: const Icon(Icons.replay_outlined),
              ),
            ),
          ],
          iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
        ),
        body: _dLoading
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
            : info.isNotEmpty
                ? ListView.builder(
                    itemCount: info.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 20.0),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  info[index].patientName.toString(),
                                  style: kLabelTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                info[index].status.toString(),
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        DateFormat('dd-MMM-yyyy')
                                            .format(info[index].appoinmentDate),
                                        style: kLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        '${info[index].fromTime.toString()} - ${info[index].toTime.toString()}',
                                        style: kLabelTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: TextButton(
                                      onPressed: () {
                                        _isloading = true;
                                        UpdateDocotrAppointmentController()
                                            .updateDocotrAppointment(
                                                id: info[index]
                                                    .bookingId
                                                    .toString(),
                                                taskName: 'Approve',
                                                patientId: info[index]
                                                    .userId
                                                    .toString(),
                                                context: context)
                                            .whenComplete(() {
                                          getData();
                                          _isloading = false;
                                          setState(() {});
                                        });
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                darkBlue),
                                        // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        //     RoundedRectangleBorder(
                                        //         borderRadius: BorderRadius.circular(18.0),
                                        //         side: BorderSide(color: darkBlue)))
                                      ),
                                      child: const Text(
                                        "Visited",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: TextButton(
                                      onPressed: () {
                                        _isloading = true;
                                        UpdateDocotrAppointmentController()
                                            .updateDocotrAppointment(
                                                id: info[index]
                                                    .bookingId
                                                    .toString(),
                                                taskName: 'Cancel',
                                                patientId: info[index]
                                                    .userId
                                                    .toString(),
                                                context: context)
                                            .whenComplete(() {
                                          getData();
                                          _isloading = false;
                                          setState(() {});
                                        });
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                darkBlue),
                                        // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        //     RoundedRectangleBorder(
                                        //         borderRadius: BorderRadius.circular(18.0),
                                        //         side: BorderSide(color: darkBlue)))
                                      ),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPrescription(
                                        id: info[index].bookingId,
                                        userid: info[index].userId,
                                        patientName: info[index].patientName,
                                      )),
                            ).whenComplete(() => getData());
                          },
                        ),
                      );
                    }),
                  )
                : const Center(
                    child: Text('No appointmnets found.'),
                  ));
  }
}
//  '${info[index].patientName}',