import 'dart:convert';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/models/htmodels/ht_bp_details.dart';
import 'package:editable/editable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/padding.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/post_login/app_menu.dart';
import '../../../../widgets/pre_login/blue_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class bpTable extends StatefulWidget {
  static String id = 'diabetesTable';
  var measureId;

  var illnessTypeId;
  bpTable({this.illnessTypeId, this.measureId});
  @override
  State<bpTable> createState() => _bpTableState();
}

class _bpTableState extends State<bpTable> {
//EDITABLE WIDGET IS USED
  // List row = [];

  // List headers = [
  //   {
  //     "title": 'Date',
  //     'widthFactor': 0.3,
  //     'key': 'mesureDate',
  //     'editable': false
  //   },
  //   {"title": 'Time', 'widthFactor': 0.3, 'key': 'mesureTime'},
  //   {"title": 'Sys(High)', 'widthFactor': 0.3, 'key': 'systolicHigh'},
  //   {"title": 'Dia(Low)', 'widthFactor': 0.3, 'key': 'diastolicLow'},
  //   {"title": 'Pulse', 'widthFactor': 0.3, 'key': 'pulse'},
  // ];

  @override
  void initState() {
    super.initState();
    getBpTable(widget.measureId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff82B445),
      appBar: AppBarIndividual(title: 'Metier'),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: kScreenPadding,
            child: Column(
              children: const [
                Center(
                  child: Text(
                    'Monthly Blood Pressure Log Sheet',
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
              child: FutureBuilder(
                future: getDataSource(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return snapshot.hasData
                      ? SfDataGrid(
                          source: snapshot.data,
                          columns: getColumns(),
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                        )
                      : Center(
                          child: CircularProgressIndicator(strokeWidth: 3),
                        );
                },
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: BlueButton(
      //   onPressed: () {},
      //   title: 'Ok',
      //   height: MediaQuery.of(context).size.height * 0.05,
      //   width: MediaQuery.of(context).size.width * 0.5,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<BpDataGridSource> getDataSource() async {
    //add fetch method here
    var dataList = await getBpTable(widget.measureId.toString());
    return BpDataGridSource(dataList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'Date',
          width: 200,
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
    final header = {'Authorization': 'Bearer $userToken'};
    print(userId);
    print('Sent ID $id');
    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=$userId&IllnessName=BLOOD PRESSURE&ReminderId=$id'),
        headers: header);
    print('response${res.body}');
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
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
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


// class bpTable extends StatefulWidget {
//   static String id = 'diabetesTable';

//   @override
//   State<bpTable> createState() => _bpTableState();
// }

// class _bpTableState extends State<bpTable> {
//   String? valueServiceProvideName;

// //EDITABLE WIDGET IS USED
//   List row = [];

//   List headers = [
//     {
//       "title": 'Date',
//       'widthFactor': 0.3,
//       'key': 'mesureDate',
//       'editable': false
//     },
//     {"title": 'Time', 'widthFactor': 0.3, 'key': 'mesureTime'},
//     {"title": 'Sys(High)', 'widthFactor': 0.3, 'key': 'systolicHigh'},
//     {"title": 'Dia(Low)', 'widthFactor': 0.3, 'key': 'diastolicLow'},
//     {"title": 'Pulse', 'widthFactor': 0.3, 'key': 'pulse'},
//   ];

//   // List rows = [
//   //   {
//   //      "date": '23/09/2020',
//   //     "Time": '02:40',
//   //     "Sys": '33',
//   //     "Dia": '44',
//   //     "Pulse": '33'
//   //   },
//   //   {"date": '12/4/2020', "Time": '', "Sys": '', "Dia": '', "Pulse": ''},
//   //   {"date": '09/4/1993', "Time": '', "Sys": '', "Dia": '', "Pulse": ''},
//   //   {
//   //     "date": '02/9/1998',
//   //     "Time": '',
//   //     "Sys": '',
//   //     "Dia": '',
//   //     "Pulse": '',
//   //   },
//   // ];
//   // List headers = [
//   //   {"title": 'Date', 'widthFactor': 0.3, 'key': 'date', 'editable': false},
//   //   {"title": 'Time', 'widthFactor': 0.3, 'key': 'Time'},
//   //   {"title": 'Sys(High)', 'widthFactor': 0.3, 'key': 'Sys'},
//   //   {"title": 'Dia(Low)', 'widthFactor': 0.3, 'key': 'Dia'},
//   //   {"title": 'Pulse', 'widthFactor': 0.3, 'key': 'Pulse'},
//   // ];

//   Future<List<TableDetails?>?> getBpTable() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userToken = prefs.getString('data');
//     var userId = prefs.getString('userId');
//     final header = {'Authorization': 'Bearer $userToken'};

//     var res = await http.get(
//         Uri.parse(
//             '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=301&IllnessName=BLOOD PRESSURE'),
//         headers: header);
//     print('naruto${res.body}');
//     if (res.statusCode == 200) {
//       var data = jsonDecode(res.body.toString());
//       List<TableDetails> dataList = (data['data'] as List)
//           .map<TableDetails>((e) => TableDetails.fromJson(e))
//           .toList();
//       return dataList;

//       //return GetHomeModelclass.fromJson(data);
//     } else {
//       throw Exception('Failed to load post');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getBpTable();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff82B445),
//       appBar: AppBarIndividual(title: 'Metier'),
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
//                     'Monthly Blood Pressure Log Sheet',
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
//               child: Editable(
//                 columns: headers,
//                 rows: row,
//                 showCreateButton: false,
//                 tdStyle: TextStyle(fontSize: 11),
//                 showSaveIcon: true, //set true
//                 borderColor: Colors.grey.shade300,
//                 onSubmitted: (value) {
//                   print(value);
//                 },
//                 onRowSaved: (value) {
//                   //added line
//                   print(value); //prints to console
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: BlueButton(
//         onPressed: () {
//           // Navigator.pushNamed(context, timeFrameScreen);
//         },
//         title: 'Ok',
//         height: MediaQuery.of(context).size.height * 0.05,
//         width: MediaQuery.of(context).size.width * 0.5,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
