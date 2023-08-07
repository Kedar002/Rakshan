//  Expanded(
//               child: LayoutBuilder(builder: (context, constraints) {
//                 if (items.isNotEmpty) {
//                   return Stack(children: [
//                     ListView.separated(
//                       controller: _scrollController,
//                       itemBuilder: (BuildContext context, index) {
//                         if (index < items.length) {
//                           return ListTile(
//                             title: Text(
//                               items[index],
//                             ),
//                           );
//                         } else {
//                           return Container(
//                             width: constraints.maxWidth,
//                             height: 50,
//                             child: Center(
//                               child: Text('Nothing more to load'),
//                             ),
//                           );
//                         }
//                       },
//                       separatorBuilder: (BuildContext context, index) {
//                         return Divider(
//                           height: 1,
//                         );
//                       },
//                       itemCount: items.length + (allLoaded ? 1 : 0),
//                     ),
//                     if (loading) ...[
//                       Positioned(
//                         left: 0,
//                         bottom: 0,
//                         child: Container(
//                           width: constraints.maxWidth,
//                           child: Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                         ),
//                       ),
//                     ]
//                   ]);
//                 } else {
//                   return Container(
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }
//               }),
//             ),




















// import 'dart:html';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// // import 'package:image_picker/image_picker.dart';

// // import 'package:Rakshan/widgets/post_login/app_bar.dart';
// // import 'package:Rakshan/widgets/post_login/app_menu.dart';
// // import 'package:Rakshan/widgets/pre_login/blue_button.dart';

// import '../../routes/app_routes.dart';

// class BookingCalender extends StatefulWidget {
//   @override
//   _BookingCalenderState createState() => _BookingCalenderState();
// }

// class _BookingCalenderState extends State<BookingCalender> {
//   final ImagePicker imagePicker = ImagePicker();
//   List<XFile>? _ImageFileList = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(children: [
//           OutlinedButton(
//               onPressed: () {
//                 selectedImage();
//               },
//               child: Text("Select Images")),
//           SizedBox(height: 5),
//           Expanded(
//             child: GridView.builder(
//               itemCount: _ImageFileList!.length,
//               gridDelegate:
//                   SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//               itemBuilder: (BuildContext context, int index) {
//                 return Image.file(File(_ImageFileList![index].path));
//               },
//             ),
//           )
//         ]),
//       ), // Column // SafeArea
//     ); // Scaffold
//   }

//   void selectedImage() async {
//     final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
//     if (selectedImages!.isNotEmpty) {
//       _ImageFileList!.addAll(selectedImages);
//     }
//     // add permission inside manifest
//     print('Image List Length : ' + _ImageFileList!.length.toString());
//   }
// }





// class InfinteScrollingPagination extends StatefulWidget {
//   @override
//   _InfinteScrollingPaginationState createState() =>
//       _InfinteScrollingPaginationState();
// }

// class _InfinteScrollingPaginationState
//     extends State<InfinteScrollingPagination> {
//   final ScrollController _scrollController = ScrollController();
//   List<String> items = [];
//   bool loading = false, allLoaded = false;

//   mockFetch() async {
//     if (allLoaded) {
//       return;
//     }

//     setState(() {
//       loading = true;
//     });
//     await Future.delayed(Duration(milliseconds: 500));
//     List<String> newData = items.length >= 60
//         ? []
//         : List.generate(10, (index) => "List Item${index + items.length}");
//     if (newData.isNotEmpty) {
//       items.addAll(newData);
//     }
//     setState(() {
//       loading = false;
//       allLoaded = newData.isEmpty;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     mockFetch();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent &&
//           !loading) {
//         print('new data called');
//         mockFetch();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _scrollController.dispose();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             ListView.builder(
//                 controller: _scrollController,
//                 itemCount: items.length + (allLoaded ? 1 : 0),
//                 itemBuilder: (BuildContext context, int index) {
//                   if (index < items.length) {
//                     return Text('TEST');
//                   } else {
//                     return Container(
// //  width: constraints.maxWidth,
//                         height: 50,
//                         child: Center(
//                           child: Text("Nothing more to Load"),
//                         ));
//                   }
//                 }),
//             Positioned(
//               left: 0,
//               bottom: 0,
//               child: Container(
//                   width: double.infinity,
//                   height: 80,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   )
//                   //wrap list view with stack.
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
