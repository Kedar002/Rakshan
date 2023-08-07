import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:Rakshan/constants/api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:animated_horizontal_calendar/utils/color.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/user_profilecontroller.dart';

import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/app_bar_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:Rakshan/widgets/pre_login/login_help.dart';
import 'package:Rakshan/widgets/pre_login/logo.dart';
import 'package:Rakshan/widgets/pre_login/tc_button.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../post_login/welcome_screen.dart';

class UserProfile extends StatefulWidget {
  static String id = 'user_profile';
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? value;

  String? bloodgroup;
  final item = ['Male', 'Female', 'Other'];
  List bloodGrouplist = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  List<dynamic> gender = [];
  // List getUserData = [];
  final formKey = GlobalKey<FormState>();
  final _snackBar = GlobalKey<State<StatefulWidget>>();
  String? genderID;
  final getuserdata = UserProfileController();
  InternetCheck getInternetStatus = InternetCheck();

  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController selectedgender = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController policyNumber = TextEditingController();
  TextEditingController dateinputFrom = TextEditingController();
  TextEditingController dateinputTo = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController insuranceCompanyName = TextEditingController();

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

  // var DropDown;
  // var selectedGender = 'Male';
  bool isDiabetic = false;
  bool isHeartPatient = false;
  bool policy = false;
  bool _isloading = true;

//post api

