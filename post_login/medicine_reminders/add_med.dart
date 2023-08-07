import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/models/prescriptionlistcontroller.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/medicine_detail_screen.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/medicine_type.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/prescription_details.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/reason_for_taking_medicine.dart';
import 'package:Rakshan/screens/post_login/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';

import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/getPrescriptionMedicines.dart';
import '../../../models/prescriptionlistcontroller.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';

class addMed extends StatefulWidget {
  int? prescriptionId;

  addMed(this.prescriptionId);

  static String id = 'add_med';

  @override
  State<addMed> createState() => _addMedState();
}

class _addMedState extends State<addMed> {
  List<dynamic> items = [];

  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setData();
    getPrescriptionMedList();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'prescription', (Route<dynamic> route) => false);
              return true;
            },

            //  Navigator.of(context).pushNamedAndRemoveUntil(
            //     'radiobutton', (Route<dynamic> route) => false);
            // return true;
            child: Scaffold(
              backgroundColor: const Color(0xff82B445),
              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'radiobutton', (Route<dynamic> route) => false);
                  }, // Handle your on tap here.
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: const Color(0xfffcfcfc),
                title: const Text(
                  'Rakshan',
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
                        setState(() {
                          getPrescriptionMedList();
                        });
                      },
                      icon: const Icon(Icons.replay_outlined),
                    ),
                  ),
                ],
                iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
              ),
              body: Column(
                children: [
                  Container(
                    padding: kScreenPadding,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Medicine Reminders',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'OpeanSans'),
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
                      child: FutureBuilder<List<PrescriptionMedList?>?>(
                        future: getPrescriptionMedList(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<PrescriptionMedList?>?>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<PrescriptionMedList?> wData = snapshot.data!;
                            print(wData.length);
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return ListView.builder(
                                itemCount: wData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  PrescriptionMedList? info = wData[index];
                                  final currentId =
                                      info?.prescriptionMedId.toString();
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  medicineDetailType(info!
                                                      .prescriptionMedId)));
                                    },
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: Card(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              info!.prescriptionMedTitle!,
                                              style: kLabelTextStyle,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            '${info.prescriptionMedTitle}'),
                                                        content: const Text(
                                                            "Are you sure do you want to delete this Medicine ?"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                "No"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                              child: const Text(
                                                                  "Yes"),
                                                              onPressed: () {
                                                                deletePrescriptionMed(
                                                                    currentId);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                // PrescriptionList();
                                                                getPrescriptionMedList();

                                                                setState(() {});
                                                              }),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  // Navigator.pushNamed(context,
                                                  //     diabetesAnalysisScreen);
                                                },
                                                icon: const Icon(Icons.delete))
                                          ],
                                        ),
                                      )),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text(
                                  "No Medicine added..",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: BlueButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              medicineType(widget.prescriptionId)));
                },
                title: 'Add a Med',
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
  }

  Future<List<PrescriptionMedList?>?> getPrescriptionMedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/Medicine/GetPrescriptionMedicineList?PrescriptionId=${widget.prescriptionId}'),
        headers: header);
    print('naruto${res.body}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      print("hashirama${data['prescriptionId']}");
      print("Tobirama${data['prescriptionTitle']}");
      List<PrescriptionMedList> dataList = (data['data'] as List)
          .map<PrescriptionMedList>((e) => PrescriptionMedList.fromJson(e))
          .toList();
      print("dataList$dataList");
      return dataList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  deletePrescriptionMed(id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    print('sanjii${userId}');
    var response = await http.delete(
        Uri.parse(
            '$BASE_URL/api/Medicine/DeletePrescriptionMedicine?MedicineId=$id&UserId=$userId'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
        });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('lufyy${data}');
      final bool isSuccess = data["isSuccess"];
      return isSuccess;
    } else {
      print('Error in deleteMedecine');
      return false;
    }
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';

// import 'package:Rakshan/constants/api.dart';
// import 'package:Rakshan/constants/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:Rakshan/constants/padding.dart';
// import 'package:Rakshan/constants/textfield.dart';
// import 'package:Rakshan/routes/app_routes.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../widgets/post_login/app_bar.dart';
// import '../../../widgets/pre_login/blue_button.dart';
// import 'package:http/http.dart' as http;

// import 'medicine_detail_screen.dart';
// import 'medicine_type.dart';

// class addMed extends StatefulWidget {
//   int? prescriptionId;

//   addMed(this.prescriptionId);

//   static String id = 'add_med';

//   @override
//   State<addMed> createState() => _addMedState();
// }

// class _addMedState extends State<addMed> {
//   List<dynamic> items = [];

//   bool isLoad = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoad
//         ? const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           )
//         : Scaffold(
//             backgroundColor: Color(0xff82B445),
//             appBar: AppBar(
//               elevation: 0,
//               leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context, true);
//                 }, // Handle your on tap here.
//                 icon: const Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.black,
//                 ),
//               ),
//               backgroundColor: const Color(0xfffcfcfc),
//               title: const Text(
//                 'Rakshan',
//                 style: TextStyle(
//                   fontFamily: 'OpenSans',
//                   color: Color(0xff2e66aa),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               actions: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20.0),
//                   child: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         setData();
//                       });
//                     },
//                     icon: const Icon(Icons.replay_outlined),
//                   ),
//                 ),
//               ],
//               iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
//             ),
//             body: Column(
//               children: [
//                 Container(
//                   padding: kScreenPadding,
//                   child: Column(
//                     children: const [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Center(
//                         child: Text(
//                           'Medicine Reminders',
//                           style:
//                               TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//                 Expanded(
//                   child: Container(
//                       decoration: const BoxDecoration(
//                           border: Border.symmetric(),
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(30.0)),
//                           color: Color(0xffFBFBFB)),
//                       padding: kScreenPadding,
//                       child: items.isNotEmpty
//                           ? ListView.builder(
//                               itemCount: items.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 medicineDetailType(items[index]
//                                                     ['prescriptionDetailId'])));
//                                   },
//                                   child: SizedBox(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.1,
//                                     child: Card(
//                                         child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 24, vertical: 8),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             '${items[index]['medicineName']}',
//                                             style: kApiTextstyle,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder:
//                                                       (BuildContext context) {
//                                                     return AlertDialog(
//                                                       title: Text(
//                                                         '${items[index]['medicineName']}',
//                                                         style: kLabelTextStyle,
//                                                       ),
//                                                       content: const Text(
//                                                           "Are you sure do you want to delete this Prescription ?"),
//                                                       actions: <Widget>[
//                                                         TextButton(
//                                                           child:
//                                                               const Text("No"),
//                                                           onPressed: () {
//                                                             Navigator.of(
//                                                                     context)
//                                                                 .pop();
//                                                           },
//                                                         ),
//                                                         TextButton(
//                                                             child: const Text(
//                                                                 "Yes"),
//                                                             onPressed: () {
//                                                               deletePrescriptionMeds(
//                                                                   items[index][
//                                                                       'prescriptionDetailId']);
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();

