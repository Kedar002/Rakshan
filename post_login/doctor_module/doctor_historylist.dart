import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/controller/update_doctor_appoitnment_controller.dart';
import 'package:Rakshan/screens/pdfview.dart';
import 'package:Rakshan/screens/post_login/doctor_module/add_prescription.dart';
import 'package:Rakshan/utills/progressIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controller/doctor_controller.dart';

class DoctorHistoryScreen extends StatefulWidget {
  @override
  State<DoctorHistoryScreen> createState() => _DoctorHistoryScreenState();
}

class _DoctorHistoryScreenState extends State<DoctorHistoryScreen> {
  late ProcessIndicatorDialog _progressIndicator;
  String remotePDFpath = '';
  String pathPDF = '';
  bool _isloading = true;
  List<dynamic> info = [];
  var listType = 'Approve';
  @override
  void initState() {
    _progressIndicator = ProcessIndicatorDialog(context);
    init();
    // TODO: implement initState
    super.initState();
  }

  init() {
    getData();
    _isloading = false;
  }

  void getData() async {
    var data;
    info.clear();
    data = await DoctorController().getDoctorPrescriptionHistory(listType);
    info.addAll(data.data);
    print("zoro $data");
    _isloading = false;
    print(DateTime.now().toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: const AppMenuForDoctor(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfffcfcfc),
        title: const Text(
          'Appointment History',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Color(0xff2e66aa),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
      ),
      body: _isloading
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
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(60, 30),
                          side: BorderSide(
                            color: darkBlue,
                          ),
                        ),
                        onPressed: () {
                          _isloading = true;
                          listType = 'Approve';
                          getData();
                        },
                        child: const Text(
                          'Visited',
                          style: kBlueTextstyle,
                        )),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(60, 30),
                          side: BorderSide(
                            color: darkBlue,
                          ),
                        ),
                        onPressed: () {
                          _isloading = true;
                          listType = 'cancel';
                          getData();
                        },
                        child: const Text(
                          'Cancelled',
                          style: kBlueTextstyle,
                        )),
                  ],
                ),
                info.length > 0
                    ? Expanded(
                        child: ListView.builder(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      info[index].patientName.toString(),
                                      style: kLabelTextStyle,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              DateFormat('dd-MMM-yyyy').format(
                                                  info[index].appoinmentDate),
                                              style: kLabelTextStyle,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              '${info[index].fromTime.toString()} - ${info[index].toTime.toString()}',
                                              style: kLabelTextStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (info[index].prescriptionIdNo != 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              print(
                                                  info[index].prescriptionIdNo);
                                              createFileOfPdfUrl(info[index]
                                                      .prescriptionIdNo)
                                                  .then((f) {
                                                setState(() {
                                                  remotePDFpath = f.path;
                                                });
                                              });
                                            },
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(darkBlue),
                                            ),
                                            child: const Text(
                                              "Prescription",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  if (info[index].prescriptionIdNo != 0) {
                                    _showPrescriptionUpdateDialog(
                                        context, index);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddPrescription(
                                                id: info[index].bookingId,
                                                userid: info[index].userId,
                                                patientName:
                                                    info[index].patientName,
                                              )),
                                    ).whenComplete(() => getData());
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      )
                    : Column(
                        children: const [
                          SizedBox(
                            height: 150,
                          ),
                          Center(
                            child: Text('Nothing to Load..'),
                          ),
                        ],
                      )
              ],
            ),
    );
  }

  _showPrescriptionUpdateDialog(context, int index) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title =
            "Do you want to create new prescription for this patient?";
        String message =
            "This will allow you to create new prescription and replace previous precription.";
        String btnLabel = "OK";
        String btnLabelCancel = "Cancel";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPrescription(
                                  id: info[index].bookingId,
                                  userid: info[index].userId,
                                  patientName: info[index].patientName,
                                )),
                      ).whenComplete(() {
                        setState(() {
                          Navigator.pop(context);
                          getData();
                        });
                      });
                    },
                  ),
                  TextButton(
                    child: Text(btnLabelCancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabel),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPrescription(
                                  id: info[index].bookingId,
                                  userid: info[index].userId,
                                  patientName: info[index].patientName,
                                )),
                      ).whenComplete(() {
                        setState(() {
                          Navigator.pop(context);
                          getData();
                        });
                      });
                    },
                  ),
                  TextButton(
                    child: Text(btnLabelCancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
      },
    );
  }

  Future<File> createFileOfPdfUrl(int? id) async {
    Completer<File> completer = Completer();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userToken = prefs.getString('data');
      final header = {'Authorization': 'Bearer $userToken'};
      _progressIndicator.show();
      var res = await http.get(
          Uri.parse(
              "$BASE_URL/api/Medicine/GetDoctorPriscriptionPdf?PrescriptionId=$id"),
          headers: header);

      _progressIndicator.hide();
      if (res.statusCode == 200 &&
          jsonDecode(res.body.toString())['data'] != null) {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 3),
          context,
          const CustomSnackBar.info(
            message: "File download at Downloads Folder in your device",
          ),
        );
        var data = jsonDecode(res.body.toString());
        Directory generalDownloadDir =
            Directory('/storage/emulated/0/Download');
        String name = (DateTime.now().microsecondsSinceEpoch).toString();
        File file =
            await File("${generalDownloadDir.path}/prescription$name.pdf")
                .create();
        Uint8List bytes = base64Decode(data['data']);
        await file.writeAsBytes(bytes);
        completer.complete(file);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pdf(path: file.path),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 3),
          context,
          const CustomSnackBar.info(
            message: "No link Available",
          ),
        );
      }
    } catch (e) {
      _progressIndicator.hide();
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }
}
//  '${info[index].patientName}',