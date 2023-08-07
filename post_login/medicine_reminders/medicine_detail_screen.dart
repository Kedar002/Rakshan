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

import '../../../constants/theme.dart';
import '../../../widgets/post_login/app_bar.dart';
import '../../../widgets/pre_login/blue_button.dart';
import 'package:http/http.dart' as http;

import 'everyday.dart';

class medicineDetailType extends StatefulWidget {
  int? prescriptionId;

  medicineDetailType(this.prescriptionId);

  // static String id = 'medicine_type';

  @override
  State<medicineDetailType> createState() => _medicineDetailTypeState();
}

class _medicineDetailTypeState extends State<medicineDetailType> {
  String? valueServiceProvideName;
  String? valueServiceProvideName2;
  String? medicineId;
  String? imageShow;
  File? image;

  final _controller1 = TextEditingController();
  final _medicineName = TextEditingController();
  final _quantity = TextEditingController();

  bool isLoad = false;

  // List listItem = ['Combiflam', 'Paracetamol', 'Sertor', 'Dichoflenc'];
  List<dynamic> listItem2 = [];

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Yes", "No", "Other", "Only When Needed"];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  List listItem = [
    'Once Daily',
    'Twice Daily',
    '3',
    '4',
    '5',
    'Every 6 Hours',
  ];

  List listItem3 = [
    'Once a week',
    'Twice a week',
    'Thrice a week',
    '4 Days a week',
    '5 Days a week',
    '6 Days a week',
  ];
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: const Color(0xff82B445),
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
                            'Medicine Details',
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
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
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            child: const Text(
                              "Medicine Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 2, right: 2),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
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
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            child: const Text(
                              "Form of Medicine",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Form of Medicine';
                              }
                              return null;
                            },
                            controller: _controller1,
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Form of Medicine',
                              hintStyle: const TextStyle(
                                fontFamily: 'OpenSans',
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff325CA2), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff325CA2), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              suffixIcon: PopupMenuButton(
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 30,
                                ),
                                itemBuilder: (context) {
                                  return List.generate(listItem2.length,
                                      (index) {
                                    return PopupMenuItem(
                                        child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _controller1.text =
                                              listItem2[index]['displayName'];
                                          medicineId =
                                              listItem2[index]['id'].toString();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          height: 40,
                                          color: Colors.white,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              listItem2[index]['displayName'])),
                                    ));
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            child: const Text(
                              "Medicine Quantity",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 2, right: 2),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
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
                                decoration: ktextfieldDecoration(
                                    'Enter Medicine Quantity'),
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          // FadeInImage(
                          //   image: NetworkImage(imageShow!),
                          //   placeholder: AssetImage('assets/images/pharmacy.png'),
                          // ),
                          imageShow != null
                              ? Container(
                                  child: Image.network(
                                    imageShow!,
                                    fit: BoxFit.contain,
                                    height: 300,
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, top: 10, bottom: 5),
                            child: const Text(
                              "Schedule Type",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: DropdownButton<String>(
                              value: _selectedGender,
                              items: _dropDownItem(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                                switch (value) {
                                  case "Yes":

                                  case "No":
                                    break;
                                  case "Other":
                                    break;
                                  case "Only When Needed":
                                    break;
                                }
                              },
                              hint: Text(_selectedGender!),
                            ),
                          ),
                          _selectedGender == "Yes"
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  child: DropdownButton(
                                    hint: Text(
                                      'Once a week',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black),
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
                                    value: valueServiceProvideName,
                                    onChanged: (newValue) {
                                      setState(() {
                                        valueServiceProvideName =
                                            newValue as String?;
                                      });
                                    },
                                    items: listItem.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : _selectedGender == "No"
                                  ? Container(
                                      padding: EdgeInsets.all(20),
                                      child: DropdownButton(
                                        hint: Text(
                                          'Once a Week',
                                          style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              //fontWeight: FontWeight.bold,
                                              color: Colors.black),
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
                                        value: valueServiceProvideName,
                                        onChanged: (newValue) {
                                          setState(() {
                                            valueServiceProvideName =
                                                newValue as String?;
                                          });
                                        },
                                        items: listItem3.map((valueItem) {
                                          return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container(),
                          const SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // floatingActionButton: BlueButton(
            //   onPressed: () {
            //     // Navigator.pushNamed(context, medicineEverydayScreen);
            //     // if (_formKey.currentState!.validate()) {
            //     //   _formKey.currentState!.save();
            //     //   Navigator.push(context, MaterialPageRoute(builder: (context) =>
            //     //       medicineEveryday(
            //     //         medicineName: _medicineName.text.trim(),
            //     //         medicineTypeId: medicineId,
            //     //         prescriptionId: widget.prescriptionId,
            //     //         medicineTypeName: _controller1.text.trim(),
            //     //         quantity: _quantity.text.trim(),
            //     //         image: image,
            //     //       )));
            //     // }
            //   },
            //   title: 'Next',
            //   height: MediaQuery.of(context).size.height * 0.05,
            //   width: MediaQuery.of(context).size.width * 0.5,
            // ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
          );
  }

  apiCall() async {
    setState(() {
      isLoad = true;
    });
    await setData();
    await getPrescriptionDetails();
    setState(() {
      isLoad = false;
    });
  }

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

      print("data" + data.toString());
    } else {
      // toast('Something went wrong');
    }
  }

  getPrescriptionDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    var response = await http.get(
        Uri.parse(
            '$BASE_URL/api/Medicine/GetPrescriptionMedicineDetails?PrescriptionDetailId=${widget.prescriptionId}'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
        });

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['isSuccess'] = true) {
        print("data" + data.toString());
        _medicineName.text = data['data']['medicineName'];
        medicineId = data['data']['medicineTypeId'].toString();
        _quantity.text = data['data']['medicineQuantity'].toString();
        _controller1.text = data['data']['medecineType'].toString();
        valueServiceProvideName = data['data']['scheduleType'].toString();
        _selectedGender = data['data']['everyday'].toString();
        imageShow = "$BASE_URL/${data['data']['documentPath']}";
      }
    } else {
      // toast('Something went wrong');
    }
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
