import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/cancel_appointment_controller.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/user_prescription.dart';
import 'package:Rakshan/screens/post_login/payment.dart';
import 'package:Rakshan/screens/post_login/user_prescription_new.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../models/appointmentHistoryModel.dart';
import '../../utills/progressIndicator.dart';
import '../pdfview.dart';
import 'claim_process_ipd.dart';

class AppointmentHistory extends StatefulWidget {
  @override
  State<AppointmentHistory> createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  final cancelAppointment = CancelAppointmentController();
  late ProcessIndicatorDialog _progressIndicator;
  String remotePDFpath = '';
  String pathPDF = '';

  bool isloading = false;

  @override
  void initState() {
    _progressIndicator = ProcessIndicatorDialog(context);
    super.initState();
    getAppointmentHistory();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            'radiobutton', (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, radioButton);
            }, // Handle your on tap here.
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xfffcfcfc),
          title: const Text(
            'Appointment History',
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Color(0xff2e66aa),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.replay_outlined),
              ),
            ),
          ],
          iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
        ),
        // AppBarIndividual(title: 'Appointment History'),
        body: isloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Processing Cancellation Request...")
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: FutureBuilder<List<appointmentHistory>>(
                        future: getAppointmentHistory(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<appointmentHistory>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<appointmentHistory?> aData = snapshot.data!;
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return ListView.builder(
                                // reverse: true,
                                itemCount: aData.length,
                                itemBuilder: (BuildContext context, int i) {
                                  appointmentHistory? info = aData[i];
                                  //=================DATE=============================
                                  String sAppointmentDate = info!.appoinmentDate
                                      .toString()
                                      .replaceAll('/', '-');
                                  DateTime dAppointmentDate =
                                      DateTime.parse("$sAppointmentDate");
                                  // DateTime.parse("2012-02-27 13:27:00");
                                  var newDate = DateTime(
                                      dAppointmentDate.year,
                                      dAppointmentDate.month,
                                      dAppointmentDate.day + 2);
                                  var inputDate = DateTime.parse(
                                      dAppointmentDate.toString());
                                  var now1 = DateTime.now();
                                  print('date now = $now1');
                                  print('newDate = $newDate');
                                  print('AppointmentDate = $dAppointmentDate');
                                  print(
                                      'difference is ${newDate.compareTo(dAppointmentDate)}');
                                  print(
                                      'difference == ${dAppointmentDate.compareTo(now1)}');
                                  print('\n');

                                  var outputFormat = DateFormat('dd/MM/yyyy');
                                  var outputDate =
                                      outputFormat.format(inputDate);
                                  String sAppointmentDateFinal =
                                      outputDate.toString().split(' ').first;

                                  //=================DATE=============================
                                  //=================TIME=============================
                                  var now = DateFormat('HH:mm:ss')
                                      .format(DateTime.now());

                                  int iTimeNow = int.parse(
                                      now.toString().split(':').join(''));
                                  // print('Now time = $iTimeNow');

                                  DateTime date2 = DateFormat.jm()
                                      .parse(info.fromTime.toString());
                                  String sDateTimeFrom =
                                      date2.toString().split(" ").last;
                                  String sTime = sDateTimeFrom.split(".").first;
                                  int iTimeFrom =
                                      int.parse(sTime.split(":").join(""));
                                  // int iFromTime = int.parse(
                                  //     info.fromTime.toString().split(":").first);
                                  // print('From time = $iTimeFrom');

                                  //=================TIME=============================
                                  return Card(
                                    color: Colors.white,
                                    shadowColor: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            info.day.toString(),
                                            style: kMessageTextStyle,
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xfff5f5f5)),
                                              child: Text(
                                                sAppointmentDateFinal,
                                                style: kMessageTextStyle,
                                              )),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //From date to date
                                          VerticalHeight(),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'From : ${info.fromTime.toString()}',
                                                  style: kMessageTextStyle,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                ),
                                                Text(
                                                  'To : ${info.toTime.toString()}',
                                                  style: kMessageTextStyle,
                                                ),
                                              ]),
                                          VerticalHeight(),
                                          //Service Provider
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Service Provider',
                                                  style: kDarkgreyTextstyle,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    info.serviceProvider
                                                        .toString(),
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: kBlueTextstyle,
                                                  ),
                                                ),
                                              ]),
                                          VerticalHeight(),
                                          //Doctor name
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Doctor Name',
                                                  style: kDarkgreyTextstyle,
                                                ),
                                                Flexible(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                  ),
                                                ),
                                                Text(
                                                  info.doctorName.toString(),
                                                  style: kBlueTextstyle,
                                                  maxLines: 4,
                                                ),
                                              ]),
                                          VerticalHeight(),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Patient Name',
                                                  style: kDarkgreyTextstyle,
                                                ),
                                                Flexible(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                  ),
                                                ),
                                                Text(
                                                  info.patient_Name.toString(),
                                                  style: kBlueTextstyle,
                                                  maxLines: 4,
                                                ),
                                              ]),
                                          VerticalHeight(),
                                          //Appointment Status
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Appointment Status',
                                                  style: kDarkgreyTextstyle,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                ),
                                                Text(
                                                  info.status.toString(),
                                                  style: kBlueTextstyle,
                                                ),
                                              ]),
                                          VerticalHeight(),
                                          //Payment Type
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Payment Type',
                                                  style: kDarkgreyTextstyle,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                ),
                                                Text(
                                                  info.paymentType.toString(),
                                                  style: kBlueTextstyle,
                                                ),
                                              ]),
                                          VerticalHeight(),
                                          //Paid Amount
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Paid Amount',
                                                  style: kDarkgreyTextstyle,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                ),
                                                Text(
                                                  info.paidAmount.toString(),
                                                  style: kBlueTextstyle,
                                                ),
                                              ]),
                                          VerticalHeight(),
                                          //Payment Status
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                if (info.paymentStatus != null)
                                                  info.paymentStatus == null
                                                      ? SizedBox()
                                                      : const Text(
                                                          'Payment Status',
                                                          style:
                                                              kDarkgreyTextstyle,
                                                        ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                ),
                                                if (info.paymentStatus != null)
                                                  VerticalHeight(),
                                                info.paymentStatus == null
                                                    ? const SizedBox()
                                                    : Text(
                                                        info.paymentStatus
                                                            .toString(),
                                                        style: kBlueTextstyle,
                                                      ),
                                              ]),

                                          info.paymentType == "Cash on Desk" &&
                                                  info.status == 'visited' &&
                                                  (dAppointmentDate.compareTo(
                                                          DateUtils.dateOnly(
                                                              DateTime.now())) <
                                                      0)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                      Flexible(
                                                        child: TextButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ClaimProcessIPD(
                                                                      sProviderTypeId: int.parse(info
                                                                          .clientTypeId
                                                                          .toString()),
                                                                      //in 1st dropdownn
                                                                      sClientId: int.parse(info
                                                                          .clientId
                                                                          .toString()),
                                                                      //2nd dropdown
                                                                      sServiceNameId: int.parse(info
                                                                          .serviceId
                                                                          .toString()),
                                                                      //3rd dropdown
                                                                      sClientTypeName: info
                                                                          .clientTypeName
                                                                          .toString(),

                                                                      // in 1st drop hint
                                                                      sClientName: info
                                                                          .serviceProvider
                                                                          .toString(),

                                                                      // in 2nd drop hint
                                                                      sServiceName: info
                                                                          .serviceName
                                                                          .toString(),

                                                                      //in 3rd dropdown hint
                                                                      nInstantDiscount: (info.instantDiscount !=
                                                                              null
                                                                          ? info
                                                                              .instantDiscount
                                                                              .toString()
                                                                          : '0.0'),

                                                                      nCashbackDiscount: (info.cashbackDiscount !=
                                                                              null
                                                                          ? info
                                                                              .cashbackDiscount
                                                                              .toString()
                                                                          : '0.0'),

                                                                      sServiceType: info
                                                                          .serviceName
                                                                          .toString(),

                                                                      nServiceId: int.parse(info
                                                                          .serviceId
                                                                          .toString()),
                                                                      sAmount: (info.appointmentFee !=
                                                                              null
                                                                          ? info
                                                                              .appointmentFee
                                                                              .toString()
                                                                          : '0'),
                                                                    ),
                                                                  ));
                                                            },
                                                            child: const Text(
                                                              'Claim now to get extra benefits on your booking',
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                color: darkBlue,
                                                                fontFamily:
                                                                    'OpenSans',
                                                                fontSize: 16,
                                                              ),
                                                            )),
                                                      ),
                                                      VerticalHeight(),
                                                      // Icon(Icons.arrow_forward_ios),
                                                    ])
                                              : const SizedBox.shrink(),

                                          info.appointmentFee != null &&
                                                  info.appointmentFee !=
                                                      '0.00' &&
                                                  info.status.toString() !=
                                                      'Cancel' &&
                                                  info.paymentType ==
                                                      "Cash on Desk" &&
                                                  ((dAppointmentDate.compareTo(
                                                              DateUtils.dateOnly(
                                                                  DateTime
                                                                      .now())) >
                                                          0) ||
                                                      (dAppointmentDate.compareTo(
                                                                  DateUtils.dateOnly(
                                                                      DateTime
                                                                          .now())) ==
                                                              0 &&
                                                          iTimeFrom - iTimeNow >
                                                              0))
                                              // iTimeFrom - iTimeNow > 0
                                              ? Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: TextButton(
                                                        onPressed: () {
                                                          var nDiscountedAmount =
                                                              0.0;
                                                          if (info.instantDiscount !=
                                                              null) {
                                                            nDiscountedAmount = (double.parse(info
                                                                        .appointmentFee
                                                                        .toString()) *
                                                                    double.parse(info
                                                                        .instantDiscount
                                                                        .toString())) /
                                                                100;
                                                            print(
                                                                nDiscountedAmount);
                                                          }

                                                          var nFinalAmount = double
                                                                  .parse(info
                                                                      .appointmentFee
                                                                      .toString()) -
                                                              nDiscountedAmount;
                                                          print(nFinalAmount);
                                                          var amount = nFinalAmount
                                                              .toStringAsFixed(
                                                                  2);
                                                          if (info.appointmentFee !=
                                                                  null &&
                                                              info.appointmentFee !=
                                                                  '0.0') {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PaymentScreen(
                                                                    amount: double
                                                                        .parse(
                                                                            amount),
                                                                    id: info
                                                                        .appoinmentConfigId,
                                                                    sName:
                                                                        'Appointment',
                                                                    subType: '',
                                                                    // coupontype: 'Claim'
                                                                  ),
                                                                ));
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            border: Border.all(
                                                                color: darkBlue,
                                                                width: 1),
                                                          ),
                                                          child: const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                    vertical:
                                                                        4),
                                                            child: Text(
                                                              'Pay now and get Instant Discount',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  kBlueTextstyle,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (info.prescriptionIdNo != 0)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 25.0),
                                                  child: BlueButton(
                                                    height: 30,
                                                    width: 80,
                                                    title: 'Prescription',
                                                    onPressed: () {
                                                      print(info
                                                          .prescriptionIdNo);
                                                      createFileOfPdfUrl(info
                                                              .prescriptionIdNo)
                                                          .then((f) {
                                                        setState(() {
                                                          remotePDFpath =
                                                              f.path;
                                                        });
                                                      });

                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         UserPrescriptionInfo(
                                                      //       id: info.bookingId,
                                                      //     ),
                                                      //   ),
                                                      // );
                                                    },
                                                  ),
                                                ),
                                              if (info.status == "Pending" &&
                                                  newDate.compareTo(
                                                          dAppointmentDate) <=
                                                      2 &&
                                                  dAppointmentDate
                                                          .compareTo(now1) >=
                                                      0)
                                                Center(
                                                  child: BlueButton(
                                                    height: 25,
                                                    title: 'Cancel Appointment',
                                                    width: 160,
                                                    onPressed: () {
                                                      setState(() {
                                                        isloading = true;
                                                      });
                                                      cancelAppointment
                                                          .cancelAppointment(
                                                              context,
                                                              info.bookingId
                                                                  .toString())
                                                          .whenComplete((() {
                                                        setState(() {
                                                          getAppointmentHistory();
                                                          isloading = false;
                                                        });
                                                      }));
                                                    },
                                                  ),
                                                )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "No Data Found",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ],
              ),
      ),
    );
  }

  Future<List<appointmentHistory>> getAppointmentHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse('$BASE_URL/api/Appoinment/GetAppointmentList?UserId=$userId'),
        headers: header);
    // print('luffy${res.body}');

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      // print("response - ${data['data']}");
      List<appointmentHistory> dataList = (data['data'] as List)
          .map<appointmentHistory>((e) => appointmentHistory.fromJson(e))
          .toList();

      return dataList;
    } else {
      throw Exception('Failed to load posts');
    }
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
            message: "File download at Download Folder in your device",
          ),
        );
        var data = jsonDecode(res.body.toString());
        if(Platform.isAndroid){
          Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
          String name = (DateTime.now().microsecondsSinceEpoch).toString();
          File file = await File("${generalDownloadDir.path}/prescription$name.pdf").create();
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
        }else if(Platform.isIOS){
          final dir = await getApplicationSupportDirectory();
          String name = (DateTime.now().microsecondsSinceEpoch).toString();
          final file = File('${dir.path}/prescription$name.pdf');
          Uint8List bytes = base64Decode(data['data']);
          await file.writeAsBytes(bytes);
          completer.complete(file);
          print("path for ios--${file.path}");
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Pdf(path: file.path),
            ),
          );
        }
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

  VerticalHeight() {
    return Divider();
  }
}
