// import 'package:flutter/material.dart';
// import 'package:Rakshan/constants/textfield.dart';
// import 'package:Rakshan/routes/app_routes.dart';
// import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// import 'package:Rakshan/widgets/post_login/app_bar.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';
// import 'package:Rakshan/widgets/post_login/discout_offered.dart';
// import 'package:snippet_coder_utils/FormHelper.dart';

// class ClaimProcessOPD extends StatefulWidget {
//   static String claimProcessoPD = 'claim_process_opd';

//   @override
//   State<ClaimProcessOPD> createState() => _ClaimProcessOPDState();
// }

// class _ClaimProcessOPDState extends State<ClaimProcessOPD> {
//   String? valueHospitalName;
//   List listItem4 = ['item 1', 'item 2'];

//   String? valueServiceName;
//   List listItem5 = ['item 10', 'item 20'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBarIndividual(
//         title: 'Claim Process (OPD)',
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: [
//           //extract padding to create this repeatative code in one reuseable widget.
// // create a seperate class for dropdown button and pass method.

//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Container(
//               padding: EdgeInsets.only(left: 16, right: 16),
//               decoration: BoxDecoration(
//                 color: Color(0xfff1f7ff),
//                 border: Border.all(color: Colors.white, width: 1),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: DropdownButton(
//                 hint: Text(
//                   'Hospital Name',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//                 dropdownColor: Colors.white,
//                 icon: Icon(Icons.arrow_drop_down),
//                 iconSize: 36,
//                 isExpanded: true,
//                 underline: SizedBox(),
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//                 value: valueHospitalName,
//                 onChanged: (newValue) {
//                   setState(() {
//                     valueHospitalName = newValue as String?;
//                   });
//                 },
//                 items: listItem4.map((valueItem) {
//                   return DropdownMenuItem(
//                     value: valueItem,
//                     child: Text(valueItem),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           //1st part
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Container(
//               padding: EdgeInsets.only(left: 16, right: 16),
//               decoration: BoxDecoration(
//                 color: Color(0xfff1f7ff),
//                 border: Border.all(color: Colors.white, width: 1),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: DropdownButton(
//                 hint: Text(
//                   'Service Name',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//                 dropdownColor: Colors.white,
//                 icon: Icon(Icons.arrow_drop_down),
//                 iconSize: 36,
//                 isExpanded: true,
//                 underline: SizedBox(),
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//                 value: valueServiceName,
//                 onChanged: (newValue) {
//                   setState(() {
//                     valueServiceName = newValue as String?;
//                   });
//                 },
//                 items: listItem5.map((valueItem) {
//                   return DropdownMenuItem(
//                     value: valueItem,
//                     child: Text(valueItem),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           DiscountOffered(),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                     primary: Colors.blue,
//                     padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
//                     minimumSize: Size(360, 10),
//                     side: BorderSide(color: Colors.blue),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(7))),
//                 onPressed: () {},
//                 child: Text(
//                   'Upload',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//               BlueButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, walletMessage);
//                   },
//                   title: 'Save',
//                   height: 50,
//                   width: 360),
//             ],
//           ),
//         ]),
//       ),
//     );
//   }
// }
