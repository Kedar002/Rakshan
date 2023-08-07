import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/claimhistory.dart';
import 'package:Rakshan/screens/post_login/payment.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/homeclasscontroller.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:Rakshan/widgets/post_login/discout_offered.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as dartPath;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ClaimProcessIPD extends StatefulWidget {
  static String claimProcessIPD = 'claim_process_ipd';

  ClaimProcessIPD(
      {Key? key,
      required this.sProviderTypeId,
      required this.sClientId,
      required this.sClientTypeName,
      required this.sClientName,
      required this.sServiceNameId,
      required this.sServiceName,
      required this.sServiceType,
      required this.nInstantDiscount,
      required this.nCashbackDiscount,
      required this.nServiceId,
      required this.sAmount})
      : super(key: key);

  final int sProviderTypeId; //in 1st dropdownn
  final int sClientId; //2nd dropdown
  final int sServiceNameId; //3rd dropdown
  final String sClientTypeName; // in 1st drop hint
  final String sClientName; // in 2nd drop hint
  final String sServiceName; //3rd dropdown hint
  final String nInstantDiscount;
  final String nCashbackDiscount;
  final String sServiceType;
  final int nServiceId;
  final String sAmount;

  @override
  State<ClaimProcessIPD> createState() => _ClaimProcessIPDState();
}

class _ClaimProcessIPDState extends State<ClaimProcessIPD> {
  final clientTypeName = TextEditingController();
  final clientName = TextEditingController();
  final serviceName = TextEditingController();

  // ==========================
  List discoutPrice = [];
  String? valueServiceProvideId;
  String? formattedDate;
  var result;
  var claimId;
  final amount = TextEditingController();
  final billAmount = TextEditingController();
  final recievedAmount = TextEditingController();
  TextEditingController balanceAmount = TextEditingController();
  // List listItem = ['item 1', 'item 2'];
  final ImagePicker imagePicker = ImagePicker();
  final GlobalKey<ScaffoldState> cliamkey = new GlobalKey<ScaffoldState>();
  final recievedKey = GlobalKey<FormState>();
  String? valueServiceName1;
  String? valueService;
  // List listItem2 = ['item 10', 'item 20'];
  String? valueFamily;
  String? member;
  String? ipd;

  String? valueClaimDate;
  // List listItem3 = ['item 100', 'item 200'];
  final _claim = HomeClassController();
  // final seen = Set<String>();
  List<XFile>? _imagesFileList = [];
  TextEditingController dateInput = TextEditingController();
  TextEditingController dateInputAdmission = TextEditingController();
  TextEditingController dateInputDischarge = TextEditingController();
  bool _isloading = true;
  List documentTypes = [];
  List documentTypes1 = []; //1
  File? _image;
  List clientType = [];
  List serviceType = [];
  List familymember = [];
  String? clientid;
  var familyID;
  bool checkedValue = false;
  int id = 1;
  final name = TextEditingController();
  var currentInstantDiscount;
  var cashbackDiscount;
  var serviceTypeValue;
  var serviceId;
  int? nSrvcId;
  var serviceProviderId;
  var serviceTypeId;
  File? selectedImage;
  var sClientTypeIdFromToken;

  DateTime? pickedDateAdmission;

  var nAppointmentAmount;

  getusertoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sClientTypeIdFromToken = prefs.getString('clientTypeId');
    print(sClientTypeIdFromToken);
  }

  @override
  void initState() {
    getusertoken();
    // formatDate();
    // dateInput.text = formattedDate!;
    fetchDocumentTypes();
    if (widget.sProviderTypeId != 0) {
      clientTypeName.text = widget.sClientTypeName;
      clientName.text = widget.sClientName;
      serviceName.text = widget.sServiceName;
      valueServiceName1 = widget.sClientId.toString();
      valueService = widget.sServiceNameId.toString();
      currentInstantDiscount = double.parse(widget.nInstantDiscount);
      cashbackDiscount = double.parse(widget.nCashbackDiscount);
      serviceTypeValue = widget.sServiceType;
      nSrvcId = int.parse(widget.nServiceId.toString());
      serviceId = int.parse(widget.nServiceId.toString());
      if (nSrvcId == 12) {
        currentInstantDiscount = 0.0;
        cashbackDiscount = 0.0;
      }
      if (widget.sAmount != '') {
        amount.text = widget.sAmount;
      }
      if (nSrvcId == 11 && widget.sAmount != '' && widget.sAmount.isNotEmpty) {
        if (currentInstantDiscount != null && currentInstantDiscount != 0.0) {
          nAppointmentAmount = double.parse(widget.sAmount) -
              ((double.parse(widget.sAmount) * currentInstantDiscount) / 100);
          print(widget.sAmount);
          print(nAppointmentAmount);
          amount.text = nAppointmentAmount.toStringAsFixed(2);
        }
      }
    }

    // _claim.getFilterServiceTypeApi().whenComplete(() {
    getUserId(); //3
    member = 'self';
    dateInput.text = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    // });
    super.initState();
  }

  // void formatDate() {
  //   formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  //   print(formattedDate);
  // }

  Future getSaveClaim(
      //check this with arun sir
      // BuildContext context,
      int serviceProviderId,
      int serviceTypeId,
      int serviceId,
      int? famillyId,
      // double claimAmount,
      String claimantName,
      double discountOffered,
      String claimDate,
      List<Map> claimDocument,
      status) async {
    const url = '$BASE_URL/api/Claims/SaveClaim';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('data');
    final userID = sharedPreferences.get("userId");
    final userName = sharedPreferences.get("userName");
    final splittedStr = claimDate.split("-");
    sharedPreferences.getString(jsonEncode(''));
    final myObj = {
      'ServiceProviderId': serviceProviderId,
      'ServiceTypeId': 0,
      'ServiceId': serviceId,
      'FamillyId': member == 'self' ? 0 : famillyId,
      'ClaimAmount':
          nSrvcId == 12 || nSrvcId == 1 ? balanceAmount.text : amount.text,
      'ClaimantName': userName,
      'DiscountOffered': '0.0',
      'ClaimDate':
          "${int.parse(splittedStr[0])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[2])}",
      'ClaimAddimitionDate':
          dateInputAdmission.text, //this is added later for 2 new date fields.
      'ClaimDischargeDate':
          dateInputDischarge.text, // this is added later for 2 new date fields.
      'ClaimFinalApprovalAmount': '0', // this is added later.
      'UserId': int.tryParse(userID as String),
      'IPDClaimType':
          nSrvcId == 12 ? 'Cashless' : (nSrvcId == 1 ? 'Reimbursement' : null),
      // ipd == null ? null : (ipd == '1' ? 'Cashless' : 'Reimbursement'),
      'IPDBillAmount': billAmount.text == '' ? '0' : billAmount.text,
      'IPDAmountFromTpa': recievedAmount.text == '' ? '0' : recievedAmount.text,
      'IPDSuretyLetterRequired': checkedValue == false ? "No" : "Yes",

      "ClaimDocument": claimDocument
    };
    print(myObj);
    final body = jsonEncode(myObj);
    var res = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $userToken',
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );
    print(res.body);
    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${data['message']}",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(milliseconds: 3000),
        ),
      );
      result = data['isSuccess'];
      print(data['id']);
      claimId = data['id'];
      if (data["isSuccess"] == true) {
        if (status) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return PaymentScreen(
                  amount: myObj['ClaimAmount'],
                  id: claimId,
                  sName: 'Claim IPD',
                  subType: '',
                  // coupontype: 'Claim',
                );
              },
            ),
          );
        }
      }
    } else {
      log(res.body);
      return false;
    }
  }

  void selectImage(ImageSource source) async {
    final XFile? selectedImage = await imagePicker.pickImage(source: source);
    if (selectedImage!.path.isNotEmpty) {
      _imagesFileList!.add(selectedImage);
    }
    setState(() {});
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.get('userId');
    final fetchfamilydata =
        await _claim.getFamilymemberData(user.toString()).whenComplete(() {
      setState(() {
        _isloading = false;
      });
    });
    setState(() {
      familymember = fetchfamilydata;
      // familymember['nnbnb'];
    });
  }

  void fetchDocumentTypes() async {
    final fetchedclientType = await _claim.getClientType().whenComplete(() {
      setState(() {
        _isloading = false;
      });
    });
    setState(() {
      // documentTypes = fetchedDocumentTypes;
      documentTypes1 = documentTypes.toSet().toList();
      clientType = fetchedclientType;
      // serviceType = fetchedServices;
    });
  }

