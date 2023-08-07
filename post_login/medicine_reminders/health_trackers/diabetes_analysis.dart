// // import 'package:flutter/material.dart';
// // import 'package:draw_graph/draw_graph.dart';
// // import 'package:draw_graph/models/feature.dart';
// // import 'package:Rakshan/constants/padding.dart';

// // final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// // class diabetesAnalysis extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("DrawGraph Package"),
// //       ),
// //       body: MyScreen(),
// //     );
// //   }
// // }

// // class MyScreen extends StatelessWidget {
// //   final List<Feature> features = [
// //     Feature(
// //       title: "Weekly",
// //       color: Colors.blue,
// //       data: [0.2, 0.8, 0.4, 0.7, 0.6],
// //     ),
// //     Feature(
// //       title: "Fortnightly",
// //       color: Colors.pink,
// //       data: [1, 0.8, 0.6, 0.7, 0.3],
// //     ),
// //     Feature(
// //       title: "Monthly",
// //       color: Colors.cyan,
// //       data: [0.5, 0.4, 0.85, 0.4, 0.7],
// //     ),
// //     Feature(
// //       title: "Water Plants",
// //       color: Colors.green,
// //       data: [0.6, 0.2, 0, 0.1, 1],
// //     ),
// //     Feature(
// //       title: "Grocery Shopping",
// //       color: Colors.amber,
// //       data: [0.25, 1, 0.3, 0.8, 0.6],
// //     ),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView(
// //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
// //       // crossAxisAlignment: CrossAxisAlignment.center,
// //       children: <Widget>[
// //         Container(),
// //         const Padding(
// //           padding: kScreenPadding,
// //           child: Text(
// //             "Diabates Analysis",
// //             style: TextStyle(
// //               fontSize: 28,
// //               fontWeight: FontWeight.bold,
// //               letterSpacing: 2,
// //             ),
// //           ),
// //         ),
// //         LineGraph(
// //           features: features,
// //           size: Size(400, 400),
// //           labelX: const ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
// //           labelY: const ['20%', '40%', '60%', '80%', '100%'],
// //           showDescription: true,
// //           graphColor: Colors.black,
// //           graphOpacity: 0.2,
// //           verticalFeatureDirection: true,
// //           descriptionHeight: 130,
// //         ),
// //         SizedBox(
// //           height: 50,
// //         )
// //       ],
// //     );
// //   }
// // }

// import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/diabetes_table.dart';
// import 'package:draw_graph/draw_graph.dart';
// import 'package:draw_graph/models/feature.dart';
// import 'package:flutter/material.dart';
// import 'package:Rakshan/constants/textfield.dart';
// import 'package:Rakshan/routes/app_routes.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';

// import '../../../../constants/padding.dart';
// import '../../../../widgets/post_login/app_bar.dart';
// import '../../../../widgets/pre_login/blue_button.dart';

// class diabetesAnalysis extends StatefulWidget {
//   static String id = 'bloodpressure';
//   var illnessTypeId;
//   var measureId;
//   diabetesAnalysis({this.illnessTypeId, this.measureId});
//   @override
//   State<diabetesAnalysis> createState() => _diabetesAnalysisState();
// }

// class _diabetesAnalysisState extends State<diabetesAnalysis> {
//   String? valueServiceProvideName;

