import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/models/Claimhistorylist.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/download_surety_letter.dart';
import 'package:Rakshan/utills/progressIndicator.dart';
import 'package:Rakshan/widgets/post_login/webview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:open_file/open_file.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../pdfview.dart';

class ClaimHistory extends StatefulWidget {
  @override
  State<ClaimHistory> createState() => _ClaimHistoryState();
}

class _ClaimHistoryState extends State<ClaimHistory> {
  List<User> documents = [];
  var sClientTypeIdFromToken;
  String remotePDFpath = '';
  String pathPDF = '';
  late ProcessIndicatorDialog _progressIndicator;

  @override
  void initState() {
    _progressIndicator = ProcessIndicatorDialog(context);
    getusertoken();
    // TODO: implement initState
    super.initState();
  }

  getusertoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sClientTypeIdFromToken = prefs.getString('clientTypeId');
    print('zoro$sClientTypeIdFromToken');
  }

  Future<List<Claimhistorylist?>?> getclaimHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');
    final header = {'Authorization': 'Bearer $userToken'};

    var res = await http.get(
        Uri.parse('$BASE_URL/api/Claims/GetClaimList?UserId=$userId'),
        headers: header);
    // print('luffy${res.body}');
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      List<Claimhistorylist> dataList = (data['data'] as List)
          .map<Claimhistorylist>((e) => Claimhistorylist.fromJson(e))
          .toList();

      // print("madara$dataList");
      return dataList;
    } else {
      throw Exception('Failed to load posts');
    }
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
        backgroundColor: kFaintBlue,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              documents.clear();
              Navigator.popAndPushNamed(context, radioButton);
            }, // Handle your on tap here.
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xfffcfcfc),
          title: const Text(
            'Claim History',
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
                    documents.clear();
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
            Expanded(
              child: FutureBuilder<List<Claimhistorylist?>?>(
                  future: getclaimHistory(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Claimhistorylist?>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<Claimhistorylist?> aData = snapshot.data!;
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          // reverse: true,
                          itemCount: aData.length,
                          itemBuilder: (BuildContext context, int i) {
                            Claimhistorylist? info = aData[i];

                            return Card(
                              color: Colors.white,
                              shadowColor: darkBlue,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                // border: OutlineInputBorder(
                                //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                title: Column(
                                  children: [
                                    const VerticalHeight(),
                                    info!.claimDate == null
                                        ? const Text(
                                            '',
                                            style: kBlueTextstyle,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Date',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.claimDate}',
                                                style: kBlueTextstyle,
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                    const SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Claim Status',
                                          style: kDarkgreyTextstyle,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${info.claimStatus}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kBlueTextstyle,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalHeight(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Claim Number',
                                          style: kDarkgreyTextstyle,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${info.claimNumber}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kBlueTextstyle,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalHeight(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Service Name',
                                          style: kDarkgreyTextstyle,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${info.serviceName}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kBlueTextstyle,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalHeight(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Claim Amount',
                                          style: kDarkgreyTextstyle,
                                        ),
                                        Text(
                                          '${info.claimAmount}',
                                          style: kBlueTextstyle,
                                        ),
                                      ],
                                    ),
                                    info.discountOffered == null
                                        ? const SizedBox()
                                        : const SizedBox(height: 7),
                                    info.discountOffered == null
                                        ? const SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Instant Discount',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.discountOffered}',
                                                style: kBlueTextstyle,
                                              ),
                                            ],
                                          ),
                                    const SizedBox(height: 7),
                                    info.redeemAmount == '0.00'
                                        ? const SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Cashback',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.redeemAmount}',
                                                style: kBlueTextstyle,
                                              ),
                                            ],
                                          ),
                                    const SizedBox(height: 7),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     const Text(
                                    //       // change this to only visible when status is Approved. also change to reedemed amount.
                                    //       'Cashback Reedemed',
                                    //       style: kDarkgreyTextstyle,
                                    //     ),
                                    //     Text(
                                    //       '${info.redeemAmount}',
                                    //       style: kBlueTextstyle,
                                    //     ),
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 7),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     const Text(
                                    //       // change this to only visible when status is Approved. also change to reedemed amount.
                                    //       'Total Discount Recd.',
                                    //       style: kDarkgreyTextstyle,
                                    //     ),
                                    //     Text(
                                    //       ' ',
                                    //       // '${info.redeemAmount}',
                                    //       style: kBlueTextstyle,
                                    //     ),
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            // change this to only visible when status is Approved. also change to reedemed amount.
                                            'Provider',
                                            style: kDarkgreyTextstyle,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${info.serviceProviderName}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kBlueTextstyle,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    info.ipdSuretyLetterRequired == "Yes"
                                        // &&
                                        //         info.suretyLetterDocument != null
                                        // &&
                                        // sClientTypeIdFromToken == "2"
                                        // "No"
                                        ? GestureDetector(
                                            onTap: () async {
                                              createFileOfPdfUrl(info.claimId)
                                                  .then((f) {
                                                setState(() {
                                                  remotePDFpath = f.path;
                                                });
                                              });
                                              //print("${info}");
                                              // if (info.claimDocumentPath != null) {
                                              //   // await saveFile("https://www.clickdimensions.com/links/TestPDFfile.pdf", "sample.pdf");
                                              //   await saveFile(
                                              //       "https://www.clickdimensions.com/links/TestPDFfile.pdf",
                                              //       "sample.pdf");
                                              //   ScaffoldMessenger.of(context)
                                              //       .showSnackBar(
                                              //     const SnackBar(
                                              //       content: Text(
                                              //         'success',
                                              //         style: TextStyle(
                                              //             color: Colors.white),
                                              //       ),
                                              //     ),
                                              //   );
                                              // } else {
                                              //   showTopSnackBar(
                                              //     dismissType: DismissType.onTap,
                                              //     displayDuration:
                                              //         const Duration(seconds: 3),
                                              //     context,
                                              //     const CustomSnackBar.info(
                                              //       message: "No link Available",
                                              //     ),
                                              //   );
                                              // }
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: const [
                                                    Text(
                                                      'Surety Letter', //Claim Document
                                                      style: kDarkgreyTextstyle,
                                                    ),
                                                    Icon(
                                                      Icons.download,
                                                      color: darkBlue,
                                                    ),
                                                  ],
                                                ),
                                                const VerticalHeight(),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    // const SizedBox(height: 7),
                                    info.ipdBillAmount == '0.00' ||
                                            info.ipdBillAmount == null
                                        ? const SizedBox.shrink()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'IPD Bill Amount',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.ipdBillAmount}',
                                                style: kBlueTextstyle,
                                              ),
                                            ],
                                          ),
                                    const SizedBox(height: 7),
                                    info.ipdAmountFromTpa == '0.00' ||
                                            info.ipdAmountFromTpa == null
                                        ? const SizedBox.shrink()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'IPD Amount from Insurer',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.ipdAmountFromTpa}',
                                                style: kBlueTextstyle,
                                              ),
                                            ],
                                          ),
                                    // const SizedBox(height: 7),
                                    // info.ipdSuretyLetterRequired == null
                                    //     ? SizedBox()
                                    //     : Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           const Text(
                                    //             'IPD Surety Letter',
                                    //             style: kDarkgreyTextstyle,
                                    //           ),
                                    //           IconButton(
                                    //             onPressed: () async {
                                    //               // String path = await ExtStorage.getExternalStorageDirectory();
                                    //               Navigator.push(
                                    //                 context,
                                    //                 MaterialPageRoute(
                                    //                   builder: (context) =>
                                    //                       DownloadingDialog(
                                    //                     pdfPath: info
                                    //                         .ipdSuretyLetterRequired!,
                                    //                   ),
                                    //                 ),
                                    //               );
                                    //             },
                                    //             icon: Icon(
                                    //               Icons.download,
                                    //               color: darkBlue,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    const SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Claimant Name',
                                          style: kDarkgreyTextstyle,
                                        ),
                                        Text(
                                          '${info.claimantName}',
                                          style: kBlueTextstyle,
                                        ),
                                      ],
                                    ),
                                    const VerticalHeight(),
                                    info.claimAddimitionDate != null &&
                                            info.claimAddimitionDate !=
                                                "01/01/1900 00:00:00"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Admission Date',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.claimAddimitionDate}'
                                                    .split(' ')
                                                    .first
                                                    .toString(),
                                                style: kBlueTextstyle,
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    const VerticalHeight(),
                                    info.claimDischargeDate != null &&
                                            info.claimDischargeDate !=
                                                "01/01/1900 00:00:00"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Discharge Date',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.claimDischargeDate}'
                                                    .split(' ')
                                                    .first
                                                    .toString(),
                                                style: kBlueTextstyle,
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    const VerticalHeight(),
                                    info.claimFinalApprovalAmount != null &&
                                            info.claimFinalApprovalAmount !=
                                                "0.00"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Final Approval Amount',
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Text(
                                                '${info.claimFinalApprovalAmount}',
                                                style: kBlueTextstyle,
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    const VerticalHeight(),
                                    GestureDetector(
                                      onTap: () async {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              // <-- SEE HERE
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(25.0),
                                              ),
                                            ),
                                            builder: (context) {
                                              final split = info?.claimDocuments
                                                  .split(',');
                                              // print(split);
                                              for (int i = 0;
                                                  i < split.length;
                                                  i++) {
                                                documents?.add(User(
                                                    name: "Document ${i + 1}",
                                                    address: split[i]));
                                              }
                                              // print("luffy $documents");
                                              print("zoro ${documents.length}");
                                              // print("zoro ${documents}");

                                              return SizedBox(
                                                  height: 200,
                                                  child: ListView.builder(
                                                    itemCount: documents.length,

                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      print(documents.length);
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: const BorderRadius
                                                                  .only(
                                                              topRight:
                                                                  Radius
                                                                      .circular(
                                                                          25.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      25.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      25.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      25.0)),
                                                          color: Colors
                                                              .blue.shade50,
                                                        ),
                                                        margin: const EdgeInsets
                                                            .all(5),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: ListTile(
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    ImageDialog(
                                                                        url:
                                                                            // 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                                                                            "${BASE_URL}/${documents[index].address}"));
                                                            // openFile(
                                                            //     url:
                                                            //         "${BASE_URL}/${documents[index].address}",
                                                            //     fileName:
                                                            //         'claimdoc.jpg');
                                                          },

                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(documents[
                                                                      index]
                                                                  .name),
                                                              const Icon(
                                                                Icons
                                                                    .remove_red_eye_outlined,
                                                                color: darkBlue,
                                                              ),
                                                            ],
                                                          ),

                                                          // subtitle: Text(
                                                          //     "Address: " +
                                                          //         userone
                                                          //             .address),
                                                        ),
                                                      );
                                                    },
                                                    // children: documents!
                                                    //     .map((userone) {

                                                    // }).toList(),
                                                  )
                                                  // Column(
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment.start,
                                                  //   mainAxisSize:
                                                  //       MainAxisSize.min,
                                                  //   children: const <Widget>[
                                                  //     Text('hi'),
                                                  //   ],
                                                  // ),
                                                  );
                                            });

                                        // createFileOfPdfUrl(info.claimId)
                                        //     .then((f) {
                                        //   setState(() {
                                        //     remotePDFpath = f.path;
                                        //   });
                                        // });

                                        //===========================direct download =================

                                        //print("${info}");
                                        // if (info.claimDocumentPath != null) {
                                        //   // await saveFile("https://www.clickdimensions.com/links/TestPDFfile.pdf", "sample.pdf");
                                        //   await saveFile(
                                        //       "https://www.clickdimensions.com/links/TestPDFfile.pdf",
                                        //       "sample.pdf");
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(
                                        //     const SnackBar(
                                        //       content: Text(
                                        //         'success',
                                        //         style: TextStyle(
                                        //             color: Colors.white),
                                        //       ),
                                        //     ),
                                        //   );
                                        // } else {
                                        //   showTopSnackBar(
                                        //     dismissType: DismissType.onTap,
                                        //     displayDuration:
                                        //         const Duration(seconds: 3),
                                        //     context,
                                        //     const CustomSnackBar.info(
                                        //       message: "No link Available",
                                        //     ),
                                        //   );
                                        // }
                                        documents.clear();
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Claim Document', //Claim Document
                                                style: kDarkgreyTextstyle,
                                              ),
                                              Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: darkBlue,
                                              ),
                                            ],
                                          ),
                                          const VerticalHeight(),
                                        ],
                                      ),
                                    )

                                    //reset
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
                                "You haven't saved any claims yet",
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
      ),
    );
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      print('file:');
      final response = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0),
      );
      print('hi: $response');
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  Future<bool> saveFile(String url, String fileName) async {
    try {
      print(await Permission.storage.request().isGranted);
      if (await Permission.storage.request().isGranted) {
        Directory? directory;
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          print("folder$folder");
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/PDF_Download";
        print("ssssssssssssssss${newPath}");
        directory = Directory(newPath);
        File saveFile = File(directory.path + "/$fileName");
        print("ssssssssssssssss${saveFile.path}");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          await Dio().download(
            url,
            saveFile.path,
          );
        }
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please allow for download docs',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return false;
      }
    } catch (e) {
      print("here");
      return false;
    }
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> createFileOfPdfUrl(int? id) async {
    Completer<File> completer = Completer();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userToken = prefs.getString('data');
      final header = {'Authorization': 'Bearer $userToken'};
      _progressIndicator.show();
      var res = await http.get(
          Uri.parse("$BASE_URL/api/Claims/GetSuretyletter?ClaimId=$id"),
          headers: header);
      log(res.body);
      _progressIndicator.hide();
      if (res.statusCode == 200 &&
          jsonDecode(res.body.toString())['data'] != null) {
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
            File file =await File("${generalDownloadDir.path}/suretyLetter+$name.pdf").create();
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
          final file = File('${dir.path}/suretyLetter+$name.pdf');
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

  Future<File> createFileOfjpgUrl(int? id) async {
    Completer<File> completer = Completer();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userToken = prefs.getString('data');
      final header = {'Authorization': 'Bearer $userToken'};
      _progressIndicator.show();
      var res = await http.get(
          Uri.parse("$BASE_URL/api/Claims/GetSuretyletter?ClaimId=$id"),
          headers: header);
      log(res.body);
      _progressIndicator.hide();
      if (res.statusCode == 200 &&
          jsonDecode(res.body.toString())['data'] != null) {
        showTopSnackBar(
          dismissType: DismissType.onTap,
          displayDuration: const Duration(seconds: 3),
          context,
          const CustomSnackBar.info(
            message: "File download at Download Folder in your device",
          ),
        );
        var data = jsonDecode(res.body.toString());
        Directory generalDownloadDir =
            Directory('/storage/emulated/0/Download');
        String name = (DateTime.now().microsecondsSinceEpoch).toString();
        File file =
            await File("${generalDownloadDir.path}/suretyLetter+$name.pdf")
                .create();
        Uint8List bytes = base64Decode(data['data']);
        await file.writeAsBytes(bytes);
        completer.complete(file);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pdf(path: file.path),
          ),
        );
      } else {
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

  Future openFile({required String url, required String fileName}) async {
    final file = await downloadFile(url, fileName!);
    print('Path : ${file?.path}');
    if (file == null) {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 3),
        context,
        const CustomSnackBar.info(
          message: "something went wrong",
        ),
      );
      return;
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 3),
        context,
        const CustomSnackBar.info(
          message: "File downloaded",
        ),
      );
      // OpenFile.open(file.path);
    }
  }
}

class VerticalHeight extends StatelessWidget {
  const VerticalHeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}

class User {
  String name, address;
  User({required this.name, required this.address});
}

class ImageDialog extends StatelessWidget {
  final String url;
  ImageDialog({required this.url});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(
            // 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
            url), fit: BoxFit.cover)),
      ),
    );
  }
}