//2
  void getInstantDiscountByService(int serviceId) {
    final firstMatch = (serviceType as List).firstWhere((service) {
      // return service["serviceId"] == serviceId;
      return service["serviceId"] == serviceId;
    });

    setState(() {
      if (nSrvcId != 12) {
        currentInstantDiscount = firstMatch["instantDiscount"];
        cashbackDiscount = firstMatch["cashbackDiscount"];
      } else if (nSrvcId == 12) {
        currentInstantDiscount = 0.0;
        cashbackDiscount = 0.0;
      }
      //Todo:
      serviceTypeValue = firstMatch['serviceType'];
      // serviceId = firstMatch[serviceId];  // <<< this is causing 3rd dropdown slected value updating issue.
    });
  }

  void getServiceIdType(int serviceProviderId) {
    final valueFirst = (documentTypes1 as List).firstWhere((element) {
      return element["clientId"] == serviceProviderId;
    });
    setState(() {
      serviceProviderId = valueFirst['clientId'];
    });
  }

// clientType
  getServiceTypeid(int serviceTypeId) {
    final valueSecond = (clientType as List).firstWhere((element) {
      return element['clientTypeId'] == serviceTypeId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            }, // Handle your on tap here.
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: Color(0xfffcfcfc),
          title: const Text(
            'Payment / Claim Benefits',
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Color(0xff2e66aa),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, claimhistory);
                  },
                  child: const Icon(
                    Icons.history,
                    size: 26.0,
                  ),
                )),
          ],
          iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isloading,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  widget.sProviderTypeId != 0
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: clientTypeName,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xfff1f7ff),
                                    hintText: widget.sClientTypeName,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'OpenSans',
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value!.length == 10) {
                                  //     return null;
                                  //   } else {
                                  //     return '';
                                  //   }
                                  // },
                                ),
                              ),
                            ),
                            // to atupopulate 1st dropddown
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Container(
                                // padding:
                                //     const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: kFaintBlue,
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: clientName,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xfff1f7ff),
                                    hintText: widget.sClientTypeName,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'OpenSans',
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //for service name
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kFaintBlue,
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: serviceName,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xfff1f7ff),
                                    hintText: widget.sClientTypeName,
                                    hintStyle: const TextStyle(
                                      fontFamily: 'OpenSans',
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButton(
                                  hint: const Text(
                                    'Service Provider Type',
                                    style: kSubheadingTextstyle,
                                  ),
                                  dropdownColor: Colors.white,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  value: valueServiceProvideId,
                                  items: clientType.map((valueItem) {
                                    return DropdownMenuItem(
                                      value:
                                          valueItem['clientTypeId'].toString(),
                                      child: Text(
                                        valueItem['clientTypeName'].toString(),
                                        style: kApiTextstyle,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) async {
                                    setState(() {
                                      valueServiceProvideId =
                                          newValue as String?;
                                      _isloading = true;
                                    });

                                    final serviceProviders = await _claim
                                        .getFilterService(newValue.toString());

                                    setState(() {
                                      documentTypes1 = serviceProviders;
                                      _isloading = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            //1st part
                            //ToDo:provider Name
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButton(
                                  hint: const Text('Service Provider',
                                      style: kSubheadingTextstyle),
                                  dropdownColor: Colors.white,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  value: valueServiceName1,
                                  onChanged: (newValue) async {
                                    setState(() {
                                      _isloading = true;
                                    });
                                    final discoutPrice = await _claim
                                        .getFilterService(newValue.toString())
                                        .whenComplete(() {
                                      setState(() {
                                        _isloading = false;
                                      });
                                      valueServiceName1 = newValue as String?;
                                      // documentTypes1 =
                                    });

                                    final services = await _claim
                                        .getServices(newValue.toString());
                                    setState(() {
                                      serviceType = services;
                                    });
                                  },
                                  items: documentTypes1
                                      .map((valueItem) {
                                        return DropdownMenuItem(
                                          value:
                                              valueItem["clientId"].toString(),
                                          child: Text(
                                            '${valueItem["clientName"]}',
                                            style: kApiTextstyle,
                                          ),
                                        );
                                      })
                                      .toSet()
                                      .toList(),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButton(
                                    hint: const Text('Services',
                                        style: kSubheadingTextstyle),
                                    dropdownColor: Colors.white,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 36,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    value: valueService,
                                    onChanged: ((value) {
                                      setState(() {});

                                      billAmount.text = '';
                                      balanceAmount.text = "";
                                      recievedAmount.text = "";

                                      nSrvcId = int.parse(value.toString());
                                      if (nSrvcId == 12) {
                                        ipd = 'cashless';
                                      } else if (nSrvcId == 1) {
                                        ipd = 'reimbursement';
                                      }

                                      getInstantDiscountByService(
                                        int.parse(
                                          value.toString(),
                                        ),
                                      );

                                      setState(() {
                                        _isloading = false;
                                        valueService = value as String;
                                      });
                                    }),
                                    items: serviceType
                                        .map((valueItem) {
                                          return DropdownMenuItem(
                                            value: valueItem["serviceId"]
                                                .toString(),
                                            child: Text(
                                              '${valueItem["serviceName"]}',
                                              style: kApiTextstyle,
                                            ),
                                          );
                                        })
                                        .toSet()
                                        .toList(),
                                  ),
                                )),
                          ],
                        ),
//>>>>>> These 2 NEW FIELDS FOR DATE OF ADMISSION AND DATE OF DISCHARGE
                  if (nSrvcId == 12 || nSrvcId == 1)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          child: TextFormField(
                            controller: dateInputAdmission,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Select Date of Admission',
                              // DateTime.now().toString().split(' ').first,
                              hintStyle: TextStyle(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_month),
                                onPressed: () async {
                                  pickedDateAdmission = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      // DateTime
                                      //     .now(), //- not to allow to choose before today,
                                      lastDate: DateTime(2100));

                                  if (pickedDateAdmission != null) {
                                    print(
                                        pickedDateAdmission); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDateAdmission =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDateAdmission!);
                                    log(formattedDateAdmission); //formatted date output using intl
                                    setState(() {
                                      dateInputAdmission.text =
                                          formattedDateAdmission;
                                      print(dateInputAdmission
                                          .text); //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          child: TextFormField(
                            controller: dateInputDischarge,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Select Date of Discharge',
                              // DateTime.now().toString().split(' ').first,
                              hintStyle: TextStyle(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_month),
                                onPressed: () async {
                                  if (pickedDateAdmission == null) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message:
                                            'Select Date of Admission First',
                                      ),
                                    );
                                  }
                                  DateTime? pickedDateDischarge =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: pickedDateAdmission!,
                                          firstDate: pickedDateAdmission!,
                                          lastDate: DateTime.now());

                                  if (pickedDateDischarge != null) {
                                    print(
                                        pickedDateDischarge); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDateDischarge =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDateDischarge);
                                    log(formattedDateDischarge); //formatted date output using intl
                                    setState(() {
                                      dateInputDischarge.text =
                                          formattedDateDischarge;
                                      print(dateInputDischarge
                                          .text); //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  //break
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: RadioListTile(
                            title: const Text("Self", style: kLabelTextStyle),
                            value: "self",
                            groupValue: member,
                            onChanged: (value) {
                              setState(() {
                                member = value.toString();
                                print(member);
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 200,
                          child: RadioListTile(
                            title: const Text("Family", style: kLabelTextStyle),
                            value: "family",
                            groupValue: member,
                            onChanged: (value) {
                              setState(() {
                                member = value.toString();

                                print(member);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  member == 'self'
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              hint: const Text(
                                'family member',
                                style: kSubTextStyle,
                              ),
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 36,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              value: valueFamily,
                              onChanged: ((value) {
                                setState(() {
                                  valueFamily = value as String;
                                  print(valueFamily);
                                });
                              }),
                              items: familymember
                                  .map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem["familyMappingId"]
                                          .toString(),
                                      child: Text('${valueItem["name"]}'),
                                    );
                                  })
                                  .toSet()
                                  .toList(),
                            ),
                          )),

                  currentInstantDiscount == 0.0 ||
                          currentInstantDiscount == null
                      ? const SizedBox()
                      : DiscountOffered(discount: currentInstantDiscount),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: dateInput,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: dateInput
                            .text, // DateTime.now().toString().split(' ').first,
                        hintStyle: const TextStyle(),
                        suffixIcon: const Icon(Icons.calendar_month),
                        // suffixIcon: IconButton(
                        //   icon: const Icon(Icons.calendar_month),
                        // //   onPressed: () async {
                        //     DateTime? pickedDate = await showDatePicker(
                        //         context: context,
                        //         initialDate: DateTime.now(),
                        //         firstDate: //DateTime(1950),
                        //             DateTime
                        //                 .now(), //- not to allow to choose before today,
                        //         lastDate: DateTime.now()); //DateTime(2100));

                        //     if (pickedDate != null) {
                        //       print(
                        //           pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        //       String formattedDate =
                        //           DateFormat('dd-MM-yyyy').format(pickedDate);
                        //       log(formattedDate); //formatted date output using intl
                        //       setState(() {
                        //         dateInput.text =
                        //             formattedDate; //set output date to TextField value.
                        //       });
                        //     } else {}
                        //   },
                        // ),
                      ),
                    ),
                  ),
                  nSrvcId == 12 || nSrvcId == 1
                      // serviceTypeValue == 'IPD'
                      ? nSrvcId == 12
                          ? Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: TextFormField(
                                      onChanged: (value) {
                                        balanceAmount.text = "";
                                        recievedAmount.text = "";
                                      },
                                      controller: billAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue.shade50,
                                        hintText: 'Bill Amount',
                                        hintStyle: const TextStyle(
                                          fontFamily: 'OpenSans',
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              7.0,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.length > 1) {
                                          return null;
                                        } else {
                                          return 'Enter Amount';
                                        }
                                      }),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          balanceAmount.text = '';
                                          int cal = int.parse(billAmount.text) -
                                              int.parse(recievedAmount.text);
                                          double calculatedPercentage =
                                              ((100 - currentInstantDiscount) /
                                                  100);
                                          balanceAmount.text =
                                              (calculatedPercentage * cal)
                                                  .toInt()
                                                  .toString();

                                          if (int.parse(recievedAmount.text) >
                                              int.parse(billAmount.text)) {
                                            balanceAmount.text = "";
                                          } else if (recievedAmount.text ==
                                              '') {
                                            balanceAmount.text =
                                                billAmount.text;
                                          }
                                        });
                                      },
                                      key: recievedKey,
                                      controller: recievedAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue.shade50,
                                        hintText:
                                            'Received Amount from Insurer',
                                        hintStyle: const TextStyle(
                                          fontFamily: 'OpenSans',
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              7.0,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.length == 0 ||
                                            int.parse(value) >
                                                int.parse(billAmount.text)) {
                                          return 'Enter valid Amount';
                                        } else {
                                          return null;
                                        }
                                      }),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          if (recievedAmount.text == '') {
                                            balanceAmount.text =
                                                '${int.parse(billAmount.text) + int.parse(recievedAmount.text)}';
                                          }
                                        });
                                      },
                                      readOnly: true,
                                      controller: balanceAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue.shade50,
                                        hintText: 'Balance Payable',
                                        hintStyle: const TextStyle(
                                          fontFamily: 'OpenSans',
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              7.0,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.length > 1) {
                                          return null;
                                        } else {
                                          return 'Enter Amount';
                                        }
                                      }),
                                ),
                                nSrvcId == 12 && sClientTypeIdFromToken != "3"
                                    ? CheckboxListTile(
                                        title: const Text(
                                          'Surety Letter Required',
                                          style: kLabelTextStyle,
                                        ),
                                        value: checkedValue,
                                        selected: checkedValue,
                                        autofocus: false,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        onChanged: (value) {
                                          setState(() {
                                            checkedValue = value as bool;
                                            print(
                                                'surety letter - ${checkedValue}');
                                          });
                                        })
                                    : const SizedBox(),
                              ],
                              //>>>>>>>>>>> this else is for reimbersement.
                            )
                          : Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: TextFormField(
                                      onChanged: (value) {
                                        balanceAmount.text = "";

                                        setState(() {
                                          int cal = int.parse(billAmount.text);
                                          double calculatedPercentage =
                                              ((100 - currentInstantDiscount) /
                                                  100);
                                          balanceAmount.text =
                                              (calculatedPercentage * cal)
                                                  .toInt()
                                                  .toString();
                                        });
                                      },
                                      controller: billAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue.shade50,
                                        hintText: 'Bill Amount',
                                        hintStyle: const TextStyle(
                                          fontFamily: 'OpenSans',
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              7.0,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.length > 1) {
                                          return null;
                                        } else {
                                          return 'Enter Amount';
                                        }
                                      }),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          if (recievedAmount.text == '') {
                                            balanceAmount.text =
                                                '${int.parse(billAmount.text) + int.parse(recievedAmount.text)}';
                                          }
                                        });
                                      },
                                      readOnly: true,
                                      controller: balanceAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue.shade50,
                                        hintText: 'Balance Payable',
                                        hintStyle: const TextStyle(
                                          fontFamily: 'OpenSans',
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              7.0,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.length > 1) {
                                          return null;
                                        } else {
                                          return 'Enter Amount';
                                        }
                                      }),
                                ),
                              ],
                            )
                      //  if (widget.sAmount != '')
                      : (widget.sAmount != ''
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                  readOnly: true,
                                  controller: amount,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blue.shade50,
                                    hintText: 'Enter Amount',
                                    hintStyle: const TextStyle(
                                      fontFamily: 'OpenSans',
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          7.0,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length > 1) {
                                      return null;
                                    } else {
                                      return 'Enter Amount';
                                    }
                                  }),
                            )
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                  controller: amount,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.blue.shade50,
                                    hintText: 'Enter Amount',
                                    hintStyle: const TextStyle(
                                      fontFamily: 'OpenSans',
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          7.0,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length > 1) {
                                      return null;
                                    } else {
                                      return 'Enter Amount';
                                    }
                                  }),
                            )),
                  const SizedBox(
                    height: 16,
                  ),
                  _imagesFileList!.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 20,
                          ),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            itemCount: _imagesFileList!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return _imagesFileList!.isEmpty
                                  ? const Icon(Icons.camera)
                                  : Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          6,
                                        ),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(_imagesFileList![index].path),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      children: [
                        cashbackDiscount == 0.0 || cashbackDiscount == null
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'To get extra cashback of $cashbackDiscount% ,Please upload your receipt received by Provider/Hospital',
                                  style: kGreyTextstyle,
                                ),
                              ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: darkBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 15,
                              ),
                              minimumSize: const Size(20, 10),
                              side: BorderSide(color: Colors.blue.shade100),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Upload Document'),
                                actions: [
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: darkBlue),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            selectImage(ImageSource.camera);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              const Text('Camera'), // <-- Text
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Icon(
                                                // <-- Icon

                                                Icons.camera_alt_outlined,
                                                size: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: darkBlue),
                                          onPressed: () {
                                            selectImage(ImageSource.gallery);

                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: const [
                                              Text('Gallery'),
                                              Icon(
                                                // <-- Icon
                                                Icons.image,
                                                size: 24.0,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            'Upload Bills',
                            style:
                                TextStyle(fontFamily: 'OpenSans', fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlueButton(
                              onPressed: () async {
                                if (widget.sProviderTypeId != 0) {
                                } else {
                                  if (documentTypes1.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Service Provider Type',
                                      ),
                                    );
                                    return;
                                  } else if (clientType.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Service Provider',
                                      ),
                                    );
                                    return;
                                  } else if (serviceType.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Please Select Services',
                                      ),
                                    );
                                    return;
                                  }
                                }
                                if (dateInput.text.isEmpty) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Select Date',
                                    ),
                                  );
                                  return;
                                }
                                if (nSrvcId != 12 && nSrvcId != 1) {
                                  if (amount.text.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Enter Bill Amount',
                                      ),
                                    );
                                    return;
                                  }
                                }
                                if (nSrvcId == 12 || nSrvcId == 1) {
                                  if (dateInputAdmission.text.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Addmission Date',
                                      ),
                                    );
                                    return;
                                  }
                                  if (dateInputDischarge.text.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Discharge Date',
                                      ),
                                    );
                                    return;
                                  }
                                  if (billAmount.text.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Enter Bill Amount',
                                      ),
                                    );
                                    return;
                                  }
                                  if (nSrvcId == 12) {
                                    if (recievedAmount.text.isEmpty) {
                                      showTopSnackBar(
                                        dismissType: DismissType.onTap,
                                        displayDuration:
                                            const Duration(seconds: 2),
                                        context,
                                        const CustomSnackBar.info(
                                          message: 'Enter Recieved Amount',
                                        ),
                                      );
                                      return;
                                    }
                                    if (int.parse(billAmount.text) <=
                                        int.parse(recievedAmount.text)) {
                                      showTopSnackBar(
                                        dismissType: DismissType.onTap,
                                        displayDuration:
                                            const Duration(seconds: 2),
                                        context,
                                        const CustomSnackBar.info(
                                          message:
                                              'Recieved Amount should not be greater than Bill Amount',
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                }
                                // if (!recievedKey.currentState!.validate()) {
                                //   showTopSnackBar(
                                //     dismissType: DismissType.onTap,
                                //     displayDuration: const Duration(seconds: 2),
                                //     context,
                                //     const CustomSnackBar.info(
                                //       message: 'Please Upload Images',
                                //     ),
                                //   );
                                //   return;
                                // }
                                if (_imagesFileList!.isEmpty) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Upload Images',
                                    ),
                                  );
                                  return;
                                } else {
                                  final readAsBytesFuture =
                                      <Future<Uint8List>>[];

                                  _imagesFileList!.forEach((image) {
                                    final readFuture = image.readAsBytes();
                                    readAsBytesFuture.add(readFuture);
                                  });

                                  final base64ImagesList =
                                      await Future.wait(readAsBytesFuture);

                                  int index = 0;
                                  final finalImagesList =
                                      _imagesFileList!.map((image) {
                                    final myMap = Map();
                                    myMap["DocumentExtension"] =
                                        dartPath.extension(image.path);
                                    myMap["ClaimDocumentPath"] =
                                        base64.encode(base64ImagesList[index]);
                                    index++;
                                    return myMap;
                                  }).toList();
                                  setState(() {
                                    _isloading = true;
                                  });
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  bool isPay = await sharedPreferences
                                          .getBool("isPay") ??
                                      false;
                                  if (isPay) {
                                    getSaveClaim(
                                            int.tryParse(valueServiceName1!)!,
                                            int.tryParse(valueServiceName1!)!,
                                            int.tryParse(valueService!)!,
                                            valueFamily != null
                                                ? int.tryParse(valueFamily!)
                                                : null,
                                            name.text,
                                            5.0,
                                            dateInput.text,
                                            finalImagesList,
                                            checkedValue) //set this back to false if save claim dosnt work
                                        .whenComplete(() {
                                      setState(() {
                                        amount.clear();
                                        billAmount.clear();
                                        recievedAmount.clear();
                                        balanceAmount.clear();
                                        // dateInput.clear();
                                        _imagesFileList!.clear();
                                        documentTypes1.clear();
                                        clientType.clear();
                                        serviceType.clear();
                                        _isloading = false;

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClaimHistory()),
                                        ).whenComplete(
                                            () => fetchDocumentTypes());
                                      });
                                    });
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, homeFirst, (route) => false);
                                  }
                                }
                              },
                              title: 'Save',
                              height: 50,
                              width: 125),
                        ),
                      ),
                      checkedValue == true
                          // serviceTypeValue != 'IPD'
                          ? const SizedBox()
                          : BlueButton(
                              onPressed: () async {
                                if (widget.sProviderTypeId != 0) {
                                } else {
                                  if (documentTypes1.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Service Provider Type',
                                      ),
                                    );
                                    return;
                                  } else if (valueServiceName1 == null) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Service Provider',
                                      ),
                                    );
                                    return;
                                  } else if (nSrvcId == null) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select a Service',
                                      ),
                                    );
                                    return;
                                  }
                                }

                                if (dateInput.text.isEmpty) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Select Date',
                                    ),
                                  );
                                  return;
                                } else if (billAmount.text.isEmpty) {
                                  if (nSrvcId != 12) {
                                    if (amount.text.isEmpty) {
                                      showTopSnackBar(
                                        dismissType: DismissType.onTap,
                                        displayDuration:
                                            const Duration(seconds: 2),
                                        context,
                                        const CustomSnackBar.info(
                                          message: 'Enter Bill Amount',
                                        ),
                                      );
                                      return;
                                    }
                                    balanceAmount.text = amount.text;
                                  } else {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Enter Bill Amount',
                                      ),
                                    );
                                    return;
                                  }
                                } else if (recievedAmount.text.isEmpty) {
                                  if (nSrvcId != 1) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Enter Received Amount Amount',
                                      ),
                                    );
                                    return;
                                  }
                                }
                                if (nSrvcId == 12 || nSrvcId == 1) {
                                  if (dateInputAdmission.text.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Addmission Date',
                                      ),
                                    );
                                    return;
                                  }
                                  if (dateInputDischarge.text.isEmpty) {
                                    showTopSnackBar(
                                      dismissType: DismissType.onTap,
                                      displayDuration:
                                          const Duration(seconds: 2),
                                      context,
                                      const CustomSnackBar.info(
                                        message: 'Select Discharge Date',
                                      ),
                                    );
                                    return;
                                  }
                                }
                                if (_imagesFileList!.isEmpty) {
                                  showTopSnackBar(
                                    dismissType: DismissType.onTap,
                                    displayDuration: const Duration(seconds: 2),
                                    context,
                                    const CustomSnackBar.info(
                                      message: 'Please Upload Images',
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isloading = true;
                                });
                                final readAsBytesFuture = <Future<Uint8List>>[];

                                _imagesFileList!.forEach((image) {
                                  final readFuture = image.readAsBytes();
                                  readAsBytesFuture.add(readFuture);
                                });

                                final base64ImagesList =
                                    await Future.wait(readAsBytesFuture);

                                int index = 0;
                                final finalImagesList =
                                    _imagesFileList!.map((image) {
                                  final myMap = Map();
                                  myMap["DocumentExtension"] =
                                      dartPath.extension(image.path);
                                  myMap["ClaimDocumentPath"] =
                                      base64.encode(base64ImagesList[index]);
                                  index++;
                                  return myMap;
                                }).toList();
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                bool isPay =
                                    await sharedPreferences.getBool("isPay") ??
                                        false;
                                if (isPay) {
                                  if (recievedAmount.text == '') {
                                    recievedAmount.text = '0';
                                  }
                                  if (balanceAmount.text == '') {
                                    balanceAmount.text = amount.text;
                                  }
                                  if (nSrvcId != 1 &&
                                      nSrvcId != 12 &&
                                      currentInstantDiscount != null &&
                                      currentInstantDiscount != 0.0) {
                                    var discountedAmount =
                                        double.parse(balanceAmount.text) -
                                            ((double.parse(balanceAmount.text) *
                                                    currentInstantDiscount) /
                                                100);
                                    balanceAmount.text =
                                        discountedAmount.toString();
                                  }
                                  getSaveClaim(
                                          int.tryParse(valueServiceName1!)!,
                                          int.tryParse(valueServiceName1!)!,
                                          int.tryParse(valueService!)!,
                                          valueFamily != null
                                              ? int.tryParse(valueFamily!)
                                              : null,
                                          // double.parse(amount.text),
                                          name.text,
                                          5.0,
                                          dateInput.text,
                                          finalImagesList,
                                          checkedValue) //set this back to true if save claim dosnt work
                                      .whenComplete(() {
                                    setState(() {
                                      amount.clear();
                                      billAmount.clear();
                                      recievedAmount.clear();

                                      // dateInput.clear();
                                      _imagesFileList!.clear();
                                      documentTypes1.clear();
                                      clientType.clear();
                                      serviceType.clear();
                                      _isloading = false;

                                      if (result == true) {
                                        print(balanceAmount.text);

                                        // ignore: unnecessary_null_comparison, unrelated_type_equality_checks
                                        if (balanceAmount.text != null &&
                                            balanceAmount.text != '0') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen(
                                                amount: double.parse(
                                                    balanceAmount.text),
                                                id: claimId,
                                                sName: 'Claim Process',
                                                subType: '',
                                                // coupontype: 'Claim'
                                              ),
                                            ),
                                          ).then((value) {
                                            balanceAmount.clear();
                                          });
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClaimHistory()),
                                          ).whenComplete(
                                              () => fetchDocumentTypes());
                                        }
                                      }
                                    });
                                  });
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, homeFirst, (route) => false);
                                }
                              },
                              title: 'Save & Pay',
                              height: 50,
                              width: 125),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
