// import 'dart:typed_data';
// import 'package:Rakshan/constants/theme.dart';
// import 'package:Rakshan/controller/doctor_controller.dart';
// import 'package:Rakshan/widgets/post_login/app_bar.dart';
// import 'package:signature/signature.dart';
// import 'package:flutter/material.dart';

// class CommonNotePad extends StatefulWidget {
//   CommonNotePad({Key? key, required this.title}) : super(key: key);

//   var title;

//   @override
//   State<CommonNotePad> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<CommonNotePad> {
//   Uint8List? exportedImage;
// //  Image? image;

//   SignatureController controller = SignatureController(
//     penStrokeWidth: 1.0,
//     penColor: Colors.black87,
//     exportBackgroundColor: Colors.white70,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarIndividual(
//         title: widget.title,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Signature(
//               controller: controller,
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 1,
//               backgroundColor: Color.fromARGB(255, 255, 255, 255),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             // SizedBox(
//             //   height: 10,
//             // ),
//             if (exportedImage != null)
//               Image.memory(
//                 exportedImage!,
//                 width: 720, //300
//                 height: 1080, //250
//               )
//           ],
//         ),
//       ),
//       floatingActionButton: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: ElevatedButton(
//                 onPressed: () async {
//                   exportedImage = await controller.toPngBytes();
//                   // image = await controller.toImage();
//                   //API
//                   // DoctorController()
//                   //     .saveDoctorPriscription()
//                   //     .whenComplete((() {}));
//                   // setState(() {});
//                 },
//                 child: const Text(
//                   "Save",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(darkBlue),
//                   // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   //     RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(18.0),
//                   //         side: BorderSide(color: Colors.red))),
//                 )),
//           ),
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: ElevatedButton(
//               onPressed: () {
//                 controller.clear();
//               },
//               child: const Text(
//                 "Clear",
//                 style: TextStyle(fontSize: 20),
//               ),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(darkBlue),
//                 // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 //     RoundedRectangleBorder(
//                 //         borderRadius: BorderRadius.circular(18.0),
//                 //         side: BorderSide(color: darkBlue)))
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
