// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';

import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../constants/theme.dart';
import '../../../widgets/post_login/app_bar.dart';
import '../../../widgets/pre_login/blue_button.dart';
import 'package:http/http.dart' as http;

import 'everyday.dart';

class medicineType extends StatefulWidget {
  int? prescriptionId;
  medicineType(this.prescriptionId);
  static String id = 'medicine_type';

  @override
  State<medicineType> createState() => _medicineTypeState();
}

class _medicineTypeState extends State<medicineType> {
  String? valueServiceProvideName;
  String? valueServiceProvideName2;
  String? medicineId;
  File? image;

  var valueFormofMedicine;
  var valueTimeofMedicine;

  final _controller1 = TextEditingController();
  final _controller = TextEditingController();
  final _medicineName = TextEditingController();
  final _quantity = TextEditingController();

  bool isLoad = false;

  List listItem = [
    'Before Meal',
    'After Meal',
    'Empty Stomach',
    'At the time of meal'
  ];
  List<dynamic> listItem2 = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff82B445),
      appBar: AppBarIndividual(title: 'Rakshan'),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: kScreenPadding,
              child: Column(
                children: const [
                  Center(
                    child: Text(
                      'Add Medicine Details',
                      style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    border: Border.symmetric(),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.0)),
                    color: Color(0xffFBFBFB)),
                padding: kScreenPadding,
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 2, right: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Medicine Name';
                            }
                            return null;
                          },
                          controller: _medicineName,
                          decoration:
                              ktextfieldDecoration('Enter Medicine Name'),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: darkBlue, width: 1),
                      ),
                      child: DropdownButton(
                        hint: Text(
                          'Form of Medicine',
                          style: kGreyTextstyle,
                        ),
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        value: valueFormofMedicine,
                        onChanged: (newValue) {
                          setState(() {
                            valueFormofMedicine = newValue.toString();
                            // _controller1.text =
                            //      listItem2[index]['displayName'];
                          });
                        },
                        items: listItem2.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem['id'].toString(),
                            child: Text(
                              valueItem['displayName'],
                              style: kApiTextstyle,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // TextFormField(
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Enter Form of Medicine';
                    //     }
                    //     return null;
                    //   },
                    //   controller: _controller1,
                    //   readOnly: true,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     hintText: 'Form of Medicine',
                    //     hintStyle: const TextStyle(
                    //       fontFamily: 'OpenSans',
                    //     ),
                    //     contentPadding: const EdgeInsets.symmetric(
                    //         vertical: 10.0, horizontal: 20.0),
                    //     border: const OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    //     ),
                    //     enabledBorder: const OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Color(0xff325CA2), width: 1.0),
                    //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    //     ),
                    //     focusedBorder: const OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Color(0xff325CA2), width: 1.0),
                    //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    //     ),
                    //     suffixIcon: PopupMenuButton(
                    //       icon: const Icon(
                    //         Icons.arrow_drop_down,
                    //         size: 30,
                    //       ),
                    //       itemBuilder: (context) {
                    //         return List.generate(listItem2.length, (index) {
                    //           return PopupMenuItem(
                    //               child: GestureDetector(
                    //             onTap: () {
                    //               setState(() {
                    //                 _controller1.text =
                    //                     listItem2[index]['displayName'];
                    //                 medicineId =
                    //                     listItem2[index]['id'].toString();
                    //               });
                    //               Navigator.of(context).pop();
                    //             },
                    //             child: Container(
                    //                 height: 40,
                    //                 color: Colors.white,
                    //                 alignment: Alignment.centerLeft,
                    //                 child:
                    //                     Text(listItem2[index]['displayName'])),
                    //           ));
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.2,
                    //   height: MediaQuery.of(context).size.height * 0.08,
                    //   child: TextButton(
                    //       style: TextButton.styleFrom(
                    //           backgroundColor: Color(0xffEDF5FF)),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: const [
                    //           Text('Add Medicine Image'),
                    //           SizedBox(
                    //             width: 5,
                    //           ),
                    //           Icon(
                    //             Icons.add_box_outlined,
                    //             size: 24.0,
                    //           ),
                    //         ],
                    //       ),
                    //       onPressed: () {
                    //         showDialog(
                    //           context: context,
                    //           builder: (context) => AlertDialog(
                    //             title: Text('Upload Document'),
                    //             actions: [
                    //               Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   ElevatedButton(
                    //                     style: ElevatedButton.styleFrom(
                    //                         primary: darkBlue),
                    //                     onPressed: () =>
                    //                         pickImage(ImageSource.camera),
                    //                     child: Row(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       // ignore: prefer_const_literals_to_create_immutables
                    //                       children: [
                    //                         Text('Camera'), // <-- Text
                    //                         const SizedBox(
                    //                           width: 5,
                    //                         ),
                    //                         const Icon(
                    //                           // <-- Icon
                    //                           Icons.camera_alt_outlined,
                    //                           size: 24.0,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   ElevatedButton(
                    //                     style: ElevatedButton.styleFrom(
                    //                         primary: darkBlue),
                    //                     onPressed: () =>
                    //                         pickImage(ImageSource.gallery),
                    //                     child: Row(
                    //                       mainAxisSize: MainAxisSize.min,
                    //                       // ignore: prefer_const_literals_to_create_immutables
                    //                       children: [
                    //                         Text('Gallery'), // <-- Text
                    //                         const SizedBox(
                    //                           width: 5,
                    //                         ),
                    //                         const Icon(
                    //                           // <-- Icon
                    //                           Icons.image,
                    //                           size: 24.0,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               )
                    //             ],
                    //           ),
                    //         );
                    //       }),
                    // )
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: darkBlue, width: 1),
                      ),
                      child: DropdownButton(
                        hint: Text(
                          'Time of Medicine',
                          style: kGreyTextstyle,
                        ),
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        value: valueTimeofMedicine,
                        onChanged: (newValue) {
                          setState(() {
                            valueTimeofMedicine = newValue.toString();
                            // _controller1.text =
                            //      listItem2[index]['displayName'];
                          });
                        },
                        items: listItem.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem,
                              style: kApiTextstyle,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // TextFormField(
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Enter Time of Medicine';
                    //     }
                    //     return null;
                    //   },
                    //   controller: _controller,
                    //   readOnly: true,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     hintText: 'Time of Medicine',
                    //     hintStyle: const TextStyle(
                    //       fontFamily: 'OpenSans',
                    //     ),
                    //     contentPadding: const EdgeInsets.symmetric(
                    //         vertical: 10.0, horizontal: 20.0),
                    //     border: const OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    //     ),
                    //     enabledBorder: const OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Color(0xff325CA2), width: 1.0),
                    //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    //     ),
                    //     focusedBorder: const OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Color(0xff325CA2), width: 1.0),
                    //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    //     ),
                    //     suffixIcon: PopupMenuButton(
                    //       icon: const Icon(
                    //         Icons.arrow_drop_down,
                    //         size: 30,
                    //       ),
                    //       itemBuilder: (context) {
                    //         return List.generate(listItem.length, (index) {
                    //           return PopupMenuItem(
                    //               child: GestureDetector(
                    //             onTap: () {
                    //               setState(() {
                    //                 _controller.text = listItem[index];
                    //               });
                    //               Navigator.of(context).pop();
                    //             },
                    //             child: Container(
                    //                 height: 40,
                    //                 color: Colors.white,
                    //                 alignment: Alignment.centerLeft,
                    //                 child: Text(listItem[index])),
                    //           ));
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 2, right: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Medicine Quantity';
                            }
                            return null;
                          },
                          controller: _quantity,
                          keyboardType: TextInputType.number,
                          decoration:
                              ktextfieldDecoration('Enter Medicine Quantity'),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                        child: image == null
                            ? Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Add an Image",
                                      style: TextStyle(
                                          fontSize: 18, fontFamily: 'OpenSans'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  Container(
                                    //height: MediaQuery.of(context).size.height * 0.5,
                                    // width: MediaQuery.of(context).size.width * 1,
                                    //alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          child: ElevatedButton(
                                            // color: Colors.lightBlue[200],
                                            onPressed: () {
                                              getFromGallery();
                                            },
                                            child: Text("GALLERY"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          child: ElevatedButton(
                                            // color: Colors.lightBlue[200],
                                            onPressed: () {
                                              _getFromCamera();
                                            },
                                            child: Text("CAMERA"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlueButton(
        onPressed: () {
          if (image == null) {
            showTopSnackBar(
              dismissType: DismissType.onTap,
              displayDuration: const Duration(seconds: 2),
              context,
              const CustomSnackBar.info(
                message: 'Please Upload Image',
              ),
            );
            return;
          }
          // Navigator.pushNamed(context, medicineEverydayScreen);
          else if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => medicineEveryday(
                          medicineName: _medicineName.text.trim(),
                          medicineTypeId: valueFormofMedicine.toString(),
                          prescriptionId: widget.prescriptionId,
                          medicineTypeName: 'addLater',
                          // medicineTypeName: _controller1.text.trim(),
                          timeOfMedicine: valueTimeofMedicine.toString(),
                          quantity: _quantity.text.trim(),
                          image: image,
                        )));
          } else {}
        },
        title: 'Next',
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Future pickImage(ImageSource source) async {
  //   try {
  //     await ImagePicker().pickImage(source: source);
  //     if (Image == null) return;

  //     final imageTemporary = File(image!.path);
  //     this.image = imageTemporary;
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  setData() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    var response = await http.get(
        Uri.parse(
            '$BASE_URL/api/Medicine/GetMedecineTypeDropDown?MedecineId=0'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
        });

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['isSuccess'] = true) {
        for (int i = 0; i < data['data'].length; i++) {
          listItem2.add(data['data'][i]);
        }
      }
      setState(() {
        isLoad = false;
      });
      print("data" + data.toString());
    } else {
      setState(() {
        isLoad = false;
      }); // toast('Something went wrong');
    }
    setState(() {
      isLoad = false;
    });
  }

  getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
}

class choiceChipWidget extends StatefulWidget {
  late final String chipName;

  choiceChipWidget({Key? key, required this.chipName}) : super(key: key);

  @override
  State<choiceChipWidget> createState() => _choiceChipWidgetState();
}

class _choiceChipWidgetState extends State<choiceChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      backgroundColor: Colors.transparent,
      shape: const StadiumBorder(side: BorderSide()),
      selectedColor: const Color(0xff325CA2),
      disabledColor: Colors.grey,
      pressElevation: 20.0,
      label: Text(widget.chipName),
      selected: _isSelected,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
    );
  }
}
