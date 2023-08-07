//shubham's code

import 'dart:convert';

import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:http/http.dart' as http;
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/models/getuserdocumentslist.dart';
import 'package:animated_horizontal_calendar/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:Rakshan/config/api_url_mapping.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/document_manager_controller.dart';
import 'package:Rakshan/screens/post_login/document_detail.dart';
import 'package:Rakshan/screens/post_login/document_manager.dart';
import 'package:Rakshan/screens/post_login/edit_document.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDocumentsList extends StatefulWidget {
  UserDocumentsList({Key? key}) : super(key: key);

  @override
  State<UserDocumentsList> createState() => _UserDocumentsListState();
}

class _UserDocumentsListState extends State<UserDocumentsList> {
  List<UserDocumentList?>? userDocuments = [];

  final documentManager = DocumentMangerController();
  bool isLoading = true;



  void fetchUserDocuments() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    final docs = await documentManager.getUserDocumentList();
    setState(() {
      userDocuments = docs;
      isLoading = false;
      print("docssss$userDocuments");
    });
  }

  void showDeleteConfirmModal(context, int id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Column(
          children: [
            Text("Delete - $name ?"),
          ],
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: darkBlue,
            ),
            onPressed: () async {
              final deleteStatus = await documentManager.deleteUserDocument(
                id,
              );
              print(id);
              if (deleteStatus) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Document deleted successfully",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    duration: Duration(
                      milliseconds: 200 - 00,
                    ),
                    backgroundColor: darkBlue,
                  ),
                );
                fetchUserDocuments();
              } else {
                // fail
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Document not deleted",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    duration: Duration(
                      milliseconds: 2000,
                    ),
                    backgroundColor: Colors.white,
                  ),
                );
              }
            },
            child: const Text(
              'YES',
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: darkBlue,
            ),
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text(
              'NO',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserDocuments();
    super.initState();
  }

  // Future<List<UserDocumentList?>?> getUserDocumentList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userToken = prefs.getString('data');
  //   var userId = prefs.getString('userId');
  //   final header = {'Authorization': 'Bearer $userToken'};

  //   var res = await http.get(
  //       Uri.parse(
  //           '$BASE_URL/api/DocumentManagement/GetDocumentListByUser?UserId=$userId'),
  //       headers: header);
  //   print('luffy${res.body}');

  //   if (res.statusCode == 200) {
  //     var data = jsonDecode(res.body.toString());
  //     print(data['data']);
  //     List<UserDocumentList> dataList = (data['data'] as List)
  //         .map<UserDocumentList>((e) => UserDocumentList.fromJson(e))
  //         .toList();
  //     print("madara$dataList");
  //     return dataList;
  //   } else {
  //     throw Exception('Failed to load Documents');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Your Documents',
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
                  fetchUserDocuments();
              },
              icon: const Icon(Icons.replay_outlined),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Loading your documents...")
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 28,
                  ),
                  child: userDocuments?.length != null
                      ? ListView.builder(
                          itemCount: userDocuments?.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (tx, index) {
                            final currentDocument = userDocuments?[index];
                            final userDocumentInstance = UserDocument(
                                documentId: currentDocument!.documentId!,
                                // documentId: currentDocument["documentId"],
                                documentTypeName:
                                    ('${currentDocument.documentTypeName}'),
                                // currentDocument["documentTypeName"],
                                userDocumentId: currentDocument.userDocumentId!,
                                // currentDocument["userDocumentId"],
                                clientId: currentDocument.clientId!,
                                // currentDocument["clientId"],
                                documentName:
                                    ('${currentDocument.documentName}'),
                                // currentDocument["documentName"],
                                name: ('${currentDocument.name}'),
                                // currentDocument["name"],
                                documentPath:
                                    ('${currentDocument.documentPath}')
                                // currentDocument["documentPath"] ??
                                // "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg",
                                );
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade300,
                                    Colors.blue.shade700,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DocumentDetail(
                                              documentId:
                                                  currentDocument.documentId!,
                                              // currentDocument["documentId"],
                                              userDocumentId: currentDocument
                                                  .userDocumentId!,
                                              // currentDocument[
                                              //     "userDocumentId"],
                                              clientId:
                                                  currentDocument.clientId!,
                                              // currentDocument["clientId"],
                                              documentTypeName:
                                                  ('${currentDocument.documentTypeName}'),
                                              // currentDocument[
                                              //     "documentTypeName"],
                                              documentPath:
                                                  ('${currentDocument.documentPath}'),
                                              //  currentDocument[
                                              // "documentPath"],
                                              documentName:
                                                  ('${currentDocument.documentName}'),
                                              //  currentDocument[
                                              // "documentName"],
                                              name:
                                                  ('${currentDocument.name}'))));
                                  // currentDocument["name"])));
                                },
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 32,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        '$kBaseUrl/${currentDocument.documentPath ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ('${currentDocument.name}'),
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                  ],
                                ),
                                subtitle: Wrap(
                                  children: [
                                    Text(
                                      ('${currentDocument.documentName}'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.white,
                                      onPressed: () async {
                                        showDeleteConfirmModal(
                                          context,
                                          currentDocument.documentId!,
                                          ('${currentDocument.name}'),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Colors.white,
                                      onPressed: () async {
                                        var result = await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) {
                                              return DocumentEditManager(
                                                initialDocument:
                                                    userDocumentInstance,
                                              );
                                            },
                                          ),
                                        );
                                        if(result){
                                          fetchUserDocuments();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 8,
                          ),
                          margin: const EdgeInsets.only(
                            top: 24,
                          ),
                          child: const Text(
                            "Ops! It seems you have no document.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}

//Rohits Code
// import 'package:animated_horizontal_calendar/utils/color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:Rakshan/config/api_url_mapping.dart';
// import 'package:Rakshan/constants/theme.dart';
// import 'package:Rakshan/controller/document_manager_controller.dart';
// import 'package:Rakshan/screens/post_login/document_detail.dart';
// import 'package:Rakshan/screens/post_login/document_manager.dart';
// import 'package:Rakshan/screens/post_login/edit_document.dart';
// import 'package:Rakshan/widgets/post_login/app_bar.dart';

// class UserDocumentsList extends StatefulWidget {
//   UserDocumentsList({Key? key}) : super(key: key);

//   @override
//   State<UserDocumentsList> createState() => _UserDocumentsListState();
// }

// class _UserDocumentsListState extends State<UserDocumentsList> {
//   List userDocuments = [];

//   final documentManager = DocumentMangerController();
//   bool isLoading = true;

//   void fetchUserDocuments() async {
//     if (!isLoading) {
//       setState(() {
//         isLoading = true;
//       });
//     }
//     final docs = await documentManager.getUserDocumentList();
//     setState(() {
//       userDocuments = docs;
//       isLoading = false;
//     });
//   }

//   void showDeleteConfirmModal(context, int id, String name) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Column(
//           children: [
//             Text("Delete - $name ?"),
//           ],
//         ),
//         actions: [
//           OutlinedButton(
//             style: OutlinedButton.styleFrom(
//               primary: darkBlue,
//             ),
//             onPressed: () async {
//               final deleteStatus = await documentManager.deleteUserDocument(
//                 id,
//               );
//               if (deleteStatus) {
//                 Navigator.of(ctx).pop();
//                 ScaffoldMessenger.of(ctx).showSnackBar(
//                   const SnackBar(
//                     content: Text(
//                       "Document deleted successfully",
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     duration: Duration(
//                       milliseconds: 2000,
//                     ),
//                     backgroundColor: Colors.blue,
//                   ),
//                 );
//                 fetchUserDocuments();
//               } else {
//                 // fail
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text(
//                       "Document not deleted",
//                       style: TextStyle(
//                         color: Colors.red,
//                       ),
//                     ),
//                     duration: Duration(
//                       milliseconds: 2000,
//                     ),
//                     backgroundColor: Colors.white,
//                   ),
//                 );
//               }
//             },
//             child: const Text(
//               'YES',
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: darkBlue,
//             ),
//             onPressed: () => {Navigator.of(context).pop()},
//             child: const Text(
//               'NO',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     fetchUserDocuments();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context, true);
//           }, // Handle your on tap here.
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: const Color(0xfffcfcfc),
//         title: const Text(
//           'Your Documents',
//           style: TextStyle(
//             fontFamily: 'OpenSans',
//             color: Color(0xff2e66aa),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(right: 20.0),
//             child: IconButton(
//               onPressed: () {
//                 setState(() {});
//               },
//               icon: const Icon(Icons.replay_outlined),
//             ),
//           ),
//         ],
//         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
//       ),
//       body: isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: const [
//                   CircularProgressIndicator(),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   Text("Loading your documents...")
//                 ],
//               ),
//             )
//           : SingleChildScrollView(
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 28,
//                   ),
//                   child: userDocuments.length > 0
//                       ? ListView.builder(
//                           itemCount: userDocuments.length,
//                           shrinkWrap: true,
//                           physics: const BouncingScrollPhysics(),
//                           itemBuilder: (tx, index) {
//                             final currentDocument = userDocuments[index];
//                             final userDocumentInstance = UserDocument(
//                                 documentId: currentDocument["documentId"],
//                                 documentTypeName:
//                                     currentDocument["documentTypeName"],
//                                 userDocumentId:
//                                     currentDocument["userDocumentId"],
//                                 clientId: currentDocument["clientId"],
//                                 documentName: currentDocument["documentName"],
//                                 name: currentDocument["name"],
//                                 documentPath: currentDocument["documentPath"] ??
//                                     "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg");
//                             return Container(
//                               margin: const EdgeInsets.only(
//                                 bottom: 20,
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.blue.shade300,
//                                     Colors.blue.shade700,
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: ListTile(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => DocumentDetail(
//                                               documentId:
//                                                   currentDocument["documentId"],
//                                               userDocumentId: currentDocument[
//                                                   "userDocumentId"],
//                                               clientId:
//                                                   currentDocument["clientId"],
//                                               documentTypeName: currentDocument[
//                                                   "documentTypeName"],
//                                               documentPath: currentDocument[
//                                                   "documentPath"],
//                                               documentName: currentDocument[
//                                                   "documentName"],
//                                               name: currentDocument["name"])));
//                                 },
//                                 dense: true,
//                                 leading: CircleAvatar(
//                                   backgroundColor: Colors.white,
//                                   radius: 32,
//                                   child: CircleAvatar(
//                                     radius: 30,
//                                     backgroundImage: NetworkImage(
//                                         '$kBaseUrl/${currentDocument["documentPath"] ?? "Documents/DocumentManager/07235966-05ce-43d3-8a0b-367dfd3499d3.jpeg"}'),
//                                   ),
//                                 ),
//                                 title: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       currentDocument["name"],
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 14,
//                                     ),
//                                   ],
//                                 ),
//                                 subtitle: Wrap(
//                                   children: [
//                                     Text(
//                                       currentDocument["documentName"],
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white70,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Wrap(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.delete),
//                                       color: Colors.white,
//                                       onPressed: () async {
//                                         showDeleteConfirmModal(
//                                           context,
//                                           currentDocument["documentId"],
//                                           currentDocument["name"],
//                                         );
//                                       },
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.edit),
//                                       color: Colors.white,
//                                       onPressed: () {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (ctx) {
//                                               return DocumentEditManager(
//                                                 initialDocument:
//                                                     userDocumentInstance,
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         )
//                       : Container(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 20,
//                             horizontal: 8,
//                           ),
//                           margin: const EdgeInsets.only(
//                             top: 24,
//                           ),
//                           child: const Text(
//                             "Ops! It seems you have no document.",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
