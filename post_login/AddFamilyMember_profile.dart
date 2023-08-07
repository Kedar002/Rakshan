import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/controller/relationcontroller.dart';
import 'package:Rakshan/screens/post_login/allFamilyMembers.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/pre_login/app_bar_auth.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:Rakshan/widgets/pre_login/logo.dart';
import 'package:Rakshan/widgets/pre_login/tc_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/theme.dart';

class FamilyProfile extends StatefulWidget {
  static String id = 'add_family_member';
  @override
  State<FamilyProfile> createState() => _FamilyProfileState();
}

class _FamilyProfileState extends State<FamilyProfile> {
  final getfamily = RelationController();
  List<dynamic> gender = [];
  List<dynamic> familyMembers = [];
  String name = '';
  bool _isloading = false;

  var valueRelation;
  List relation = [];
  late String familyid; //default id for the dropdown
  final formKey = GlobalKey<FormState>();
  String? genderID;

  TextEditingController selectedgender = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController dob = TextEditingController();

  TextEditingController dateinput = TextEditingController();

  // >>>>>>>> New geder dropdown
  String? value;
  final item = ['Male', 'Female', 'Other'];
// >>>>>>>>>>>>
  final dropDownItems = [
    const DropdownMenuItem<String>(
      value: "Male",
      child: Text("Male"),
    ),
    const DropdownMenuItem<String>(
      value: "Female",
      child: Text("Female"),
    ),
  ];

  final dropDownItems1 = [];

  var selectedGender = 'Male';
  var selectedSpouse = 'Spouse';

  Future profile(
    String clientName,
    selectedgender,
    dateinput,
  ) async {
    print('update prfoile');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');

    final body = jsonEncode({
      "FamilyMappingId": 0,
      "EmployeeId": int.tryParse(userId as String), //making sting into int
      "RelationId": int.tryParse(valueRelation as String), //valueRelation,
      "EmployeePersonName": clientName,
      "EmployeePersonGender": value,
      "EmployeePersonDOB": dateinput,
      "active": 1
    });
    print('shubham>>>>>>>>>>>>');
    print('zorooo${userId}');
    print(body.toString());
    // final header = {'Authorization': 'Bearer $userToken'};
    // var userToken =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiZGQ3NmEyZi1mNDBlLTQyODMtYjE1MC0yOWUxMWE0NWVjMTYiLCJ2YWxpZCI6IjEiLCJVc2VyTmFtZSI6IkFydW4gR295YWwiLCJVc2VySWQiOiIxOCIsIkVtYWlsSWQiOiJBcnVuQGdtYWlsLmNvbSIsIk1vYmlsZU51bWJlciI6IjEyMzQ1Njc4OTAiLCJDbGllbnRJZCI6IjQiLCJTdWJzY3JpYmUiOiJVbnN1YnNjcmliZSIsIlN1YnNjcmlwdGlvbklkIjoiMCIsIlN1YnNjcmlwdGlvbk5hbWUiOiIiLCJleHAiOjE2NjM2ODA1OTEsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjQ0MzgyIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzODIifQ.TcEDyci7hIHJBYhpihPm_MmDmlBer6YhhVTj_5TVaWY';
    final header = {
      'Authorization': 'Bearer $userToken',
      HttpHeaders.contentTypeHeader: "application/json"
    };

    Response response = await post(
        Uri.parse('$BASE_URL/api/EmployeeFamily/SaveEmployeeFamily'),
        body: body,
        headers: header);
    //print('luffy${userID}');
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      // Navigator.pushNamed(context, accountRequestSubmitted);
      // ignore: use_build_context_synchronously
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: Duration(seconds: 2),
        context,
        CustomSnackBar.success(
          message: data['message'],
        ),
      );
      log(data['message']);
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 2),
        context,
        CustomSnackBar.info(
          message: data['message'],
        ),
      );
      log(data['message']);
    }
  }

  @override
  void initState() {
    Relation();
    // init();
    dateinput.text = "";
    super.initState();

    this.gender.add({'id': 1, 'label': 'Male'});
    this.gender.add({'id': 2, 'label': 'Female'});
  }

  Relation() async {
    final _family = await getfamily.getRelation().whenComplete(() {
      setState(() {});
    });
    setState(() {
      relation = _family;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIndividual(title: 'Add Family Member'),
      body: _isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Loading ...")
                ],
              ),
            )
          : SafeArea(
              child: Container(
                padding: kScreenPadding,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PROFILE IMAGE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Logo(),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        // CUSTOMER'S NAME
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$name',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                  controller: clientName,
                                  keyboardType: TextInputType.name,
                                  decoration: ktextfieldDecoration(
                                      'Family Member Name'),
                                  validator: (value) {
                                    if (value!.length > 1) {
                                      return null;
                                    } else {
                                      return 'Enter Name';
                                    }
                                  }),
                              const SizedBox(
                                height: 15,
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
                                    'Select Relation',
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
                                  value: valueRelation,
                                  onChanged: (newValue) {
                                    setState(() {
                                      valueRelation = newValue.toString();
                                    });
                                  },
                                  items: relation.map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem['relationId'].toString(),
                                      child: Text(
                                        valueItem['relation'],
                                        style: kApiTextstyle,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
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
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    iconSize: 34,
                                    hint: const Text('Select gender',
                                        style: kGreyTextstyle),
                                    value: value,
                                    isExpanded: true,
                                    items: item.map(buildMenuItem).toList(),
                                    onChanged: (value) => setState(() {
                                      this.value = value;
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 2),
                                height: 45,
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  controller: dateinput,
                                  //editing controller of this TextField
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'DOB',
                                    suffixIcon: Icon(Icons.calendar_today),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff325CA2), width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff325CA2), width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                  ),
                                  readOnly: true,
                                  //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime.now());

                                    if (pickedDate != null) {
                                      print(
                                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement

                                      setState(() {
                                        dateinput.text =
                                            formattedDate; //set output date to TextField value.
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlueButton(
                              onPressed: () {
                                if (clientName.text.isEmpty) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Enter Name',
                                    ),
                                  );
                                  return;
                                }
                                if (valueRelation == null) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Select Relation',
                                    ),
                                  );
                                  return;
                                }
                                if (value == null) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Select Gender',
                                    ),
                                  );
                                  return;
                                }
                                if (dateinput.text.isEmpty) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Select DOB',
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  _isloading = true;
                                });
                                profile(
                                  clientName.text,
                                  selectedgender.text,
                                  dateinput.text,
                                ).whenComplete(() {
                                  setState(() {
                                    _isloading = true;
                                    dateinput.clear();
                                    clientName.clear();
                                    valueRelation = null;
                                    // selectedgender.clear();
                                    value = null;

                                    _isloading = false;
                                  });
                                });

                                final isValid =
                                    formKey.currentState!.validate();
                                if (isValid) {
                                  formKey.currentState?.save();
                                  setState(() {
                                    _isloading = false;
                                  });
                                }
                              },
                              title: 'Save',
                              height: 45,
                              width: 160,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlueButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllFamilyMembers()),
                                );
                              },
                              title: 'Family members',
                              height: 45,
                              width: 160,
                            ),
                          ],
                        ),
                        const TcButton(
                          colour: Colors.white,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));
}