  Future profile(
      String mobileNumber,
      email,
      selectedgender,
      clientName,
      dateinput,
      weight,
      height,
      isDiabetic,
      isHeartPatient,
      bloodgroup,
      policy,
      policyNumber,
      dateinputTo,
      dateinputFrom,
      insuranceCompanyName) async {
    print('update prfoile');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('data');
    var userId = prefs.getString('userId');

    final body = jsonEncode({
      "EmployeeId": int.tryParse(userId as String),
      "ClientId": 0,
      "EmailId": email,
      "MobileNumber": mobileNumber,
      "Name": clientName,
      "DOB": dateinput,
      "Gender": value,
      "DOL": "06/06/1994",
      "UserId": int.tryParse(userId),
      "IsDiabeticPatient": isDiabetic,
      "IsHeartPatient": isHeartPatient,
      "Height": height,
      "Weight": weight,
      "BloodGroup": bloodgroup,
      "IsHealthCarePolicy": policy,
      "PolicyNumber": policyNumber,
      "PolicyFromDate": dateinputFrom,
      "PolicyToDate": dateinputTo,
      "InsuranceCompany": insuranceCompanyName
    });
    print('shubham>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    print(userId);
    print(body.toString());

    // final header = {'Authorization': 'Bearer $userToken'};
    // var userToken =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiZGQ3NmEyZi1mNDBlLTQyODMtYjE1MC0yOWUxMWE0NWVjMTYiLCJ2YWxpZCI6IjEiLCJVc2VyTmFtZSI6IkFydW4gR295YWwiLCJVc2VySWQiOiIxOCIsIkVtYWlsSWQiOiJBcnVuQGdtYWlsLmNvbSIsIk1vYmlsZU51bWJlciI6IjEyMzQ1Njc4OTAiLCJDbGllbnRJZCI6IjQiLCJTdWJzY3JpYmUiOiJVbnN1YnNjcmliZSIsIlN1YnNjcmlwdGlvbklkIjoiMCIsIlN1YnNjcmlwdGlvbk5hbWUiOiIiLCJleHAiOjE2NjM2ODA1OTEsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjQ0MzgyIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzODIifQ.TcEDyci7hIHJBYhpihPm_MmDmlBer6YhhVTj_5TVaWY';
    final header = {
      'Authorization': 'Bearer $userToken',
      HttpHeaders.contentTypeHeader: "application/json"
    };

    Response response = await post(
        Uri.parse('$BASE_URL/api/Common/SaveEmployeeInfo'),
        body: body,
        headers: header);
    print(response.statusCode);
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        _isloading = false;
      });
      // Navigator.pushNamed(context, accountRequestSubmitted);
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
      showTopSnackBar(
        dismissType: DismissType.onTap,
        displayDuration: const Duration(seconds: 2),
        context,
        CustomSnackBar.info(
          message: data['message'],
        ),
      );
    }
  }

  //post api end

  @override
  void initState() {
    getuserdata.getUserProfile().whenComplete(() {
      setState(() {
        _isloading = false;
        mobileNumber.text = getuserdata.user['mobileNumber'].toString();
        email.text = getuserdata.user['emailId'].toString();
        // selectedGender.text
        // DropDown = getuserdata.user['gender'].toString();
        value = getuserdata.user['gender'].toString();
        clientName.text = getuserdata.user['name'].toString();
        dateinput.text = getuserdata.user['dob'].toString().split(' ').first;
        weight.text = getuserdata.user['weight'] == null
            ? ''
            : getuserdata.user['weight'].toString();
        height.text = getuserdata.user['height'] == null
            ? ''
            : getuserdata.user['height'].toString();
        isDiabetic = getuserdata.user['isDiabeticPatient'];
        isDiabetic = getuserdata.user['isDiabeticPatient'];
        isHeartPatient = getuserdata.user['isHeartPatient'];
        bloodgroup = getuserdata.user['bloodGroup'];
        policy = getuserdata.user['isHealthCarePolicy'];
        dateinputFrom.text = getuserdata.user['policyFromDate'] == null
            ? ""
            : getuserdata.user['policyFromDate'].toString();
        dateinputTo.text = getuserdata.user['policyToDate'] == null
            ? ""
            : getuserdata.user['policyToDate'].toString();
        policyNumber.text = getuserdata.user['policyNumber'] == null
            ? ''
            : getuserdata.user['policyNumber'].toString();
        insuranceCompanyName.text = getuserdata.user['insuranceCompany'] == null
            ? ""
            : getuserdata.user['insuranceCompany'].toString();
      });
    });
    this.gender.add({'id': 1, 'label': 'Male'});
    this.gender.add({'id': 2, 'label': 'Female'});
    dateinput.text = "";
    getnullcheck();
    super.initState();
  }

  void getnullcheck() {}

  //   getuserdata.getUserProfile().whenComplete(() {
  //     setState(() {
  //       _isloading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: ''),
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
                  Text("Loading your Profile...")
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
                              (clientName.text),
                              style: const TextStyle(
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
                                readOnly: true,
                                controller: mobileNumber,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                keyboardType: TextInputType.phone,
                                decoration: ktextfieldDecoration(
                                    '10 Digit Mobile Number'),
                                validator: (value) {
                                  if (value!.length == 10) {
                                    return null;
                                  } else {
                                    return 'Enter valid Number';
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: ktextfieldDecoration('Email'),
                                validator: EmailValidator(
                                  errorText: 'enter a valid email address',
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
                                  border: Border.all(color: darkBlue),
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
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
                                // child: DropdownButton(
                                //   hint: Text(DropDown),
                                //   items: dropDownItems,
                                //   isExpanded: true,
                                //   value: selectedGender,
                                //   underline: Container(child: null),
                                //   onChanged: (value) => {
                                //     setState(() {
                                //       selectedGender = value.toString();
                                //       // print(selectedGender);
                                //     })
                                //   },
                                //   focusColor: Colors.blue,
                                //   elevation: 0,
                                // ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                  controller: clientName,
                                  keyboardType: TextInputType.name,
                                  decoration: ktextfieldDecoration('Name'),
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
                                          DateFormat('dd/MM/yyyy')
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
                        const SizedBox(
                          height: 32,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Text(
                            "More Information",
                            style: kSubTextStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Card(
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 32,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 28),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: const Text('Weight',
                                            style: kLabelTextStyle),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          controller: weight,
                                          keyboardType: TextInputType.number,
                                          decoration:
                                              ktextfieldDecoration('In Kg'),
                                          validator: ((value) {
                                            // print(weight);
                                          }),
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 28),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(
                                        flex: 1,
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: const Text('Height',
                                            style: kLabelTextStyle),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          controller: height,
                                          keyboardType: TextInputType.number,
                                          decoration:
                                              ktextfieldDecoration('In cm'),
                                          validator: ((value) {
                                            // print(height);
                                          }),
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    const Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Diabetic",
                                        style: kLabelTextStyle,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: isDiabetic,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    isDiabetic = value as bool;
                                                    // print(isDiabetic);
                                                  });
                                                }),
                                              ),
                                              const Text(
                                                "Yes",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Radio(
                                                value: false,
                                                groupValue: isDiabetic,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    isDiabetic = value as bool;
                                                    // print(isDiabetic);
                                                  });
                                                }),
                                              ),
                                              const Text(
                                                "No",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    const Expanded(
                                      flex: 2,
                                      child: Text("Heart Patient",
                                          style: kLabelTextStyle),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: isHeartPatient,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    isHeartPatient =
                                                        value as bool;
                                                  });
                                                }),
                                              ),
                                              const Text(
                                                "Yes",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Radio(
                                                value: false,
                                                groupValue: isHeartPatient,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    isHeartPatient =
                                                        value as bool;
                                                  });
                                                }),
                                              ),
                                              const Text(
                                                "No",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    )
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 20,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 25),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: darkBlue,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButton(
                                      hint: const Text('Select Blood Group',
                                          style: kLabelTextStyle),
                                      dropdownColor: Colors.white,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 36,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      value: bloodgroup,
                                      onChanged: (newValue) {
                                        setState(() {
                                          bloodgroup = newValue as String;
                                          // print(bloodGroup);
                                        });
                                      },
                                      items: bloodGrouplist.map((valueItem) {
                                        return DropdownMenuItem(
                                          value: valueItem,
                                          child: Text(valueItem),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                                // Row(
                                //   children: [
                                //     Text('Bloodgroup', style: TextStyle(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.w500,
                                //         ),),

                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    const Expanded(
                                      flex: 2,
                                      child: Text("Do you have any policy?",
                                          style: kLabelTextStyle),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: policy,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    policy = value as bool;
                                                  });
                                                }),
                                              ),
                                              const Text(
                                                "Yes",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Radio(
                                                value: false,
                                                groupValue: policy,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    policy = value as bool;
                                                  });
                                                }),
                                              ),
                                              const Text(
                                                "No",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                policy
                                    ? Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 8),
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: policyNumber,
                                              // keyboardType: TextInputType.phone,
                                              decoration: ktextfieldDecoration(
                                                  'Policy Number'),
                                              // validator: (value) {
                                              //   if (value!.length == 10) {
                                              //     return null;
                                              //   } else {
                                              //     return 'Enter valid Number';
                                              //   }
                                              // },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 8),
                                            height: 45,
                                            child: TextField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: dateinputFrom,
                                              //editing controller of this TextField
                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText: 'Date From',
                                                suffixIcon:
                                                    Icon(Icons.calendar_today),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7.0)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff325CA2),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff325CA2),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7.0)),
                                                ),
                                              ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2100),
                                                );

                                                if (pickedDate != null) {
                                                  print(
                                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                  String formattedDate =
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(pickedDate);
                                                  print(
                                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement

                                                  setState(() {
                                                    dateinputFrom.text =
                                                        formattedDate; //set output date to TextField value.
                                                  });
                                                } else {
                                                  print("Date is not selected");
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 8),
                                            height: 45,
                                            child: TextField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: dateinputTo,
                                              //editing controller of this TextField
                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText: 'Date To',
                                                suffixIcon:
                                                    Icon(Icons.calendar_today),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 20.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7.0)),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff325CA2),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7.0)),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff325CA2),
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7.0)),
                                                ),
                                              ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1900),
                                                        //DateTime.now() - not to allow to choose before today.
                                                        lastDate:
                                                            DateTime(2100));

                                                if (pickedDate != null) {
                                                  print(
                                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                  String formattedDate =
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(pickedDate);
                                                  print(
                                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                                  //you can implement different kind of Date Format here according to your requirement

                                                  setState(() {
                                                    dateinputTo.text =
                                                        formattedDate; //set output date to TextField value.
                                                  });
                                                } else {
                                                  print("Date is not selected");
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 8),
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.name,
                                              decoration: ktextfieldDecoration(
                                                  'Insurance Company Name'),
                                              controller: insuranceCompanyName,
                                            ),
                                          )
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlueButton(
                              onPressed: () {
                                InternetCheck().checkConnectivity();
                                var status;
                                if (status != ConnectivityResult.none) {
                                  setState(() {
                                    _isloading = true;
                                  });
                                  profile(
                                      mobileNumber.text,
                                      email.text,
                                      selectedgender.text,
                                      clientName.text,
                                      dateinput.text,
                                      weight.text,
                                      height.text,
                                      isDiabetic,
                                      isHeartPatient,
                                      bloodgroup,
                                      policy,
                                      policyNumber.text,
                                      dateinputTo.text,
                                      dateinputFrom.text,
                                      insuranceCompanyName.text);
                                  // Navigator.pushNamed(
                                  // context, accountRequestSubmitted);

                                  final isValid =
                                      formKey.currentState!.validate();
                                  if (isValid) {
                                    formKey.currentState?.save();
                                    // setState(() {
                                    //   _isloading = false;
                                    // });
                                  }
                                }

                                // Navigator.popAndPushNamed(context, radioButton);
                              },
                              title: weight.text != "" || height.text != ""
                                  ? 'Update'
                                  : 'Save',
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
