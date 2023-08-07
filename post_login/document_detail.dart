import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:Rakshan/config/api_url_mapping.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';

class DocumentDetail extends StatelessWidget {
  const DocumentDetail({
    Key? key,
    required this.documentId,
    required this.userDocumentId,
    required this.clientId,
    required this.documentTypeName,
    required this.documentPath,
    required this.documentName,
    required this.name,
  }) : super(key: key);

  final int documentId;
  final int userDocumentId;
  final int clientId;
  final String documentTypeName;
  final String documentPath;
  final String documentName;
  final String name;

  // final a =   {
  //     "documentId": 3,
  //     "clientId": 1,
  //     "userDocumentId": 1,
  //     "documentTypeName": "HOSPITAL",
  //     "documentPath": "Documents/ClientRegistration/20220714153551.jpg",
  //     "documentName": "Discount letter",
  //     "name": "Title"
  // },

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIndividual(
        title: name,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // child: Image.network(
                  //   "$BASE_URL/Documents/DocumentManager/473d4bd6-ff7e-4519-898a-622a4044df53.jpg",
                  // ),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    '$kBaseUrl/$documentPath',
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width - 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: Column(children: [
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(documentName),
                const SizedBox(height: 16),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
