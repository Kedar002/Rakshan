import 'dart:io';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/config/api_url_mapping.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserPrescriptionDetail extends StatelessWidget {
  const UserPrescriptionDetail({
    Key? key,
    required this.documentPath,
    required this.documentName,
  }) : super(key: key);

  final String documentPath;
  final String documentName;

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
        title: documentName,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: kScreenPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: darkBlue),
                      onPressed: () {
                        shareImage();
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share')),

                  /// THIS IS COMMEMTED COZ PACKAGE DIDNT MATHCH WITH KOTLIN VERSION >>>>>>>>>>
                  // ElevatedButton.icon(
                  //     style:
                  //         ElevatedButton.styleFrom(backgroundColor: darkBlue),
                  //     onPressed: () {
                  //       downloadImage(context);
                  //     },
                  //     icon: const Icon(Icons.download),
                  //     label: const Text('Download'))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    // child: Image.network(
                    //   "$BASE_URL/Documents/DocumentManager/473d4bd6-ff7e-4519-898a-622a4044df53.jpg",
                    // ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        '$kBaseUrl/$documentPath',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  shareImage() async {
    final urlImage = '$kBaseUrl/$documentPath';
    final url = Uri.parse(urlImage);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);

    await Share.shareFiles([path], text: '');
  }

  // downloadImage(BuildContext context) async {
  //   try {
  //     // Saved with this method.
  //     var imageId =
  //         await ImageDownloader.downloadImage('$kBaseUrl/$documentPath');
  //     if (imageId == null) {
  //       return;
  //     }

  //     // Below is a method of obtaining saved image information.
  //     var fileName = await ImageDownloader.findName(imageId);
  //     var path = await ImageDownloader.findPath(imageId);
  //     var size = await ImageDownloader.findByteSize(imageId);
  //     var mimeType = await ImageDownloader.findMimeType(imageId);
  //     // ignore: use_build_context_synchronously
  //     showTopSnackBar(
  //       dismissType: DismissType.onTap,
  //       displayDuration: const Duration(seconds: 2),
  //       context,
  //       const CustomSnackBar.success(
  //         message: "Image is downloaded",
  //       ),
  //     );
  //   } on PlatformException catch (error) {
  //     showTopSnackBar(
  //         dismissType: DismissType.onTap,
  //         displayDuration: const Duration(seconds: 2),
  //         context,
  //         const CustomSnackBar.error(
  //           message: "Something went wrong",
  //         ));
  //     print("chopper$error");
  //   }
  // }
}
