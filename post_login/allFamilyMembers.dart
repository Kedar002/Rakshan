import 'dart:convert';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/models/FamilyList.dart';
import 'package:Rakshan/screens/post_login/edit_family.dart';
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
import '../../constants/textfield.dart';

class AllFamilyMembers extends StatefulWidget {
  @override
  State<AllFamilyMembers> createState() => _AllFamilyMembersState();
}

class _AllFamilyMembersState extends State<AllFamilyMembers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<FamilyMappingList>> familyMemberList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(Uri.parse(
            // 'https://devmetier.bskytech.in/api/EmployeeFamily/GetFamilyMappingList?EmployeeId=101'),
            '$BASE_URL/api/EmployeeFamily/GetFamilyMappingList?EmployeeId=$userId'),
        headers: header);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      List<FamilyMappingList> dataList = (data['data'] as List)
          .map<FamilyMappingList>((e) => FamilyMappingList.fromJson(e))
          .toList();
      print("dataList$dataList");

      return dataList;
      //return GetHomeModelclass.fromJson(data);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'Family Members'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<FamilyMappingList?>?>(
              future: familyMemberList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<FamilyMappingList?>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<FamilyMappingList?> wData = snapshot.data!;
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: wData.length,
                      itemBuilder: (BuildContext context, int i) {
                        FamilyMappingList? info = wData[i];
                        print('sanjiii${info?.name}');
                        return Card(
                          color: info!.active == 1
                              ? Colors.white
                              : Colors.grey.shade300,
                          shadowColor: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            leading: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditFamilyMember(
                                        sName: info.name.toString(),
                                        sDate: info.dob.toString(),
                                        sGender: info.gender.toString(),
                                        sRelation: info.relation.toString(),
                                        nRelationId: info.relationId!.toInt(),
                                        nEmployeeId: info.employeeId!.toInt(),
                                        Id: info.familyMappingId!.toInt(),
                                        memberStatus: info.active!.toInt(),
                                      ),
                                    ),
                                  ).whenComplete(() => setState(() {
                                        familyMemberList();
                                      }));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: darkBlue,
                                )),
                            title: Text(
                              '${info.name}',
                              style: kLabelTextStyle,
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${info.gender}',
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  info.active == 1
                                      ? const Text(
                                          'Status : Active',
                                          style: const TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          'Status : Inactive',
                                          style: const TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xfff5f5f5)),
                                    child: Text(
                                      '${info.dob}',
                                    )),
                                Text(
                                  '${info.relation}',
                                  style: const TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
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
                            "No Family Member Added",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