//   @override
//   Widget build(BuildContext context) {
//     final List<Feature> features = [
//       Feature(
//         title: "Weekly",
//         color: Colors.blue,
//         data: [0.2, 0.8, 0.4, 0.7, 0.6],
//       ),
//       Feature(
//         title: "Fortnightly",
//         color: Colors.pink,
//         data: [1, 0.8, 0.6, 0.7, 0.3],
//       ),
//       Feature(
//         title: "Monthly",
//         color: Colors.cyan,
//         data: [0.5, 0.4, 0.85, 0.4, 0.7],
//       ),
//     ];
//     return Scaffold(
//       backgroundColor: Color(0xff82B445),
//       appBar: AppBarIndividual(title: 'Rakshan'),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//           Container(
//             padding: kScreenPadding,
//             child: Column(
//               children: const [
//                 Center(
//                   child: Text(
//                     'Diabetes',
//                     style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                   border: Border.symmetric(),
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(30.0)),
//                   color: Color(0xffFBFBFB)),
//               padding: kScreenPadding,
//               child: ListView(
//                 children: [
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//                   Container(
//                     padding: kScreenPadding,
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.9,
//                       child: ListView(
//                         children: [
//                           LineGraph(
//                             fontFamily: 'OpeanSans',
//                             features: features,
//                             size: const Size(300, 300),
//                             labelX: const [
//                               'Day 1',
//                               'Day 2',
//                               'Day 3',
//                               'Day 4',
//                               'Day 5'
//                             ],
//                             labelY: const ['20%', '40%', '60%', '80%', '100%'],
//                             showDescription: true,
//                             graphColor: Colors.black,
//                             graphOpacity: 0.2,
//                             verticalFeatureDirection: false,
//                             descriptionHeight: 130,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Wrap(children: [
//         BlueButton(
//           onPressed: () {
//             print(widget.illnessTypeId);
//             print(widget.measureId);
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => diabetesTable(
//                           illnessTypeId: widget.illnessTypeId,
//                           measureId: widget.measureId,
//                         )));
//           },
//           title: 'Analysis',
//           height: MediaQuery.of(context).size.height * 0.05,
//           width: MediaQuery.of(context).size.width * 0.3,
//         ),
//         SizedBox(
//           width: MediaQuery.of(context).size.width * 0.15,
//         ),
//         BlueButton(
//           onPressed: () {
//             //Navigator.pushNamed(context, moreSettingsScreen);
//           },
//           title: 'Done',
//           height: MediaQuery.of(context).size.height * 0.05,
//           width: MediaQuery.of(context).size.width * 0.3,
//         ),
//       ]),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }

// diabetesAnalysis

import 'dart:convert';
import 'dart:developer';

import 'package:Rakshan/models/gethommodel.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/models/htmodels/ht_bp_details.dart';
import 'package:Rakshan/screens/post_login/medicine_reminders/health_trackers/bp_table.dart';
// import 'package:draw_graph/draw_graph.dart';
// import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../constants/padding.dart';
import '../../../../models/htmodels/ht_d_details.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';

class diabetesAnalysis extends StatefulWidget {
  static String id = 'bloodpressure';

  var illnessTypeId;
  var measureId;
  diabetesAnalysis({this.illnessTypeId, this.measureId});

  @override
  State<diabetesAnalysis> createState() => _diabetesAnalysisState();
}

class _diabetesAnalysisState extends State<diabetesAnalysis> {
  // late List graph = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBpGraph(widget.measureId.toString());
    getDiabetesTable(widget.measureId.toString());
    // graph = getBpGraph(widget.measureId.toString()) as List<diabGraphList>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff82B445),
      appBar: AppBarIndividual(title: 'Rakshan'),
      body: Column(
        children: [
          Container(
            // padding: kScreenPadding,
            child: Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Diabeties Analysis',
                    style: TextStyle(fontSize: 20, fontFamily: 'OpeanSans'),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Start Date';
                            }
                            return null;
                          },
                          controller:
                              _startDateController, //editing controller of this TextField
                          readOnly: true,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Start Date',
                            suffixIcon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff325CA2), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff325CA2), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                          ), //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                _startDateController.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter End Date';
                            }
                            return null;
                          },
                          controller:
                              _endDateController, //editing controller of this TextField
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'End Date',
                            suffixIcon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff325CA2), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff325CA2), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                          ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                _endDateController.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const Center(
                    child: Text(
                      "PRE MEAL",
                      style: TextStyle(fontSize: 18, fontFamily: 'OpeanSans'),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  FutureBuilder<List<diabGraphList>>(
                      future: getBpGraph(widget.measureId.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<diabGraphList>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<diabGraphList> graph = snapshot.data!;
                          print(graph.length);
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            var empty = "";
                            return (SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                title: AxisTitle(text: 'Date'),
                                // autoScrollingDelta: 4,
                              ),
                              primaryYAxis: CategoryAxis(
                                  title: AxisTitle(text: 'Blood Glucose')),
                              legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom),
                              series: <ChartSeries>[
                                StackedLineSeries<diabGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (diabGraphList graph, _) =>
                                        graph.diabetesHigh == "Pre Breakfast" ||
                                                graph.diabetesHigh == "-"
                                            ? graph.mesureDate!
                                                //  .split('/')
                                                // .first
                                                .toString()
                                            : null,
                                    yValueMapper: (diabGraphList graph, _) =>
                                        int.parse(
                                            graph.bloodGlucose.toString()),
                                    name: 'breakfast',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),
                                StackedLineSeries<diabGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (diabGraphList graph, _) =>
                                        graph.diabetesHigh == "Pre Lunch" ||
                                                graph.diabetesHigh == "-"
                                            ? graph.mesureDate!
                                                //  .split('/')
                                                // .first
                                                .toString()
                                            : null,
                                    yValueMapper: (diabGraphList graph, _) =>
                                        int.parse(
                                            graph.bloodGlucose.toString()),
                                    name: 'lunch',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),
                                StackedLineSeries<diabGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (diabGraphList graph, _) =>
                                        graph.mesureDate!
                                            //  .split('/')
                                            // .first
                                            .toString(),
                                    yValueMapper: (diabGraphList graph, _) =>
                                        graph.diabetesHigh == "Pre Dinner" ||
                                                graph.diabetesHigh == "-"
                                            ? int.parse(
                                                graph.bloodGlucose.toString())
                                            : null,
                                    name: 'dinner',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),

                                // LineSeries<diabGraphList, dynamic>(
                                //   dataSource: graph,
                                // xValueMapper: (diabGraphList graph, _) =>
                                //     int.parse(graph.mesureDate!
                                //         .split('/')
                                //         .first
                                //         .toString()),
                                // yValueMapper: (diabGraphList graph, _) =>
                                //     int.parse(graph.bloodGlucose.toString()),
                                // )
                              ],
                            ));
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "NO DATA",
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  const Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  const Center(
                    child: Text(
                      "POST MEAL",
                      style: TextStyle(fontSize: 18, fontFamily: 'OpeanSans'),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  FutureBuilder<List<diabGraphList>>(
                      future: getBpGraph(widget.measureId.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<diabGraphList>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<diabGraphList> graph = snapshot.data!;
                          print(graph.length);
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return (SfCartesianChart(
                              primaryXAxis:
                                  CategoryAxis(title: AxisTitle(text: 'Date')),
                              primaryYAxis: CategoryAxis(
                                  title: AxisTitle(text: 'Blood Glucose')),
                              legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom),
                              series: <ChartSeries>[
                                StackedLineSeries<diabGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (diabGraphList graph, _) =>
                                        graph.diabetesHigh ==
                                                    "Post Breakfast" ||
                                                graph.diabetesHigh == "-"
                                            ? graph.mesureDate!
                                                //  .split('/')
                                                // .first
                                                .toString()
                                            : null,
                                    yValueMapper: (diabGraphList graph, _) =>
                                        int.parse(
                                            graph.bloodGlucose.toString()),
                                    name: 'breakfast',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),
                                StackedLineSeries<diabGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (diabGraphList graph, _) =>
                                        graph.diabetesHigh == "Post Lunch" ||
                                                graph.diabetesHigh == "-"
                                            ? graph.mesureDate!
                                                //  .split('/')
                                                // .first
                                                .toString()
                                            : null,
                                    yValueMapper: (diabGraphList graph, _) =>
                                        int.parse(
                                            graph.bloodGlucose.toString()),
                                    name: 'lunch',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),
                                StackedLineSeries<diabGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (diabGraphList graph, _) =>
                                        graph.diabetesHigh == "PostDinner" ||
                                                graph.diabetesHigh == "-"
                                            ? graph.mesureDate!
                                                //  .split('/')
                                                // .first
                                                .toString()
                                            : null,
                                    yValueMapper: (diabGraphList graph, _) =>
                                        int.parse(
                                            graph.bloodGlucose.toString()),
                                    name: 'dinner',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),

                                // LineSeries<diabGraphList, dynamic>(
                                //   dataSource: graph,
                                // xValueMapper: (diabGraphList graph, _) =>
                                //     int.parse(graph.mesureDate!
                                //         .split('/')
                                //         .first
                                //         .toString()),
                                // yValueMapper: (diabGraphList graph, _) =>
                                //     int.parse(graph.bloodGlucose.toString()),
                                // )
                              ],
                            ));
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "NO DATA",
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
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Monthly Blood Sugar Log Sheet',
                      style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border.symmetric(),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30.0)),
                        color: Color(0xffFBFBFB)),
                    padding: kScreenPadding,
                    child: FutureBuilder(
                      future: getDataSource(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        return snapshot.hasData
                            ? SfDataGrid(
                                source: snapshot.data,
                                columns: getColumns(),
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                              )
                            : Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 3),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<diabGraphList>> getBpGraph(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final now = DateTime.now();
    final dFromDate = DateTime(now.year, now.month, now.day - 7);
    String sFromDate =
        _startDateController.text ?? DateFormat("dd/MM/yyyy").format(dFromDate);
    String sToDate = _endDateController.text ??
        DateFormat("dd/MM/yyyy").format(DateTime.now());
    final header = {'Authorization': 'Bearer $userToken'};
    print(userId);
    print('Sent ID $id');
    print(sFromDate);
    print(sToDate);
    print(_startDateController.text);
    var res = await http.get(Uri.parse(
            // '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=$userId&IllnessName=DIABETIES&ReminderId=$id'),
            '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=$userId&IllnessName=DIABETIES&ReminderId=$id&DateFrom=$sFromDate&DateTo=$sToDate'),
        headers: header);
    log('response is ${res.body}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      List<diabGraphList> dataList = (data['data'] as List)
          .map<diabGraphList>((e) => diabGraphList.fromJson(e))
          .toList();
      return dataList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Future getGraphData() async {
  //   final graphData = await getBpGraph(widget.measureId);
  // }
  Future<BpDataGridSource> getDataSource() async {
    //add fetch method here
    var dataList = await getDiabetesTable(widget.measureId.toString());
    return BpDataGridSource(dataList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'Date',
          width: 120,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('Date',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Time',
          width: 120,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child:
                  Text('Time', overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Meal Time',
          width: 120,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Meal Time',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Blood Glucose',
          width: 120,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Blood Glucose',
                  overflow: TextOverflow.clip, softWrap: true))),
    ];
  }

  Future<List<DTableDetails>> getDiabetesTable(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};
    final now = DateTime.now();
    final dFromDate = DateTime(now.year, now.month, now.day - 7);
    String sFromDate =
        _startDateController.text ?? DateFormat("dd/MM/yyyy").format(dFromDate);
    String sToDate = _endDateController.text ??
        DateFormat("dd/MM/yyyy").format(DateTime.now());
    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=$userId&IllnessName=DIABETIES&ReminderId=$id&DateFrom=$sFromDate&DateTo=$sToDate'),
        headers: header);
    print(res.body);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      List<DTableDetails> dataList = (data['data'] as List)
          .map<DTableDetails>((e) => DTableDetails.fromJson(e))
          .toList();
      print(dataList);
      return dataList;
      //return GetHomeModelclass.fromJson(data);
    } else {
      throw Exception('Failed to load Data');
    }
  }
}

