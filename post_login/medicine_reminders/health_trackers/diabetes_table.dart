import 'dart:convert';
import 'package:Rakshan/models/htmodels/ht_d_details.dart';
import 'package:http/http.dart' as http;
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/models/htmodels/ht_bp_details.dart';
import 'package:editable/editable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../constants/padding.dart';
import '../../../../widgets/post_login/app_bar.dart';
import '../../../../widgets/post_login/app_menu.dart';
import '../../../../widgets/pre_login/blue_button.dart';

class diabetesTable extends StatefulWidget {
  static String id = 'diabetesTable';
  var illnessTypeId;
  var measureId;
  diabetesTable({this.illnessTypeId, this.measureId});
  @override
  State<diabetesTable> createState() => _diabetesTableState();
}

class _diabetesTableState extends State<diabetesTable> {
  @override
  void initState() {
    super.initState();
    getDiabetesTable(widget.measureId.toString());
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
                    'Monthly Blood Sugar Log Sheet',
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
    );
  }

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

    var res = await http.get(
        Uri.parse(
            '$BASE_URL/api/HealthTracker/GetHealthTrackerDetails?UserId=$userId&IllnessName=DIABETIES&ReminderId=$id'),
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