//                                                               // PrescriptionList();
//                                                               setData();

//                                                               setState(() {});
//                                                             }),
//                                                       ],
//                                                     );
//                                                   },
//                                                 );
//                                                 // Navigator.pushNamed(context,
//                                                 //     diabetesAnalysisScreen);
//                                               },
//                                               icon: const Icon(Icons.delete))
//                                         ],
//                                       ),
//                                     )),
//                                   ),
//                                 );
//                               })
//                           : const Center(
//                               child: Text("No Medicine Added..."),
//                             )),
//                 ),
//               ],
//             ),
//             floatingActionButton: BlueButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             medicineType(widget.prescriptionId)));
//                 // Navigator.pushNamed(context, medicineTypeScreen);
//               },
//               title: 'Add a Med',
//               height: MediaQuery.of(context).size.height * 0.05,
//               width: MediaQuery.of(context).size.width * 0.5,
//             ),
//             floatingActionButtonLocation:
//                 FloatingActionButtonLocation.centerFloat,
//           );
//   }

//   setData() async {
//     setState(() {
//       isLoad = true;
//     });
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var userToken = sharedPreferences.getString('data');
//     final userId = sharedPreferences.getString("userId");
//     var response = await http.get(
//         Uri.parse(
//             '$BASE_URL/api/Medicine/GetPrescriptionMedicineList?PrescriptionId=${widget.prescriptionId}'),
//         headers: {
//           HttpHeaders.contentTypeHeader: "application/json",
//           HttpHeaders.authorizationHeader: 'Bearer $userToken',
//         });

//     // log(response.body);
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);

//       if (data['isSuccess'] = true) {
//         for (int i = 0; i < data['data'].length; i++) {
//           items.add(data['data'][i]);
//         }
//       }
//       setState(() {
//         isLoad = false;
//       });
//       print("data" + data.toString());
//     } else {
//       setState(() {
//         isLoad = false;
//       }); // toast('Something went wrong');
//     }
//     setState(() {
//       isLoad = false;
//     });
//   }

//   deletePrescriptionMeds(id) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var userToken = sharedPreferences.getString('data');
//     final userId = sharedPreferences.getString("userId");
//     print('sanjii${userId}');
//     var response = await http.delete(Uri.parse(
//             //api/Medicine/DeletePrescriptionMedicine?MedicineId=1&UserId=236
//             '$BASE_URL/api/Medicine/DeletePrescriptionMedicine?MedicineId=$id&UserId=$userId'),
//         headers: {
//           HttpHeaders.contentTypeHeader: "application/json",
//           HttpHeaders.authorizationHeader: 'Bearer $userToken',
//         });

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       print('lufyy${data}');
//       final bool isSuccess = data["isSuccess"];
//       return isSuccess;
//     } else {
//       print('Error in deletePrescription');
//       return false;
//     }
//   }
// }