class diabGraphList {
  int? mesureId;
  int? mesureReminderId;
  int? illnessnId;
  String? mesureDate;
  String? mesureTime;
  String? systolicHigh;
  String? diastolicLow;
  String? bloodGlucose;
  String? diabetesHigh;
  String? diabetesLow;
  int? pulse;
  String? illnessName;
  int? userId;

  diabGraphList(
      {this.mesureId,
      this.mesureReminderId,
      this.illnessnId,
      this.mesureDate,
      this.mesureTime,
      this.systolicHigh,
      this.diastolicLow,
      this.bloodGlucose,
      this.diabetesHigh,
      this.diabetesLow,
      this.pulse,
      this.illnessName,
      this.userId});

  diabGraphList.fromJson(Map<String, dynamic> json) {
    mesureId = json['mesureId'];
    mesureReminderId = json['mesureReminderId'];
    illnessnId = json['illnessnId'];
    mesureDate = json['mesureDate'];
    mesureTime = json['mesureTime'];
    systolicHigh = json['systolicHigh'];
    diastolicLow = json['diastolicLow'];
    bloodGlucose = json['bloodGlucose'];
    diabetesHigh = json['diabetesHigh'];
    diabetesLow = json['diabetesLow'];
    pulse = json['pulse'];
    illnessName = json['illnessName'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mesureId'] = this.mesureId;
    data['mesureReminderId'] = this.mesureReminderId;
    data['illnessnId'] = this.illnessnId;
    data['mesureDate'] = this.mesureDate;
    data['mesureTime'] = this.mesureTime;
    data['systolicHigh'] = this.systolicHigh;
    data['diastolicLow'] = this.diastolicLow;
    data['bloodGlucose'] = this.bloodGlucose;
    data['diabetesHigh'] = this.diabetesHigh;
    data['diabetesLow'] = this.diabetesLow;
    data['pulse'] = this.pulse;
    data['illnessName'] = this.illnessName;
    data['userId'] = this.userId;
    return data;
  }
}

class SalesData {
  SalesData(this.month, this.sales);

  final String month;
  final double sales;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['month'].toString(),
      parsedJson['sales'],
    );
  }
}

class BpDataGridSource extends DataGridSource {
  BpDataGridSource(this.dataList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<DTableDetails> dataList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = dataList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Date', value: dataGridRow.mesureDate),
        DataGridCell<String>(columnName: 'Time', value: dataGridRow.mesureTime),
        DataGridCell<String>(
            columnName: 'Measure Time', value: dataGridRow.diabetesHigh),
        DataGridCell<String>(
            columnName: 'Blood Glucose', value: dataGridRow.bloodGlucose),
      ]);
    }).toList(growable: false);
  }
}
