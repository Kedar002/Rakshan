import 'dart:convert';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/models/notificationlistmodel.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationList>> getNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    final response = await http.get(
        Uri.parse('$BASE_URL/api/Common/GetNotificationList?UserId=$userId'),
        headers: header);
    print(response.statusCode);
    // var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data['data']);
      List<NotificationList> dataList = (data['data'] as List)
          .map<NotificationList>((e) => NotificationList.fromJson(e))
          .toList();
      print("dataList-$dataList");
      return dataList;
    } else {
      print('failed');
      throw Exception('Failed to load notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIndividual(title: 'Notifications'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<NotificationList>>(
                future: getNotificationList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<NotificationList>? nData = snapshot.data;
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        // reverse: true,
                        itemCount: nData?.length,
                        itemBuilder: (context, index) {
                          NotificationList info = nData![index];
                          return Card(
                            color: Colors.white,
                            shadowColor: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date : ${info.notificationDate.toString()}',
                                    style: kBlueTextstyle,
                                  ),
                                  Text(
                                    'Time : ${info.notificationTime.toString()}',
                                    style: kBlueTextstyle,
                                  ),
                                ],
                              ),

                              subtitle: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    info.notification.toString(),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0),
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
                              "No notifications to show.",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
