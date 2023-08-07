import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:Rakshan/constants/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/routes/app_routes.dart';
//import 'package:Rakshan/screens/post_login/medicine_reminders/everyday.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/post_login/app_bar.dart';
import '../../../widgets/pre_login/blue_button.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/toast.dart';
import 'add_med.dart';

class prescriptionDetails extends StatefulWidget {
  // static String id = 'medicine_reason';

  int? id;
  prescriptionDetails(this.id);

  @override
  State<prescriptionDetails> createState() => _prescriptionDetailsState();
}

// ignore: camel_case_types
class _prescriptionDetailsState extends State<prescriptionDetails> {
  String? valueServiceProvideName;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _refillDateController = TextEditingController();
  final TextEditingController _refillTimeController = TextEditingController();

  List<dynamic> ailmentList = [];

  List<dynamic> patientName = [];

  String? imageShow;
  String? familyId;
  int? prescriptionId;
  bool isLoad = false;
  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    dateinput.text = "";
    super.initState();
    apiCall();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return isLoad
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xff82B445),
            appBar: AppBarIndividual(title: 'Rakshan'),
            body: Column(
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
                          'Prescription Details',
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'OpenSans'),
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
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter prescription title';
                              }
                              return null;
                            },
                            // readOnly: true,
                            controller: _titleController,
                            decoration:
                                ktextfieldDecoration('Prescription Title'),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Doctor Name';
                              }
                              return null;
                            },
                            // readOnly: true,
                            controller: _doctorNameController,
                            decoration:
                                ktextfieldDecoration('Enter Doctor\'s Name'),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Patient Name';
                              }
                              return null;
                            },
                            readOnly: true,
                            controller: _controller1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Patient Name',
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
                                  return List.generate(patientName.length,
                                      (index) {
                                    return PopupMenuItem(
                                        child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _controller1.text =
                                              patientName[index]['name'];
                                          familyId = patientName[index]
                                                  ['familyMappingId']
                                              .toString();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          height: 40,
                                          color: Colors.white,
                                          alignment: Alignment.centerLeft,
                                          child:
                                              Text(patientName[index]['name'])),
                                    ));
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Start Date';
                                    }
                                    return null;
                                  },
                                  controller:
                                      _startDateController, //editing controller of this TextField
                                  // readOnly: true,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Start Date',
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
                                  ), //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101));

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
                                        _startDateController.text =
                                            formattedDate; //set output date to TextField value.
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter End Date';
                                    }
                                    return null;
                                  },
                                  controller:
                                      _endDateController, //editing controller of this TextField
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'End Date',
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
                                  readOnly:
                                      true, //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101));

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
                                        _endDateController.text =
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextFormField(
                            controller: _controller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Ailment Name';
                              }
                              return null;
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Ailment Name',
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
                                  return List.generate(ailmentList.length,
                                      (index) {
                                    return PopupMenuItem(
                                        child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _controller.text =
                                              ailmentList[index]['displayName'];
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          height: 40,
                                          color: Colors.white,
                                          alignment: Alignment.centerLeft,
                                          child: Text(ailmentList[index]
                                              ['displayName'])),
                                    ));
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          TextFormField(
                            controller:
                                _refillDateController, //editing controller of this TextField

                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Enter Refill Reminder Date';
                            //   }
                            //   return null;
                            // },
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Set Refill Reminder Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff325CA2), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff325CA2), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                            ),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  _refillDateController.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Enter Refill Reminder Time';
                            //   }
                            //   return null;
                            // },
                            controller:
                                _refillTimeController, //editing controller of this TextField
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Set Refill Reminder Time',
                              suffixIcon: Icon(Icons.calendar_today),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff325CA2), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff325CA2), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0)),
                              ),
                            ),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              showDialogue();
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),

                          // imageShow != null ||
                          imageShow?.split('.').last == "jpg"
                              ? Container(
                                  child: Image.network(
                                    imageShow!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          BlueButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          addMed(prescriptionId)));
                            },
                            title: 'Next',
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  showDialogue() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height * 0.5,
                    color: Colors.white,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      onDateTimeChanged: (value) {
                        print(value.toString());
                        _refillTimeController.text =
                            DateFormat('hh:mm a').format(value);
                      },
                      initialDateTime: DateTime.now(),
                    ),
                  );
                },
              ),
            ));
  }

  apiCall() async {
    setState(() {
      isLoad = true;
    });

    await setData();
    await setPatientName();
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
    final userId = sharedPreferences.get("userId");
    var response = await http
        .get(Uri.parse('$BASE_URL/api/Medicine/GetAilmentDropDown'), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
    });

    //log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['isSuccess'] = true) {
        for (int i = 0; i < data['data'].length; i++) {
          ailmentList.add(data['data'][i]);
        }
      }

      print("data" + data.toString());
    } else {
      // toast('Something went wrong');
    }
  }

  setPatientName() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");
    var response = await http.get(
        Uri.parse(
            '$BASE_URL/api/EmployeeFamily/GetFamilyMappingList?EmployeeId=$userId'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
        });

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['isSuccess'] = true) {
        for (int i = 0; i < data['data'].length; i++) {
          patientName.add(data['data'][i]);
        }
      }

      Map da = {
        "familyMappingId": 0,
        "employeeId": userId,
        "relation": "Self",
        "relationId": 0,
        "name": "Self",
        "gender": "Male",
        "dob": "06/07/1992",
        "userId": 0,
        "active": 1
      };
      patientName.add(da);

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
            '$BASE_URL/api/Medicine/GetPrescriptionDetail?PrescriptionId=${widget.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
        });

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['isSuccess'] = true) {
        print("data" + data.toString());

        _titleController.text = data['data']['prescriptionTitle'];
        _startDateController.text = data['data']['startDate'];
        _endDateController.text = data['data']['endDate'];
        _doctorNameController.text = data['data']['doctorName'];
        _refillDateController.text =
            data['data']['reminderDate'] != '01/01/1900'
                ? data['data']['reminderDate']
                : '';
        _refillTimeController.text = data['data']['reminderTime'] != '12:00 AM'
            ? data['data']['reminderTime']
            : '';
        _controller.text = data['data']['ailmentName'];
        _controller1.text = data['data']['familyName'] ?? "Self";
        familyId = data['data']['familyId'].toString();
        prescriptionId = data['data']['prescriptionId'];
        imageShow = "$BASE_URL/${data['data']['documentPath']}";
        print('showwww$imageShow');
      }
    } else {
      // toast('Something went wrong');
    }
  }

  addPrescription() async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.getString("userId");

    Map d = {
      "PrescriptionId": 0,
      "Prescription": _titleController.text.trim(),
      "StartDate": _startDateController.text.trim(),
      "EndDate": _endDateController.text.trim(),
      "DoctorName": _doctorNameController.text.trim(),
      "AilmentName": _controller.text.trim(),
      "ReminderDate": _refillDateController.text.trim() != '01/01/1900'
          ? _refillDateController.text.trim()
          : '',
      "ReminderTime": _refillTimeController.text.trim() != '12:00 AM'
          ? _refillTimeController.text.trim()
          : '',
      "ClientId": int.parse(userId as String),
      "FamilyId": int.parse(familyId.toString()),
      "UserId": int.parse(userId as String)
    };

    print(d.toString());
    var response = await http.post(
        Uri.parse('$BASE_URL/api/Medicine/SavePrescription'),
        body: jsonEncode(d),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
          HttpHeaders.contentTypeHeader: "application/json"
        });

    // log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print(data.toString());

      if (data['isSuccess'] = true) {
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => addMed(data['id'])));

        // Navigator.pushNamed(context, addMedicineScreen);
        setState(() {
          isLoad = false;
        });
      }
      setState(() {
        isLoad = false;
      });
    } else {
      toast('Something went wrong');
      print(response.statusCode.toString());
      print(response.body.toString());
      setState(() {
        isLoad = false;
      });
    }
  }
}
