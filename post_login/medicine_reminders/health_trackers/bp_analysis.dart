import 'dart:convert';
import 'dart:developer';

import 'package:Rakshan/models/gethommodel.dart';
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
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/pre_login/blue_button.dart';

class BpAnalysis extends StatefulWidget {
  static String id = 'bloodpressure';

  var illnessTypeId;
  var measureId;
  BpAnalysis({this.illnessTypeId, this.measureId});

  @override
  State<BpAnalysis> createState() => _BpAnalysisState();
}

class _BpAnalysisState extends State<BpAnalysis> {
  // late List graph = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  List listOfDates = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBpGraph(widget.measureId.toString());
    // graph = getBpGraph(widget.measureId.toString()) as List<BpGraphList>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff82B445),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
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
        iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
      ),
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
                    'Blood Pressure Analysis',
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  FutureBuilder<List<BpGraphList>>(
                      future: getBpGraph(widget.measureId.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BpGraphList>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          List<BpGraphList> graph = snapshot.data!;
                          print(graph.length);
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            var empty = "";

                            return (SfCartesianChart(
                              enableAxisAnimation: true,
                              primaryXAxis: CategoryAxis(
                                  // title: AxisTitle(text: 'Date'),
                                  // maximumLabels: 100,
                                  // autoScrollingDelta: 4,
                                  ),
                              primaryYAxis: NumericAxis(
                                  // title: AxisTitle(text: 'Blood Pressure'),
                                  ),
                              legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom),
                              series: <ChartSeries>[
                                StackedLineSeries<BpGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (BpGraphList graph, _) =>
                                        graph.mesureDate!
                                            .split(' ')
                                            .join('\n')
                                            .toString(),
                                    yValueMapper: (BpGraphList graph, _) =>
                                        int.parse(
                                            graph.systolicHigh.toString()),
                                    name: 'systolicHigh',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),
                                StackedLineSeries<BpGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (BpGraphList graph, _) =>
                                        graph.mesureDate!
                                            .split(' ')
                                            .join('\n')
                                            .toString(),
                                    yValueMapper: (BpGraphList graph, _) =>
                                        int.parse(
                                            graph.bloodGlucose.toString()),
                                    name: 'bloodGlucose',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),
                                StackedLineSeries<BpGraphList, String>(
                                    dataSource: graph,
                                    xValueMapper: (BpGraphList graph, _) =>
                                        graph.mesureDate!
                                            .split(' ')
                                            .join('\n')
                                            .toString(),
                                    yValueMapper: (BpGraphList graph, _) =>
                                        int.parse(
                                            graph.diastolicLow.toString()),
                                    name: 'diastolicLow',
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true)),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Container(
                    padding: kScreenPadding,
                    child: Column(
                      children: const [
                        Center(
                          child: Text(
                            'Monthly Blood Pressure Log Sheet',
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                          ),
                        ),
                      ],
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

  Future<List<BpGraphList>> getBpGraph(String id) async {
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
    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=$userId&IllnessName=BLOOD PRESSURE&ReminderId=$id&DateFrom=$sFromDate&DateTo=$sToDate'),
        headers: header);
    log('response is ${res.body}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      List<BpGraphList> dataList = (data['data'] as List)
          .map<BpGraphList>((e) => BpGraphList.fromJson(e))
          .toList();

      return dataList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Future getGraphData() async {
  //   final graphData = await getBpGraph(widget.measureId);
  // }Future<BpDataGridSource> getDataSource() async {
  //add fetch method here

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'Date',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('Date and Time',
                  overflow: TextOverflow.clip, softWrap: true))),
      // GridColumn(
      //     columnName: 'Time',
      //     width: 80,
      //     label: Container(
      //         padding: EdgeInsets.all(8),
      //         alignment: Alignment.center,
      //         child:
      //             Text('Time', overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Sys(High)',
          width: 85,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Sys(High)',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Dia(Low)',
          width: 80,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Dia(Low)',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnName: 'Pulse',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('Pulse')))
    ];
  }

  Future<List<TableDetails>> getBpTable(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final now = DateTime.now();
    final dFromDate = DateTime(now.year, now.month, now.day - 7);
    String sFromDate =
        _startDateController.text ?? DateFormat("dd/MM/yyyy").format(dFromDate);
    print('luffy$sFromDate');
    String sToDate = _endDateController.text ??
        DateFormat("dd/MM/yyyy").format(DateTime.now());
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=$userId&IllnessName=BLOOD PRESSURE&ReminderId=$id&DateFrom=$sFromDate&DateTo=$sToDate'),
        headers: header);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      List<TableDetails> dataList = (data['data'] as List)
          .map<TableDetails>((e) => TableDetails.fromJson(e))
          .toList();
      return dataList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<BpDataGridSource> getDataSource() async {
    //add fetch method here
    var dataList = await getBpTable(widget.measureId.toString());
    return BpDataGridSource(dataList);
  }
}

class BpGraphList {
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

  BpGraphList(
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

  BpGraphList.fromJson(Map<String, dynamic> json) {
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

class BpDataGridSource extends DataGridSource {
  BpDataGridSource(this.dataList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<TableDetails> dataList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(row.getCells()[0].value.toString(),
            overflow: TextOverflow.clip),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      // Container(
      //   alignment: Alignment.center,
      //   padding: EdgeInsets.all(8.0),
      //   child: Text(
      //     row.getCells()[1].value.toString(),
      //     overflow: TextOverflow.ellipsis,
      //   ),
      // ),
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
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  // {"title": 'Time', 'widthFactor': 0.3, 'key': 'mesureTime'},
  //   {"title": 'Sys(High)', 'widthFactor': 0.3, 'key': 'systolicHigh'},
  //   {"title": 'Dia(Low)', 'widthFactor': 0.3, 'key': 'diastolicLow'},
  //   {"title": 'Pulse', 'widthFactor': 0.3, 'key': 'pulse'},

  void buildDataGridRow() {
    dataGridRows = dataList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Date', value: dataGridRow.mesureDate),
        // DataGridCell<String>(columnName: 'Time', value: dataGridRow.mesureTime),
        DataGridCell<String>(
            columnName: 'Sys(High)', value: dataGridRow.systolicHigh),
        DataGridCell<String>(
            columnName: 'Dia(Low)', value: dataGridRow.diastolicLow),
        DataGridCell<int>(columnName: 'Pulse', value: dataGridRow.pulse),
      ]);
    }).toList(growable: false);
  }
}
