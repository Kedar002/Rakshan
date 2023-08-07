import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/models/ecard_model_class.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api.dart';

class ECard extends StatefulWidget {
  const ECard({Key? key}) : super(key: key);

  @override
  State<ECard> createState() => _ECardState();
}

class _ECardState extends State<ECard> {
  var sClientTypeIdFromToken;
  @override
  void initState() {
    // getECard();
    getusertoken();
    // TODO: implement initState
    super.initState();
  }

  getusertoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sClientTypeIdFromToken = prefs.getString('clientTypeId');
    print('luffy$sClientTypeIdFromToken');
  }

  Future<List<empData?>?> getECard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.get("userId");
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse('$BASE_URL/api/Common/GetECardDetails?UserId=$userId'),
        headers: header);
    print(res.body);
    var data = jsonDecode(res.body.toString());
    if (res.statusCode == 200) {
      print("daaataaaa${data['data']}");
      var data1 = [data['data']];
      List<empData> dataList =
          data1.map<empData>((e) => empData.fromJson(e)).toList();
      print("dataList$dataList");
      return dataList;
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'E-Card'),
      body: Container(
        padding: kScreenPadding,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            //CARD
            Container(
                height: 250,
                child: FutureBuilder<List<empData?>?>(
                    future: getECard(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<empData?>?> snapshot) {
                      print("snapshot${snapshot.data}");
                      if (snapshot.connectionState == ConnectionState.done) {
                        List<empData?>? d = snapshot.data;
                        print("ddddddddd${d?[0]?.dob}");
                        return SizedBox(
                          height: 210,
                          width: double.infinity,
                          child: Center(
                            child: Container(
                              // padding:
                              //     const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                              decoration: BoxDecoration(
                                // color: Color(0xff31509e),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff215da5),
                                      Color(0xffcadf59),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.9, 0.1]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Positioned(
                                    top: -12,
                                    right: 0,
                                    child: SizedBox(
                                      height: 180,
                                      width: 180,
                                      child: Image.asset(
                                        'assets/images/card/patternTopRight.png',
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 25,
                                    left: -12,
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset(
                                        'assets/images/card/patternBottomLeft.png',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    margin: const EdgeInsets.only(bottom: 25),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                padding: const EdgeInsets.only(
                                                    right: 35, top: 10),
                                                height: 55,
                                                width: double.infinity,
                                                child: Image.asset(
                                                  'assets/images/card/MetierSurehealthLogo.png',
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'M E M B E R  N A M E',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffcadf59),
                                                        fontSize: 9),
                                                  ),
                                                  Text(
                                                    "${d?[0]?.employeeName}",
                                                    style: const TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'D A T E  O F  B I R T H',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xffcadf59),
                                                        fontSize: 9),
                                                  ),
                                                  Text(
                                                    "${d?[0]?.dob}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.topRight,
                                                // padding: EdgeInsets.only(
                                                //   left: 80,
                                                // ),
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                height: 55,
                                                width: double.infinity,
                                                child: Image.asset(
                                                  'assets/images/card/RakshanLogo.png',
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'C A R D  N U M B E R',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFFCADF59),
                                                        fontSize: 9),
                                                  ),
                                                  Text(
                                                    "${d?[0]?.cardNumber}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              sClientTypeIdFromToken == "2"
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'G R O U P  W I T H  C O D E',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffcadf59),
                                                              fontSize: 9),
                                                        ),
                                                        Text(
                                                          "${d?[0]?.groupCode}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox.shrink()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  const Positioned(
                                    bottom: 6,
                                    left: 150,
                                    child: Text(
                                      'www.metier.co.in',
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 9),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
          ],
        ),
      ),
    );
  }
}

// void _takeScreenshot() async {
//   final imageFile = await _screenshotcontroller.capture().then((value) {

//   });
//   Share.shareFiles([imageFile.toString()]);
// }

