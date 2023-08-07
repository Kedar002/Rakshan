import 'dart:convert';
import 'dart:io';

import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/models/getservicemodel.dart';
import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
import 'package:Rakshan/utills/progressIndicator.dart';
import 'package:Rakshan/widgets/post_login/discout_offered.dart';
//import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/controller/appointment_controller.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
import 'package:Rakshan/screens/post_login/home_screen.dart';
import 'package:Rakshan/screens/post_login/payment.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/homeclasscontroller.dart';
import '../../utills/horizontalCalender.dart';
import '/config/api_url_mapping.dart' as API;
import 'package:http/http.dart' as http;
import '../../constants/theme.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

enum PaymentMethod { cod, advance }

class BookingDetails {
  String? date;
  String? fromTime;
  String? toTime;
  int? appoinmentConfigId;
  int? doctorId;
  int? clientId;
  String? dat;

  BookingDetails({
    this.date,
    this.fromTime,
    this.toTime,
    this.appoinmentConfigId,
    this.doctorId,
    this.clientId,
    this.dat,
  });
}

class BookingSlot {
  int? slotId;
  String? day;
  String? fromTime;
  String? toTime;
  int? appoinmentConfigId;
  double? appoinmentFee;

  BookingSlot({
    this.slotId,
    this.day,
    this.fromTime,
    this.toTime,
    this.appoinmentConfigId,
    this.appoinmentFee,
  });
}

class Appointment extends StatefulWidget {
  const Appointment({
    Key? key,
    required this.sProviderTypeId,
    required this.sClientId,
    required this.sClientTypeName,
    required this.sClientName,
    required this.sServiceNameId,
    // required this.sServiceNameId
  }) : super(key: key);
  final int sServiceNameId;
  final int sProviderTypeId; //in 1st dropdownn
  final int sClientId; //2nd dropdown
  final String sClientTypeName; // in 1st drop hint
  final String sClientName; // in 2nd drop hint

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  // DateTime _selectedDate = DateTime.now();
  final _appointmentController = AppointmentController();
  late ProcessIndicatorDialog _progressIndicator;
  int selectedCard = -1;
  dynamic amount = 0.0;
  String? member = "self";
  String? valueFamily;
  List familymember = [];

  final clientTypeName = TextEditingController();
  final clientName = TextEditingController();
  // ===============ROHIT's===================

  final engDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  int stepCount = 0;
  // selected provider Type = 1
  // selected provider = 2
  // selected doctor = 3
  // selected date = 4
  // selected slot  = 5
  // selected paymentMethod  = 6
  // selected doingBooking  = 7

  List providerTypes = [];
  int? selectedProviderType;

  List serviceProviders = [];
  int? selectedProvider;

  List consultants = [];
  int? selectedConsultant;

  List fetchservices = [];
  List<int> paymentHeads = [];
  var currentInstantDiscount;
  var familyid;
  var cashbackDiscount;

  bool isLoading = true;
  bool _isloading = false;

// booking
  bool showDates = false;
  bool showSlots = false;
  bool showPaymentMethods = false;
  bool isSavingAppointment = false;

  var flag;

  List allSlots = [];
  List? slotsForTheSelectedDay;
  final _claim = HomeClassController();
  String paymentHeadstr = '';
  String selectedDate = "";
  BookingSlot selectedSlot = BookingSlot();

  PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

  BookingDetails bookingTracker = BookingDetails();
  late String sToday;

  void fetchProviderTypes() async {
    final fetechedProviderTypes =
        await _appointmentController.getProviderTypes();

    setState(() {
      stepCount = 0;
      providerTypes = fetechedProviderTypes;

      // set other two as empty
      serviceProviders = [];
      if (widget.sClientId == null) {
        consultants = [];
      }
    });
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

  setPaymentHeads() {
// String paymentHeadstr = "1,2";
    paymentHeads = paymentHeadstr.split(",").map(int.parse).toList();
    print(paymentHeads);
    // setState(() {});
  }

  void fetchServiceProviders(int ClientTypeId) async {
    final fetchedServiceProvider =
        await _appointmentController.getServiceProviders(ClientTypeId);

    setState(() {
      selectedProviderType = ClientTypeId;
      serviceProviders = fetchedServiceProvider;
      // String paymentHeadstr = "1,2";
      // paymentHeads = paymentHeadstr.split(",").map(int.parse).toList();

      showDates = false;
      showSlots = false;
      showPaymentMethods = false;
      selectedDate = "";
      slotsForTheSelectedDay = null;

      if (widget.sClientId == null) {
        consultants = [];
      }
    });
  }

  void fetchConsultants(int clientId) async {
    final fetchedConsultants =
        await _appointmentController.getConsultants(clientId);

    setState(() {
      if (widget.sClientId != 0) {
        selectedProvider = widget.sClientId;
      } else {
        selectedProvider = clientId;
      }

      consultants = fetchedConsultants;
      showDates = false;
    });
  }

  void getServices(String clientId) async {
    final getservices =
        await _appointmentController.getServicesForAppointment(clientId);
    fetchservices = getservices;
    getInstantDiscountByService();
  }

  void getInstantDiscountByService() {
    final firstMatch = (fetchservices as List).firstWhere((service) {
      print('sServiceNameId is ${widget.sServiceNameId}');
      // return service["serviceId"] == 11;
      return service["serviceId"] == widget.sServiceNameId;
    });

    setState(() {
      currentInstantDiscount = firstMatch["instantDiscount"];
      cashbackDiscount = firstMatch["cashbackDiscount"];
      // print(cashbackDiscount);
      // print(currentInstantDiscount);
      //Todo:
      // serviceTypeValue = firstMatch['serviceType'];
      // serviceId = firstMatch[serviceId];
    });
  }

  void handleDateSelect(BuildContext ctx, String date) {
    if (widget.sProviderTypeId != 0) {
      if (selectedConsultant == null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Please Select a doctor first",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(
              milliseconds: 2000,
            ),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }
    } else {
      if (stepCount < 3) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Please pick provider and doctor first",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(
              milliseconds: 2000,
            ),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }
    }
    if (widget.sProviderTypeId != 0) {
    } else {
      if (stepCount < 3) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Please pick provider and doctor first",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(
              milliseconds: 2000,
            ),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }
    }

    final splittedStr = date.split("-");
    final chosenDate = DateTime(
      int.parse(splittedStr[0]),
      int.parse(splittedStr[1]),
      int.parse(splittedStr[2]),
    );

    final weekday = DateFormat("EEEE").format(chosenDate);
    setState(() {
      stepCount = 4;
      selectedDate = date;
      slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
      selectedSlot = BookingSlot();
    });

    if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'No slots available for this date.',
            // "No slots available for this date",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          backgroundColor: darkBlue,
        ),
      );
    }
  }

  void handleSlotSelect(BookingSlot slot) {
    if (stepCount <= 4) {
      return;
    }
    setState(() {
      stepCount = 5;
    });
  }

  List findSlotsForTheSelectedDay(String day) {
    final coppyArray = new List<Map>.from(allSlots);
    coppyArray.removeWhere((slot) => slot['day'] != day);
    int index = 0;
    final slotsWithId = coppyArray.map((slot) {
      final myMap = Map();
      myMap["slotId"] = index;
      myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
      myMap["day"] = slot["day"];
      myMap["fromTime"] = slot["fromTime"];
      myMap["toTime"] = slot["toTime"];
      myMap["appoinmentFee"] = slot["appoinmentFee"];
      index++;
      return myMap;
    }).toList();
    return slotsWithId;
  }

  Future<bool> saveAppointments(
    BookingSlot bookingDetails,
    int clientId,
    int consultantId,
    String selectedDate,
    int famillyid,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userToken = sharedPreferences.getString('data');
    final userId = sharedPreferences.get("userId");
    _progressIndicator.show();
    var response = await http.post(
        Uri.parse(
          API.buildUrl(
            API.kBookAppointment,
          ),
        ),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $userToken',
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: jsonEncode({
          "ClientId": clientId,
          "ServiceId": 4, //service id isnt sent dynamically.
          "DoctorId": consultantId,
          "UserId": int.tryParse(userId as String),
          "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
          "Day": bookingDetails.day,
          "FromTime": bookingDetails.fromTime,
          "ToTime": bookingDetails.toTime,
          "AppoinmentDate": selectedDate,
          "famillyId": member == 'self' ? 0 : int.parse(familyid),
        }));

    _progressIndicator.hide();
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('data is $data');
      // print('sServiceNameId is ${widget.sServiceNameId}');
      // print('consultantId is $consultantId');
      // print(userId);
      // print(bookingDetails);
      // print(selectedDate);

      if (data["isSuccess"]) {
        int bookId = data['id'];
        flag = bookId;
        print(bookId);
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void saveAppointment(ctx, dynamic amounts) async {
    print(selectedSlot);
    print(selectedProvider);
    print(selectedConsultant);
    print(selectedSlot.appoinmentFee);
    valueFamily == null ? valueFamily = "0" : int.tryParse(valueFamily!);
    print('hurrray $valueFamily');
    print(currentInstantDiscount);
    final splittedStr = selectedDate.split("-");
    final selectedDateToSend =
        "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
    print(selectedDateToSend);
    // show confirmation page
    bool savedAppointment = await saveAppointments(
      selectedSlot,
      selectedProvider!,
      selectedConsultant!,
      selectedDateToSend,
      int.parse(valueFamily!),
    );

    setState(() {
      isSavingAppointment = false;
    });

    if (savedAppointment) {
      if (selectedPaymentMethod == PaymentMethod.advance &&
          selectedSlot.appoinmentFee! != 0.0) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              return PaymentScreen(
                amount: currentInstantDiscount == null
                    ? selectedSlot.appoinmentFee!
                    : (selectedSlot.appoinmentFee! *
                        (100 - currentInstantDiscount) /
                        100),

                id: flag,
                sName: "Appointment",
                subType: '',
                // coupontype: "",
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text(
              "Appointment booked successfully",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(
              milliseconds: 2000,
            ),
            backgroundColor: Colors.blue,
          ),
        );
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) {
              return BookingConfirmation();
            },
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            "Appointment booking failed",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    _progressIndicator = ProcessIndicatorDialog(context);
    super.initState();
    clientTypeName.text = widget.sClientTypeName;
    clientName.text = widget.sClientName;
    fetchProviderTypes();
    getUserId();
    if (widget.sProviderTypeId != 0) {
      fetchServiceProviders(widget.sClientId);
      fetchConsultants(widget.sClientId);
      getServices(widget.sClientId.toString());
      // selectedProvider = widget.sClientId;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
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
          'Appointment',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Color(0xff2e66aa),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, appointmentHistoryScreen);
              },
              icon: Icon(Icons.history),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isloading,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              !isSavingAppointment
                  ? Container(
                      child: Column(children: [
                        widget.sProviderTypeId != 0
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 1),
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
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
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
                                        border: Border.all(
                                            color: Colors.white, width: 1),
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
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
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
                                        //     return 'Phone no should be 10 digit';
                                        //   }
                                        // },
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
                                        color: const Color(0xfff1f7ff),
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton(
                                        value: selectedConsultant,
                                        onChanged: (consultantId) async {
                                          setState(() {
                                            selectedConsultant =
                                                consultantId as int;
                                            selectedProvider = widget.sClientId;
                                            print('luffy$selectedConsultant');
                                          });

                                          final consultantSlots =
                                              await _appointmentController
                                                  .getDoctorAppointmentDetails(
                                            selectedProvider as int,
                                            consultantId as int,
                                          );

                                          setState(() {
                                            allSlots = consultantSlots;
                                          });
                                        },
                                        items: consultants.map((consultant) {
                                          return DropdownMenuItem(
                                            value: consultant["consultantId"],
                                            child: Text(
                                              consultant["consultantName"],
                                              style: kApiTextstyle,
                                            ),
                                          );
                                        }).toList(),
                                        hint: const Text(
                                          'Select Doctors',
                                          style: kApiTextstyle,
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
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff1f7ff),
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton(
                                        value: selectedProviderType,
                                        onChanged: (ClientTypeId) {
                                          setState(() {
                                            // serviceProviders =[];
                                            stepCount = 1;
                                            allSlots = [];
                                            selectedProviderType =
                                                ClientTypeId as int;
                                          });
                                          fetchServiceProviders(
                                              ClientTypeId as int);
                                        },
                                        items:
                                            providerTypes.map((providerType) {
                                          return DropdownMenuItem(
                                            value: providerType["clientTypeId"],
                                            child: Text(
                                              providerType["clientTypeName"],
                                              style: kApiTextstyle,
                                            ),
                                          );
                                        }).toList(),
                                        hint: const Text(
                                          'Select Provider Type',
                                          style: kSubheadingTextstyle,
                                        ),
                                        dropdownColor: Colors.white,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 36,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // SERVICE PROVIDERS
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        color: kFaintBlue,
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton(
                                        value: selectedProvider,
                                        onChanged: (clientId) {
                                          setState(() {
                                            stepCount = 2;
                                            selectedProvider = clientId as int;
                                            //changes done by shubham on 13 march 2023 to show paymentheads dynamically
                                            int selectedIndex = -1;
                                            for (int i = 0;
                                                i < serviceProviders.length;
                                                i++) {
                                              if (serviceProviders[i]
                                                      ["clientId"] ==
                                                  selectedProvider) {
                                                selectedIndex = i;
                                                break;
                                              }
                                            }
                                            // int selectedIndex = serviceProviders
                                            //     .indexOf(selectedProvider);
                                            paymentHeadstr =
                                                serviceProviders[selectedIndex]
                                                    ["PaymentHeads"];
                                            setPaymentHeads();
                                            //changes done by shubham on 13 march 2023 to show paymentheads dynamically till here
                                            print(selectedProvider);
                                            allSlots = [];
                                          });

                                          fetchConsultants(clientId as int);
                                          // widget.sServiceNameId == 11
                                          getServices(clientId.toString());
                                        },
                                        items: serviceProviders
                                            .map((serviceProvider) {
                                          return DropdownMenuItem(
                                            value: serviceProvider["clientId"],
                                            child: Text(
                                              serviceProvider["clientName"],
                                              style: kApiTextstyle,
                                            ),
                                          );
                                        }).toList(),
                                        hint: const Text(
                                          'Service Provider',
                                          style: kApiTextstyle,
                                        ),
                                        dropdownColor: Colors.white,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 36,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // CONSULTANTS
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff1f7ff),
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButton(
                                        value: selectedConsultant,
                                        onChanged: (consultantId) async {
                                          setState(() {
                                            stepCount = 3;
                                            if (widget.sClientId != 0) {
                                              selectedProvider =
                                                  widget.sClientId;
                                            }
                                            selectedConsultant =
                                                consultantId as int;
                                          });
                                          setState(() {
                                            _isloading = true;
                                          });
                                          final consultantSlots =
                                              await _appointmentController
                                                  .getDoctorAppointmentDetails(
                                            selectedProvider as int,
                                            consultantId as int,
                                          );

                                          setState(() {
                                            allSlots = consultantSlots;
                                            _isloading = false;
                                          });
                                        },
                                        items: consultants.map((consultant) {
                                          return DropdownMenuItem(
                                            value: consultant["consultantId"],
                                            child: Text(
                                              consultant["consultantName"],
                                              style: kApiTextstyle,
                                            ),
                                          );
                                        }).toList(),
                                        hint: const Text(
                                          'Select Doctors',
                                          style: kApiTextstyle,
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: RadioListTile(
                                  title: const Text("Self",
                                      style: kLabelTextStyle),
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
                                  title: const Text("Family",
                                      style: kLabelTextStyle),
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
                        member == 'self' || member == null
                            ? const SizedBox()
                            : Padding(
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
                                        familyid = value;
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    ' select a date',
                                    style: TextStyle(
                                      color: darkBlue,
                                      fontSize: 18,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                  padding: kScreenPadding,
                                  child: DatePicker(
                                    DateTime.now().add(
                                      Duration(
                                        hours: 2 - DateTime.now().hour,
                                        // minutes: 60 - DateTime.now().minute,
                                        // seconds: 60 - DateTime.now().second,
                                      ),
                                    ),
                                    height: 100,
                                    width: 60,
                                    daysCount: 7,
                                    selectionColor: darkBlue,
                                    selectedTextColor: Colors.white,
                                    dateTextStyle: kBlueTextstyle,
                                    onDateChange: (date) {
                                      var selecteddate =
                                          date.toString().split(' ').first;
                                      sToday = selecteddate.split('-').last;
                                      String cdate = DateFormat("dd")
                                          .format(DateTime.now());

                                      handleDateSelect(context, selecteddate);
                                    },
                                  )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 12, top: 12, bottom: 16),
                                      child: const Text(
                                        'Available Slots',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: darkBlue,
                                          fontSize: 18,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    stepCount >= 4
                                        ? slotsForTheSelectedDay!.length > 0
                                            ? Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            ScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 3,
                                                          mainAxisSpacing: 3,
                                                          childAspectRatio: MediaQuery
                                                                      .of(
                                                                          context)
                                                                  .size
                                                                  .width /
                                                              (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  6),
                                                        ),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                index) {
                                                          final currentSlot =
                                                              slotsForTheSelectedDay![
                                                                  index];

                                                          int ifromtime = int
                                                              .parse(currentSlot[
                                                                      "toTime"]
                                                                  .split(':')
                                                                  .first);
                                                          List<String>
                                                              ifromtime2 =
                                                              currentSlot[
                                                                      "toTime"]
                                                                  .split(' ');

                                                          String tdata =
                                                              DateFormat(
                                                                      'HH:mm:ss')
                                                                  .format(DateTime
                                                                      .now());
                                                          int iCurrentTime =
                                                              int.parse(tdata
                                                                  .toString()
                                                                  .split(':')
                                                                  .first);
                                                          List<String>
                                                              iCurrentTime2 =
                                                              tdata
                                                                  .toString()
                                                                  .split(':');

                                                          String tdata1 =
                                                              DateFormat("a")
                                                                  .format(DateTime
                                                                      .now());
                                                          String sfromdataAMPM =
                                                              currentSlot[
                                                                      "toTime"]
                                                                  .split(' ')
                                                                  .last;
                                                          late int
                                                              iFromTimeInMinutes;
                                                          for (int i = 0;
                                                              i <
                                                                  ifromtime2
                                                                      .length;
                                                              i++) {
                                                            if (i == 0) {
                                                              int fromMinutes =
                                                                  int.parse(
                                                                      ifromtime2[
                                                                              i]
                                                                          .split(
                                                                              ':')
                                                                          .last);
                                                              if (sfromdataAMPM ==
                                                                  "AM") {
                                                                int xxx =
                                                                    ifromtime *
                                                                        100;
                                                                iFromTimeInMinutes =
                                                                    xxx +
                                                                        fromMinutes;
                                                                // print(
                                                                //     'iFromTimeInMinutes=$iFromTimeInMinutes');
                                                              } else {
                                                                int xxx =
                                                                    ifromtime *
                                                                        100;
                                                                iFromTimeInMinutes =
                                                                    xxx +
                                                                        fromMinutes +
                                                                        1200;
                                                                // print(
                                                                //     'iFromTimeInMinutes=$iFromTimeInMinutes');
                                                              }
                                                            }
                                                          }
                                                          late int
                                                              iCurrentTimeInMinutes;

                                                          int iCurrentTimePlusTwo =
                                                              iCurrentTime + 2;

                                                          int iCurrentTime3;
                                                          for (int i = 0;
                                                              i <
                                                                  iCurrentTime2
                                                                      .length;
                                                              i++) {
                                                            if (i == 1) {
                                                              iCurrentTime3 =
                                                                  int.parse(
                                                                      iCurrentTime2[
                                                                          i]);

                                                              int xxx =
                                                                  iCurrentTime *
                                                                      100;
                                                              if (xxx > 999) {}
                                                              iCurrentTimeInMinutes =
                                                                  xxx +
                                                                      iCurrentTime3;
                                                              // print(
                                                              //     'iCurrentTimeInMinutes=$iCurrentTimeInMinutes');
                                                            }
                                                          }

                                                          // print(
                                                          //     'ifromtime2=$ifromtime2');

                                                          // print(
                                                          //     'ifromtime=$ifromtime');
                                                          // print(
                                                          //     'iCurrentTime2=$iCurrentTime2');

                                                          // print(
                                                          //     'sfromdataAMPM=$sfromdataAMPM');

                                                          String cdate =
                                                              DateFormat("dd")
                                                                  .format(DateTime
                                                                      .now());
                                                          return cdate == sToday
                                                              ? ((iFromTimeInMinutes -
                                                                          iCurrentTimeInMinutes) >
                                                                      200)
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          stepCount =
                                                                              7;
                                                                          amount =
                                                                              selectedSlot.appoinmentFee;
                                                                          showPaymentMethods =
                                                                              true;
                                                                          selectedSlot =
                                                                              BookingSlot(
                                                                            slotId:
                                                                                currentSlot["slotId"],
                                                                            appoinmentConfigId:
                                                                                currentSlot["appoinmentConfigId"],
                                                                            day:
                                                                                currentSlot["day"],
                                                                            fromTime:
                                                                                currentSlot["fromTime"],
                                                                            toTime:
                                                                                currentSlot["toTime"],
                                                                            appoinmentFee:
                                                                                currentSlot["appoinmentFee"],
                                                                          );
                                                                        });
                                                                      },
                                                                      child:
                                                                          Card(
                                                                        color: selectedSlot.slotId ==
                                                                                currentSlot["slotId"]
                                                                            ? const Color(0xff325CA2)
                                                                            : Colors.white,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              200,
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
                                                                              style: TextStyle(
                                                                                color: selectedSlot.slotId == currentSlot["slotId"] ? Colors.white : Colors.black,
                                                                                fontSize: 14,
                                                                                fontFamily: 'OpenSans',
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  : Card(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            200,
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: selectedSlot.slotId == currentSlot["slotId"] ? Colors.white : Colors.black,
                                                                              fontSize: 14,
                                                                              fontFamily: 'OpenSans',
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      stepCount =
                                                                          7;
                                                                      amount =
                                                                          selectedSlot
                                                                              .appoinmentFee;
                                                                      showPaymentMethods =
                                                                          true;
                                                                      selectedSlot =
                                                                          BookingSlot(
                                                                        slotId:
                                                                            currentSlot["slotId"],
                                                                        appoinmentConfigId:
                                                                            currentSlot["appoinmentConfigId"],
                                                                        day: currentSlot[
                                                                            "day"],
                                                                        fromTime:
                                                                            currentSlot["fromTime"],
                                                                        toTime:
                                                                            currentSlot["toTime"],
                                                                        appoinmentFee:
                                                                            currentSlot["appoinmentFee"],
                                                                      );
                                                                    });
                                                                  },
                                                                  child: Card(
                                                                    color: selectedSlot.slotId ==
                                                                            currentSlot[
                                                                                "slotId"]
                                                                        ? const Color(
                                                                            0xff325CA2)
                                                                        : Colors
                                                                            .white,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          200,
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
                                                                          style:
                                                                              TextStyle(
                                                                            color: selectedSlot.slotId == currentSlot["slotId"]
                                                                                ? Colors.white
                                                                                : Colors.black,
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                'OpenSans',
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ));
                                                        },
                                                        itemCount:
                                                            slotsForTheSelectedDay ==
                                                                    null
                                                                ? 0
                                                                : slotsForTheSelectedDay!
                                                                    .length,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : (Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: const [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 10,
                                                    ),
                                                    child: Text(
                                                      "No slots available for this date",
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        : (Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 6,
                                                  horizontal: 10,
                                                ),
                                                child: Text(
                                                  "Please select a date",
                                                ),
                                              ),
                                            ],
                                          )),
                                  ],
                                ),
                              ),
                              stepCount >= 6
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        (currentInstantDiscount == 0.0 ||
                                                currentInstantDiscount ==
                                                    null ||
                                                selectedSlot.appoinmentFee == 0)
                                            ? const SizedBox()
                                            : DiscountOffered(
                                                discount:
                                                    currentInstantDiscount),
                                        (selectedSlot.appoinmentFee == 0)
                                            ? SizedBox.shrink()
                                            : const AppointmentSectionHeading(
                                                title: "Payment Method",
                                              ),
                                        (selectedSlot.appoinmentFee == 0)
                                            ? SizedBox.shrink()
                                            : paymentHeads.contains(2)
                                                ? AppointmentFees(
                                                    fees: selectedSlot
                                                        .appoinmentFee!,
                                                  )
                                                : const SizedBox.shrink(),
                                        (currentInstantDiscount == 0.0 ||
                                                currentInstantDiscount ==
                                                    null ||
                                                selectedSlot.appoinmentFee == 0)
                                            ? SizedBox.shrink()
                                            : paymentHeads.contains(1)
                                                ? Column(
                                                    children: [
                                                      const AppointmentSectionHeading(
                                                        title: "OR",
                                                      ),
                                                      DiscountedAppointmentFees(
                                                        fees: (selectedSlot
                                                                .appoinmentFee! *
                                                            (100 -
                                                                currentInstantDiscount) /
                                                            100),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    paymentHeads.length > 1
                                                        ? MainAxisAlignment
                                                            .spaceBetween
                                                        : MainAxisAlignment
                                                            .center,
                                                children: [
                                                  selectedSlot.appoinmentFee ==
                                                          0
                                                      ? SizedBox.shrink()
                                                      : paymentHeads.contains(2)
                                                          ? Column(
                                                              children: [
                                                                Radio(
                                                                  value:
                                                                      PaymentMethod
                                                                          .cod,
                                                                  groupValue:
                                                                      selectedPaymentMethod,
                                                                  onChanged:
                                                                      ((value) {
                                                                    setState(
                                                                        () {
                                                                      selectedPaymentMethod =
                                                                          value
                                                                              as PaymentMethod;
                                                                      // print(isDiabetic);
                                                                    });
                                                                  }),
                                                                ),
                                                                const Text(
                                                                  "Cash on Desk",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox
                                                              .shrink(),
                                                  selectedSlot.appoinmentFee ==
                                                          0
                                                      ? SizedBox.shrink()
                                                      : paymentHeads.contains(1)
                                                          ? Column(
                                                              children: [
                                                                Radio(
                                                                  value: PaymentMethod
                                                                      .advance,
                                                                  groupValue:
                                                                      selectedPaymentMethod,
                                                                  onChanged:
                                                                      ((value) {
                                                                    setState(
                                                                        () {
                                                                      selectedPaymentMethod =
                                                                          value
                                                                              as PaymentMethod;
                                                                      // print(isDiabetic);
                                                                    });
                                                                  }),
                                                                ),
                                                                const Text(
                                                                  "Pay Now",
                                                                  // "Advance",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox
                                                              .shrink()
                                                ],
                                              ),
                                            ),
                                            const Spacer(
                                              flex: 1,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              stepCount == 7
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BlueButton(
                                          onPressed: () async {
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            bool isPay = await sharedPreferences
                                                    .getBool("isPay") ??
                                                false;
                                            if (isPay) {
                                              saveAppointment(context,
                                                  selectedSlot.appoinmentFee);
                                            } else {
                                              // Navigator.pushNamedAndRemoveUntil(
                                              //     context,
                                              //     homeFirst,
                                              //     (route) => false);
                                              saveAppointment(context,
                                                  selectedSlot.appoinmentFee);
                                            }
                                            //  IF ANY FAMILY OR SELF IS NOT SELECTED THEN THE VALUE OF THE USER SHOULD BE PASSED AS DEFAULT
                                          },
                                          title: 'Book Appointment',
                                          height: 45,
                                          width: 200,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              const SizedBox(
                                height: 32,
                              ),
                              // const Divider(
                              //   height: 2,
                              //   color: Colors.grey,
                              // ),
                              // const SizedBox(
                              //   height: 32,
                              // ),
                              // SizedBox(
                              //   width: double.infinity,
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(12.0),
                              //     child: ElevatedButton(
                              //       child: Text("View My Appointments"),
                              //       onPressed: () {},
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.86,
                      child: Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: const [
                            CircularProgressIndicator(
                              color: darkBlue,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text("Saving your appointment, Please wait")
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentSectionHeading extends StatelessWidget {
  final String title;
  const AppointmentSectionHeading({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 12,
              top: 12,
              bottom: 10,
            ),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: darkBlue,
                fontSize: 18,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentFees extends StatelessWidget {
  final double fees;
  const AppointmentFees({Key? key, required this.fees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: OutlinedButton(
            onPressed: () {},
            child: Text(
              'Pay  ${fees.toString()} ₹ on Desk',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: darkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DiscountedAppointmentFees extends StatelessWidget {
  final double fees;
  const DiscountedAppointmentFees({Key? key, required this.fees})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: OutlinedButton(
            onPressed: () {},
            child: Text(
              'Pay  ${fees.toString()} ₹  Now',
              // 'Pay  ${fees.toString()} ₹  Advance',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: darkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// <<<<<<<<<<<<<<<<<< Second latest code >>>>>>>>>>>>>>>>>>>>>>

// import 'dart:convert';
// import 'dart:io';

// import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
// import 'package:Rakshan/utills/progressIndicator.dart';
// //import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:Rakshan/constants/padding.dart';
// import 'package:Rakshan/controller/appointment_controller.dart';
// import 'package:Rakshan/routes/app_routes.dart';
// import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
// import 'package:Rakshan/screens/post_login/home_screen.dart';
// import 'package:Rakshan/screens/post_login/payment.dart';
// import 'package:Rakshan/widgets/post_login/app_bar.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';
// import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../utills/horizontalCalender.dart';
// import '/config/api_url_mapping.dart' as API;
// import 'package:http/http.dart' as http;
// import '../../constants/theme.dart';
// import 'package:date_picker_timeline/date_picker_timeline.dart';

// enum PaymentMethod { cod, advance }

// class BookingDetails {
//   String? date;
//   String? fromTime;
//   String? toTime;
//   int? appoinmentConfigId;
//   int? doctorId;
//   int? clientId;
//   String? dat;

//   BookingDetails({
//     this.date,
//     this.fromTime,
//     this.toTime,
//     this.appoinmentConfigId,
//     this.doctorId,
//     this.clientId,
//     this.dat,
//   });
// }

// class BookingSlot {
//   int? slotId;
//   String? day;
//   String? fromTime;
//   String? toTime;
//   int? appoinmentConfigId;
//   double? appoinmentFee;

//   BookingSlot({
//     this.slotId,
//     this.day,
//     this.fromTime,
//     this.toTime,
//     this.appoinmentConfigId,
//     this.appoinmentFee,
//   });
// }

// class Appointment extends StatefulWidget {
//   const Appointment(
//       {Key? key,
//       required this.sProviderTypeId,
//       required this.sClientId,
//       required this.sClientTypeName,
//       required this.sClientName})
//       : super(key: key);

//   final int sProviderTypeId; //in 1st dropdownn
//   final int sClientId; //2nd dropdown
//   final String sClientTypeName; // in 1st drop hint
//   final String sClientName; // in 2nd drop hint

//   @override
//   State<Appointment> createState() => _AppointmentState();
// }

// class _AppointmentState extends State<Appointment> {
//   // DateTime _selectedDate = DateTime.now();
//   final _appointmentController = AppointmentController();
//   late ProcessIndicatorDialog _progressIndicator;
//   int selectedCard = -1;
//   dynamic amount = 0.0;
//   var bookId;
//   // ===============ROHIT's===================

//   final engDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday',
//   ];

//   int stepCount = 0;
//   // selected provider Type = 1
//   // selected provider = 2
//   // selected doctor = 3
//   // selected date = 4
//   // selected slot  = 5
//   // selected paymentMethod  = 6
//   // selected doingBooking  = 7

//   List providerTypes = [];
//   int? selectedProviderType;

//   List serviceProviders = [];
//   int? selectedProvider;

//   List consultants = [];
//   int? selectedConsultant;

//   bool isLoading = true;

// // booking
//   bool showDates = false;
//   bool showSlots = false;
//   bool showPaymentMethods = false;
//   bool isSavingAppointment = false;

//   List allSlots = [];
//   List? slotsForTheSelectedDay;

//   String selectedDate = "";
//   BookingSlot selectedSlot = BookingSlot();

//   PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

//   BookingDetails bookingTracker = BookingDetails();

//   void fetchProviderTypes() async {
//     final fetechedProviderTypes =
//         await _appointmentController.getProviderTypes();

//     setState(() {
//       stepCount = 0;
//       providerTypes = fetechedProviderTypes;

//       // set other two as empty
//       serviceProviders = [];
//       consultants = [];
//     });
//   }

//   void fetchServiceProviders(int ClientTypeId) async {
//     final fetchedServiceProvider =
//         await _appointmentController.getServiceProviders(ClientTypeId);

//     setState(() {
//       selectedProviderType = ClientTypeId;
//       serviceProviders = fetchedServiceProvider;

//       showDates = false;
//       showSlots = false;
//       showPaymentMethods = false;
//       selectedDate = "";
//       slotsForTheSelectedDay = null;

//       consultants = [];
//     });
//   }

//   void fetchConsultants(int clientId) async {
//     final fetchedConsultants =
//         await _appointmentController.getConsultants(clientId);

//     setState(() {
//       selectedProvider = clientId;
//       consultants = fetchedConsultants;
//       showDates = false;
//     });
//   }

//   void handleDateSelect(BuildContext ctx, String date) {
//     if (stepCount < 3) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text(
//             "Please pick provider and doctor first",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           duration: Duration(
//             milliseconds: 2000,
//           ),
//           backgroundColor: Colors.blue,
//         ),
//       );
//       return;
//     }

//     final splittedStr = date.split("-");
//     final chosenDate = DateTime(
//       int.parse(splittedStr[0]),
//       int.parse(splittedStr[1]),
//       int.parse(splittedStr[2]),
//     );

//     final weekday = DateFormat("EEEE").format(chosenDate);
//     setState(() {
//       stepCount = 4;
//       selectedDate = date;
//       slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
//       selectedSlot = BookingSlot();
//     });

//     if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'You cannot book slots for current day, please look for next day onwards.',
//             // "No slots available for this date",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           duration: Duration(
//             milliseconds: 2000,
//           ),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     }
//   }

//   void handleSlotSelect(BookingSlot slot) {
//     if (stepCount <= 4) {
//       return;
//     }
//     setState(() {
//       stepCount = 5;
//     });
//   }

//   List findSlotsForTheSelectedDay(String day) {
//     final coppyArray = new List<Map>.from(allSlots);
//     coppyArray.removeWhere((slot) => slot['day'] != day);
//     int index = 0;
//     final slotsWithId = coppyArray.map((slot) {
//       final myMap = Map();
//       myMap["slotId"] = index;
//       myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
//       myMap["day"] = slot["day"];
//       myMap["fromTime"] = slot["fromTime"];
//       myMap["toTime"] = slot["toTime"];
//       myMap["appoinmentFee"] = slot["appoinmentFee"];
//       index++;
//       return myMap;
//     }).toList();
//     return slotsWithId;
//   }

//   Future<bool> saveAppointments(
//     BookingSlot bookingDetails,
//     int clientId,
//     int consultantId,
//     String selectedDate,
//   ) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     final userToken = sharedPreferences.getString('data');
//     final userId = sharedPreferences.get("userId");
//     _progressIndicator.show();
//     var response = await http.post(
//         Uri.parse(
//           API.buildUrl(
//             API.kBookAppointment,
//           ),
//         ),
//         headers: {
//           HttpHeaders.authorizationHeader: 'Bearer $userToken',
//           HttpHeaders.contentTypeHeader: "application/json"
//         },
//         body: jsonEncode({
//           "ClientId": clientId,
//           "ServiceId": 4,
//           "DoctorId": consultantId,
//           "UserId": int.tryParse(userId as String),
//           "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
//           "Day": bookingDetails.day,
//           "FromTime": bookingDetails.fromTime,
//           "ToTime": bookingDetails.toTime,
//           "AppoinmentDate": selectedDate
//         }));
//     _progressIndicator.hide();
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data["isSuccess"]) {
//         var bookId = data['id'];
//         return true;
//       } else {
//         return false;
//       }
//     }
//     return false;
//   }

//   void saveAppointment(ctx, dynamic amounts) async {
//     // setState(() {
//     //   isSavingAppointment = true;
//     // });

//     final splittedStr = selectedDate.split("-");

//     final selectedDateToSend =
//         "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
//     // show confirmation page
//     bool savedAppointment = await saveAppointments(
//       selectedSlot,
//       selectedProvider!,
//       selectedConsultant!,
//       selectedDateToSend,
//     );

//     setState(() {
//       isSavingAppointment = false;
//     });

//     if (savedAppointment) {
//       if (selectedPaymentMethod == PaymentMethod.advance) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (ctx) {
//               var bookId;
//               return PaymentScreen(
//                 amount: amounts,
//                 id: bookId,
//                 sName: "Appointment",
//                 // coupontype: "",
//               );
//             },
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(ctx).showSnackBar(
//           const SnackBar(
//             content: Text(
//               "Appointment booked successfully",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             duration: Duration(
//               milliseconds: 2000,
//             ),
//             backgroundColor: Colors.blue,
//           ),
//         );
//         Navigator.pop(context);
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (ctx) {
//               return BookingConfirmation();
//             },
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text(
//             "Appointment not booked successfully",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           duration: Duration(
//             milliseconds: 2000,
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     _progressIndicator = ProcessIndicatorDialog(context);
//     super.initState();
//     fetchProviderTypes();
//     if (widget.sProviderTypeId != 0) {
//       fetchServiceProviders(widget.sClientId);
//       fetchConsultants(widget.sClientId);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context, true);
//           }, // Handle your on tap here.
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Color(0xfffcfcfc),
//         title: const Text(
//           'Appointment',
//           style: TextStyle(
//             fontFamily: 'OpenSans',
//             color: Color(0xff2e66aa),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(right: 20.0),
//             child: IconButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, appointmentHistoryScreen);
//               },
//               icon: Icon(Icons.history),
//             ),
//           ),
//         ],
//         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             !isSavingAppointment
//                 ? Container(
//                     child: Column(children: [
//                       // SERVICE PROVIDER TYPES
//                       // if(widget.sProviderTypeId != ''){}else{}
//                       widget.sProviderTypeId != 0
//                           ? Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 10),
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.only(left: 16, right: 16),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xfff1f7ff),
//                                   border:
//                                       Border.all(color: Colors.white, width: 1),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: DropdownButton(
//                                   value: selectedProviderType =
//                                       widget.sProviderTypeId,
//                                   onChanged: (ClientTypeId) {
//                                     setState(() {
//                                       // serviceProviders =[];
//                                       stepCount = 1;
//                                       allSlots = [];
//                                       selectedProviderType =
//                                           ClientTypeId as int;
//                                     });

//                                     fetchServiceProviders(ClientTypeId as int);
//                                   },
//                                   items: providerTypes.map((providerType) {
//                                     return DropdownMenuItem(
//                                       value: providerType["clientTypeId"],
//                                       child: Text(
//                                         providerType["clientTypeName"],
//                                         style: kApiTextstyle,
//                                       ),
//                                     );
//                                   }).toList(),
//                                   hint: Text(
//                                     widget.sClientTypeName,
//                                     style: kSubheadingTextstyle,
//                                   ),
//                                   dropdownColor: Colors.white,
//                                   icon: Icon(Icons.arrow_drop_down),
//                                   iconSize: 36,
//                                   isExpanded: true,
//                                   underline: SizedBox(),
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           // to atupopulate 1st dropddown
//                           : Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 10),
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.only(left: 16, right: 16),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xfff1f7ff),
//                                   border:
//                                       Border.all(color: Colors.white, width: 1),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: DropdownButton(
//                                   value: selectedProviderType,
//                                   onChanged: (ClientTypeId) {
//                                     setState(() {
//                                       // serviceProviders =[];
//                                       stepCount = 1;
//                                       allSlots = [];
//                                       selectedProviderType =
//                                           ClientTypeId as int;
//                                     });
//                                     fetchServiceProviders(ClientTypeId as int);
//                                   },
//                                   items: providerTypes.map((providerType) {
//                                     return DropdownMenuItem(
//                                       value: providerType["clientTypeId"],
//                                       child: Text(
//                                         providerType["clientTypeName"],
//                                         style: kApiTextstyle,
//                                       ),
//                                     );
//                                   }).toList(),
//                                   hint: const Text(
//                                     'Select Provider Type',
//                                     style: kSubheadingTextstyle,
//                                   ),
//                                   dropdownColor: Colors.white,
//                                   icon: Icon(Icons.arrow_drop_down),
//                                   iconSize: 36,
//                                   isExpanded: true,
//                                   underline: SizedBox(),
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                       // SERVICE PROVIDERS
//                       widget.sClientId != 0
//                           ? Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 10),
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.only(left: 16, right: 16),
//                                 decoration: BoxDecoration(
//                                   color: kFaintBlue,
//                                   border:
//                                       Border.all(color: Colors.white, width: 1),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: DropdownButton(
//                                   value: selectedProvider = widget.sClientId,
//                                   onChanged: (clientId) {
//                                     setState(() {
//                                       stepCount = 2;
//                                       selectedProvider = clientId as int;
//                                       allSlots = [];
//                                     });
//                                     fetchConsultants(clientId as int);
//                                   },
//                                   items:
//                                       serviceProviders.map((serviceProvider) {
//                                     return DropdownMenuItem(
//                                       value: serviceProvider["clientId"],
//                                       child: Text(
//                                         serviceProvider["clientName"],
//                                         style: kApiTextstyle,
//                                       ),
//                                     );
//                                   }).toList(),
//                                   hint: Text(
//                                     widget.sClientName,
//                                     style: kApiTextstyle,
//                                   ),
//                                   dropdownColor: Colors.white,
//                                   icon: Icon(Icons.arrow_drop_down),
//                                   iconSize: 36,
//                                   isExpanded: true,
//                                   underline: SizedBox(),
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 10),
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.only(left: 16, right: 16),
//                                 decoration: BoxDecoration(
//                                   color: kFaintBlue,
//                                   border:
//                                       Border.all(color: Colors.white, width: 1),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: DropdownButton(
//                                   value: selectedProvider,
//                                   onChanged: (clientId) {
//                                     setState(() {
//                                       stepCount = 2;
//                                       selectedProvider = clientId as int;
//                                       allSlots = [];
//                                     });
//                                     fetchConsultants(clientId as int);
//                                   },
//                                   items:
//                                       serviceProviders.map((serviceProvider) {
//                                     return DropdownMenuItem(
//                                       value: serviceProvider["clientId"],
//                                       child: Text(
//                                         serviceProvider["clientName"],
//                                         style: kApiTextstyle,
//                                       ),
//                                     );
//                                   }).toList(),
//                                   hint: const Text(
//                                     'Service Provider',
//                                     style: kApiTextstyle,
//                                   ),
//                                   dropdownColor: Colors.white,
//                                   icon: Icon(Icons.arrow_drop_down),
//                                   iconSize: 36,
//                                   isExpanded: true,
//                                   underline: SizedBox(),
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                       // CONSULTANTS
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 10),
//                         child: Container(
//                           padding: const EdgeInsets.only(left: 16, right: 16),
//                           decoration: BoxDecoration(
//                             color: const Color(0xfff1f7ff),
//                             border: Border.all(color: Colors.white, width: 1),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: DropdownButton(
//                             value: selectedConsultant,
//                             onChanged: (consultantId) async {
//                               setState(() {
//                                 stepCount = 3;
//                                 selectedConsultant = consultantId as int;
//                               });

//                               final consultantSlots =
//                                   await _appointmentController
//                                       .getDoctorAppointmentDetails(
//                                 selectedProvider as int,
//                                 consultantId as int,
//                               );

//                               setState(() {
//                                 allSlots = consultantSlots;
//                               });
//                             },
//                             items: consultants.map((consultant) {
//                               return DropdownMenuItem(
//                                 value: consultant["consultantId"],
//                                 child: Text(
//                                   consultant["consultantName"],
//                                   style: kApiTextstyle,
//                                 ),
//                               );
//                             }).toList(),
//                             hint: const Text(
//                               'Select Doctors',
//                               style: kApiTextstyle,
//                             ),
//                             dropdownColor: Colors.white,
//                             icon: const Icon(Icons.arrow_drop_down),
//                             iconSize: 36,
//                             isExpanded: true,
//                             underline: const SizedBox(),
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),

//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 0,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                 ),
//                                 child: Text(
//                                   'Choose a date',
//                                   style: TextStyle(
//                                     color: darkBlue,
//                                     fontSize: 18,
//                                     fontFamily: 'OpenSans',
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 )),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             Container(
//                                 padding: kScreenPadding,
//                                 child: DatePicker(
//                                   DateTime.now().add(
//                                     Duration(
//                                       hours: 2 - DateTime.now().hour,
//                                       // minutes: 60 - DateTime.now().minute,
//                                       // seconds: 60 - DateTime.now().second,
//                                     ),
//                                   ),
//                                   height: 100,
//                                   width: 60,
//                                   daysCount: 7,
//                                   selectionColor: darkBlue,
//                                   selectedTextColor: Colors.white,
//                                   dateTextStyle: kBlueTextstyle,
//                                   onDateChange: (date) {
//                                     var selecteddate =
//                                         date.toString().split(' ').first;
//                                     print(selecteddate);
//                                     handleDateSelect(context, selecteddate);
//                                   },
//                                 )),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     margin: const EdgeInsets.only(
//                                         left: 12, top: 12, bottom: 16),
//                                     child: const Text(
//                                       'Available Slots',
//                                       textAlign: TextAlign.start,
//                                       style: TextStyle(
//                                         color: darkBlue,
//                                         fontSize: 18,
//                                         fontFamily: 'OpenSans',
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   stepCount >= 4
//                                       ? slotsForTheSelectedDay!.length > 0
//                                           ? Container(
//                                               child: Column(
//                                                 children: [
//                                                   Container(
//                                                     child: GridView.builder(
//                                                       shrinkWrap: true,
//                                                       physics: ScrollPhysics(),
//                                                       gridDelegate:
//                                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                                         crossAxisCount: 2,
//                                                         crossAxisSpacing: 3,
//                                                         mainAxisSpacing: 3,
//                                                         childAspectRatio: MediaQuery
//                                                                     .of(context)
//                                                                 .size
//                                                                 .width /
//                                                             (MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .height /
//                                                                 6),
//                                                       ),
//                                                       scrollDirection:
//                                                           Axis.vertical,
//                                                       itemBuilder:
//                                                           (BuildContext context,
//                                                               index) {
//                                                         final currentSlot =
//                                                             slotsForTheSelectedDay![
//                                                                 index];

//                                                         return GestureDetector(
//                                                           onTap: () {
//                                                             setState(() {
//                                                               stepCount = 7;
//                                                               amount = selectedSlot
//                                                                   .appoinmentFee;
//                                                               showPaymentMethods =
//                                                                   true;
//                                                               selectedSlot =
//                                                                   BookingSlot(
//                                                                 slotId:
//                                                                     currentSlot[
//                                                                         "slotId"],
//                                                                 appoinmentConfigId:
//                                                                     currentSlot[
//                                                                         "appoinmentConfigId"],
//                                                                 day:
//                                                                     currentSlot[
//                                                                         "day"],
//                                                                 fromTime:
//                                                                     currentSlot[
//                                                                         "fromTime"],
//                                                                 toTime:
//                                                                     currentSlot[
//                                                                         "toTime"],
//                                                                 appoinmentFee:
//                                                                     currentSlot[
//                                                                         "appoinmentFee"],
//                                                               );
//                                                             });
//                                                           },
//                                                           child: Card(
//                                                             color: selectedSlot
//                                                                         .slotId ==
//                                                                     currentSlot[
//                                                                         "slotId"]
//                                                                 ? const Color(
//                                                                     0xff325CA2)
//                                                                 : Colors.white,
//                                                             child: Container(
//                                                               height: 200,
//                                                               width: 200,
//                                                               child: Center(
//                                                                 child: Text(
//                                                                   "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: selectedSlot.slotId ==
//                                                                             currentSlot[
//                                                                                 "slotId"]
//                                                                         ? Colors
//                                                                             .white
//                                                                         : Colors
//                                                                             .black,
//                                                                     fontSize:
//                                                                         14,
//                                                                     fontFamily:
//                                                                         'OpenSans',
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w500,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         );
//                                                       },
//                                                       itemCount:
//                                                           slotsForTheSelectedDay ==
//                                                                   null
//                                                               ? 0
//                                                               : slotsForTheSelectedDay!
//                                                                   .length,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           : (Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: const [
//                                                 Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: 6,
//                                                     horizontal: 10,
//                                                   ),
//                                                   child: Text(
//                                                     "No slots available for this date",
//                                                   ),
//                                                 ),
//                                               ],
//                                             ))
//                                       : (Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: const [
//                                             Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                 vertical: 6,
//                                                 horizontal: 10,
//                                               ),
//                                               child: Text(
//                                                 "Please select a date",
//                                               ),
//                                             ),
//                                           ],
//                                         )),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             stepCount >= 6
//                                 ? Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       AppointmentSectionHeading(
//                                         title: "Payment Method",
//                                       ),
//                                       AppointmentFees(
//                                         fees: selectedSlot.appoinmentFee!,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const Spacer(
//                                             flex: 1,
//                                           ),
//                                           Expanded(
//                                             flex: 4,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Column(
//                                                   children: [
//                                                     Radio(
//                                                       value: PaymentMethod.cod,
//                                                       groupValue:
//                                                           selectedPaymentMethod,
//                                                       onChanged: ((value) {
//                                                         setState(() {
//                                                           selectedPaymentMethod =
//                                                               value
//                                                                   as PaymentMethod;
//                                                           // print(isDiabetic);
//                                                         });
//                                                       }),
//                                                     ),
//                                                     const Text(
//                                                       "COD",
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     Radio(
//                                                       value:
//                                                           PaymentMethod.advance,
//                                                       groupValue:
//                                                           selectedPaymentMethod,
//                                                       onChanged: ((value) {
//                                                         setState(() {
//                                                           selectedPaymentMethod =
//                                                               value
//                                                                   as PaymentMethod;
//                                                           // print(isDiabetic);
//                                                         });
//                                                       }),
//                                                     ),
//                                                     const Text(
//                                                       "ADVANCE",
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Spacer(
//                                             flex: 1,
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 : const SizedBox(
//                                     height: 0,
//                                   ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             stepCount == 7
//                                 ? Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       BlueButton(
//                                         onPressed: () async {
//                                           SharedPreferences sharedPreferences =
//                                               await SharedPreferences
//                                                   .getInstance();
//                                           bool isPay = await sharedPreferences
//                                                   .getBool("isPay") ??
//                                               false;
//                                           if (isPay) {
//                                             saveAppointment(context,
//                                                 selectedSlot.appoinmentFee);
//                                           } else {
//                                             // Navigator.pushNamedAndRemoveUntil(
//                                             //     context,
//                                             //     homeFirst,
//                                             //     (route) => false);
//                                             saveAppointment(context,
//                                                 selectedSlot.appoinmentFee);
//                                           }
//                                         },
//                                         title: 'Book Appointment',
//                                         height: 45,
//                                         width: 200,
//                                       ),
//                                     ],
//                                   )
//                                 : const SizedBox(
//                                     height: 0,
//                                   ),
//                             const SizedBox(
//                               height: 32,
//                             ),
//                             // const Divider(
//                             //   height: 2,
//                             //   color: Colors.grey,
//                             // ),
//                             // const SizedBox(
//                             //   height: 32,
//                             // ),
//                             // SizedBox(
//                             //   width: double.infinity,
//                             //   child: Padding(
//                             //     padding: const EdgeInsets.all(12.0),
//                             //     child: ElevatedButton(
//                             //       child: Text("View My Appointments"),
//                             //       onPressed: () {},
//                             //     ),
//                             //   ),
//                             // ),
//                             const SizedBox(
//                               height: 32,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ]),
//                   )
//                 : Container(
//                     height: MediaQuery.of(context).size.height * 0.86,
//                     child: Center(
//                       child: Wrap(
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         direction: Axis.vertical,
//                         children: const [
//                           CircularProgressIndicator(
//                             color: darkBlue,
//                           ),
//                           SizedBox(
//                             height: 24,
//                           ),
//                           Text("Saving your appointment, Please wait")
//                         ],
//                       ),
//                     ),
//                   )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AppointmentSectionHeading extends StatelessWidget {
//   final String title;
//   const AppointmentSectionHeading({Key? key, required this.title})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(
//               left: 12,
//               top: 12,
//               bottom: 10,
//             ),
//             child: Text(
//               title,
//               textAlign: TextAlign.start,
//               style: const TextStyle(
//                 color: darkBlue,
//                 fontSize: 18,
//                 fontFamily: 'OpenSans',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppointmentFees extends StatelessWidget {
//   final double fees;
//   const AppointmentFees({Key? key, required this.fees}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(
//             horizontal: 20,
//           ),
//           child: OutlinedButton(
//             onPressed: () {},
//             child: Text(
//               'Fees : ${fees.toString()} ₹',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: darkBlue,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< CODE BELOW IS BEFORE IMPLEMENTING AUTOLOAD IN DROPDOWNS >>>>>>>>>>>>>>>>>>>>>>>>>>

// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
// // import 'package:Rakshan/utills/progressIndicator.dart';
// // //import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:Rakshan/constants/padding.dart';
// // import 'package:Rakshan/controller/appointment_controller.dart';
// // import 'package:Rakshan/routes/app_routes.dart';
// // import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
// // import 'package:Rakshan/screens/post_login/home_screen.dart';
// // import 'package:Rakshan/screens/post_login/payment.dart';
// // import 'package:Rakshan/widgets/post_login/app_bar.dart';
// // import 'package:Rakshan/widgets/post_login/app_menu.dart';
// // import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../utills/horizontalCalender.dart';
// // import '/config/api_url_mapping.dart' as API;
// // import 'package:http/http.dart' as http;
// // import '../../constants/theme.dart';
// // import 'package:date_picker_timeline/date_picker_timeline.dart';

// // enum PaymentMethod { cod, advance }

// // class BookingDetails {
// //   String? date;
// //   String? fromTime;
// //   String? toTime;
// //   int? appoinmentConfigId;
// //   int? doctorId;
// //   int? clientId;
// //   String? dat;

// //   BookingDetails({
// //     this.date,
// //     this.fromTime,
// //     this.toTime,
// //     this.appoinmentConfigId,
// //     this.doctorId,
// //     this.clientId,
// //     this.dat,
// //   });
// // }

// // class BookingSlot {
// //   int? slotId;
// //   String? day;
// //   String? fromTime;
// //   String? toTime;
// //   int? appoinmentConfigId;
// //   double? appoinmentFee;

// //   BookingSlot({
// //     this.slotId,
// //     this.day,
// //     this.fromTime,
// //     this.toTime,
// //     this.appoinmentConfigId,
// //     this.appoinmentFee,
// //   });
// // }

// // class Appointment extends StatefulWidget {
// //   const Appointment(
// //       {Key? key,
// //       required this.sProviderTypeId,
// //       required this.sClientId,
// //       required this.sService,
// //       required this.sClientName})
// //       : super(key: key);

// //   final String sProviderTypeId; //in 1st dropdownn
// //   final String sClientId; //2nd dropdown
// //   final String sService;
// //   final String sClientName;

// //   @override
// //   State<Appointment> createState() => _AppointmentState();
// // }

// // class _AppointmentState extends State<Appointment> {
// //   // DateTime _selectedDate = DateTime.now();
// //   final _appointmentController = AppointmentController();
// //   late ProcessIndicatorDialog _progressIndicator;
// //   int selectedCard = -1;
// //   dynamic amount = 0.0;
// //   var bookId;
// //   // ===============ROHIT's===================

// //   final engDays = [
// //     'Monday',
// //     'Tuesday',
// //     'Wednesday',
// //     'Thursday',
// //     'Friday',
// //     'Saturday',
// //     'Sunday',
// //   ];

// //   int stepCount = 0;
// //   // selected provider Type = 1
// //   // selected provider = 2
// //   // selected doctor = 3
// //   // selected date = 4
// //   // selected slot  = 5
// //   // selected paymentMethod  = 6
// //   // selected doingBooking  = 7

// //   List providerTypes = [];
// //   int? selectedProviderType;

// //   List serviceProviders = [];
// //   int? selectedProvider;

// //   List consultants = [];
// //   int? selectedConsultant;

// //   bool isLoading = true;

// // // booking
// //   bool showDates = false;
// //   bool showSlots = false;
// //   bool showPaymentMethods = false;
// //   bool isSavingAppointment = false;

// //   List allSlots = [];
// //   List? slotsForTheSelectedDay;

// //   String selectedDate = "";
// //   BookingSlot selectedSlot = BookingSlot();

// //   PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

// //   BookingDetails bookingTracker = BookingDetails();

// //   void fetchProviderTypes() async {
// //     final fetechedProviderTypes =
// //         await _appointmentController.getProviderTypes();

// //     setState(() {
// //       stepCount = 0;
// //       providerTypes = fetechedProviderTypes;

// //       // set other two as empty
// //       serviceProviders = [];
// //       consultants = [];
// //     });
// //   }

// //   void fetchServiceProviders(int ClientTypeId) async {
// //     final fetchedServiceProvider =
// //         await _appointmentController.getServiceProviders(ClientTypeId);

// //     setState(() {
// //       selectedProviderType = ClientTypeId;
// //       serviceProviders = fetchedServiceProvider;

// //       showDates = false;
// //       showSlots = false;
// //       showPaymentMethods = false;
// //       selectedDate = "";
// //       slotsForTheSelectedDay = null;

// //       consultants = [];
// //     });
// //   }

// //   void fetchConsultants(int clientId) async {
// //     final fetchedConsultants =
// //         await _appointmentController.getConsultants(clientId);

// //     setState(() {
// //       selectedProvider = clientId;
// //       consultants = fetchedConsultants;
// //       showDates = false;
// //     });
// //   }

// //   void handleDateSelect(BuildContext ctx, String date) {
// //     if (stepCount < 3) {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             "Please pick provider and doctor first",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.blue,
// //         ),
// //       );
// //       return;
// //     }

// //     final splittedStr = date.split("-");
// //     final chosenDate = DateTime(
// //       int.parse(splittedStr[0]),
// //       int.parse(splittedStr[1]),
// //       int.parse(splittedStr[2]),
// //     );

// //     final weekday = DateFormat("EEEE").format(chosenDate);
// //     setState(() {
// //       stepCount = 4;
// //       selectedDate = date;
// //       slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
// //       selectedSlot = BookingSlot();
// //     });

// //     if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             'You cannot book slots for current day, please look for next day onwards.',
// //             // "No slots available for this date",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.redAccent,
// //         ),
// //       );
// //     }
// //   }

// //   void handleSlotSelect(BookingSlot slot) {
// //     if (stepCount <= 4) {
// //       return;
// //     }
// //     setState(() {
// //       stepCount = 5;
// //     });
// //   }

// //   List findSlotsForTheSelectedDay(String day) {
// //     final coppyArray = new List<Map>.from(allSlots);
// //     coppyArray.removeWhere((slot) => slot['day'] != day);
// //     int index = 0;
// //     final slotsWithId = coppyArray.map((slot) {
// //       final myMap = Map();
// //       myMap["slotId"] = index;
// //       myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
// //       myMap["day"] = slot["day"];
// //       myMap["fromTime"] = slot["fromTime"];
// //       myMap["toTime"] = slot["toTime"];
// //       myMap["appoinmentFee"] = slot["appoinmentFee"];
// //       index++;
// //       return myMap;
// //     }).toList();
// //     return slotsWithId;
// //   }

// //   Future<bool> saveAppointments(
// //     BookingSlot bookingDetails,
// //     int clientId,
// //     int consultantId,
// //     String selectedDate,
// //   ) async {
// //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// //     final userToken = sharedPreferences.getString('data');
// //     final userId = sharedPreferences.get("userId");
// //     _progressIndicator.show();
// //     var response = await http.post(
// //         Uri.parse(
// //           API.buildUrl(
// //             API.kBookAppointment,
// //           ),
// //         ),
// //         headers: {
// //           HttpHeaders.authorizationHeader: 'Bearer $userToken',
// //           HttpHeaders.contentTypeHeader: "application/json"
// //         },
// //         body: jsonEncode({
// //           "ClientId": clientId,
// //           "ServiceId": 4,
// //           "DoctorId": consultantId,
// //           "UserId": int.tryParse(userId as String),
// //           "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
// //           "Day": bookingDetails.day,
// //           "FromTime": bookingDetails.fromTime,
// //           "ToTime": bookingDetails.toTime,
// //           "AppoinmentDate": selectedDate
// //         }));
// //     _progressIndicator.hide();
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       if (data["isSuccess"]) {
// //         var bookId = data['id'];
// //         return true;
// //       } else {
// //         return false;
// //       }
// //     }
// //     return false;
// //   }

// //   void saveAppointment(ctx, dynamic amounts) async {
// //     // setState(() {
// //     //   isSavingAppointment = true;
// //     // });

// //     final splittedStr = selectedDate.split("-");

// //     final selectedDateToSend =
// //         "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
// //     // show confirmation page
// //     bool savedAppointment = await saveAppointments(
// //       selectedSlot,
// //       selectedProvider!,
// //       selectedConsultant!,
// //       selectedDateToSend,
// //     );

// //     setState(() {
// //       isSavingAppointment = false;
// //     });

// //     if (savedAppointment) {
// //       if (selectedPaymentMethod == PaymentMethod.advance) {
// //         Navigator.of(context).push(
// //           MaterialPageRoute(
// //             builder: (ctx) {
// //               var bookId;
// //               return PaymentScreen(
// //                 amount: amounts,
// //                 id: bookId,
// //                 sName: "Appointment",
// //                 // coupontype: "",
// //               );
// //             },
// //           ),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(ctx).showSnackBar(
// //           const SnackBar(
// //             content: Text(
// //               "Appointment booked successfully",
// //               style: TextStyle(
// //                 color: Colors.white,
// //               ),
// //             ),
// //             duration: Duration(
// //               milliseconds: 2000,
// //             ),
// //             backgroundColor: Colors.blue,
// //           ),
// //         );
// //         Navigator.pop(context);
// //         Navigator.of(context).push(
// //           MaterialPageRoute(
// //             builder: (ctx) {
// //               return BookingConfirmation();
// //             },
// //           ),
// //         );
// //       }
// //     } else {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             "Appointment not booked successfully",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   void initState() {
// //     _progressIndicator = ProcessIndicatorDialog(context);
// //     super.initState();
// //     fetchProviderTypes();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       //
// //       appBar: AppBar(
// //         elevation: 0,
// //         leading: IconButton(
// //           onPressed: () {
// //             Navigator.pop(context, true);
// //           }, // Handle your on tap here.
// //           icon: const Icon(
// //             Icons.arrow_back_ios,
// //             color: Colors.black,
// //           ),
// //         ),
// //         backgroundColor: Color(0xfffcfcfc),
// //         title: const Text(
// //           'Appointment',
// //           style: TextStyle(
// //             fontFamily: 'OpenSans',
// //             color: Color(0xff2e66aa),
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         actions: <Widget>[
// //           Padding(
// //             padding: EdgeInsets.only(right: 20.0),
// //             child: IconButton(
// //               onPressed: () {
// //                 Navigator.pushNamed(context, appointmentHistoryScreen);
// //               },
// //               icon: Icon(Icons.history),
// //             ),
// //           ),
// //         ],
// //         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Stack(
// //           children: [
// //             !isSavingAppointment
// //                 ? Container(
// //                     child: Column(children: [
// //                       // SERVICE PROVIDER TYPES
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 10),
// //                         child: Container(
// //                           padding: const EdgeInsets.only(left: 16, right: 16),
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xfff1f7ff),
// //                             border: Border.all(color: Colors.white, width: 1),
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: DropdownButton(
// //                             value: selectedProviderType,
// //                             onChanged: (ClientTypeId) {
// //                               setState(() {
// //                                 // serviceProviders =[];
// //                                 stepCount = 1;
// //                                 allSlots = [];
// //                                 selectedProviderType = ClientTypeId as int;
// //                               });
// //                               fetchServiceProviders(ClientTypeId as int);
// //                             },
// //                             items: providerTypes.map((providerType) {
// //                               return DropdownMenuItem(
// //                                 value: providerType["clientTypeId"],
// //                                 child: Text(
// //                                   providerType["clientTypeName"],
// //                                   style: kApiTextstyle,
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             hint: const Text(
// //                               'Select Provider Type',
// //                               style: kSubheadingTextstyle,
// //                             ),
// //                             dropdownColor: Colors.white,
// //                             icon: Icon(Icons.arrow_drop_down),
// //                             iconSize: 36,
// //                             isExpanded: true,
// //                             underline: SizedBox(),
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       // SERVICE PROVIDERS
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 10),
// //                         child: Container(
// //                           padding: const EdgeInsets.only(left: 16, right: 16),
// //                           decoration: BoxDecoration(
// //                             color: kFaintBlue,
// //                             border: Border.all(color: Colors.white, width: 1),
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: DropdownButton(
// //                             value: selectedProvider,
// //                             onChanged: (clientId) {
// //                               setState(() {
// //                                 stepCount = 2;
// //                                 selectedProvider = clientId as int;
// //                                 allSlots = [];
// //                               });
// //                               fetchConsultants(clientId as int);
// //                             },
// //                             items: serviceProviders.map((serviceProvider) {
// //                               return DropdownMenuItem(
// //                                 value: serviceProvider["clientId"],
// //                                 child: Text(
// //                                   serviceProvider["clientName"],
// //                                   style: kApiTextstyle,
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             hint: const Text(
// //                               'Service Provider',
// //                               style: kApiTextstyle,
// //                             ),
// //                             dropdownColor: Colors.white,
// //                             icon: Icon(Icons.arrow_drop_down),
// //                             iconSize: 36,
// //                             isExpanded: true,
// //                             underline: SizedBox(),
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       // CONSULTANTS
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 10),
// //                         child: Container(
// //                           padding: const EdgeInsets.only(left: 16, right: 16),
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xfff1f7ff),
// //                             border: Border.all(color: Colors.white, width: 1),
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: DropdownButton(
// //                             value: selectedConsultant,
// //                             onChanged: (consultantId) async {
// //                               setState(() {
// //                                 stepCount = 3;
// //                                 selectedConsultant = consultantId as int;
// //                               });

// //                               final consultantSlots =
// //                                   await _appointmentController
// //                                       .getDoctorAppointmentDetails(
// //                                 selectedProvider as int,
// //                                 consultantId as int,
// //                               );

// //                               setState(() {
// //                                 allSlots = consultantSlots;
// //                               });
// //                             },
// //                             items: consultants.map((consultant) {
// //                               return DropdownMenuItem(
// //                                 value: consultant["consultantId"],
// //                                 child: Text(
// //                                   consultant["consultantName"],
// //                                   style: kApiTextstyle,
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             hint: const Text(
// //                               'Select Doctors',
// //                               style: kApiTextstyle,
// //                             ),
// //                             dropdownColor: Colors.white,
// //                             icon: const Icon(Icons.arrow_drop_down),
// //                             iconSize: 36,
// //                             isExpanded: true,
// //                             underline: const SizedBox(),
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 0,
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             const SizedBox(
// //                               height: 16,
// //                             ),
// //                             const Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: 20,
// //                                 ),
// //                                 child: Text(
// //                                   'Choose a date',
// //                                   style: TextStyle(
// //                                     color: darkBlue,
// //                                     fontSize: 18,
// //                                     fontFamily: 'OpenSans',
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 )),
// //                             const SizedBox(
// //                               height: 16,
// //                             ),
// //                             Container(
// //                                 padding: kScreenPadding,
// //                                 child: DatePicker(
// //                                   DateTime.now().add(
// //                                     Duration(
// //                                       hours: 24 - DateTime.now().hour,
// //                                       minutes: 60 - DateTime.now().minute,
// //                                       seconds: 60 - DateTime.now().second,
// //                                     ),
// //                                   ),
// //                                   height: 100,
// //                                   width: 60,
// //                                   // initialSelectedDate: DateTime.now().add(
// //                                   //   Duration(
// //                                   //     hours: 24 - DateTime.now().hour,
// //                                   //     minutes: 60 - DateTime.now().minute,
// //                                   //     seconds: 60 - DateTime.now().second,
// //                                   //   ),
// //                                   // ),
// //                                   daysCount: 7,
// //                                   selectionColor: darkBlue,
// //                                   selectedTextColor: Colors.white,
// //                                   dateTextStyle: kBlueTextstyle,
// //                                   onDateChange: (date) {
// //                                     var selecteddate =
// //                                         date.toString().split(' ').first;
// //                                     print(selecteddate);
// //                                     handleDateSelect(context, selecteddate);
// //                                     // New date selected
// //                                     // setState(() {});
// //                                   },
// //                                 )),
// //                             // Container(
// //                             //   padding: kScreenPadding,
// //                             //   height: MediaQuery.of(context).size.height * 0.2,
// //                             //   child: AnimatedHorizontalCalendar(
// //                             //       selectedBoxShadow:
// //                             //           const BoxShadow(color: kFaintBlue),
// //                             //       tableCalenderButtonColor: darkBlue,
// //                             //       initialDate: DateTime.now().add(
// //                             //         Duration(
// //                             //           hours: 24 - DateTime.now().hour,
// //                             //           minutes: 60 - DateTime.now().minute,
// //                             //           seconds: 60 - DateTime.now().second,
// //                             //         ),
// //                             //       ),
// //                             //       lastDate: DateTime.now().add(
// //                             //         const Duration(
// //                             //           days: 7,
// //                             //         ),
// //                             //       ),
// //                             //       date: DateTime.now().add(
// //                             //         Duration(
// //                             //           hours: 24 - DateTime.now().hour,
// //                             //           minutes: 60 - DateTime.now().minute,
// //                             //           seconds: 60 - DateTime.now().second,
// //                             //         ),
// //                             //       ),
// //                             //       tableCalenderIcon: const Icon(
// //                             //         Icons.calendar_today,
// //                             //         color: Colors.white,
// //                             //       ),
// //                             //       textColor: Colors.black45,
// //                             //       backgroundColor: kFaintBlue,
// //                             //       tableCalenderThemeData:
// //                             //           ThemeData.light().copyWith(
// //                             //         primaryColor: darkBlue,
// //                             //         buttonTheme: const ButtonThemeData(
// //                             //           textTheme: ButtonTextTheme.primary,
// //                             //         ),
// //                             //         colorScheme: const ColorScheme.light(
// //                             //           primary: darkBlue,
// //                             //         ).copyWith(secondary: darkBlue),
// //                             //       ),
// //                             //       selectedColor: darkBlue,
// //                             //       onDateSelected: (date) {
// //                             //         print(date);
// //                             //         handleDateSelect(context, date as String);
// //                             //       }),
// //                             // ),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 10,
// //                               ),
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Container(
// //                                     margin: const EdgeInsets.only(
// //                                         left: 12, top: 12, bottom: 16),
// //                                     child: const Text(
// //                                       'Available Slots',
// //                                       textAlign: TextAlign.start,
// //                                       style: TextStyle(
// //                                         color: darkBlue,
// //                                         fontSize: 18,
// //                                         fontFamily: 'OpenSans',
// //                                         fontWeight: FontWeight.bold,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   stepCount >= 4
// //                                       ? slotsForTheSelectedDay!.length > 0
// //                                           ? Container(
// //                                               child: Column(
// //                                                 children: [
// //                                                   Container(
// //                                                     child: GridView.builder(
// //                                                       shrinkWrap: true,
// //                                                       physics: ScrollPhysics(),
// //                                                       gridDelegate:
// //                                                           SliverGridDelegateWithFixedCrossAxisCount(
// //                                                         crossAxisCount: 2,
// //                                                         crossAxisSpacing: 3,
// //                                                         mainAxisSpacing: 3,
// //                                                         childAspectRatio: MediaQuery
// //                                                                     .of(context)
// //                                                                 .size
// //                                                                 .width /
// //                                                             (MediaQuery.of(
// //                                                                         context)
// //                                                                     .size
// //                                                                     .height /
// //                                                                 6),
// //                                                       ),
// //                                                       scrollDirection:
// //                                                           Axis.vertical,
// //                                                       itemBuilder:
// //                                                           (BuildContext context,
// //                                                               index) {
// //                                                         final currentSlot =
// //                                                             slotsForTheSelectedDay![
// //                                                                 index];

// //                                                         return GestureDetector(
// //                                                           onTap: () {
// //                                                             setState(() {
// //                                                               stepCount = 7;
// //                                                               amount = selectedSlot
// //                                                                   .appoinmentFee;
// //                                                               showPaymentMethods =
// //                                                                   true;
// //                                                               selectedSlot =
// //                                                                   BookingSlot(
// //                                                                 slotId:
// //                                                                     currentSlot[
// //                                                                         "slotId"],
// //                                                                 appoinmentConfigId:
// //                                                                     currentSlot[
// //                                                                         "appoinmentConfigId"],
// //                                                                 day:
// //                                                                     currentSlot[
// //                                                                         "day"],
// //                                                                 fromTime:
// //                                                                     currentSlot[
// //                                                                         "fromTime"],
// //                                                                 toTime:
// //                                                                     currentSlot[
// //                                                                         "toTime"],
// //                                                                 appoinmentFee:
// //                                                                     currentSlot[
// //                                                                         "appoinmentFee"],
// //                                                               );
// //                                                             });
// //                                                           },
// //                                                           child: Card(
// //                                                             color: selectedSlot
// //                                                                         .slotId ==
// //                                                                     currentSlot[
// //                                                                         "slotId"]
// //                                                                 ? const Color(
// //                                                                     0xff325CA2)
// //                                                                 : Colors.white,
// //                                                             child: Container(
// //                                                               height: 200,
// //                                                               width: 200,
// //                                                               child: Center(
// //                                                                 child: Text(
// //                                                                   "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
// //                                                                   style:
// //                                                                       TextStyle(
// //                                                                     color: selectedSlot.slotId ==
// //                                                                             currentSlot[
// //                                                                                 "slotId"]
// //                                                                         ? Colors
// //                                                                             .white
// //                                                                         : Colors
// //                                                                             .black,
// //                                                                     fontSize:
// //                                                                         14,
// //                                                                     fontFamily:
// //                                                                         'OpenSans',
// //                                                                     fontWeight:
// //                                                                         FontWeight
// //                                                                             .w500,
// //                                                                   ),
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                         );
// //                                                       },
// //                                                       itemCount:
// //                                                           slotsForTheSelectedDay ==
// //                                                                   null
// //                                                               ? 0
// //                                                               : slotsForTheSelectedDay!
// //                                                                   .length,
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             )
// //                                           : (Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment.start,
// //                                               children: const [
// //                                                 Padding(
// //                                                   padding: EdgeInsets.symmetric(
// //                                                     vertical: 6,
// //                                                     horizontal: 10,
// //                                                   ),
// //                                                   child: Text(
// //                                                     "No slots available for this date",
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ))
// //                                       : (Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.start,
// //                                           children: const [
// //                                             Padding(
// //                                               padding: EdgeInsets.symmetric(
// //                                                 vertical: 6,
// //                                                 horizontal: 10,
// //                                               ),
// //                                               child: Text(
// //                                                 "Please select a date",
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         )),
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(
// //                               height: 20,
// //                             ),
// //                             stepCount >= 6
// //                                 ? Column(
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     children: [
// //                                       AppointmentSectionHeading(
// //                                         title: "Payment Method",
// //                                       ),
// //                                       AppointmentFees(
// //                                         fees: selectedSlot.appoinmentFee!,
// //                                       ),
// //                                       Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.center,
// //                                         children: [
// //                                           const Spacer(
// //                                             flex: 1,
// //                                           ),
// //                                           Expanded(
// //                                             flex: 4,
// //                                             child: Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment
// //                                                       .spaceBetween,
// //                                               children: [
// //                                                 Column(
// //                                                   children: [
// //                                                     Radio(
// //                                                       value: PaymentMethod.cod,
// //                                                       groupValue:
// //                                                           selectedPaymentMethod,
// //                                                       onChanged: ((value) {
// //                                                         setState(() {
// //                                                           selectedPaymentMethod =
// //                                                               value
// //                                                                   as PaymentMethod;
// //                                                           // print(isDiabetic);
// //                                                         });
// //                                                       }),
// //                                                     ),
// //                                                     const Text(
// //                                                       "COD",
// //                                                       textAlign:
// //                                                           TextAlign.center,
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                                 Column(
// //                                                   children: [
// //                                                     Radio(
// //                                                       value:
// //                                                           PaymentMethod.advance,
// //                                                       groupValue:
// //                                                           selectedPaymentMethod,
// //                                                       onChanged: ((value) {
// //                                                         setState(() {
// //                                                           selectedPaymentMethod =
// //                                                               value
// //                                                                   as PaymentMethod;
// //                                                           // print(isDiabetic);
// //                                                         });
// //                                                       }),
// //                                                     ),
// //                                                     const Text(
// //                                                       "ADVANCE",
// //                                                       textAlign:
// //                                                           TextAlign.center,
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           const Spacer(
// //                                             flex: 1,
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   )
// //                                 : const SizedBox(
// //                                     height: 0,
// //                                   ),
// //                             const SizedBox(
// //                               height: 20,
// //                             ),
// //                             stepCount == 7
// //                                 ? Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     children: [
// //                                       BlueButton(
// //                                         onPressed: () async {
// //                                           SharedPreferences sharedPreferences =
// //                                               await SharedPreferences
// //                                                   .getInstance();
// //                                           bool isPay = await sharedPreferences
// //                                                   .getBool("isPay") ??
// //                                               false;
// //                                           if (isPay) {
// //                                             saveAppointment(context,
// //                                                 selectedSlot.appoinmentFee);
// //                                           } else {
// //                                             // Navigator.pushNamedAndRemoveUntil(
// //                                             //     context,
// //                                             //     homeFirst,
// //                                             //     (route) => false);
// //                                             saveAppointment(context,
// //                                                 selectedSlot.appoinmentFee);
// //                                           }
// //                                         },
// //                                         title: 'Book Appointment',
// //                                         height: 45,
// //                                         width: 200,
// //                                       ),
// //                                     ],
// //                                   )
// //                                 : const SizedBox(
// //                                     height: 0,
// //                                   ),
// //                             const SizedBox(
// //                               height: 32,
// //                             ),
// //                             // const Divider(
// //                             //   height: 2,
// //                             //   color: Colors.grey,
// //                             // ),
// //                             // const SizedBox(
// //                             //   height: 32,
// //                             // ),
// //                             // SizedBox(
// //                             //   width: double.infinity,
// //                             //   child: Padding(
// //                             //     padding: const EdgeInsets.all(12.0),
// //                             //     child: ElevatedButton(
// //                             //       child: Text("View My Appointments"),
// //                             //       onPressed: () {},
// //                             //     ),
// //                             //   ),
// //                             // ),
// //                             const SizedBox(
// //                               height: 32,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ]),
// //                   )
// //                 : Container(
// //                     height: MediaQuery.of(context).size.height * 0.86,
// //                     child: Center(
// //                       child: Wrap(
// //                         crossAxisAlignment: WrapCrossAlignment.center,
// //                         direction: Axis.vertical,
// //                         children: const [
// //                           CircularProgressIndicator(
// //                             color: darkBlue,
// //                           ),
// //                           SizedBox(
// //                             height: 24,
// //                           ),
// //                           Text("Saving your appointment, Please wait")
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AppointmentSectionHeading extends StatelessWidget {
// //   final String title;
// //   const AppointmentSectionHeading({Key? key, required this.title})
// //       : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 10,
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             margin: const EdgeInsets.only(
// //               left: 12,
// //               top: 12,
// //               bottom: 10,
// //             ),
// //             child: Text(
// //               title,
// //               textAlign: TextAlign.start,
// //               style: const TextStyle(
// //                 color: darkBlue,
// //                 fontSize: 18,
// //                 fontFamily: 'OpenSans',
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class AppointmentFees extends StatelessWidget {
// //   final double fees;
// //   const AppointmentFees({Key? key, required this.fees}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Container(
// //           margin: const EdgeInsets.symmetric(
// //             horizontal: 20,
// //           ),
// //           child: OutlinedButton(
// //             onPressed: () {},
// //             child: Text(
// //               'Fees : ${fees.toString()} ₹',
// //               style: const TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w500,
// //                 color: darkBlue,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// //    <<<<<<<<<<<<<<<<<<< BELOW CODE IS BEFORE IMPLEMENTING NEW PACKAGE FOR HORIOZONTAL CALENDER >>>>>>>>>>>>>>>>>>>>>>>>

// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
// // import 'package:Rakshan/utills/progressIndicator.dart';
// // //import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:Rakshan/constants/padding.dart';
// // import 'package:Rakshan/controller/appointment_controller.dart';
// // import 'package:Rakshan/routes/app_routes.dart';
// // import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
// // import 'package:Rakshan/screens/post_login/home_screen.dart';
// // import 'package:Rakshan/screens/post_login/payment.dart';
// // import 'package:Rakshan/widgets/post_login/app_bar.dart';
// // import 'package:Rakshan/widgets/post_login/app_menu.dart';
// // import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../utills/horizontalCalender.dart';
// // import '/config/api_url_mapping.dart' as API;
// // import 'package:http/http.dart' as http;
// // import '../../constants/theme.dart';

// // enum PaymentMethod { cod, advance }

// // class BookingDetails {
// //   String? date;
// //   String? fromTime;
// //   String? toTime;
// //   int? appoinmentConfigId;
// //   int? doctorId;
// //   int? clientId;
// //   String? dat;

// //   BookingDetails({
// //     this.date,
// //     this.fromTime,
// //     this.toTime,
// //     this.appoinmentConfigId,
// //     this.doctorId,
// //     this.clientId,
// //     this.dat,
// //   });
// // }

// // class BookingSlot {
// //   int? slotId;
// //   String? day;
// //   String? fromTime;
// //   String? toTime;
// //   int? appoinmentConfigId;
// //   double? appoinmentFee;

// //   BookingSlot({
// //     this.slotId,
// //     this.day,
// //     this.fromTime,
// //     this.toTime,
// //     this.appoinmentConfigId,
// //     this.appoinmentFee,
// //   });
// // }

// // class Appointment extends StatefulWidget {
// //   const Appointment(
// //       {Key? key,
// //       required this.sProviderTypeId,
// //       required this.sProviderType,
// //       required this.sService,
// //       required this.sClientName})
// //       : super(key: key);

// //   final String sProviderTypeId;
// //   final String sProviderType;
// //   final String sService;
// //   final String sClientName;

// //   @override
// //   State<Appointment> createState() => _AppointmentState();
// // }

// // class _AppointmentState extends State<Appointment> {
// //   final _appointmentController = AppointmentController();
// //   late ProcessIndicatorDialog _progressIndicator;
// //   int selectedCard = -1;
// //   dynamic amount = 0.0;
// //   var bookId;
// //   // ===============ROHIT's===================

// //   final engDays = [
// //     'Monday',
// //     'Tuesday',
// //     'Wednesday',
// //     'Thursday',
// //     'Friday',
// //     'Saturday',
// //     'Sunday',
// //   ];

// //   int stepCount = 0;
// //   // selected provider Type = 1
// //   // selected provider = 2
// //   // selected doctor = 3
// //   // selected date = 4
// //   // selected slot  = 5
// //   // selected paymentMethod  = 6
// //   // selected doingBooking  = 7

// //   List providerTypes = [];
// //   int? selectedProviderType;

// //   List serviceProviders = [];
// //   int? selectedProvider;

// //   List consultants = [];
// //   int? selectedConsultant;

// //   bool isLoading = true;

// // // booking
// //   bool showDates = false;
// //   bool showSlots = false;
// //   bool showPaymentMethods = false;
// //   bool isSavingAppointment = false;

// //   List allSlots = [];
// //   List? slotsForTheSelectedDay;

// //   String selectedDate = "";
// //   BookingSlot selectedSlot = BookingSlot();

// //   PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

// //   BookingDetails bookingTracker = BookingDetails();

// //   void fetchProviderTypes() async {
// //     final fetechedProviderTypes =
// //         await _appointmentController.getProviderTypes();

// //     setState(() {
// //       stepCount = 0;
// //       providerTypes = fetechedProviderTypes;

// //       // set other two as empty
// //       serviceProviders = [];
// //       consultants = [];
// //     });
// //   }

// //   void fetchServiceProviders(int ClientTypeId) async {
// //     final fetchedServiceProvider =
// //         await _appointmentController.getServiceProviders(ClientTypeId);

// //     setState(() {
// //       selectedProviderType = ClientTypeId;
// //       serviceProviders = fetchedServiceProvider;

// //       showDates = false;
// //       showSlots = false;
// //       showPaymentMethods = false;
// //       selectedDate = "";
// //       slotsForTheSelectedDay = null;

// //       consultants = [];
// //     });
// //   }

// //   void fetchConsultants(int clientId) async {
// //     final fetchedConsultants =
// //         await _appointmentController.getConsultants(clientId);

// //     setState(() {
// //       selectedProvider = clientId;
// //       consultants = fetchedConsultants;
// //       showDates = false;
// //     });
// //   }

// //   void handleDateSelect(BuildContext ctx, String date) {
// //     if (stepCount < 3) {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             "Please pick provider and doctor first",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.blue,
// //         ),
// //       );
// //       return;
// //     }

// //     final splittedStr = date.split("-");
// //     final chosenDate = DateTime(
// //       int.parse(splittedStr[0]),
// //       int.parse(splittedStr[1]),
// //       int.parse(splittedStr[2]),
// //     );

// //     final weekday = DateFormat("EEEE").format(chosenDate);
// //     setState(() {
// //       stepCount = 4;
// //       selectedDate = date;
// //       slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
// //       selectedSlot = BookingSlot();
// //     });

// //     if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             "No slots available for this date",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.redAccent,
// //         ),
// //       );
// //     }
// //   }

// //   void handleSlotSelect(BookingSlot slot) {
// //     if (stepCount <= 4) {
// //       return;
// //     }
// //     setState(() {
// //       stepCount = 5;
// //     });
// //   }

// //   List findSlotsForTheSelectedDay(String day) {
// //     final coppyArray = new List<Map>.from(allSlots);
// //     coppyArray.removeWhere((slot) => slot['day'] != day);
// //     int index = 0;
// //     final slotsWithId = coppyArray.map((slot) {
// //       final myMap = Map();
// //       myMap["slotId"] = index;
// //       myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
// //       myMap["day"] = slot["day"];
// //       myMap["fromTime"] = slot["fromTime"];
// //       myMap["toTime"] = slot["toTime"];
// //       myMap["appoinmentFee"] = slot["appoinmentFee"];
// //       index++;
// //       return myMap;
// //     }).toList();
// //     return slotsWithId;
// //   }

// //   Future<bool> saveAppointments(
// //     BookingSlot bookingDetails,
// //     int clientId,
// //     int consultantId,
// //     String selectedDate,
// //   ) async {
// //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// //     final userToken = sharedPreferences.getString('data');
// //     final userId = sharedPreferences.get("userId");
// //     _progressIndicator.show();
// //     var response = await http.post(
// //         Uri.parse(
// //           API.buildUrl(
// //             API.kBookAppointment,
// //           ),
// //         ),
// //         headers: {
// //           HttpHeaders.authorizationHeader: 'Bearer $userToken',
// //           HttpHeaders.contentTypeHeader: "application/json"
// //         },
// //         body: jsonEncode({
// //           "ClientId": clientId,
// //           "ServiceId": 4,
// //           "DoctorId": consultantId,
// //           "UserId": int.tryParse(userId as String),
// //           "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
// //           "Day": bookingDetails.day,
// //           "FromTime": bookingDetails.fromTime,
// //           "ToTime": bookingDetails.toTime,
// //           "AppoinmentDate": selectedDate
// //         }));
// //     _progressIndicator.hide();
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       if (data["isSuccess"]) {
// //         var bookId = data['id'];
// //         return true;
// //       } else {
// //         return false;
// //       }
// //     }
// //     return false;
// //   }

// //   void saveAppointment(ctx, dynamic amounts) async {
// //     // setState(() {
// //     //   isSavingAppointment = true;
// //     // });

// //     final splittedStr = selectedDate.split("-");

// //     final selectedDateToSend =
// //         "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
// //     // show confirmation page
// //     bool savedAppointment = await saveAppointments(
// //       selectedSlot,
// //       selectedProvider!,
// //       selectedConsultant!,
// //       selectedDateToSend,
// //     );

// //     setState(() {
// //       isSavingAppointment = false;
// //     });

// //     if (savedAppointment) {
// //       if (selectedPaymentMethod == PaymentMethod.advance) {
// //         Navigator.of(context).push(
// //           MaterialPageRoute(
// //             builder: (ctx) {
// //               var bookId;
// //               return PaymentScreen(
// //                 amount: amounts,
// //                 id: bookId,
// //                 sName: "Appointment",
// //                 // coupontype: "",
// //               );
// //             },
// //           ),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(ctx).showSnackBar(
// //           const SnackBar(
// //             content: Text(
// //               "Appointment booked successfully",
// //               style: TextStyle(
// //                 color: Colors.white,
// //               ),
// //             ),
// //             duration: Duration(
// //               milliseconds: 2000,
// //             ),
// //             backgroundColor: Colors.blue,
// //           ),
// //         );
// //         Navigator.pop(context);
// //         Navigator.of(context).push(
// //           MaterialPageRoute(
// //             builder: (ctx) {
// //               return BookingConfirmation();
// //             },
// //           ),
// //         );
// //       }
// //     } else {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             "Appointment not booked successfully",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   void initState() {
// //     _progressIndicator = ProcessIndicatorDialog(context);
// //     super.initState();
// //     fetchProviderTypes();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       //
// //       appBar: AppBar(
// //         elevation: 0,
// //         leading: IconButton(
// //           onPressed: () {
// //             Navigator.pop(context, true);
// //           }, // Handle your on tap here.
// //           icon: const Icon(
// //             Icons.arrow_back_ios,
// //             color: Colors.black,
// //           ),
// //         ),
// //         backgroundColor: Color(0xfffcfcfc),
// //         title: const Text(
// //           'Appointment',
// //           style: TextStyle(
// //             fontFamily: 'OpenSans',
// //             color: Color(0xff2e66aa),
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         actions: <Widget>[
// //           Padding(
// //             padding: EdgeInsets.only(right: 20.0),
// //             child: IconButton(
// //               onPressed: () {
// //                 Navigator.pushNamed(context, appointmentHistoryScreen);
// //               },
// //               icon: Icon(Icons.history),
// //             ),
// //           ),
// //         ],
// //         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Stack(
// //           children: [
// //             !isSavingAppointment
// //                 ? Container(
// //                     child: Column(children: [
// //                       // SERVICE PROVIDER TYPES
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 10),
// //                         child: Container(
// //                           padding: const EdgeInsets.only(left: 16, right: 16),
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xfff1f7ff),
// //                             border: Border.all(color: Colors.white, width: 1),
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: DropdownButton(
// //                             value: selectedProviderType,
// //                             onChanged: (ClientTypeId) {
// //                               setState(() {
// //                                 // serviceProviders =[];
// //                                 stepCount = 1;
// //                                 allSlots = [];
// //                                 selectedProviderType = ClientTypeId as int;
// //                               });
// //                               fetchServiceProviders(ClientTypeId as int);
// //                             },
// //                             items: providerTypes.map((providerType) {
// //                               return DropdownMenuItem(
// //                                 value: providerType["clientTypeId"],
// //                                 child: Text(
// //                                   providerType["clientTypeName"],
// //                                   style: kApiTextstyle,
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             hint: const Text(
// //                               'Select Provider Type',
// //                               style: kSubheadingTextstyle,
// //                             ),
// //                             dropdownColor: Colors.white,
// //                             icon: Icon(Icons.arrow_drop_down),
// //                             iconSize: 36,
// //                             isExpanded: true,
// //                             underline: SizedBox(),
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       // SERVICE PROVIDERS
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 10),
// //                         child: Container(
// //                           padding: const EdgeInsets.only(left: 16, right: 16),
// //                           decoration: BoxDecoration(
// //                             color: kFaintBlue,
// //                             border: Border.all(color: Colors.white, width: 1),
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: DropdownButton(
// //                             value: selectedProvider,
// //                             onChanged: (clientId) {
// //                               setState(() {
// //                                 stepCount = 2;
// //                                 selectedProvider = clientId as int;
// //                                 allSlots = [];
// //                               });
// //                               fetchConsultants(clientId as int);
// //                             },
// //                             items: serviceProviders.map((serviceProvider) {
// //                               return DropdownMenuItem(
// //                                 value: serviceProvider["clientId"],
// //                                 child: Text(
// //                                   serviceProvider["clientName"],
// //                                   style: kApiTextstyle,
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             hint: const Text(
// //                               'Service Provider',
// //                               style: kApiTextstyle,
// //                             ),
// //                             dropdownColor: Colors.white,
// //                             icon: Icon(Icons.arrow_drop_down),
// //                             iconSize: 36,
// //                             isExpanded: true,
// //                             underline: SizedBox(),
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       // CONSULTANTS
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 10),
// //                         child: Container(
// //                           padding: const EdgeInsets.only(left: 16, right: 16),
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xfff1f7ff),
// //                             border: Border.all(color: Colors.white, width: 1),
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: DropdownButton(
// //                             value: selectedConsultant,
// //                             onChanged: (consultantId) async {
// //                               setState(() {
// //                                 stepCount = 3;
// //                                 selectedConsultant = consultantId as int;
// //                               });

// //                               final consultantSlots =
// //                                   await _appointmentController
// //                                       .getDoctorAppointmentDetails(
// //                                 selectedProvider as int,
// //                                 consultantId as int,
// //                               );

// //                               setState(() {
// //                                 allSlots = consultantSlots;
// //                               });
// //                             },
// //                             items: consultants.map((consultant) {
// //                               return DropdownMenuItem(
// //                                 value: consultant["consultantId"],
// //                                 child: Text(
// //                                   consultant["consultantName"],
// //                                   style: kApiTextstyle,
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             hint: const Text(
// //                               'Select Doctors',
// //                               style: kApiTextstyle,
// //                             ),
// //                             dropdownColor: Colors.white,
// //                             icon: const Icon(Icons.arrow_drop_down),
// //                             iconSize: 36,
// //                             isExpanded: true,
// //                             underline: const SizedBox(),
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 0,
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             const SizedBox(
// //                               height: 16,
// //                             ),
// //                             const Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: 20,
// //                                 ),
// //                                 child: Text(
// //                                   'Choose a date',
// //                                   style: TextStyle(
// //                                     color: darkBlue,
// //                                     fontSize: 18,
// //                                     fontFamily: 'OpenSans',
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 )),
// //                             const SizedBox(
// //                               height: 16,
// //                             ),
// //                             Container(
// //                               padding: kScreenPadding,
// //                               height: MediaQuery.of(context).size.height * 0.2,
// //                               child: AnimatedHorizontalCalendar(
// //                                   selectedBoxShadow:
// //                                       const BoxShadow(color: kFaintBlue),
// //                                   tableCalenderButtonColor: darkBlue,
// //                                   initialDate: DateTime.now().add(
// //                                     Duration(
// //                                       hours: 24 - DateTime.now().hour,
// //                                       minutes: 60 - DateTime.now().minute,
// //                                       seconds: 60 - DateTime.now().second,
// //                                     ),
// //                                   ),
// //                                   lastDate: DateTime.now().add(
// //                                     const Duration(
// //                                       days: 7,
// //                                     ),
// //                                   ),
// //                                   date: DateTime.now().add(
// //                                     Duration(
// //                                       hours: 24 - DateTime.now().hour,
// //                                       minutes: 60 - DateTime.now().minute,
// //                                       seconds: 60 - DateTime.now().second,
// //                                     ),
// //                                   ),
// //                                   tableCalenderIcon: const Icon(
// //                                     Icons.calendar_today,
// //                                     color: Colors.white,
// //                                   ),
// //                                   textColor: Colors.black45,
// //                                   backgroundColor: kFaintBlue,
// //                                   tableCalenderThemeData:
// //                                       ThemeData.light().copyWith(
// //                                     primaryColor: darkBlue,
// //                                     buttonTheme: const ButtonThemeData(
// //                                       textTheme: ButtonTextTheme.primary,
// //                                     ),
// //                                     colorScheme: const ColorScheme.light(
// //                                       primary: darkBlue,
// //                                     ).copyWith(secondary: darkBlue),
// //                                   ),
// //                                   selectedColor: darkBlue,
// //                                   onDateSelected: (date) {
// //                                     handleDateSelect(context, date as String);
// //                                   }),
// //                             ),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 10,
// //                               ),
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Container(
// //                                     margin: const EdgeInsets.only(
// //                                         left: 12, top: 12, bottom: 16),
// //                                     child: const Text(
// //                                       'Available Slots',
// //                                       textAlign: TextAlign.start,
// //                                       style: TextStyle(
// //                                         color: darkBlue,
// //                                         fontSize: 18,
// //                                         fontFamily: 'OpenSans',
// //                                         fontWeight: FontWeight.bold,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   stepCount >= 4
// //                                       ? slotsForTheSelectedDay!.length > 0
// //                                           ? Container(
// //                                               child: Column(
// //                                                 children: [
// //                                                   Container(
// //                                                     child: GridView.builder(
// //                                                       shrinkWrap: true,
// //                                                       physics: ScrollPhysics(),
// //                                                       gridDelegate:
// //                                                           SliverGridDelegateWithFixedCrossAxisCount(
// //                                                         crossAxisCount: 2,
// //                                                         crossAxisSpacing: 3,
// //                                                         mainAxisSpacing: 3,
// //                                                         childAspectRatio: MediaQuery
// //                                                                     .of(context)
// //                                                                 .size
// //                                                                 .width /
// //                                                             (MediaQuery.of(
// //                                                                         context)
// //                                                                     .size
// //                                                                     .height /
// //                                                                 6),
// //                                                       ),
// //                                                       scrollDirection:
// //                                                           Axis.vertical,
// //                                                       itemBuilder:
// //                                                           (BuildContext context,
// //                                                               index) {
// //                                                         final currentSlot =
// //                                                             slotsForTheSelectedDay![
// //                                                                 index];

// //                                                         return GestureDetector(
// //                                                           onTap: () {
// //                                                             setState(() {
// //                                                               stepCount = 7;
// //                                                               amount = selectedSlot
// //                                                                   .appoinmentFee;
// //                                                               showPaymentMethods =
// //                                                                   true;
// //                                                               selectedSlot =
// //                                                                   BookingSlot(
// //                                                                 slotId:
// //                                                                     currentSlot[
// //                                                                         "slotId"],
// //                                                                 appoinmentConfigId:
// //                                                                     currentSlot[
// //                                                                         "appoinmentConfigId"],
// //                                                                 day:
// //                                                                     currentSlot[
// //                                                                         "day"],
// //                                                                 fromTime:
// //                                                                     currentSlot[
// //                                                                         "fromTime"],
// //                                                                 toTime:
// //                                                                     currentSlot[
// //                                                                         "toTime"],
// //                                                                 appoinmentFee:
// //                                                                     currentSlot[
// //                                                                         "appoinmentFee"],
// //                                                               );
// //                                                             });
// //                                                           },
// //                                                           child: Card(
// //                                                             color: selectedSlot
// //                                                                         .slotId ==
// //                                                                     currentSlot[
// //                                                                         "slotId"]
// //                                                                 ? const Color(
// //                                                                     0xff325CA2)
// //                                                                 : Colors.white,
// //                                                             child: Container(
// //                                                               height: 200,
// //                                                               width: 200,
// //                                                               child: Center(
// //                                                                 child: Text(
// //                                                                   "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
// //                                                                   style:
// //                                                                       TextStyle(
// //                                                                     color: selectedSlot.slotId ==
// //                                                                             currentSlot[
// //                                                                                 "slotId"]
// //                                                                         ? Colors
// //                                                                             .white
// //                                                                         : Colors
// //                                                                             .black,
// //                                                                     fontSize:
// //                                                                         14,
// //                                                                     fontFamily:
// //                                                                         'OpenSans',
// //                                                                     fontWeight:
// //                                                                         FontWeight
// //                                                                             .w500,
// //                                                                   ),
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                         );
// //                                                       },
// //                                                       itemCount:
// //                                                           slotsForTheSelectedDay ==
// //                                                                   null
// //                                                               ? 0
// //                                                               : slotsForTheSelectedDay!
// //                                                                   .length,
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             )
// //                                           : (Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment.start,
// //                                               children: const [
// //                                                 Padding(
// //                                                   padding: EdgeInsets.symmetric(
// //                                                     vertical: 6,
// //                                                     horizontal: 10,
// //                                                   ),
// //                                                   child: Text(
// //                                                     "No slots available for this date",
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ))
// //                                       : (Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.start,
// //                                           children: const [
// //                                             Padding(
// //                                               padding: EdgeInsets.symmetric(
// //                                                 vertical: 6,
// //                                                 horizontal: 10,
// //                                               ),
// //                                               child: Text(
// //                                                 "Please select a date",
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         )),
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(
// //                               height: 20,
// //                             ),
// //                             stepCount >= 6
// //                                 ? Column(
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     children: [
// //                                       AppointmentSectionHeading(
// //                                         title: "Payment Method",
// //                                       ),
// //                                       AppointmentFees(
// //                                         fees: selectedSlot.appoinmentFee!,
// //                                       ),
// //                                       Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.center,
// //                                         children: [
// //                                           const Spacer(
// //                                             flex: 1,
// //                                           ),
// //                                           Expanded(
// //                                             flex: 4,
// //                                             child: Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment
// //                                                       .spaceBetween,
// //                                               children: [
// //                                                 Column(
// //                                                   children: [
// //                                                     Radio(
// //                                                       value: PaymentMethod.cod,
// //                                                       groupValue:
// //                                                           selectedPaymentMethod,
// //                                                       onChanged: ((value) {
// //                                                         setState(() {
// //                                                           selectedPaymentMethod =
// //                                                               value
// //                                                                   as PaymentMethod;
// //                                                           // print(isDiabetic);
// //                                                         });
// //                                                       }),
// //                                                     ),
// //                                                     const Text(
// //                                                       "COD",
// //                                                       textAlign:
// //                                                           TextAlign.center,
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                                 Column(
// //                                                   children: [
// //                                                     Radio(
// //                                                       value:
// //                                                           PaymentMethod.advance,
// //                                                       groupValue:
// //                                                           selectedPaymentMethod,
// //                                                       onChanged: ((value) {
// //                                                         setState(() {
// //                                                           selectedPaymentMethod =
// //                                                               value
// //                                                                   as PaymentMethod;
// //                                                           // print(isDiabetic);
// //                                                         });
// //                                                       }),
// //                                                     ),
// //                                                     const Text(
// //                                                       "ADVANCE",
// //                                                       textAlign:
// //                                                           TextAlign.center,
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           const Spacer(
// //                                             flex: 1,
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   )
// //                                 : const SizedBox(
// //                                     height: 0,
// //                                   ),
// //                             const SizedBox(
// //                               height: 20,
// //                             ),
// //                             stepCount == 7
// //                                 ? Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     children: [
// //                                       BlueButton(
// //                                         onPressed: () async {
// //                                           SharedPreferences sharedPreferences =
// //                                               await SharedPreferences
// //                                                   .getInstance();
// //                                           bool isPay = await sharedPreferences
// //                                                   .getBool("isPay") ??
// //                                               false;
// //                                           if (isPay) {
// //                                             saveAppointment(context,
// //                                                 selectedSlot.appoinmentFee);
// //                                           } else {
// //                                             // Navigator.pushNamedAndRemoveUntil(
// //                                             //     context,
// //                                             //     homeFirst,
// //                                             //     (route) => false);
// //                                             saveAppointment(context,
// //                                                 selectedSlot.appoinmentFee);
// //                                           }
// //                                         },
// //                                         title: 'Book Appointment',
// //                                         height: 45,
// //                                         width: 200,
// //                                       ),
// //                                     ],
// //                                   )
// //                                 : const SizedBox(
// //                                     height: 0,
// //                                   ),
// //                             const SizedBox(
// //                               height: 32,
// //                             ),
// //                             // const Divider(
// //                             //   height: 2,
// //                             //   color: Colors.grey,
// //                             // ),
// //                             // const SizedBox(
// //                             //   height: 32,
// //                             // ),
// //                             // SizedBox(
// //                             //   width: double.infinity,
// //                             //   child: Padding(
// //                             //     padding: const EdgeInsets.all(12.0),
// //                             //     child: ElevatedButton(
// //                             //       child: Text("View My Appointments"),
// //                             //       onPressed: () {},
// //                             //     ),
// //                             //   ),
// //                             // ),
// //                             const SizedBox(
// //                               height: 32,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ]),
// //                   )
// //                 : Container(
// //                     height: MediaQuery.of(context).size.height * 0.86,
// //                     child: Center(
// //                       child: Wrap(
// //                         crossAxisAlignment: WrapCrossAlignment.center,
// //                         direction: Axis.vertical,
// //                         children: const [
// //                           CircularProgressIndicator(
// //                             color: darkBlue,
// //                           ),
// //                           SizedBox(
// //                             height: 24,
// //                           ),
// //                           Text("Saving your appointment, Please wait")
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AppointmentSectionHeading extends StatelessWidget {
// //   final String title;
// //   const AppointmentSectionHeading({Key? key, required this.title})
// //       : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 10,
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             margin: const EdgeInsets.only(
// //               left: 12,
// //               top: 12,
// //               bottom: 10,
// //             ),
// //             child: Text(
// //               title,
// //               textAlign: TextAlign.start,
// //               style: const TextStyle(
// //                 color: darkBlue,
// //                 fontSize: 18,
// //                 fontFamily: 'OpenSans',
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class AppointmentFees extends StatelessWidget {
// //   final double fees;
// //   const AppointmentFees({Key? key, required this.fees}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Container(
// //           margin: const EdgeInsets.symmetric(
// //             horizontal: 20,
// //           ),
// //           child: OutlinedButton(
// //             onPressed: () {},
// //             child: Text(
// //               'Fees : ${fees.toString()} ₹',
// //               style: const TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w500,
// //                 color: darkBlue,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

//============================ALL CODE BEFORE ADDING INSTANT DISCOUNT=======================================

// import 'dart:convert';
// import 'dart:io';

// import 'package:Rakshan/constants/textfield.dart';
// import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
// import 'package:Rakshan/utills/progressIndicator.dart';
// //import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:Rakshan/constants/padding.dart';
// import 'package:Rakshan/controller/appointment_controller.dart';
// import 'package:Rakshan/routes/app_routes.dart';
// import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
// import 'package:Rakshan/screens/post_login/home_screen.dart';
// import 'package:Rakshan/screens/post_login/payment.dart';
// import 'package:Rakshan/widgets/post_login/app_bar.dart';
// import 'package:Rakshan/widgets/post_login/app_menu.dart';
// import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../utills/horizontalCalender.dart';
// import '/config/api_url_mapping.dart' as API;
// import 'package:http/http.dart' as http;
// import '../../constants/theme.dart';
// import 'package:date_picker_timeline/date_picker_timeline.dart';

// enum PaymentMethod { cod, advance }

// class BookingDetails {
//   String? date;
//   String? fromTime;
//   String? toTime;
//   int? appoinmentConfigId;
//   int? doctorId;
//   int? clientId;
//   String? dat;

//   BookingDetails({
//     this.date,
//     this.fromTime,
//     this.toTime,
//     this.appoinmentConfigId,
//     this.doctorId,
//     this.clientId,
//     this.dat,
//   });
// }

// class BookingSlot {
//   int? slotId;
//   String? day;
//   String? fromTime;
//   String? toTime;
//   int? appoinmentConfigId;
//   double? appoinmentFee;

//   BookingSlot({
//     this.slotId,
//     this.day,
//     this.fromTime,
//     this.toTime,
//     this.appoinmentConfigId,
//     this.appoinmentFee,
//   });
// }

// class Appointment extends StatefulWidget {
//   const Appointment(
//       {Key? key,
//       required this.sProviderTypeId,
//       required this.sClientId,
//       required this.sClientTypeName,
//       required this.sClientName,
//       required this.sServiceNameId})
//       : super(key: key);
//   final int sServiceNameId;
//   final int sProviderTypeId; //in 1st dropdownn
//   final int sClientId; //2nd dropdown
//   final String sClientTypeName; // in 1st drop hint
//   final String sClientName; // in 2nd drop hint

//   @override
//   State<Appointment> createState() => _AppointmentState();
// }

// class _AppointmentState extends State<Appointment> {
//   // DateTime _selectedDate = DateTime.now();
//   final _appointmentController = AppointmentController();
//   late ProcessIndicatorDialog _progressIndicator;
//   int selectedCard = -1;
//   dynamic amount = 0.0;

//   final clientTypeName = TextEditingController();
//   final clientName = TextEditingController();
//   // ===============ROHIT's===================

//   final engDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday',
//   ];

//   int stepCount = 0;
//   // selected provider Type = 1
//   // selected provider = 2
//   // selected doctor = 3
//   // selected date = 4
//   // selected slot  = 5
//   // selected paymentMethod  = 6
//   // selected doingBooking  = 7

//   List providerTypes = [];
//   int? selectedProviderType;

//   List serviceProviders = [];
//   int? selectedProvider;

//   List consultants = [];
//   int? selectedConsultant;

//   bool isLoading = true;
//   bool _isloading = false;

// // booking
//   bool showDates = false;
//   bool showSlots = false;
//   bool showPaymentMethods = false;
//   bool isSavingAppointment = false;

//   var flag;

//   List allSlots = [];
//   List? slotsForTheSelectedDay;

//   String selectedDate = "";
//   BookingSlot selectedSlot = BookingSlot();

//   PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

//   BookingDetails bookingTracker = BookingDetails();
//   late String sToday;

//   void fetchProviderTypes() async {
//     final fetechedProviderTypes =
//         await _appointmentController.getProviderTypes();

//     setState(() {
//       stepCount = 0;
//       providerTypes = fetechedProviderTypes;

//       // set other two as empty
//       serviceProviders = [];
//       if (widget.sClientId == null) {
//         consultants = [];
//       }
//     });
//   }

//   void fetchServiceProviders(int ClientTypeId) async {
//     final fetchedServiceProvider =
//         await _appointmentController.getServiceProviders(ClientTypeId);

//     setState(() {
//       selectedProviderType = ClientTypeId;
//       serviceProviders = fetchedServiceProvider;

//       showDates = false;
//       showSlots = false;
//       showPaymentMethods = false;
//       selectedDate = "";
//       slotsForTheSelectedDay = null;

//       if (widget.sClientId == null) {
//         consultants = [];
//       }
//     });
//   }

//   void fetchConsultants(int clientId) async {
//     final fetchedConsultants =
//         await _appointmentController.getConsultants(clientId);

//     setState(() {
//       if (widget.sClientId != 0) {
//         selectedProvider = widget.sClientId;
//       } else {
//         selectedProvider = clientId;
//       }

//       consultants = fetchedConsultants;
//       showDates = false;
//     });
//   }

//   void handleDateSelect(BuildContext ctx, String date) {
//     if (widget.sProviderTypeId != 0) {
//       if (selectedConsultant == null) {
//         ScaffoldMessenger.of(ctx).showSnackBar(
//           const SnackBar(
//             content: Text(
//               "Please Select a doctor first",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             duration: Duration(
//               milliseconds: 2000,
//             ),
//             backgroundColor: Colors.blue,
//           ),
//         );
//         return;
//       }
//     } else {
//       if (stepCount < 3) {
//         ScaffoldMessenger.of(ctx).showSnackBar(
//           const SnackBar(
//             content: Text(
//               "Please pick provider and doctor first",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             duration: Duration(
//               milliseconds: 2000,
//             ),
//             backgroundColor: Colors.blue,
//           ),
//         );
//         return;
//       }
//     }
//     if (widget.sProviderTypeId != 0) {
//     } else {
//       if (stepCount < 3) {
//         ScaffoldMessenger.of(ctx).showSnackBar(
//           const SnackBar(
//             content: Text(
//               "Please pick provider and doctor first",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             duration: Duration(
//               milliseconds: 2000,
//             ),
//             backgroundColor: Colors.blue,
//           ),
//         );
//         return;
//       }
//     }

//     final splittedStr = date.split("-");
//     final chosenDate = DateTime(
//       int.parse(splittedStr[0]),
//       int.parse(splittedStr[1]),
//       int.parse(splittedStr[2]),
//     );

//     final weekday = DateFormat("EEEE").format(chosenDate);
//     setState(() {
//       stepCount = 4;
//       selectedDate = date;
//       slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
//       selectedSlot = BookingSlot();
//     });

//     if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'No slots available for this date.',
//             // "No slots available for this date",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           duration: Duration(
//             milliseconds: 2000,
//           ),
//           backgroundColor: darkBlue,
//         ),
//       );
//     }
//   }

//   void handleSlotSelect(BookingSlot slot) {
//     if (stepCount <= 4) {
//       return;
//     }
//     setState(() {
//       stepCount = 5;
//     });
//   }

//   List findSlotsForTheSelectedDay(String day) {
//     final coppyArray = new List<Map>.from(allSlots);
//     coppyArray.removeWhere((slot) => slot['day'] != day);
//     int index = 0;
//     final slotsWithId = coppyArray.map((slot) {
//       final myMap = Map();
//       myMap["slotId"] = index;
//       myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
//       myMap["day"] = slot["day"];
//       myMap["fromTime"] = slot["fromTime"];
//       myMap["toTime"] = slot["toTime"];
//       myMap["appoinmentFee"] = slot["appoinmentFee"];
//       index++;
//       return myMap;
//     }).toList();
//     return slotsWithId;
//   }

//   Future<bool> saveAppointments(
//     BookingSlot bookingDetails,
//     int clientId,
//     int consultantId,
//     String selectedDate,
//   ) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     final userToken = sharedPreferences.getString('data');
//     final userId = sharedPreferences.get("userId");
//     _progressIndicator.show();
//     var response = await http.post(
//         Uri.parse(
//           API.buildUrl(
//             API.kBookAppointment,
//           ),
//         ),
//         headers: {
//           HttpHeaders.authorizationHeader: 'Bearer $userToken',
//           HttpHeaders.contentTypeHeader: "application/json"
//         },
//         body: jsonEncode({
//           "ClientId": clientId,
//           "ServiceId": 4, //service id isnt sent dynamically.
//           "DoctorId": consultantId,
//           "UserId": int.tryParse(userId as String),
//           "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
//           "Day": bookingDetails.day,
//           "FromTime": bookingDetails.fromTime,
//           "ToTime": bookingDetails.toTime,
//           "AppoinmentDate": selectedDate
//         }));

//     _progressIndicator.hide();
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print(data);
//       print(widget.sServiceNameId);
//       print(consultantId);
//       print(userId);
//       print(bookingDetails);
//       print(selectedDate);

//       if (data["isSuccess"]) {
//         int bookId = data['id'];
//         flag = bookId;
//         print(bookId);
//         return true;
//       } else {
//         return false;
//       }
//     }
//     return false;
//   }

//   void saveAppointment(ctx, dynamic amounts) async {
//     final splittedStr = selectedDate.split("-");

//     final selectedDateToSend =
//         "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
//     // show confirmation page
//     bool savedAppointment = await saveAppointments(
//       selectedSlot,
//       selectedProvider!,
//       selectedConsultant!,
//       selectedDateToSend,
//     );

//     setState(() {
//       isSavingAppointment = false;
//     });

//     if (savedAppointment) {
//       if (selectedPaymentMethod == PaymentMethod.advance) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (ctx) {
//               return PaymentScreen(
//                 amount: amounts,
//                 id: flag,
//                 sName: "Appointment",
//                 // coupontype: "",
//               );
//             },
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(ctx).showSnackBar(
//           const SnackBar(
//             content: Text(
//               "Appointment booked successfully",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             duration: Duration(
//               milliseconds: 2000,
//             ),
//             backgroundColor: Colors.blue,
//           ),
//         );
//         Navigator.pop(context);
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (ctx) {
//               return BookingConfirmation();
//             },
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text(
//             "Appointment booking failed",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           duration: Duration(
//             milliseconds: 2000,
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     _progressIndicator = ProcessIndicatorDialog(context);
//     super.initState();
//     clientTypeName.text = widget.sClientTypeName;
//     clientName.text = widget.sClientName;
//     fetchProviderTypes();
//     if (widget.sProviderTypeId != 0) {
//       fetchServiceProviders(widget.sClientId);
//       fetchConsultants(widget.sClientId);
//       // selectedProvider = widget.sClientId;
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context, true);
//           }, // Handle your on tap here.
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Color(0xfffcfcfc),
//         title: const Text(
//           'Appointment',
//           style: TextStyle(
//             fontFamily: 'OpenSans',
//             color: Color(0xff2e66aa),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(right: 20.0),
//             child: IconButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, appointmentHistoryScreen);
//               },
//               icon: Icon(Icons.history),
//             ),
//           ),
//         ],
//         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: _isloading,
//         child: SingleChildScrollView(
//           child: Stack(
//             children: [
//               !isSavingAppointment
//                   ? Container(
//                       child: Column(children: [
//                         widget.sProviderTypeId != 0
//                             ? Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: Colors.white, width: 1),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: TextFormField(
//                                         textInputAction: TextInputAction.next,
//                                         controller: clientTypeName,
//                                         readOnly: true,
//                                         decoration: InputDecoration(
//                                           filled: true,
//                                           fillColor: Color(0xfff1f7ff),
//                                           hintText: widget.sClientTypeName,
//                                           hintStyle: const TextStyle(
//                                             fontFamily: 'OpenSans',
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 10.0,
//                                                   horizontal: 20.0),
//                                           border: const OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(7.0)),
//                                           ),
//                                           enabledBorder:
//                                               const OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.white, width: 1),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(7.0)),
//                                           ),
//                                           focusedBorder:
//                                               const OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.white, width: 1),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(7.0)),
//                                           ),
//                                         ),
//                                         // validator: (value) {
//                                         //   if (value!.length == 10) {
//                                         //     return null;
//                                         //   } else {
//                                         //     return '';
//                                         //   }
//                                         // },
//                                       ),
//                                     ),
//                                   ),
//                                   // to atupopulate 1st dropddown
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     child: Container(
//                                       // padding:
//                                       //     const EdgeInsets.only(left: 16, right: 16),
//                                       decoration: BoxDecoration(
//                                         color: kFaintBlue,
//                                         border: Border.all(
//                                             color: Colors.white, width: 1),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: TextFormField(
//                                         textInputAction: TextInputAction.next,
//                                         controller: clientName,
//                                         readOnly: true,
//                                         decoration: InputDecoration(
//                                           filled: true,
//                                           fillColor: Color(0xfff1f7ff),
//                                           hintText: widget.sClientTypeName,
//                                           hintStyle: const TextStyle(
//                                             fontFamily: 'OpenSans',
//                                           ),
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 10.0,
//                                                   horizontal: 20.0),
//                                           border: const OutlineInputBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(7.0)),
//                                           ),
//                                           enabledBorder:
//                                               const OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.white, width: 1),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(7.0)),
//                                           ),
//                                           focusedBorder:
//                                               const OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.white, width: 1),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(7.0)),
//                                           ),
//                                         ),
//                                         // validator: (value) {
//                                         //   if (value!.length == 10) {
//                                         //     return null;
//                                         //   } else {
//                                         //     return 'Phone no should be 10 digit';
//                                         //   }
//                                         // },
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     child: Container(
//                                       padding: const EdgeInsets.only(
//                                           left: 16, right: 16),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xfff1f7ff),
//                                         border: Border.all(
//                                             color: Colors.white, width: 1),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: DropdownButton(
//                                         value: selectedConsultant,
//                                         onChanged: (consultantId) async {
//                                           setState(() {
//                                             selectedConsultant =
//                                                 consultantId as int;
//                                             selectedProvider = widget.sClientId;
//                                           });

//                                           final consultantSlots =
//                                               await _appointmentController
//                                                   .getDoctorAppointmentDetails(
//                                             selectedProvider as int,
//                                             consultantId as int,
//                                           );

//                                           setState(() {
//                                             allSlots = consultantSlots;
//                                           });
//                                         },
//                                         items: consultants.map((consultant) {
//                                           return DropdownMenuItem(
//                                             value: consultant["consultantId"],
//                                             child: Text(
//                                               consultant["consultantName"],
//                                               style: kApiTextstyle,
//                                             ),
//                                           );
//                                         }).toList(),
//                                         hint: const Text(
//                                           'Select Doctors',
//                                           style: kApiTextstyle,
//                                         ),
//                                         dropdownColor: Colors.white,
//                                         icon: const Icon(Icons.arrow_drop_down),
//                                         iconSize: 36,
//                                         isExpanded: true,
//                                         underline: const SizedBox(),
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               )
//                             : Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     child: Container(
//                                       padding: const EdgeInsets.only(
//                                           left: 16, right: 16),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xfff1f7ff),
//                                         border: Border.all(
//                                             color: Colors.white, width: 1),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: DropdownButton(
//                                         value: selectedProviderType,
//                                         onChanged: (ClientTypeId) {
//                                           setState(() {
//                                             // serviceProviders =[];
//                                             stepCount = 1;
//                                             allSlots = [];
//                                             selectedProviderType =
//                                                 ClientTypeId as int;
//                                           });
//                                           fetchServiceProviders(
//                                               ClientTypeId as int);
//                                         },
//                                         items:
//                                             providerTypes.map((providerType) {
//                                           return DropdownMenuItem(
//                                             value: providerType["clientTypeId"],
//                                             child: Text(
//                                               providerType["clientTypeName"],
//                                               style: kApiTextstyle,
//                                             ),
//                                           );
//                                         }).toList(),
//                                         hint: const Text(
//                                           'Select Provider Type',
//                                           style: kSubheadingTextstyle,
//                                         ),
//                                         dropdownColor: Colors.white,
//                                         icon: Icon(Icons.arrow_drop_down),
//                                         iconSize: 36,
//                                         isExpanded: true,
//                                         underline: SizedBox(),
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   // SERVICE PROVIDERS
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     child: Container(
//                                       padding: const EdgeInsets.only(
//                                           left: 16, right: 16),
//                                       decoration: BoxDecoration(
//                                         color: kFaintBlue,
//                                         border: Border.all(
//                                             color: Colors.white, width: 1),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: DropdownButton(
//                                         value: selectedProvider,
//                                         onChanged: (clientId) {
//                                           setState(() {
//                                             stepCount = 2;
//                                             selectedProvider = clientId as int;
//                                             allSlots = [];
//                                           });
//                                           fetchConsultants(clientId as int);
//                                         },
//                                         items: serviceProviders
//                                             .map((serviceProvider) {
//                                           return DropdownMenuItem(
//                                             value: serviceProvider["clientId"],
//                                             child: Text(
//                                               serviceProvider["clientName"],
//                                               style: kApiTextstyle,
//                                             ),
//                                           );
//                                         }).toList(),
//                                         hint: const Text(
//                                           'Service Provider',
//                                           style: kApiTextstyle,
//                                         ),
//                                         dropdownColor: Colors.white,
//                                         icon: Icon(Icons.arrow_drop_down),
//                                         iconSize: 36,
//                                         isExpanded: true,
//                                         underline: SizedBox(),
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ),

//                                   // CONSULTANTS
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 10),
//                                     child: Container(
//                                       padding: const EdgeInsets.only(
//                                           left: 16, right: 16),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xfff1f7ff),
//                                         border: Border.all(
//                                             color: Colors.white, width: 1),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: DropdownButton(
//                                         value: selectedConsultant,
//                                         onChanged: (consultantId) async {
//                                           setState(() {
//                                             stepCount = 3;
//                                             if (widget.sClientId != 0) {
//                                               selectedProvider =
//                                                   widget.sClientId;
//                                             }
//                                             selectedConsultant =
//                                                 consultantId as int;
//                                           });
//                                           setState(() {
//                                             _isloading = true;
//                                           });
//                                           final consultantSlots =
//                                               await _appointmentController
//                                                   .getDoctorAppointmentDetails(
//                                             selectedProvider as int,
//                                             consultantId as int,
//                                           );

//                                           setState(() {
//                                             allSlots = consultantSlots;
//                                             _isloading = false;
//                                           });
//                                         },
//                                         items: consultants.map((consultant) {
//                                           return DropdownMenuItem(
//                                             value: consultant["consultantId"],
//                                             child: Text(
//                                               consultant["consultantName"],
//                                               style: kApiTextstyle,
//                                             ),
//                                           );
//                                         }).toList(),
//                                         hint: const Text(
//                                           'Select Doctors',
//                                           style: kApiTextstyle,
//                                         ),
//                                         dropdownColor: Colors.white,
//                                         icon: const Icon(Icons.arrow_drop_down),
//                                         iconSize: 36,
//                                         isExpanded: true,
//                                         underline: const SizedBox(),
//                                         style: const TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 0,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(
//                                 height: 16,
//                               ),
//                               const Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                   ),
//                                   child: Text(
//                                     ' select a date',
//                                     style: TextStyle(
//                                       color: darkBlue,
//                                       fontSize: 18,
//                                       fontFamily: 'OpenSans',
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )),
//                               const SizedBox(
//                                 height: 16,
//                               ),
//                               Container(
//                                   padding: kScreenPadding,
//                                   child: DatePicker(
//                                     DateTime.now().add(
//                                       Duration(
//                                         hours: 2 - DateTime.now().hour,
//                                         // minutes: 60 - DateTime.now().minute,
//                                         // seconds: 60 - DateTime.now().second,
//                                       ),
//                                     ),
//                                     height: 100,
//                                     width: 60,
//                                     daysCount: 7,
//                                     selectionColor: darkBlue,
//                                     selectedTextColor: Colors.white,
//                                     dateTextStyle: kBlueTextstyle,
//                                     onDateChange: (date) {
//                                       var selecteddate =
//                                           date.toString().split(' ').first;
//                                       sToday = selecteddate.split('-').last;
//                                       String cdate = DateFormat("dd")
//                                           .format(DateTime.now());

//                                       handleDateSelect(context, selecteddate);
//                                     },
//                                   )),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       margin: const EdgeInsets.only(
//                                           left: 12, top: 12, bottom: 16),
//                                       child: const Text(
//                                         'Available Slots',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                           color: darkBlue,
//                                           fontSize: 18,
//                                           fontFamily: 'OpenSans',
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     stepCount >= 4
//                                         ? slotsForTheSelectedDay!.length > 0
//                                             ? Container(
//                                                 child: Column(
//                                                   children: [
//                                                     Container(
//                                                       child: GridView.builder(
//                                                         shrinkWrap: true,
//                                                         physics:
//                                                             ScrollPhysics(),
//                                                         gridDelegate:
//                                                             SliverGridDelegateWithFixedCrossAxisCount(
//                                                           crossAxisCount: 2,
//                                                           crossAxisSpacing: 3,
//                                                           mainAxisSpacing: 3,
//                                                           childAspectRatio: MediaQuery
//                                                                       .of(
//                                                                           context)
//                                                                   .size
//                                                                   .width /
//                                                               (MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .height /
//                                                                   6),
//                                                         ),
//                                                         scrollDirection:
//                                                             Axis.vertical,
//                                                         itemBuilder:
//                                                             (BuildContext
//                                                                     context,
//                                                                 index) {
//                                                           final currentSlot =
//                                                               slotsForTheSelectedDay![
//                                                                   index];

//                                                           int ifromtime = int
//                                                               .parse(currentSlot[
//                                                                       "toTime"]
//                                                                   .split(':')
//                                                                   .first);
//                                                           List<String>
//                                                               ifromtime2 =
//                                                               currentSlot[
//                                                                       "toTime"]
//                                                                   .split(' ');

//                                                           String tdata =
//                                                               DateFormat(
//                                                                       'HH:mm:ss')
//                                                                   .format(DateTime
//                                                                       .now());
//                                                           int iCurrentTime =
//                                                               int.parse(tdata
//                                                                   .toString()
//                                                                   .split(':')
//                                                                   .first);
//                                                           List<String>
//                                                               iCurrentTime2 =
//                                                               tdata
//                                                                   .toString()
//                                                                   .split(':');

//                                                           String tdata1 =
//                                                               DateFormat("a")
//                                                                   .format(DateTime
//                                                                       .now());
//                                                           String sfromdataAMPM =
//                                                               currentSlot[
//                                                                       "toTime"]
//                                                                   .split(' ')
//                                                                   .last;
//                                                           late int
//                                                               iFromTimeInMinutes;
//                                                           for (int i = 0;
//                                                               i <
//                                                                   ifromtime2
//                                                                       .length;
//                                                               i++) {
//                                                             if (i == 0) {
//                                                               int fromMinutes =
//                                                                   int.parse(
//                                                                       ifromtime2[
//                                                                               i]
//                                                                           .split(
//                                                                               ':')
//                                                                           .last);
//                                                               if (sfromdataAMPM ==
//                                                                   "AM") {
//                                                                 int xxx =
//                                                                     ifromtime *
//                                                                         100;
//                                                                 iFromTimeInMinutes =
//                                                                     xxx +
//                                                                         fromMinutes;
//                                                                 print(
//                                                                     'iFromTimeInMinutes=$iFromTimeInMinutes');
//                                                               } else {
//                                                                 int xxx =
//                                                                     ifromtime *
//                                                                         100;
//                                                                 iFromTimeInMinutes =
//                                                                     xxx +
//                                                                         fromMinutes +
//                                                                         1200;
//                                                                 print(
//                                                                     'iFromTimeInMinutes=$iFromTimeInMinutes');
//                                                               }
//                                                             }
//                                                           }
//                                                           late int
//                                                               iCurrentTimeInMinutes;

//                                                           int iCurrentTimePlusTwo =
//                                                               iCurrentTime + 2;

//                                                           int iCurrentTime3;
//                                                           for (int i = 0;
//                                                               i <
//                                                                   iCurrentTime2
//                                                                       .length;
//                                                               i++) {
//                                                             if (i == 1) {
//                                                               iCurrentTime3 =
//                                                                   int.parse(
//                                                                       iCurrentTime2[
//                                                                           i]);

//                                                               int xxx =
//                                                                   iCurrentTime *
//                                                                       100;
//                                                               if (xxx > 999) {}
//                                                               iCurrentTimeInMinutes =
//                                                                   xxx +
//                                                                       iCurrentTime3;
//                                                               print(
//                                                                   'iCurrentTimeInMinutes=$iCurrentTimeInMinutes');
//                                                             }
//                                                           }

//                                                           print(
//                                                               'ifromtime2=$ifromtime2');

//                                                           print(
//                                                               'ifromtime=$ifromtime');
//                                                           print(
//                                                               'iCurrentTime2=$iCurrentTime2');

//                                                           print(
//                                                               'sfromdataAMPM=$sfromdataAMPM');
//                                                           print(
//                                                               'tdata1 $tdata1');
//                                                           print(
//                                                               'ifromtime=$ifromtime');
//                                                           String cdate =
//                                                               DateFormat("dd")
//                                                                   .format(DateTime
//                                                                       .now());
//                                                           return cdate == sToday
//                                                               ? ((iFromTimeInMinutes -
//                                                                           iCurrentTimeInMinutes) >
//                                                                       200)
//                                                                   ? GestureDetector(
//                                                                       onTap:
//                                                                           () {
//                                                                         setState(
//                                                                             () {
//                                                                           stepCount =
//                                                                               7;
//                                                                           amount =
//                                                                               selectedSlot.appoinmentFee;
//                                                                           showPaymentMethods =
//                                                                               true;
//                                                                           selectedSlot =
//                                                                               BookingSlot(
//                                                                             slotId:
//                                                                                 currentSlot["slotId"],
//                                                                             appoinmentConfigId:
//                                                                                 currentSlot["appoinmentConfigId"],
//                                                                             day:
//                                                                                 currentSlot["day"],
//                                                                             fromTime:
//                                                                                 currentSlot["fromTime"],
//                                                                             toTime:
//                                                                                 currentSlot["toTime"],
//                                                                             appoinmentFee:
//                                                                                 currentSlot["appoinmentFee"],
//                                                                           );
//                                                                         });
//                                                                       },
//                                                                       child:
//                                                                           Card(
//                                                                         color: selectedSlot.slotId ==
//                                                                                 currentSlot["slotId"]
//                                                                             ? const Color(0xff325CA2)
//                                                                             : Colors.white,
//                                                                         child:
//                                                                             Container(
//                                                                           height:
//                                                                               200,
//                                                                           width:
//                                                                               200,
//                                                                           child:
//                                                                               Center(
//                                                                             child:
//                                                                                 Text(
//                                                                               "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
//                                                                               style: TextStyle(
//                                                                                 color: selectedSlot.slotId == currentSlot["slotId"] ? Colors.white : Colors.black,
//                                                                                 fontSize: 14,
//                                                                                 fontFamily: 'OpenSans',
//                                                                                 fontWeight: FontWeight.w500,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ))
//                                                                   : Card(
//                                                                       color: Colors
//                                                                           .grey
//                                                                           .shade400,
//                                                                       child:
//                                                                           Container(
//                                                                         height:
//                                                                             200,
//                                                                         width:
//                                                                             200,
//                                                                         child:
//                                                                             Center(
//                                                                           child:
//                                                                               Text(
//                                                                             "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               color: selectedSlot.slotId == currentSlot["slotId"] ? Colors.white : Colors.black,
//                                                                               fontSize: 14,
//                                                                               fontFamily: 'OpenSans',
//                                                                               fontWeight: FontWeight.w500,
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     )
//                                                               : GestureDetector(
//                                                                   onTap: () {
//                                                                     setState(
//                                                                         () {
//                                                                       stepCount =
//                                                                           7;
//                                                                       amount =
//                                                                           selectedSlot
//                                                                               .appoinmentFee;
//                                                                       showPaymentMethods =
//                                                                           true;
//                                                                       selectedSlot =
//                                                                           BookingSlot(
//                                                                         slotId:
//                                                                             currentSlot["slotId"],
//                                                                         appoinmentConfigId:
//                                                                             currentSlot["appoinmentConfigId"],
//                                                                         day: currentSlot[
//                                                                             "day"],
//                                                                         fromTime:
//                                                                             currentSlot["fromTime"],
//                                                                         toTime:
//                                                                             currentSlot["toTime"],
//                                                                         appoinmentFee:
//                                                                             currentSlot["appoinmentFee"],
//                                                                       );
//                                                                     });
//                                                                   },
//                                                                   child: Card(
//                                                                     color: selectedSlot.slotId ==
//                                                                             currentSlot[
//                                                                                 "slotId"]
//                                                                         ? const Color(
//                                                                             0xff325CA2)
//                                                                         : Colors
//                                                                             .white,
//                                                                     child:
//                                                                         Container(
//                                                                       height:
//                                                                           200,
//                                                                       width:
//                                                                           200,
//                                                                       child:
//                                                                           Center(
//                                                                         child:
//                                                                             Text(
//                                                                           "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
//                                                                           style:
//                                                                               TextStyle(
//                                                                             color: selectedSlot.slotId == currentSlot["slotId"]
//                                                                                 ? Colors.white
//                                                                                 : Colors.black,
//                                                                             fontSize:
//                                                                                 14,
//                                                                             fontFamily:
//                                                                                 'OpenSans',
//                                                                             fontWeight:
//                                                                                 FontWeight.w500,
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ));
//                                                         },
//                                                         itemCount:
//                                                             slotsForTheSelectedDay ==
//                                                                     null
//                                                                 ? 0
//                                                                 : slotsForTheSelectedDay!
//                                                                     .length,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )
//                                             : (Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 children: const [
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                       vertical: 6,
//                                                       horizontal: 10,
//                                                     ),
//                                                     child: Text(
//                                                       "No slots available for this date",
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ))
//                                         : (Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: const [
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                   vertical: 6,
//                                                   horizontal: 10,
//                                                 ),
//                                                 child: Text(
//                                                   "Please select a date",
//                                                 ),
//                                               ),
//                                             ],
//                                           )),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               stepCount >= 6
//                                   ? Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         AppointmentSectionHeading(
//                                           title: "Payment Method",
//                                         ),
//                                         AppointmentFees(
//                                           fees: selectedSlot.appoinmentFee!,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             const Spacer(
//                                               flex: 1,
//                                             ),
//                                             Expanded(
//                                               flex: 4,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Column(
//                                                     children: [
//                                                       Radio(
//                                                         value:
//                                                             PaymentMethod.cod,
//                                                         groupValue:
//                                                             selectedPaymentMethod,
//                                                         onChanged: ((value) {
//                                                           setState(() {
//                                                             selectedPaymentMethod =
//                                                                 value
//                                                                     as PaymentMethod;
//                                                             // print(isDiabetic);
//                                                           });
//                                                         }),
//                                                       ),
//                                                       const Text(
//                                                         "Cash on Desk",
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   selectedSlot.appoinmentFee ==
//                                                           0
//                                                       ? SizedBox.shrink()
//                                                       : Column(
//                                                           children: [
//                                                             Radio(
//                                                               value:
//                                                                   PaymentMethod
//                                                                       .advance,
//                                                               groupValue:
//                                                                   selectedPaymentMethod,
//                                                               onChanged:
//                                                                   ((value) {
//                                                                 setState(() {
//                                                                   selectedPaymentMethod =
//                                                                       value
//                                                                           as PaymentMethod;
//                                                                   // print(isDiabetic);
//                                                                 });
//                                                               }),
//                                                             ),
//                                                             const Text(
//                                                               "ADVANCE",
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const Spacer(
//                                               flex: 1,
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     )
//                                   : const SizedBox(
//                                       height: 0,
//                                     ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               stepCount == 7
//                                   ? Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         BlueButton(
//                                           onPressed: () async {
//                                             SharedPreferences
//                                                 sharedPreferences =
//                                                 await SharedPreferences
//                                                     .getInstance();
//                                             bool isPay = await sharedPreferences
//                                                     .getBool("isPay") ??
//                                                 false;
//                                             if (isPay) {
//                                               saveAppointment(context,
//                                                   selectedSlot.appoinmentFee);
//                                             } else {
//                                               // Navigator.pushNamedAndRemoveUntil(
//                                               //     context,
//                                               //     homeFirst,
//                                               //     (route) => false);
//                                               saveAppointment(context,
//                                                   selectedSlot.appoinmentFee);
//                                             }
//                                           },
//                                           title: 'Book Appointment',
//                                           height: 45,
//                                           width: 200,
//                                         ),
//                                       ],
//                                     )
//                                   : const SizedBox(
//                                       height: 0,
//                                     ),
//                               const SizedBox(
//                                 height: 32,
//                               ),
//                               // const Divider(
//                               //   height: 2,
//                               //   color: Colors.grey,
//                               // ),
//                               // const SizedBox(
//                               //   height: 32,
//                               // ),
//                               // SizedBox(
//                               //   width: double.infinity,
//                               //   child: Padding(
//                               //     padding: const EdgeInsets.all(12.0),
//                               //     child: ElevatedButton(
//                               //       child: Text("View My Appointments"),
//                               //       onPressed: () {},
//                               //     ),
//                               //   ),
//                               // ),
//                               const SizedBox(
//                                 height: 32,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ]),
//                     )
//                   : Container(
//                       height: MediaQuery.of(context).size.height * 0.86,
//                       child: Center(
//                         child: Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           direction: Axis.vertical,
//                           children: const [
//                             CircularProgressIndicator(
//                               color: darkBlue,
//                             ),
//                             SizedBox(
//                               height: 24,
//                             ),
//                             Text("Saving your appointment, Please wait")
//                           ],
//                         ),
//                       ),
//                     )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AppointmentSectionHeading extends StatelessWidget {
//   final String title;
//   const AppointmentSectionHeading({Key? key, required this.title})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(
//               left: 12,
//               top: 12,
//               bottom: 10,
//             ),
//             child: Text(
//               title,
//               textAlign: TextAlign.start,
//               style: const TextStyle(
//                 color: darkBlue,
//                 fontSize: 18,
//                 fontFamily: 'OpenSans',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppointmentFees extends StatelessWidget {
//   final double fees;
//   const AppointmentFees({Key? key, required this.fees}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(
//             horizontal: 20,
//           ),
//           child: OutlinedButton(
//             onPressed: () {},
//             child: Text(
//               'Fees : ${fees.toString()} ₹',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: darkBlue,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // <<<<<<<<<<<<<<<<<< Second latest code >>>>>>>>>>>>>>>>>>>>>>

// // import 'dart:convert';
// // import 'dart:io';

// // import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
// // import 'package:Rakshan/utills/progressIndicator.dart';
// // //import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:Rakshan/constants/padding.dart';
// // import 'package:Rakshan/controller/appointment_controller.dart';
// // import 'package:Rakshan/routes/app_routes.dart';
// // import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
// // import 'package:Rakshan/screens/post_login/home_screen.dart';
// // import 'package:Rakshan/screens/post_login/payment.dart';
// // import 'package:Rakshan/widgets/post_login/app_bar.dart';
// // import 'package:Rakshan/widgets/post_login/app_menu.dart';
// // import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../../utills/horizontalCalender.dart';
// // import '/config/api_url_mapping.dart' as API;
// // import 'package:http/http.dart' as http;
// // import '../../constants/theme.dart';
// // import 'package:date_picker_timeline/date_picker_timeline.dart';

// // enum PaymentMethod { cod, advance }

// // class BookingDetails {
// //   String? date;
// //   String? fromTime;
// //   String? toTime;
// //   int? appoinmentConfigId;
// //   int? doctorId;
// //   int? clientId;
// //   String? dat;

// //   BookingDetails({
// //     this.date,
// //     this.fromTime,
// //     this.toTime,
// //     this.appoinmentConfigId,
// //     this.doctorId,
// //     this.clientId,
// //     this.dat,
// //   });
// // }

// // class BookingSlot {
// //   int? slotId;
// //   String? day;
// //   String? fromTime;
// //   String? toTime;
// //   int? appoinmentConfigId;
// //   double? appoinmentFee;

// //   BookingSlot({
// //     this.slotId,
// //     this.day,
// //     this.fromTime,
// //     this.toTime,
// //     this.appoinmentConfigId,
// //     this.appoinmentFee,
// //   });
// // }

// // class Appointment extends StatefulWidget {
// //   const Appointment(
// //       {Key? key,
// //       required this.sProviderTypeId,
// //       required this.sClientId,
// //       required this.sClientTypeName,
// //       required this.sClientName})
// //       : super(key: key);

// //   final int sProviderTypeId; //in 1st dropdownn
// //   final int sClientId; //2nd dropdown
// //   final String sClientTypeName; // in 1st drop hint
// //   final String sClientName; // in 2nd drop hint

// //   @override
// //   State<Appointment> createState() => _AppointmentState();
// // }

// // class _AppointmentState extends State<Appointment> {
// //   // DateTime _selectedDate = DateTime.now();
// //   final _appointmentController = AppointmentController();
// //   late ProcessIndicatorDialog _progressIndicator;
// //   int selectedCard = -1;
// //   dynamic amount = 0.0;
// //   var bookId;
// //   // ===============ROHIT's===================

// //   final engDays = [
// //     'Monday',
// //     'Tuesday',
// //     'Wednesday',
// //     'Thursday',
// //     'Friday',
// //     'Saturday',
// //     'Sunday',
// //   ];

// //   int stepCount = 0;
// //   // selected provider Type = 1
// //   // selected provider = 2
// //   // selected doctor = 3
// //   // selected date = 4
// //   // selected slot  = 5
// //   // selected paymentMethod  = 6
// //   // selected doingBooking  = 7

// //   List providerTypes = [];
// //   int? selectedProviderType;

// //   List serviceProviders = [];
// //   int? selectedProvider;

// //   List consultants = [];
// //   int? selectedConsultant;

// //   bool isLoading = true;

// // // booking
// //   bool showDates = false;
// //   bool showSlots = false;
// //   bool showPaymentMethods = false;
// //   bool isSavingAppointment = false;

// //   List allSlots = [];
// //   List? slotsForTheSelectedDay;

// //   String selectedDate = "";
// //   BookingSlot selectedSlot = BookingSlot();

// //   PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

// //   BookingDetails bookingTracker = BookingDetails();

// //   void fetchProviderTypes() async {
// //     final fetechedProviderTypes =
// //         await _appointmentController.getProviderTypes();

// //     setState(() {
// //       stepCount = 0;
// //       providerTypes = fetechedProviderTypes;

// //       // set other two as empty
// //       serviceProviders = [];
// //       consultants = [];
// //     });
// //   }

// //   void fetchServiceProviders(int ClientTypeId) async {
// //     final fetchedServiceProvider =
// //         await _appointmentController.getServiceProviders(ClientTypeId);

// //     setState(() {
// //       selectedProviderType = ClientTypeId;
// //       serviceProviders = fetchedServiceProvider;

// //       showDates = false;
// //       showSlots = false;
// //       showPaymentMethods = false;
// //       selectedDate = "";
// //       slotsForTheSelectedDay = null;

// //       consultants = [];
// //     });
// //   }

// //   void fetchConsultants(int clientId) async {
// //     final fetchedConsultants =
// //         await _appointmentController.getConsultants(clientId);

// //     setState(() {
// //       selectedProvider = clientId;
// //       consultants = fetchedConsultants;
// //       showDates = false;
// //     });
// //   }

// //   void handleDateSelect(BuildContext ctx, String date) {
// //     if (stepCount < 3) {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             "Please pick provider and doctor first",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.blue,
// //         ),
// //       );
// //       return;
// //     }

// //     final splittedStr = date.split("-");
// //     final chosenDate = DateTime(
// //       int.parse(splittedStr[0]),
// //       int.parse(splittedStr[1]),
// //       int.parse(splittedStr[2]),
// //     );

// //     final weekday = DateFormat("EEEE").format(chosenDate);
// //     setState(() {
// //       stepCount = 4;
// //       selectedDate = date;
// //       slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
// //       selectedSlot = BookingSlot();
// //     });

// //     if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             'You cannot book slots for current day, please look for next day onwards.',
// //             // "No slots available for this date",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.redAccent,
// //         ),
// //       );
// //     }
// //   }

// //   void handleSlotSelect(BookingSlot slot) {
// //     if (stepCount <= 4) {
// //       return;
// //     }
// //     setState(() {
// //       stepCount = 5;
// //     });
// //   }

// //   List findSlotsForTheSelectedDay(String day) {
// //     final coppyArray = new List<Map>.from(allSlots);
// //     coppyArray.removeWhere((slot) => slot['day'] != day);
// //     int index = 0;
// //     final slotsWithId = coppyArray.map((slot) {
// //       final myMap = Map();
// //       myMap["slotId"] = index;
// //       myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
// //       myMap["day"] = slot["day"];
// //       myMap["fromTime"] = slot["fromTime"];
// //       myMap["toTime"] = slot["toTime"];
// //       myMap["appoinmentFee"] = slot["appoinmentFee"];
// //       index++;
// //       return myMap;
// //     }).toList();
// //     return slotsWithId;
// //   }

// //   Future<bool> saveAppointments(
// //     BookingSlot bookingDetails,
// //     int clientId,
// //     int consultantId,
// //     String selectedDate,
// //   ) async {
// //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// //     final userToken = sharedPreferences.getString('data');
// //     final userId = sharedPreferences.get("userId");
// //     _progressIndicator.show();
// //     var response = await http.post(
// //         Uri.parse(
// //           API.buildUrl(
// //             API.kBookAppointment,
// //           ),
// //         ),
// //         headers: {
// //           HttpHeaders.authorizationHeader: 'Bearer $userToken',
// //           HttpHeaders.contentTypeHeader: "application/json"
// //         },
// //         body: jsonEncode({
// //           "ClientId": clientId,
// //           "ServiceId": 4,
// //           "DoctorId": consultantId,
// //           "UserId": int.tryParse(userId as String),
// //           "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
// //           "Day": bookingDetails.day,
// //           "FromTime": bookingDetails.fromTime,
// //           "ToTime": bookingDetails.toTime,
// //           "AppoinmentDate": selectedDate
// //         }));
// //     _progressIndicator.hide();
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       if (data["isSuccess"]) {
// //         var bookId = data['id'];
// //         return true;
// //       } else {
// //         return false;
// //       }
// //     }
// //     return false;
// //   }

// //   void saveAppointment(ctx, dynamic amounts) async {
// //     // setState(() {
// //     //   isSavingAppointment = true;
// //     // });

// //     final splittedStr = selectedDate.split("-");

// //     final selectedDateToSend =
// //         "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
// //     // show confirmation page
// //     bool savedAppointment = await saveAppointments(
// //       selectedSlot,
// //       selectedProvider!,
// //       selectedConsultant!,
// //       selectedDateToSend,
// //     );

// //     setState(() {
// //       isSavingAppointment = false;
// //     });

// //     if (savedAppointment) {
// //       if (selectedPaymentMethod == PaymentMethod.advance) {
// //         Navigator.of(context).push(
// //           MaterialPageRoute(
// //             builder: (ctx) {
// //               var bookId;
// //               return PaymentScreen(
// //                 amount: amounts,
// //                 id: bookId,
// //                 sName: "Appointment",
// //                 // coupontype: "",
// //               );
// //             },
// //           ),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(ctx).showSnackBar(
// //           const SnackBar(
// //             content: Text(
// //               "Appointment booked successfully",
// //               style: TextStyle(
// //                 color: Colors.white,
// //               ),
// //             ),
// //             duration: Duration(
// //               milliseconds: 2000,
// //             ),
// //             backgroundColor: Colors.blue,
// //           ),
// //         );
// //         Navigator.pop(context);
// //         Navigator.of(context).push(
// //           MaterialPageRoute(
// //             builder: (ctx) {
// //               return BookingConfirmation();
// //             },
// //           ),
// //         );
// //       }
// //     } else {
// //       ScaffoldMessenger.of(ctx).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //             "Appointment not booked successfully",
// //             style: TextStyle(
// //               color: Colors.white,
// //             ),
// //           ),
// //           duration: Duration(
// //             milliseconds: 2000,
// //           ),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   void initState() {
// //     _progressIndicator = ProcessIndicatorDialog(context);
// //     super.initState();
// //     fetchProviderTypes();
// //     if (widget.sProviderTypeId != 0) {
// //       fetchServiceProviders(widget.sClientId);
// //       fetchConsultants(widget.sClientId);
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       //
// //       appBar: AppBar(
// //         elevation: 0,
// //         leading: IconButton(
// //           onPressed: () {
// //             Navigator.pop(context, true);
// //           }, // Handle your on tap here.
// //           icon: const Icon(
// //             Icons.arrow_back_ios,
// //             color: Colors.black,
// //           ),
// //         ),
// //         backgroundColor: Color(0xfffcfcfc),
// //         title: const Text(
// //           'Appointment',
// //           style: TextStyle(
// //             fontFamily: 'OpenSans',
// //             color: Color(0xff2e66aa),
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         actions: <Widget>[
// //           Padding(
// //             padding: EdgeInsets.only(right: 20.0),
// //             child: IconButton(
// //               onPressed: () {
// //                 Navigator.pushNamed(context, appointmentHistoryScreen);
// //               },
// //               icon: Icon(Icons.history),
// //             ),
// //           ),
// //         ],
// //         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Stack(
// //           children: [
// //             !isSavingAppointment
// //                 ? Container(
// //                     child: Column(children: [
// //                       // SERVICE PROVIDER TYPES
// //                       // if(widget.sProviderTypeId != ''){}else{}
// //                       widget.sProviderTypeId != 0
// //                           ? Padding(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 16, vertical: 10),
// //                               child: Container(
// //                                 padding:
// //                                     const EdgeInsets.only(left: 16, right: 16),
// //                                 decoration: BoxDecoration(
// //                                   color: const Color(0xfff1f7ff),
// //                                   border:
// //                                       Border.all(color: Colors.white, width: 1),
// //                                   borderRadius: BorderRadius.circular(5),
// //                                 ),
// //                                 child: DropdownButton(
// //                                   value: selectedProviderType =
// //                                       widget.sProviderTypeId,
// //                                   onChanged: (ClientTypeId) {
// //                                     setState(() {
// //                                       // serviceProviders =[];
// //                                       stepCount = 1;
// //                                       allSlots = [];
// //                                       selectedProviderType =
// //                                           ClientTypeId as int;
// //                                     });

// //                                     fetchServiceProviders(ClientTypeId as int);
// //                                   },
// //                                   items: providerTypes.map((providerType) {
// //                                     return DropdownMenuItem(
// //                                       value: providerType["clientTypeId"],
// //                                       child: Text(
// //                                         providerType["clientTypeName"],
// //                                         style: kApiTextstyle,
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                   hint: Text(
// //                                     widget.sClientTypeName,
// //                                     style: kSubheadingTextstyle,
// //                                   ),
// //                                   dropdownColor: Colors.white,
// //                                   icon: Icon(Icons.arrow_drop_down),
// //                                   iconSize: 36,
// //                                   isExpanded: true,
// //                                   underline: SizedBox(),
// //                                   style: const TextStyle(
// //                                     color: Colors.black,
// //                                     fontSize: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                             )
// //                           // to atupopulate 1st dropddown
// //                           : Padding(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 16, vertical: 10),
// //                               child: Container(
// //                                 padding:
// //                                     const EdgeInsets.only(left: 16, right: 16),
// //                                 decoration: BoxDecoration(
// //                                   color: const Color(0xfff1f7ff),
// //                                   border:
// //                                       Border.all(color: Colors.white, width: 1),
// //                                   borderRadius: BorderRadius.circular(5),
// //                                 ),
// //                                 child: DropdownButton(
// //                                   value: selectedProviderType,
// //                                   onChanged: (ClientTypeId) {
// //                                     setState(() {
// //                                       // serviceProviders =[];
// //                                       stepCount = 1;
// //                                       allSlots = [];
// //                                       selectedProviderType =
// //                                           ClientTypeId as int;
// //                                     });
// //                                     fetchServiceProviders(ClientTypeId as int);
// //                                   },
// //                                   items: providerTypes.map((providerType) {
// //                                     return DropdownMenuItem(
// //                                       value: providerType["clientTypeId"],
// //                                       child: Text(
// //                                         providerType["clientTypeName"],
// //                                         style: kApiTextstyle,
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                   hint: const Text(
// //                                     'Select Provider Type',
// //                                     style: kSubheadingTextstyle,
// //                                   ),
// //                                   dropdownColor: Colors.white,
// //                                   icon: Icon(Icons.arrow_drop_down),
// //                                   iconSize: 36,
// //                                   isExpanded: true,
// //                                   underline: SizedBox(),
// //                                   style: const TextStyle(
// //                                     color: Colors.black,
// //                                     fontSize: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),

// //                       // SERVICE PROVIDERS
// //                       widget.sClientId != 0
// //                           ? Padding(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 16, vertical: 10),
// //                               child: Container(
// //                                 padding:
// //                                     const EdgeInsets.only(left: 16, right: 16),
// //                                 decoration: BoxDecoration(
// //                                   color: kFaintBlue,
// //                                   border:
// //                                       Border.all(color: Colors.white, width: 1),
// //                                   borderRadius: BorderRadius.circular(5),
// //                                 ),
// //                                 child: DropdownButton(
// //                                   value: selectedProvider = widget.sClientId,
// //                                   onChanged: (clientId) {
// //                                     setState(() {
// //                                       stepCount = 2;
// //                                       selectedProvider = clientId as int;
// //                                       allSlots = [];
// //                                     });
// //                                     fetchConsultants(clientId as int);
// //                                   },
// //                                   items:
// //                                       serviceProviders.map((serviceProvider) {
// //                                     return DropdownMenuItem(
// //                                       value: serviceProvider["clientId"],
// //                                       child: Text(
// //                                         serviceProvider["clientName"],
// //                                         style: kApiTextstyle,
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                   hint: Text(
// //                                     widget.sClientName,
// //                                     style: kApiTextstyle,
// //                                   ),
// //                                   dropdownColor: Colors.white,
// //                                   icon: Icon(Icons.arrow_drop_down),
// //                                   iconSize: 36,
// //                                   isExpanded: true,
// //                                   underline: SizedBox(),
// //                                   style: const TextStyle(
// //                                     color: Colors.black,
// //                                     fontSize: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                             )
// //                           : Padding(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 16, vertical: 10),
// //                               child: Container(
// //                                 padding:
// //                                     const EdgeInsets.only(left: 16, right: 16),
// //                                 decoration: BoxDecoration(
// //                                   color: kFaintBlue,
// //                                   border:
// //                                       Border.all(color: Colors.white, width: 1),
// //                                   borderRadius: BorderRadius.circular(5),
// //                                 ),
// //                                 child: DropdownButton(
// //                                   value: selectedProvider,
// //                                   onChanged: (clientId) {
// //                                     setState(() {
// //                                       stepCount = 2;
// //                                       selectedProvider = clientId as int;
// //                                       allSlots = [];
// //                                     });
// //                                     fetchConsultants(clientId as int);
// //                                   },
// //                                   items:
// //                                       serviceProviders.map((serviceProvider) {
// //                                     return DropdownMenuItem(
// //                                       value: serviceProvider["clientId"],
// //                                       child: Text(
// //                                         serviceProvider["clientName"],
// //                                         style: kApiTextstyle,
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                   hint: const Text(
// //                                     'Service Provider',
// //                                     style: kApiTextstyle,
// //                                   ),
// //                                   dropdownColor: Colors.white,
// //                                   icon: Icon(Icons.arrow_drop_down),
// //                                   iconSize: 36,
// //                                   isExpanded: true,
// //                                   underline: SizedBox(),
// //                                   style: const TextStyle(
// //                                     color: Colors.black,
// //                                     fontSize: 18,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),

// //                       // CONSULTANTS
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 10),
// //                         child: Container(
// //                           padding: const EdgeInsets.only(left: 16, right: 16),
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xfff1f7ff),
// //                             border: Border.all(color: Colors.white, width: 1),
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: DropdownButton(
// //                             value: selectedConsultant,
// //                             onChanged: (consultantId) async {
// //                               setState(() {
// //                                 stepCount = 3;
// //                                 selectedConsultant = consultantId as int;
// //                               });

// //                               final consultantSlots =
// //                                   await _appointmentController
// //                                       .getDoctorAppointmentDetails(
// //                                 selectedProvider as int,
// //                                 consultantId as int,
// //                               );

// //                               setState(() {
// //                                 allSlots = consultantSlots;
// //                               });
// //                             },
// //                             items: consultants.map((consultant) {
// //                               return DropdownMenuItem(
// //                                 value: consultant["consultantId"],
// //                                 child: Text(
// //                                   consultant["consultantName"],
// //                                   style: kApiTextstyle,
// //                                 ),
// //                               );
// //                             }).toList(),
// //                             hint: const Text(
// //                               'Select Doctors',
// //                               style: kApiTextstyle,
// //                             ),
// //                             dropdownColor: Colors.white,
// //                             icon: const Icon(Icons.arrow_drop_down),
// //                             iconSize: 36,
// //                             isExpanded: true,
// //                             underline: const SizedBox(),
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ),
// //                       ),

// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 0,
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             const SizedBox(
// //                               height: 16,
// //                             ),
// //                             const Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: 20,
// //                                 ),
// //                                 child: Text(
// //                                   'Choose a date',
// //                                   style: TextStyle(
// //                                     color: darkBlue,
// //                                     fontSize: 18,
// //                                     fontFamily: 'OpenSans',
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 )),
// //                             const SizedBox(
// //                               height: 16,
// //                             ),
// //                             Container(
// //                                 padding: kScreenPadding,
// //                                 child: DatePicker(
// //                                   DateTime.now().add(
// //                                     Duration(
// //                                       hours: 2 - DateTime.now().hour,
// //                                       // minutes: 60 - DateTime.now().minute,
// //                                       // seconds: 60 - DateTime.now().second,
// //                                     ),
// //                                   ),
// //                                   height: 100,
// //                                   width: 60,
// //                                   daysCount: 7,
// //                                   selectionColor: darkBlue,
// //                                   selectedTextColor: Colors.white,
// //                                   dateTextStyle: kBlueTextstyle,
// //                                   onDateChange: (date) {
// //                                     var selecteddate =
// //                                         date.toString().split(' ').first;
// //                                     print(selecteddate);
// //                                     handleDateSelect(context, selecteddate);
// //                                   },
// //                                 )),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 10,
// //                               ),
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Container(
// //                                     margin: const EdgeInsets.only(
// //                                         left: 12, top: 12, bottom: 16),
// //                                     child: const Text(
// //                                       'Available Slots',
// //                                       textAlign: TextAlign.start,
// //                                       style: TextStyle(
// //                                         color: darkBlue,
// //                                         fontSize: 18,
// //                                         fontFamily: 'OpenSans',
// //                                         fontWeight: FontWeight.bold,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   stepCount >= 4
// //                                       ? slotsForTheSelectedDay!.length > 0
// //                                           ? Container(
// //                                               child: Column(
// //                                                 children: [
// //                                                   Container(
// //                                                     child: GridView.builder(
// //                                                       shrinkWrap: true,
// //                                                       physics: ScrollPhysics(),
// //                                                       gridDelegate:
// //                                                           SliverGridDelegateWithFixedCrossAxisCount(
// //                                                         crossAxisCount: 2,
// //                                                         crossAxisSpacing: 3,
// //                                                         mainAxisSpacing: 3,
// //                                                         childAspectRatio: MediaQuery
// //                                                                     .of(context)
// //                                                                 .size
// //                                                                 .width /
// //                                                             (MediaQuery.of(
// //                                                                         context)
// //                                                                     .size
// //                                                                     .height /
// //                                                                 6),
// //                                                       ),
// //                                                       scrollDirection:
// //                                                           Axis.vertical,
// //                                                       itemBuilder:
// //                                                           (BuildContext context,
// //                                                               index) {
// //                                                         final currentSlot =
// //                                                             slotsForTheSelectedDay![
// //                                                                 index];

// //                                                         return GestureDetector(
// //                                                           onTap: () {
// //                                                             setState(() {
// //                                                               stepCount = 7;
// //                                                               amount = selectedSlot
// //                                                                   .appoinmentFee;
// //                                                               showPaymentMethods =
// //                                                                   true;
// //                                                               selectedSlot =
// //                                                                   BookingSlot(
// //                                                                 slotId:
// //                                                                     currentSlot[
// //                                                                         "slotId"],
// //                                                                 appoinmentConfigId:
// //                                                                     currentSlot[
// //                                                                         "appoinmentConfigId"],
// //                                                                 day:
// //                                                                     currentSlot[
// //                                                                         "day"],
// //                                                                 fromTime:
// //                                                                     currentSlot[
// //                                                                         "fromTime"],
// //                                                                 toTime:
// //                                                                     currentSlot[
// //                                                                         "toTime"],
// //                                                                 appoinmentFee:
// //                                                                     currentSlot[
// //                                                                         "appoinmentFee"],
// //                                                               );
// //                                                             });
// //                                                           },
// //                                                           child: Card(
// //                                                             color: selectedSlot
// //                                                                         .slotId ==
// //                                                                     currentSlot[
// //                                                                         "slotId"]
// //                                                                 ? const Color(
// //                                                                     0xff325CA2)
// //                                                                 : Colors.white,
// //                                                             child: Container(
// //                                                               height: 200,
// //                                                               width: 200,
// //                                                               child: Center(
// //                                                                 child: Text(
// //                                                                   "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
// //                                                                   style:
// //                                                                       TextStyle(
// //                                                                     color: selectedSlot.slotId ==
// //                                                                             currentSlot[
// //                                                                                 "slotId"]
// //                                                                         ? Colors
// //                                                                             .white
// //                                                                         : Colors
// //                                                                             .black,
// //                                                                     fontSize:
// //                                                                         14,
// //                                                                     fontFamily:
// //                                                                         'OpenSans',
// //                                                                     fontWeight:
// //                                                                         FontWeight
// //                                                                             .w500,
// //                                                                   ),
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                           ),
// //                                                         );
// //                                                       },
// //                                                       itemCount:
// //                                                           slotsForTheSelectedDay ==
// //                                                                   null
// //                                                               ? 0
// //                                                               : slotsForTheSelectedDay!
// //                                                                   .length,
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             )
// //                                           : (Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment.start,
// //                                               children: const [
// //                                                 Padding(
// //                                                   padding: EdgeInsets.symmetric(
// //                                                     vertical: 6,
// //                                                     horizontal: 10,
// //                                                   ),
// //                                                   child: Text(
// //                                                     "No slots available for this date",
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ))
// //                                       : (Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.start,
// //                                           children: const [
// //                                             Padding(
// //                                               padding: EdgeInsets.symmetric(
// //                                                 vertical: 6,
// //                                                 horizontal: 10,
// //                                               ),
// //                                               child: Text(
// //                                                 "Please select a date",
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         )),
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(
// //                               height: 20,
// //                             ),
// //                             stepCount >= 6
// //                                 ? Column(
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     children: [
// //                                       AppointmentSectionHeading(
// //                                         title: "Payment Method",
// //                                       ),
// //                                       AppointmentFees(
// //                                         fees: selectedSlot.appoinmentFee!,
// //                                       ),
// //                                       Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.center,
// //                                         children: [
// //                                           const Spacer(
// //                                             flex: 1,
// //                                           ),
// //                                           Expanded(
// //                                             flex: 4,
// //                                             child: Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment
// //                                                       .spaceBetween,
// //                                               children: [
// //                                                 Column(
// //                                                   children: [
// //                                                     Radio(
// //                                                       value: PaymentMethod.cod,
// //                                                       groupValue:
// //                                                           selectedPaymentMethod,
// //                                                       onChanged: ((value) {
// //                                                         setState(() {
// //                                                           selectedPaymentMethod =
// //                                                               value
// //                                                                   as PaymentMethod;
// //                                                           // print(isDiabetic);
// //                                                         });
// //                                                       }),
// //                                                     ),
// //                                                     const Text(
// //                                                       "COD",
// //                                                       textAlign:
// //                                                           TextAlign.center,
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                                 Column(
// //                                                   children: [
// //                                                     Radio(
// //                                                       value:
// //                                                           PaymentMethod.advance,
// //                                                       groupValue:
// //                                                           selectedPaymentMethod,
// //                                                       onChanged: ((value) {
// //                                                         setState(() {
// //                                                           selectedPaymentMethod =
// //                                                               value
// //                                                                   as PaymentMethod;
// //                                                           // print(isDiabetic);
// //                                                         });
// //                                                       }),
// //                                                     ),
// //                                                     const Text(
// //                                                       "ADVANCE",
// //                                                       textAlign:
// //                                                           TextAlign.center,
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           const Spacer(
// //                                             flex: 1,
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   )
// //                                 : const SizedBox(
// //                                     height: 0,
// //                                   ),
// //                             const SizedBox(
// //                               height: 20,
// //                             ),
// //                             stepCount == 7
// //                                 ? Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     children: [
// //                                       BlueButton(
// //                                         onPressed: () async {
// //                                           SharedPreferences sharedPreferences =
// //                                               await SharedPreferences
// //                                                   .getInstance();
// //                                           bool isPay = await sharedPreferences
// //                                                   .getBool("isPay") ??
// //                                               false;
// //                                           if (isPay) {
// //                                             saveAppointment(context,
// //                                                 selectedSlot.appoinmentFee);
// //                                           } else {
// //                                             // Navigator.pushNamedAndRemoveUntil(
// //                                             //     context,
// //                                             //     homeFirst,
// //                                             //     (route) => false);
// //                                             saveAppointment(context,
// //                                                 selectedSlot.appoinmentFee);
// //                                           }
// //                                         },
// //                                         title: 'Book Appointment',
// //                                         height: 45,
// //                                         width: 200,
// //                                       ),
// //                                     ],
// //                                   )
// //                                 : const SizedBox(
// //                                     height: 0,
// //                                   ),
// //                             const SizedBox(
// //                               height: 32,
// //                             ),
// //                             // const Divider(
// //                             //   height: 2,
// //                             //   color: Colors.grey,
// //                             // ),
// //                             // const SizedBox(
// //                             //   height: 32,
// //                             // ),
// //                             // SizedBox(
// //                             //   width: double.infinity,
// //                             //   child: Padding(
// //                             //     padding: const EdgeInsets.all(12.0),
// //                             //     child: ElevatedButton(
// //                             //       child: Text("View My Appointments"),
// //                             //       onPressed: () {},
// //                             //     ),
// //                             //   ),
// //                             // ),
// //                             const SizedBox(
// //                               height: 32,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ]),
// //                   )
// //                 : Container(
// //                     height: MediaQuery.of(context).size.height * 0.86,
// //                     child: Center(
// //                       child: Wrap(
// //                         crossAxisAlignment: WrapCrossAlignment.center,
// //                         direction: Axis.vertical,
// //                         children: const [
// //                           CircularProgressIndicator(
// //                             color: darkBlue,
// //                           ),
// //                           SizedBox(
// //                             height: 24,
// //                           ),
// //                           Text("Saving your appointment, Please wait")
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AppointmentSectionHeading extends StatelessWidget {
// //   final String title;
// //   const AppointmentSectionHeading({Key? key, required this.title})
// //       : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 10,
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             margin: const EdgeInsets.only(
// //               left: 12,
// //               top: 12,
// //               bottom: 10,
// //             ),
// //             child: Text(
// //               title,
// //               textAlign: TextAlign.start,
// //               style: const TextStyle(
// //                 color: darkBlue,
// //                 fontSize: 18,
// //                 fontFamily: 'OpenSans',
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class AppointmentFees extends StatelessWidget {
// //   final double fees;
// //   const AppointmentFees({Key? key, required this.fees}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Container(
// //           margin: const EdgeInsets.symmetric(
// //             horizontal: 20,
// //           ),
// //           child: OutlinedButton(
// //             onPressed: () {},
// //             child: Text(
// //               'Fees : ${fees.toString()} ₹',
// //               style: const TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w500,
// //                 color: darkBlue,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< CODE BELOW IS BEFORE IMPLEMENTING AUTOLOAD IN DROPDOWNS >>>>>>>>>>>>>>>>>>>>>>>>>>

// // // import 'dart:convert';
// // // import 'dart:io';

// // // import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
// // // import 'package:Rakshan/utills/progressIndicator.dart';
// // // //import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:Rakshan/constants/padding.dart';
// // // import 'package:Rakshan/controller/appointment_controller.dart';
// // // import 'package:Rakshan/routes/app_routes.dart';
// // // import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
// // // import 'package:Rakshan/screens/post_login/home_screen.dart';
// // // import 'package:Rakshan/screens/post_login/payment.dart';
// // // import 'package:Rakshan/widgets/post_login/app_bar.dart';
// // // import 'package:Rakshan/widgets/post_login/app_menu.dart';
// // // import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../../utills/horizontalCalender.dart';
// // // import '/config/api_url_mapping.dart' as API;
// // // import 'package:http/http.dart' as http;
// // // import '../../constants/theme.dart';
// // // import 'package:date_picker_timeline/date_picker_timeline.dart';

// // // enum PaymentMethod { cod, advance }

// // // class BookingDetails {
// // //   String? date;
// // //   String? fromTime;
// // //   String? toTime;
// // //   int? appoinmentConfigId;
// // //   int? doctorId;
// // //   int? clientId;
// // //   String? dat;

// // //   BookingDetails({
// // //     this.date,
// // //     this.fromTime,
// // //     this.toTime,
// // //     this.appoinmentConfigId,
// // //     this.doctorId,
// // //     this.clientId,
// // //     this.dat,
// // //   });
// // // }

// // // class BookingSlot {
// // //   int? slotId;
// // //   String? day;
// // //   String? fromTime;
// // //   String? toTime;
// // //   int? appoinmentConfigId;
// // //   double? appoinmentFee;

// // //   BookingSlot({
// // //     this.slotId,
// // //     this.day,
// // //     this.fromTime,
// // //     this.toTime,
// // //     this.appoinmentConfigId,
// // //     this.appoinmentFee,
// // //   });
// // // }

// // // class Appointment extends StatefulWidget {
// // //   const Appointment(
// // //       {Key? key,
// // //       required this.sProviderTypeId,
// // //       required this.sClientId,
// // //       required this.sService,
// // //       required this.sClientName})
// // //       : super(key: key);

// // //   final String sProviderTypeId; //in 1st dropdownn
// // //   final String sClientId; //2nd dropdown
// // //   final String sService;
// // //   final String sClientName;

// // //   @override
// // //   State<Appointment> createState() => _AppointmentState();
// // // }

// // // class _AppointmentState extends State<Appointment> {
// // //   // DateTime _selectedDate = DateTime.now();
// // //   final _appointmentController = AppointmentController();
// // //   late ProcessIndicatorDialog _progressIndicator;
// // //   int selectedCard = -1;
// // //   dynamic amount = 0.0;
// // //   var bookId;
// // //   // ===============ROHIT's===================

// // //   final engDays = [
// // //     'Monday',
// // //     'Tuesday',
// // //     'Wednesday',
// // //     'Thursday',
// // //     'Friday',
// // //     'Saturday',
// // //     'Sunday',
// // //   ];

// // //   int stepCount = 0;
// // //   // selected provider Type = 1
// // //   // selected provider = 2
// // //   // selected doctor = 3
// // //   // selected date = 4
// // //   // selected slot  = 5
// // //   // selected paymentMethod  = 6
// // //   // selected doingBooking  = 7

// // //   List providerTypes = [];
// // //   int? selectedProviderType;

// // //   List serviceProviders = [];
// // //   int? selectedProvider;

// // //   List consultants = [];
// // //   int? selectedConsultant;

// // //   bool isLoading = true;

// // // // booking
// // //   bool showDates = false;
// // //   bool showSlots = false;
// // //   bool showPaymentMethods = false;
// // //   bool isSavingAppointment = false;

// // //   List allSlots = [];
// // //   List? slotsForTheSelectedDay;

// // //   String selectedDate = "";
// // //   BookingSlot selectedSlot = BookingSlot();

// // //   PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

// // //   BookingDetails bookingTracker = BookingDetails();

// // //   void fetchProviderTypes() async {
// // //     final fetechedProviderTypes =
// // //         await _appointmentController.getProviderTypes();

// // //     setState(() {
// // //       stepCount = 0;
// // //       providerTypes = fetechedProviderTypes;

// // //       // set other two as empty
// // //       serviceProviders = [];
// // //       consultants = [];
// // //     });
// // //   }

// // //   void fetchServiceProviders(int ClientTypeId) async {
// // //     final fetchedServiceProvider =
// // //         await _appointmentController.getServiceProviders(ClientTypeId);

// // //     setState(() {
// // //       selectedProviderType = ClientTypeId;
// // //       serviceProviders = fetchedServiceProvider;

// // //       showDates = false;
// // //       showSlots = false;
// // //       showPaymentMethods = false;
// // //       selectedDate = "";
// // //       slotsForTheSelectedDay = null;

// // //       consultants = [];
// // //     });
// // //   }

// // //   void fetchConsultants(int clientId) async {
// // //     final fetchedConsultants =
// // //         await _appointmentController.getConsultants(clientId);

// // //     setState(() {
// // //       selectedProvider = clientId;
// // //       consultants = fetchedConsultants;
// // //       showDates = false;
// // //     });
// // //   }

// // //   void handleDateSelect(BuildContext ctx, String date) {
// // //     if (stepCount < 3) {
// // //       ScaffoldMessenger.of(ctx).showSnackBar(
// // //         const SnackBar(
// // //           content: Text(
// // //             "Please pick provider and doctor first",
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           duration: Duration(
// // //             milliseconds: 2000,
// // //           ),
// // //           backgroundColor: Colors.blue,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     final splittedStr = date.split("-");
// // //     final chosenDate = DateTime(
// // //       int.parse(splittedStr[0]),
// // //       int.parse(splittedStr[1]),
// // //       int.parse(splittedStr[2]),
// // //     );

// // //     final weekday = DateFormat("EEEE").format(chosenDate);
// // //     setState(() {
// // //       stepCount = 4;
// // //       selectedDate = date;
// // //       slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
// // //       selectedSlot = BookingSlot();
// // //     });

// // //     if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
// // //       ScaffoldMessenger.of(ctx).showSnackBar(
// // //         const SnackBar(
// // //           content: Text(
// // //             'You cannot book slots for current day, please look for next day onwards.',
// // //             // "No slots available for this date",
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           duration: Duration(
// // //             milliseconds: 2000,
// // //           ),
// // //           backgroundColor: Colors.redAccent,
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   void handleSlotSelect(BookingSlot slot) {
// // //     if (stepCount <= 4) {
// // //       return;
// // //     }
// // //     setState(() {
// // //       stepCount = 5;
// // //     });
// // //   }

// // //   List findSlotsForTheSelectedDay(String day) {
// // //     final coppyArray = new List<Map>.from(allSlots);
// // //     coppyArray.removeWhere((slot) => slot['day'] != day);
// // //     int index = 0;
// // //     final slotsWithId = coppyArray.map((slot) {
// // //       final myMap = Map();
// // //       myMap["slotId"] = index;
// // //       myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
// // //       myMap["day"] = slot["day"];
// // //       myMap["fromTime"] = slot["fromTime"];
// // //       myMap["toTime"] = slot["toTime"];
// // //       myMap["appoinmentFee"] = slot["appoinmentFee"];
// // //       index++;
// // //       return myMap;
// // //     }).toList();
// // //     return slotsWithId;
// // //   }

// // //   Future<bool> saveAppointments(
// // //     BookingSlot bookingDetails,
// // //     int clientId,
// // //     int consultantId,
// // //     String selectedDate,
// // //   ) async {
// // //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// // //     final userToken = sharedPreferences.getString('data');
// // //     final userId = sharedPreferences.get("userId");
// // //     _progressIndicator.show();
// // //     var response = await http.post(
// // //         Uri.parse(
// // //           API.buildUrl(
// // //             API.kBookAppointment,
// // //           ),
// // //         ),
// // //         headers: {
// // //           HttpHeaders.authorizationHeader: 'Bearer $userToken',
// // //           HttpHeaders.contentTypeHeader: "application/json"
// // //         },
// // //         body: jsonEncode({
// // //           "ClientId": clientId,
// // //           "ServiceId": 4,
// // //           "DoctorId": consultantId,
// // //           "UserId": int.tryParse(userId as String),
// // //           "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
// // //           "Day": bookingDetails.day,
// // //           "FromTime": bookingDetails.fromTime,
// // //           "ToTime": bookingDetails.toTime,
// // //           "AppoinmentDate": selectedDate
// // //         }));
// // //     _progressIndicator.hide();
// // //     if (response.statusCode == 200) {
// // //       final data = jsonDecode(response.body);
// // //       if (data["isSuccess"]) {
// // //         var bookId = data['id'];
// // //         return true;
// // //       } else {
// // //         return false;
// // //       }
// // //     }
// // //     return false;
// // //   }

// // //   void saveAppointment(ctx, dynamic amounts) async {
// // //     // setState(() {
// // //     //   isSavingAppointment = true;
// // //     // });

// // //     final splittedStr = selectedDate.split("-");

// // //     final selectedDateToSend =
// // //         "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
// // //     // show confirmation page
// // //     bool savedAppointment = await saveAppointments(
// // //       selectedSlot,
// // //       selectedProvider!,
// // //       selectedConsultant!,
// // //       selectedDateToSend,
// // //     );

// // //     setState(() {
// // //       isSavingAppointment = false;
// // //     });

// // //     if (savedAppointment) {
// // //       if (selectedPaymentMethod == PaymentMethod.advance) {
// // //         Navigator.of(context).push(
// // //           MaterialPageRoute(
// // //             builder: (ctx) {
// // //               var bookId;
// // //               return PaymentScreen(
// // //                 amount: amounts,
// // //                 id: bookId,
// // //                 sName: "Appointment",
// // //                 // coupontype: "",
// // //               );
// // //             },
// // //           ),
// // //         );
// // //       } else {
// // //         ScaffoldMessenger.of(ctx).showSnackBar(
// // //           const SnackBar(
// // //             content: Text(
// // //               "Appointment booked successfully",
// // //               style: TextStyle(
// // //                 color: Colors.white,
// // //               ),
// // //             ),
// // //             duration: Duration(
// // //               milliseconds: 2000,
// // //             ),
// // //             backgroundColor: Colors.blue,
// // //           ),
// // //         );
// // //         Navigator.pop(context);
// // //         Navigator.of(context).push(
// // //           MaterialPageRoute(
// // //             builder: (ctx) {
// // //               return BookingConfirmation();
// // //             },
// // //           ),
// // //         );
// // //       }
// // //     } else {
// // //       ScaffoldMessenger.of(ctx).showSnackBar(
// // //         const SnackBar(
// // //           content: Text(
// // //             "Appointment not booked successfully",
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           duration: Duration(
// // //             milliseconds: 2000,
// // //           ),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   @override
// // //   void initState() {
// // //     _progressIndicator = ProcessIndicatorDialog(context);
// // //     super.initState();
// // //     fetchProviderTypes();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       //
// // //       appBar: AppBar(
// // //         elevation: 0,
// // //         leading: IconButton(
// // //           onPressed: () {
// // //             Navigator.pop(context, true);
// // //           }, // Handle your on tap here.
// // //           icon: const Icon(
// // //             Icons.arrow_back_ios,
// // //             color: Colors.black,
// // //           ),
// // //         ),
// // //         backgroundColor: Color(0xfffcfcfc),
// // //         title: const Text(
// // //           'Appointment',
// // //           style: TextStyle(
// // //             fontFamily: 'OpenSans',
// // //             color: Color(0xff2e66aa),
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //         actions: <Widget>[
// // //           Padding(
// // //             padding: EdgeInsets.only(right: 20.0),
// // //             child: IconButton(
// // //               onPressed: () {
// // //                 Navigator.pushNamed(context, appointmentHistoryScreen);
// // //               },
// // //               icon: Icon(Icons.history),
// // //             ),
// // //           ),
// // //         ],
// // //         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
// // //       ),
// // //       body: SingleChildScrollView(
// // //         child: Stack(
// // //           children: [
// // //             !isSavingAppointment
// // //                 ? Container(
// // //                     child: Column(children: [
// // //                       // SERVICE PROVIDER TYPES
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 16, vertical: 10),
// // //                         child: Container(
// // //                           padding: const EdgeInsets.only(left: 16, right: 16),
// // //                           decoration: BoxDecoration(
// // //                             color: const Color(0xfff1f7ff),
// // //                             border: Border.all(color: Colors.white, width: 1),
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           child: DropdownButton(
// // //                             value: selectedProviderType,
// // //                             onChanged: (ClientTypeId) {
// // //                               setState(() {
// // //                                 // serviceProviders =[];
// // //                                 stepCount = 1;
// // //                                 allSlots = [];
// // //                                 selectedProviderType = ClientTypeId as int;
// // //                               });
// // //                               fetchServiceProviders(ClientTypeId as int);
// // //                             },
// // //                             items: providerTypes.map((providerType) {
// // //                               return DropdownMenuItem(
// // //                                 value: providerType["clientTypeId"],
// // //                                 child: Text(
// // //                                   providerType["clientTypeName"],
// // //                                   style: kApiTextstyle,
// // //                                 ),
// // //                               );
// // //                             }).toList(),
// // //                             hint: const Text(
// // //                               'Select Provider Type',
// // //                               style: kSubheadingTextstyle,
// // //                             ),
// // //                             dropdownColor: Colors.white,
// // //                             icon: Icon(Icons.arrow_drop_down),
// // //                             iconSize: 36,
// // //                             isExpanded: true,
// // //                             underline: SizedBox(),
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 18,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),

// // //                       // SERVICE PROVIDERS
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 16, vertical: 10),
// // //                         child: Container(
// // //                           padding: const EdgeInsets.only(left: 16, right: 16),
// // //                           decoration: BoxDecoration(
// // //                             color: kFaintBlue,
// // //                             border: Border.all(color: Colors.white, width: 1),
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           child: DropdownButton(
// // //                             value: selectedProvider,
// // //                             onChanged: (clientId) {
// // //                               setState(() {
// // //                                 stepCount = 2;
// // //                                 selectedProvider = clientId as int;
// // //                                 allSlots = [];
// // //                               });
// // //                               fetchConsultants(clientId as int);
// // //                             },
// // //                             items: serviceProviders.map((serviceProvider) {
// // //                               return DropdownMenuItem(
// // //                                 value: serviceProvider["clientId"],
// // //                                 child: Text(
// // //                                   serviceProvider["clientName"],
// // //                                   style: kApiTextstyle,
// // //                                 ),
// // //                               );
// // //                             }).toList(),
// // //                             hint: const Text(
// // //                               'Service Provider',
// // //                               style: kApiTextstyle,
// // //                             ),
// // //                             dropdownColor: Colors.white,
// // //                             icon: Icon(Icons.arrow_drop_down),
// // //                             iconSize: 36,
// // //                             isExpanded: true,
// // //                             underline: SizedBox(),
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 18,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),

// // //                       // CONSULTANTS
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 16, vertical: 10),
// // //                         child: Container(
// // //                           padding: const EdgeInsets.only(left: 16, right: 16),
// // //                           decoration: BoxDecoration(
// // //                             color: const Color(0xfff1f7ff),
// // //                             border: Border.all(color: Colors.white, width: 1),
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           child: DropdownButton(
// // //                             value: selectedConsultant,
// // //                             onChanged: (consultantId) async {
// // //                               setState(() {
// // //                                 stepCount = 3;
// // //                                 selectedConsultant = consultantId as int;
// // //                               });

// // //                               final consultantSlots =
// // //                                   await _appointmentController
// // //                                       .getDoctorAppointmentDetails(
// // //                                 selectedProvider as int,
// // //                                 consultantId as int,
// // //                               );

// // //                               setState(() {
// // //                                 allSlots = consultantSlots;
// // //                               });
// // //                             },
// // //                             items: consultants.map((consultant) {
// // //                               return DropdownMenuItem(
// // //                                 value: consultant["consultantId"],
// // //                                 child: Text(
// // //                                   consultant["consultantName"],
// // //                                   style: kApiTextstyle,
// // //                                 ),
// // //                               );
// // //                             }).toList(),
// // //                             hint: const Text(
// // //                               'Select Doctors',
// // //                               style: kApiTextstyle,
// // //                             ),
// // //                             dropdownColor: Colors.white,
// // //                             icon: const Icon(Icons.arrow_drop_down),
// // //                             iconSize: 36,
// // //                             isExpanded: true,
// // //                             underline: const SizedBox(),
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 18,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),

// // //                       Container(
// // //                         padding: const EdgeInsets.symmetric(
// // //                           horizontal: 0,
// // //                         ),
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             const SizedBox(
// // //                               height: 16,
// // //                             ),
// // //                             const Padding(
// // //                                 padding: EdgeInsets.symmetric(
// // //                                   horizontal: 20,
// // //                                 ),
// // //                                 child: Text(
// // //                                   'Choose a date',
// // //                                   style: TextStyle(
// // //                                     color: darkBlue,
// // //                                     fontSize: 18,
// // //                                     fontFamily: 'OpenSans',
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 )),
// // //                             const SizedBox(
// // //                               height: 16,
// // //                             ),
// // //                             Container(
// // //                                 padding: kScreenPadding,
// // //                                 child: DatePicker(
// // //                                   DateTime.now().add(
// // //                                     Duration(
// // //                                       hours: 24 - DateTime.now().hour,
// // //                                       minutes: 60 - DateTime.now().minute,
// // //                                       seconds: 60 - DateTime.now().second,
// // //                                     ),
// // //                                   ),
// // //                                   height: 100,
// // //                                   width: 60,
// // //                                   // initialSelectedDate: DateTime.now().add(
// // //                                   //   Duration(
// // //                                   //     hours: 24 - DateTime.now().hour,
// // //                                   //     minutes: 60 - DateTime.now().minute,
// // //                                   //     seconds: 60 - DateTime.now().second,
// // //                                   //   ),
// // //                                   // ),
// // //                                   daysCount: 7,
// // //                                   selectionColor: darkBlue,
// // //                                   selectedTextColor: Colors.white,
// // //                                   dateTextStyle: kBlueTextstyle,
// // //                                   onDateChange: (date) {
// // //                                     var selecteddate =
// // //                                         date.toString().split(' ').first;
// // //                                     print(selecteddate);
// // //                                     handleDateSelect(context, selecteddate);
// // //                                     // New date selected
// // //                                     // setState(() {});
// // //                                   },
// // //                                 )),
// // //                             // Container(
// // //                             //   padding: kScreenPadding,
// // //                             //   height: MediaQuery.of(context).size.height * 0.2,
// // //                             //   child: AnimatedHorizontalCalendar(
// // //                             //       selectedBoxShadow:
// // //                             //           const BoxShadow(color: kFaintBlue),
// // //                             //       tableCalenderButtonColor: darkBlue,
// // //                             //       initialDate: DateTime.now().add(
// // //                             //         Duration(
// // //                             //           hours: 24 - DateTime.now().hour,
// // //                             //           minutes: 60 - DateTime.now().minute,
// // //                             //           seconds: 60 - DateTime.now().second,
// // //                             //         ),
// // //                             //       ),
// // //                             //       lastDate: DateTime.now().add(
// // //                             //         const Duration(
// // //                             //           days: 7,
// // //                             //         ),
// // //                             //       ),
// // //                             //       date: DateTime.now().add(
// // //                             //         Duration(
// // //                             //           hours: 24 - DateTime.now().hour,
// // //                             //           minutes: 60 - DateTime.now().minute,
// // //                             //           seconds: 60 - DateTime.now().second,
// // //                             //         ),
// // //                             //       ),
// // //                             //       tableCalenderIcon: const Icon(
// // //                             //         Icons.calendar_today,
// // //                             //         color: Colors.white,
// // //                             //       ),
// // //                             //       textColor: Colors.black45,
// // //                             //       backgroundColor: kFaintBlue,
// // //                             //       tableCalenderThemeData:
// // //                             //           ThemeData.light().copyWith(
// // //                             //         primaryColor: darkBlue,
// // //                             //         buttonTheme: const ButtonThemeData(
// // //                             //           textTheme: ButtonTextTheme.primary,
// // //                             //         ),
// // //                             //         colorScheme: const ColorScheme.light(
// // //                             //           primary: darkBlue,
// // //                             //         ).copyWith(secondary: darkBlue),
// // //                             //       ),
// // //                             //       selectedColor: darkBlue,
// // //                             //       onDateSelected: (date) {
// // //                             //         print(date);
// // //                             //         handleDateSelect(context, date as String);
// // //                             //       }),
// // //                             // ),
// // //                             Container(
// // //                               padding: const EdgeInsets.symmetric(
// // //                                 horizontal: 10,
// // //                               ),
// // //                               child: Column(
// // //                                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                                 children: [
// // //                                   Container(
// // //                                     margin: const EdgeInsets.only(
// // //                                         left: 12, top: 12, bottom: 16),
// // //                                     child: const Text(
// // //                                       'Available Slots',
// // //                                       textAlign: TextAlign.start,
// // //                                       style: TextStyle(
// // //                                         color: darkBlue,
// // //                                         fontSize: 18,
// // //                                         fontFamily: 'OpenSans',
// // //                                         fontWeight: FontWeight.bold,
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                   stepCount >= 4
// // //                                       ? slotsForTheSelectedDay!.length > 0
// // //                                           ? Container(
// // //                                               child: Column(
// // //                                                 children: [
// // //                                                   Container(
// // //                                                     child: GridView.builder(
// // //                                                       shrinkWrap: true,
// // //                                                       physics: ScrollPhysics(),
// // //                                                       gridDelegate:
// // //                                                           SliverGridDelegateWithFixedCrossAxisCount(
// // //                                                         crossAxisCount: 2,
// // //                                                         crossAxisSpacing: 3,
// // //                                                         mainAxisSpacing: 3,
// // //                                                         childAspectRatio: MediaQuery
// // //                                                                     .of(context)
// // //                                                                 .size
// // //                                                                 .width /
// // //                                                             (MediaQuery.of(
// // //                                                                         context)
// // //                                                                     .size
// // //                                                                     .height /
// // //                                                                 6),
// // //                                                       ),
// // //                                                       scrollDirection:
// // //                                                           Axis.vertical,
// // //                                                       itemBuilder:
// // //                                                           (BuildContext context,
// // //                                                               index) {
// // //                                                         final currentSlot =
// // //                                                             slotsForTheSelectedDay![
// // //                                                                 index];

// // //                                                         return GestureDetector(
// // //                                                           onTap: () {
// // //                                                             setState(() {
// // //                                                               stepCount = 7;
// // //                                                               amount = selectedSlot
// // //                                                                   .appoinmentFee;
// // //                                                               showPaymentMethods =
// // //                                                                   true;
// // //                                                               selectedSlot =
// // //                                                                   BookingSlot(
// // //                                                                 slotId:
// // //                                                                     currentSlot[
// // //                                                                         "slotId"],
// // //                                                                 appoinmentConfigId:
// // //                                                                     currentSlot[
// // //                                                                         "appoinmentConfigId"],
// // //                                                                 day:
// // //                                                                     currentSlot[
// // //                                                                         "day"],
// // //                                                                 fromTime:
// // //                                                                     currentSlot[
// // //                                                                         "fromTime"],
// // //                                                                 toTime:
// // //                                                                     currentSlot[
// // //                                                                         "toTime"],
// // //                                                                 appoinmentFee:
// // //                                                                     currentSlot[
// // //                                                                         "appoinmentFee"],
// // //                                                               );
// // //                                                             });
// // //                                                           },
// // //                                                           child: Card(
// // //                                                             color: selectedSlot
// // //                                                                         .slotId ==
// // //                                                                     currentSlot[
// // //                                                                         "slotId"]
// // //                                                                 ? const Color(
// // //                                                                     0xff325CA2)
// // //                                                                 : Colors.white,
// // //                                                             child: Container(
// // //                                                               height: 200,
// // //                                                               width: 200,
// // //                                                               child: Center(
// // //                                                                 child: Text(
// // //                                                                   "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
// // //                                                                   style:
// // //                                                                       TextStyle(
// // //                                                                     color: selectedSlot.slotId ==
// // //                                                                             currentSlot[
// // //                                                                                 "slotId"]
// // //                                                                         ? Colors
// // //                                                                             .white
// // //                                                                         : Colors
// // //                                                                             .black,
// // //                                                                     fontSize:
// // //                                                                         14,
// // //                                                                     fontFamily:
// // //                                                                         'OpenSans',
// // //                                                                     fontWeight:
// // //                                                                         FontWeight
// // //                                                                             .w500,
// // //                                                                   ),
// // //                                                                 ),
// // //                                                               ),
// // //                                                             ),
// // //                                                           ),
// // //                                                         );
// // //                                                       },
// // //                                                       itemCount:
// // //                                                           slotsForTheSelectedDay ==
// // //                                                                   null
// // //                                                               ? 0
// // //                                                               : slotsForTheSelectedDay!
// // //                                                                   .length,
// // //                                                     ),
// // //                                                   ),
// // //                                                 ],
// // //                                               ),
// // //                                             )
// // //                                           : (Row(
// // //                                               mainAxisAlignment:
// // //                                                   MainAxisAlignment.start,
// // //                                               children: const [
// // //                                                 Padding(
// // //                                                   padding: EdgeInsets.symmetric(
// // //                                                     vertical: 6,
// // //                                                     horizontal: 10,
// // //                                                   ),
// // //                                                   child: Text(
// // //                                                     "No slots available for this date",
// // //                                                   ),
// // //                                                 ),
// // //                                               ],
// // //                                             ))
// // //                                       : (Row(
// // //                                           mainAxisAlignment:
// // //                                               MainAxisAlignment.start,
// // //                                           children: const [
// // //                                             Padding(
// // //                                               padding: EdgeInsets.symmetric(
// // //                                                 vertical: 6,
// // //                                                 horizontal: 10,
// // //                                               ),
// // //                                               child: Text(
// // //                                                 "Please select a date",
// // //                                               ),
// // //                                             ),
// // //                                           ],
// // //                                         )),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                             const SizedBox(
// // //                               height: 20,
// // //                             ),
// // //                             stepCount >= 6
// // //                                 ? Column(
// // //                                     crossAxisAlignment:
// // //                                         CrossAxisAlignment.start,
// // //                                     children: [
// // //                                       AppointmentSectionHeading(
// // //                                         title: "Payment Method",
// // //                                       ),
// // //                                       AppointmentFees(
// // //                                         fees: selectedSlot.appoinmentFee!,
// // //                                       ),
// // //                                       Row(
// // //                                         mainAxisAlignment:
// // //                                             MainAxisAlignment.center,
// // //                                         children: [
// // //                                           const Spacer(
// // //                                             flex: 1,
// // //                                           ),
// // //                                           Expanded(
// // //                                             flex: 4,
// // //                                             child: Row(
// // //                                               mainAxisAlignment:
// // //                                                   MainAxisAlignment
// // //                                                       .spaceBetween,
// // //                                               children: [
// // //                                                 Column(
// // //                                                   children: [
// // //                                                     Radio(
// // //                                                       value: PaymentMethod.cod,
// // //                                                       groupValue:
// // //                                                           selectedPaymentMethod,
// // //                                                       onChanged: ((value) {
// // //                                                         setState(() {
// // //                                                           selectedPaymentMethod =
// // //                                                               value
// // //                                                                   as PaymentMethod;
// // //                                                           // print(isDiabetic);
// // //                                                         });
// // //                                                       }),
// // //                                                     ),
// // //                                                     const Text(
// // //                                                       "COD",
// // //                                                       textAlign:
// // //                                                           TextAlign.center,
// // //                                                     ),
// // //                                                   ],
// // //                                                 ),
// // //                                                 Column(
// // //                                                   children: [
// // //                                                     Radio(
// // //                                                       value:
// // //                                                           PaymentMethod.advance,
// // //                                                       groupValue:
// // //                                                           selectedPaymentMethod,
// // //                                                       onChanged: ((value) {
// // //                                                         setState(() {
// // //                                                           selectedPaymentMethod =
// // //                                                               value
// // //                                                                   as PaymentMethod;
// // //                                                           // print(isDiabetic);
// // //                                                         });
// // //                                                       }),
// // //                                                     ),
// // //                                                     const Text(
// // //                                                       "ADVANCE",
// // //                                                       textAlign:
// // //                                                           TextAlign.center,
// // //                                                     ),
// // //                                                   ],
// // //                                                 ),
// // //                                               ],
// // //                                             ),
// // //                                           ),
// // //                                           const Spacer(
// // //                                             flex: 1,
// // //                                           )
// // //                                         ],
// // //                                       ),
// // //                                     ],
// // //                                   )
// // //                                 : const SizedBox(
// // //                                     height: 0,
// // //                                   ),
// // //                             const SizedBox(
// // //                               height: 20,
// // //                             ),
// // //                             stepCount == 7
// // //                                 ? Row(
// // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // //                                     children: [
// // //                                       BlueButton(
// // //                                         onPressed: () async {
// // //                                           SharedPreferences sharedPreferences =
// // //                                               await SharedPreferences
// // //                                                   .getInstance();
// // //                                           bool isPay = await sharedPreferences
// // //                                                   .getBool("isPay") ??
// // //                                               false;
// // //                                           if (isPay) {
// // //                                             saveAppointment(context,
// // //                                                 selectedSlot.appoinmentFee);
// // //                                           } else {
// // //                                             // Navigator.pushNamedAndRemoveUntil(
// // //                                             //     context,
// // //                                             //     homeFirst,
// // //                                             //     (route) => false);
// // //                                             saveAppointment(context,
// // //                                                 selectedSlot.appoinmentFee);
// // //                                           }
// // //                                         },
// // //                                         title: 'Book Appointment',
// // //                                         height: 45,
// // //                                         width: 200,
// // //                                       ),
// // //                                     ],
// // //                                   )
// // //                                 : const SizedBox(
// // //                                     height: 0,
// // //                                   ),
// // //                             const SizedBox(
// // //                               height: 32,
// // //                             ),
// // //                             // const Divider(
// // //                             //   height: 2,
// // //                             //   color: Colors.grey,
// // //                             // ),
// // //                             // const SizedBox(
// // //                             //   height: 32,
// // //                             // ),
// // //                             // SizedBox(
// // //                             //   width: double.infinity,
// // //                             //   child: Padding(
// // //                             //     padding: const EdgeInsets.all(12.0),
// // //                             //     child: ElevatedButton(
// // //                             //       child: Text("View My Appointments"),
// // //                             //       onPressed: () {},
// // //                             //     ),
// // //                             //   ),
// // //                             // ),
// // //                             const SizedBox(
// // //                               height: 32,
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ]),
// // //                   )
// // //                 : Container(
// // //                     height: MediaQuery.of(context).size.height * 0.86,
// // //                     child: Center(
// // //                       child: Wrap(
// // //                         crossAxisAlignment: WrapCrossAlignment.center,
// // //                         direction: Axis.vertical,
// // //                         children: const [
// // //                           CircularProgressIndicator(
// // //                             color: darkBlue,
// // //                           ),
// // //                           SizedBox(
// // //                             height: 24,
// // //                           ),
// // //                           Text("Saving your appointment, Please wait")
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class AppointmentSectionHeading extends StatelessWidget {
// // //   final String title;
// // //   const AppointmentSectionHeading({Key? key, required this.title})
// // //       : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(
// // //         horizontal: 10,
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Container(
// // //             margin: const EdgeInsets.only(
// // //               left: 12,
// // //               top: 12,
// // //               bottom: 10,
// // //             ),
// // //             child: Text(
// // //               title,
// // //               textAlign: TextAlign.start,
// // //               style: const TextStyle(
// // //                 color: darkBlue,
// // //                 fontSize: 18,
// // //                 fontFamily: 'OpenSans',
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class AppointmentFees extends StatelessWidget {
// // //   final double fees;
// // //   const AppointmentFees({Key? key, required this.fees}) : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         Container(
// // //           margin: const EdgeInsets.symmetric(
// // //             horizontal: 20,
// // //           ),
// // //           child: OutlinedButton(
// // //             onPressed: () {},
// // //             child: Text(
// // //               'Fees : ${fees.toString()} ₹',
// // //               style: const TextStyle(
// // //                 fontSize: 18,
// // //                 fontWeight: FontWeight.w500,
// // //                 color: darkBlue,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // //    <<<<<<<<<<<<<<<<<<< BELOW CODE IS BEFORE IMPLEMENTING NEW PACKAGE FOR HORIOZONTAL CALENDER >>>>>>>>>>>>>>>>>>>>>>>>

// // // import 'dart:convert';
// // // import 'dart:io';

// // // import 'package:Rakshan/screens/post_login/appointmenthistory.dart';
// // // import 'package:Rakshan/utills/progressIndicator.dart';
// // // //import 'package:animated_horizontal_calendar/animated_horizontal_calendar.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:Rakshan/constants/padding.dart';
// // // import 'package:Rakshan/controller/appointment_controller.dart';
// // // import 'package:Rakshan/routes/app_routes.dart';
// // // import 'package:Rakshan/screens/post_login/booking_confirmation.dart';
// // // import 'package:Rakshan/screens/post_login/home_screen.dart';
// // // import 'package:Rakshan/screens/post_login/payment.dart';
// // // import 'package:Rakshan/widgets/post_login/app_bar.dart';
// // // import 'package:Rakshan/widgets/post_login/app_menu.dart';
// // // import 'package:Rakshan/widgets/pre_login/blue_button.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../../utills/horizontalCalender.dart';
// // // import '/config/api_url_mapping.dart' as API;
// // // import 'package:http/http.dart' as http;
// // // import '../../constants/theme.dart';

// // // enum PaymentMethod { cod, advance }

// // // class BookingDetails {
// // //   String? date;
// // //   String? fromTime;
// // //   String? toTime;
// // //   int? appoinmentConfigId;
// // //   int? doctorId;
// // //   int? clientId;
// // //   String? dat;

// // //   BookingDetails({
// // //     this.date,
// // //     this.fromTime,
// // //     this.toTime,
// // //     this.appoinmentConfigId,
// // //     this.doctorId,
// // //     this.clientId,
// // //     this.dat,
// // //   });
// // // }

// // // class BookingSlot {
// // //   int? slotId;
// // //   String? day;
// // //   String? fromTime;
// // //   String? toTime;
// // //   int? appoinmentConfigId;
// // //   double? appoinmentFee;

// // //   BookingSlot({
// // //     this.slotId,
// // //     this.day,
// // //     this.fromTime,
// // //     this.toTime,
// // //     this.appoinmentConfigId,
// // //     this.appoinmentFee,
// // //   });
// // // }

// // // class Appointment extends StatefulWidget {
// // //   const Appointment(
// // //       {Key? key,
// // //       required this.sProviderTypeId,
// // //       required this.sProviderType,
// // //       required this.sService,
// // //       required this.sClientName})
// // //       : super(key: key);

// // //   final String sProviderTypeId;
// // //   final String sProviderType;
// // //   final String sService;
// // //   final String sClientName;

// // //   @override
// // //   State<Appointment> createState() => _AppointmentState();
// // // }

// // // class _AppointmentState extends State<Appointment> {
// // //   final _appointmentController = AppointmentController();
// // //   late ProcessIndicatorDialog _progressIndicator;
// // //   int selectedCard = -1;
// // //   dynamic amount = 0.0;
// // //   var bookId;
// // //   // ===============ROHIT's===================

// // //   final engDays = [
// // //     'Monday',
// // //     'Tuesday',
// // //     'Wednesday',
// // //     'Thursday',
// // //     'Friday',
// // //     'Saturday',
// // //     'Sunday',
// // //   ];

// // //   int stepCount = 0;
// // //   // selected provider Type = 1
// // //   // selected provider = 2
// // //   // selected doctor = 3
// // //   // selected date = 4
// // //   // selected slot  = 5
// // //   // selected paymentMethod  = 6
// // //   // selected doingBooking  = 7

// // //   List providerTypes = [];
// // //   int? selectedProviderType;

// // //   List serviceProviders = [];
// // //   int? selectedProvider;

// // //   List consultants = [];
// // //   int? selectedConsultant;

// // //   bool isLoading = true;

// // // // booking
// // //   bool showDates = false;
// // //   bool showSlots = false;
// // //   bool showPaymentMethods = false;
// // //   bool isSavingAppointment = false;

// // //   List allSlots = [];
// // //   List? slotsForTheSelectedDay;

// // //   String selectedDate = "";
// // //   BookingSlot selectedSlot = BookingSlot();

// // //   PaymentMethod selectedPaymentMethod = PaymentMethod.advance;

// // //   BookingDetails bookingTracker = BookingDetails();

// // //   void fetchProviderTypes() async {
// // //     final fetechedProviderTypes =
// // //         await _appointmentController.getProviderTypes();

// // //     setState(() {
// // //       stepCount = 0;
// // //       providerTypes = fetechedProviderTypes;

// // //       // set other two as empty
// // //       serviceProviders = [];
// // //       consultants = [];
// // //     });
// // //   }

// // //   void fetchServiceProviders(int ClientTypeId) async {
// // //     final fetchedServiceProvider =
// // //         await _appointmentController.getServiceProviders(ClientTypeId);

// // //     setState(() {
// // //       selectedProviderType = ClientTypeId;
// // //       serviceProviders = fetchedServiceProvider;

// // //       showDates = false;
// // //       showSlots = false;
// // //       showPaymentMethods = false;
// // //       selectedDate = "";
// // //       slotsForTheSelectedDay = null;

// // //       consultants = [];
// // //     });
// // //   }

// // //   void fetchConsultants(int clientId) async {
// // //     final fetchedConsultants =
// // //         await _appointmentController.getConsultants(clientId);

// // //     setState(() {
// // //       selectedProvider = clientId;
// // //       consultants = fetchedConsultants;
// // //       showDates = false;
// // //     });
// // //   }

// // //   void handleDateSelect(BuildContext ctx, String date) {
// // //     if (stepCount < 3) {
// // //       ScaffoldMessenger.of(ctx).showSnackBar(
// // //         const SnackBar(
// // //           content: Text(
// // //             "Please pick provider and doctor first",
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           duration: Duration(
// // //             milliseconds: 2000,
// // //           ),
// // //           backgroundColor: Colors.blue,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     final splittedStr = date.split("-");
// // //     final chosenDate = DateTime(
// // //       int.parse(splittedStr[0]),
// // //       int.parse(splittedStr[1]),
// // //       int.parse(splittedStr[2]),
// // //     );

// // //     final weekday = DateFormat("EEEE").format(chosenDate);
// // //     setState(() {
// // //       stepCount = 4;
// // //       selectedDate = date;
// // //       slotsForTheSelectedDay = findSlotsForTheSelectedDay(weekday);
// // //       selectedSlot = BookingSlot();
// // //     });

// // //     if (slotsForTheSelectedDay != null && slotsForTheSelectedDay!.length == 0) {
// // //       ScaffoldMessenger.of(ctx).showSnackBar(
// // //         const SnackBar(
// // //           content: Text(
// // //             "No slots available for this date",
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           duration: Duration(
// // //             milliseconds: 2000,
// // //           ),
// // //           backgroundColor: Colors.redAccent,
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   void handleSlotSelect(BookingSlot slot) {
// // //     if (stepCount <= 4) {
// // //       return;
// // //     }
// // //     setState(() {
// // //       stepCount = 5;
// // //     });
// // //   }

// // //   List findSlotsForTheSelectedDay(String day) {
// // //     final coppyArray = new List<Map>.from(allSlots);
// // //     coppyArray.removeWhere((slot) => slot['day'] != day);
// // //     int index = 0;
// // //     final slotsWithId = coppyArray.map((slot) {
// // //       final myMap = Map();
// // //       myMap["slotId"] = index;
// // //       myMap["appoinmentConfigId"] = slot["appoinmentConfigId"];
// // //       myMap["day"] = slot["day"];
// // //       myMap["fromTime"] = slot["fromTime"];
// // //       myMap["toTime"] = slot["toTime"];
// // //       myMap["appoinmentFee"] = slot["appoinmentFee"];
// // //       index++;
// // //       return myMap;
// // //     }).toList();
// // //     return slotsWithId;
// // //   }

// // //   Future<bool> saveAppointments(
// // //     BookingSlot bookingDetails,
// // //     int clientId,
// // //     int consultantId,
// // //     String selectedDate,
// // //   ) async {
// // //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// // //     final userToken = sharedPreferences.getString('data');
// // //     final userId = sharedPreferences.get("userId");
// // //     _progressIndicator.show();
// // //     var response = await http.post(
// // //         Uri.parse(
// // //           API.buildUrl(
// // //             API.kBookAppointment,
// // //           ),
// // //         ),
// // //         headers: {
// // //           HttpHeaders.authorizationHeader: 'Bearer $userToken',
// // //           HttpHeaders.contentTypeHeader: "application/json"
// // //         },
// // //         body: jsonEncode({
// // //           "ClientId": clientId,
// // //           "ServiceId": 4,
// // //           "DoctorId": consultantId,
// // //           "UserId": int.tryParse(userId as String),
// // //           "AppoinmentConfigId": bookingDetails.appoinmentConfigId,
// // //           "Day": bookingDetails.day,
// // //           "FromTime": bookingDetails.fromTime,
// // //           "ToTime": bookingDetails.toTime,
// // //           "AppoinmentDate": selectedDate
// // //         }));
// // //     _progressIndicator.hide();
// // //     if (response.statusCode == 200) {
// // //       final data = jsonDecode(response.body);
// // //       if (data["isSuccess"]) {
// // //         var bookId = data['id'];
// // //         return true;
// // //       } else {
// // //         return false;
// // //       }
// // //     }
// // //     return false;
// // //   }

// // //   void saveAppointment(ctx, dynamic amounts) async {
// // //     // setState(() {
// // //     //   isSavingAppointment = true;
// // //     // });

// // //     final splittedStr = selectedDate.split("-");

// // //     final selectedDateToSend =
// // //         "${int.parse(splittedStr[2])}-${int.parse(splittedStr[1])}-${int.parse(splittedStr[0])}";
// // //     // show confirmation page
// // //     bool savedAppointment = await saveAppointments(
// // //       selectedSlot,
// // //       selectedProvider!,
// // //       selectedConsultant!,
// // //       selectedDateToSend,
// // //     );

// // //     setState(() {
// // //       isSavingAppointment = false;
// // //     });

// // //     if (savedAppointment) {
// // //       if (selectedPaymentMethod == PaymentMethod.advance) {
// // //         Navigator.of(context).push(
// // //           MaterialPageRoute(
// // //             builder: (ctx) {
// // //               var bookId;
// // //               return PaymentScreen(
// // //                 amount: amounts,
// // //                 id: bookId,
// // //                 sName: "Appointment",
// // //                 // coupontype: "",
// // //               );
// // //             },
// // //           ),
// // //         );
// // //       } else {
// // //         ScaffoldMessenger.of(ctx).showSnackBar(
// // //           const SnackBar(
// // //             content: Text(
// // //               "Appointment booked successfully",
// // //               style: TextStyle(
// // //                 color: Colors.white,
// // //               ),
// // //             ),
// // //             duration: Duration(
// // //               milliseconds: 2000,
// // //             ),
// // //             backgroundColor: Colors.blue,
// // //           ),
// // //         );
// // //         Navigator.pop(context);
// // //         Navigator.of(context).push(
// // //           MaterialPageRoute(
// // //             builder: (ctx) {
// // //               return BookingConfirmation();
// // //             },
// // //           ),
// // //         );
// // //       }
// // //     } else {
// // //       ScaffoldMessenger.of(ctx).showSnackBar(
// // //         const SnackBar(
// // //           content: Text(
// // //             "Appointment not booked successfully",
// // //             style: TextStyle(
// // //               color: Colors.white,
// // //             ),
// // //           ),
// // //           duration: Duration(
// // //             milliseconds: 2000,
// // //           ),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   @override
// // //   void initState() {
// // //     _progressIndicator = ProcessIndicatorDialog(context);
// // //     super.initState();
// // //     fetchProviderTypes();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       //
// // //       appBar: AppBar(
// // //         elevation: 0,
// // //         leading: IconButton(
// // //           onPressed: () {
// // //             Navigator.pop(context, true);
// // //           }, // Handle your on tap here.
// // //           icon: const Icon(
// // //             Icons.arrow_back_ios,
// // //             color: Colors.black,
// // //           ),
// // //         ),
// // //         backgroundColor: Color(0xfffcfcfc),
// // //         title: const Text(
// // //           'Appointment',
// // //           style: TextStyle(
// // //             fontFamily: 'OpenSans',
// // //             color: Color(0xff2e66aa),
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //         actions: <Widget>[
// // //           Padding(
// // //             padding: EdgeInsets.only(right: 20.0),
// // //             child: IconButton(
// // //               onPressed: () {
// // //                 Navigator.pushNamed(context, appointmentHistoryScreen);
// // //               },
// // //               icon: Icon(Icons.history),
// // //             ),
// // //           ),
// // //         ],
// // //         iconTheme: const IconThemeData(color: Color(0xff2e66aa)),
// // //       ),
// // //       body: SingleChildScrollView(
// // //         child: Stack(
// // //           children: [
// // //             !isSavingAppointment
// // //                 ? Container(
// // //                     child: Column(children: [
// // //                       // SERVICE PROVIDER TYPES
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 16, vertical: 10),
// // //                         child: Container(
// // //                           padding: const EdgeInsets.only(left: 16, right: 16),
// // //                           decoration: BoxDecoration(
// // //                             color: const Color(0xfff1f7ff),
// // //                             border: Border.all(color: Colors.white, width: 1),
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           child: DropdownButton(
// // //                             value: selectedProviderType,
// // //                             onChanged: (ClientTypeId) {
// // //                               setState(() {
// // //                                 // serviceProviders =[];
// // //                                 stepCount = 1;
// // //                                 allSlots = [];
// // //                                 selectedProviderType = ClientTypeId as int;
// // //                               });
// // //                               fetchServiceProviders(ClientTypeId as int);
// // //                             },
// // //                             items: providerTypes.map((providerType) {
// // //                               return DropdownMenuItem(
// // //                                 value: providerType["clientTypeId"],
// // //                                 child: Text(
// // //                                   providerType["clientTypeName"],
// // //                                   style: kApiTextstyle,
// // //                                 ),
// // //                               );
// // //                             }).toList(),
// // //                             hint: const Text(
// // //                               'Select Provider Type',
// // //                               style: kSubheadingTextstyle,
// // //                             ),
// // //                             dropdownColor: Colors.white,
// // //                             icon: Icon(Icons.arrow_drop_down),
// // //                             iconSize: 36,
// // //                             isExpanded: true,
// // //                             underline: SizedBox(),
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 18,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),

// // //                       // SERVICE PROVIDERS
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 16, vertical: 10),
// // //                         child: Container(
// // //                           padding: const EdgeInsets.only(left: 16, right: 16),
// // //                           decoration: BoxDecoration(
// // //                             color: kFaintBlue,
// // //                             border: Border.all(color: Colors.white, width: 1),
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           child: DropdownButton(
// // //                             value: selectedProvider,
// // //                             onChanged: (clientId) {
// // //                               setState(() {
// // //                                 stepCount = 2;
// // //                                 selectedProvider = clientId as int;
// // //                                 allSlots = [];
// // //                               });
// // //                               fetchConsultants(clientId as int);
// // //                             },
// // //                             items: serviceProviders.map((serviceProvider) {
// // //                               return DropdownMenuItem(
// // //                                 value: serviceProvider["clientId"],
// // //                                 child: Text(
// // //                                   serviceProvider["clientName"],
// // //                                   style: kApiTextstyle,
// // //                                 ),
// // //                               );
// // //                             }).toList(),
// // //                             hint: const Text(
// // //                               'Service Provider',
// // //                               style: kApiTextstyle,
// // //                             ),
// // //                             dropdownColor: Colors.white,
// // //                             icon: Icon(Icons.arrow_drop_down),
// // //                             iconSize: 36,
// // //                             isExpanded: true,
// // //                             underline: SizedBox(),
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 18,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),

// // //                       // CONSULTANTS
// // //                       Padding(
// // //                         padding: const EdgeInsets.symmetric(
// // //                             horizontal: 16, vertical: 10),
// // //                         child: Container(
// // //                           padding: const EdgeInsets.only(left: 16, right: 16),
// // //                           decoration: BoxDecoration(
// // //                             color: const Color(0xfff1f7ff),
// // //                             border: Border.all(color: Colors.white, width: 1),
// // //                             borderRadius: BorderRadius.circular(5),
// // //                           ),
// // //                           child: DropdownButton(
// // //                             value: selectedConsultant,
// // //                             onChanged: (consultantId) async {
// // //                               setState(() {
// // //                                 stepCount = 3;
// // //                                 selectedConsultant = consultantId as int;
// // //                               });

// // //                               final consultantSlots =
// // //                                   await _appointmentController
// // //                                       .getDoctorAppointmentDetails(
// // //                                 selectedProvider as int,
// // //                                 consultantId as int,
// // //                               );

// // //                               setState(() {
// // //                                 allSlots = consultantSlots;
// // //                               });
// // //                             },
// // //                             items: consultants.map((consultant) {
// // //                               return DropdownMenuItem(
// // //                                 value: consultant["consultantId"],
// // //                                 child: Text(
// // //                                   consultant["consultantName"],
// // //                                   style: kApiTextstyle,
// // //                                 ),
// // //                               );
// // //                             }).toList(),
// // //                             hint: const Text(
// // //                               'Select Doctors',
// // //                               style: kApiTextstyle,
// // //                             ),
// // //                             dropdownColor: Colors.white,
// // //                             icon: const Icon(Icons.arrow_drop_down),
// // //                             iconSize: 36,
// // //                             isExpanded: true,
// // //                             underline: const SizedBox(),
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 18,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),

// // //                       Container(
// // //                         padding: const EdgeInsets.symmetric(
// // //                           horizontal: 0,
// // //                         ),
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             const SizedBox(
// // //                               height: 16,
// // //                             ),
// // //                             const Padding(
// // //                                 padding: EdgeInsets.symmetric(
// // //                                   horizontal: 20,
// // //                                 ),
// // //                                 child: Text(
// // //                                   'Choose a date',
// // //                                   style: TextStyle(
// // //                                     color: darkBlue,
// // //                                     fontSize: 18,
// // //                                     fontFamily: 'OpenSans',
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 )),
// // //                             const SizedBox(
// // //                               height: 16,
// // //                             ),
// // //                             Container(
// // //                               padding: kScreenPadding,
// // //                               height: MediaQuery.of(context).size.height * 0.2,
// // //                               child: AnimatedHorizontalCalendar(
// // //                                   selectedBoxShadow:
// // //                                       const BoxShadow(color: kFaintBlue),
// // //                                   tableCalenderButtonColor: darkBlue,
// // //                                   initialDate: DateTime.now().add(
// // //                                     Duration(
// // //                                       hours: 24 - DateTime.now().hour,
// // //                                       minutes: 60 - DateTime.now().minute,
// // //                                       seconds: 60 - DateTime.now().second,
// // //                                     ),
// // //                                   ),
// // //                                   lastDate: DateTime.now().add(
// // //                                     const Duration(
// // //                                       days: 7,
// // //                                     ),
// // //                                   ),
// // //                                   date: DateTime.now().add(
// // //                                     Duration(
// // //                                       hours: 24 - DateTime.now().hour,
// // //                                       minutes: 60 - DateTime.now().minute,
// // //                                       seconds: 60 - DateTime.now().second,
// // //                                     ),
// // //                                   ),
// // //                                   tableCalenderIcon: const Icon(
// // //                                     Icons.calendar_today,
// // //                                     color: Colors.white,
// // //                                   ),
// // //                                   textColor: Colors.black45,
// // //                                   backgroundColor: kFaintBlue,
// // //                                   tableCalenderThemeData:
// // //                                       ThemeData.light().copyWith(
// // //                                     primaryColor: darkBlue,
// // //                                     buttonTheme: const ButtonThemeData(
// // //                                       textTheme: ButtonTextTheme.primary,
// // //                                     ),
// // //                                     colorScheme: const ColorScheme.light(
// // //                                       primary: darkBlue,
// // //                                     ).copyWith(secondary: darkBlue),
// // //                                   ),
// // //                                   selectedColor: darkBlue,
// // //                                   onDateSelected: (date) {
// // //                                     handleDateSelect(context, date as String);
// // //                                   }),
// // //                             ),
// // //                             Container(
// // //                               padding: const EdgeInsets.symmetric(
// // //                                 horizontal: 10,
// // //                               ),
// // //                               child: Column(
// // //                                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                                 children: [
// // //                                   Container(
// // //                                     margin: const EdgeInsets.only(
// // //                                         left: 12, top: 12, bottom: 16),
// // //                                     child: const Text(
// // //                                       'Available Slots',
// // //                                       textAlign: TextAlign.start,
// // //                                       style: TextStyle(
// // //                                         color: darkBlue,
// // //                                         fontSize: 18,
// // //                                         fontFamily: 'OpenSans',
// // //                                         fontWeight: FontWeight.bold,
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                   stepCount >= 4
// // //                                       ? slotsForTheSelectedDay!.length > 0
// // //                                           ? Container(
// // //                                               child: Column(
// // //                                                 children: [
// // //                                                   Container(
// // //                                                     child: GridView.builder(
// // //                                                       shrinkWrap: true,
// // //                                                       physics: ScrollPhysics(),
// // //                                                       gridDelegate:
// // //                                                           SliverGridDelegateWithFixedCrossAxisCount(
// // //                                                         crossAxisCount: 2,
// // //                                                         crossAxisSpacing: 3,
// // //                                                         mainAxisSpacing: 3,
// // //                                                         childAspectRatio: MediaQuery
// // //                                                                     .of(context)
// // //                                                                 .size
// // //                                                                 .width /
// // //                                                             (MediaQuery.of(
// // //                                                                         context)
// // //                                                                     .size
// // //                                                                     .height /
// // //                                                                 6),
// // //                                                       ),
// // //                                                       scrollDirection:
// // //                                                           Axis.vertical,
// // //                                                       itemBuilder:
// // //                                                           (BuildContext context,
// // //                                                               index) {
// // //                                                         final currentSlot =
// // //                                                             slotsForTheSelectedDay![
// // //                                                                 index];

// // //                                                         return GestureDetector(
// // //                                                           onTap: () {
// // //                                                             setState(() {
// // //                                                               stepCount = 7;
// // //                                                               amount = selectedSlot
// // //                                                                   .appoinmentFee;
// // //                                                               showPaymentMethods =
// // //                                                                   true;
// // //                                                               selectedSlot =
// // //                                                                   BookingSlot(
// // //                                                                 slotId:
// // //                                                                     currentSlot[
// // //                                                                         "slotId"],
// // //                                                                 appoinmentConfigId:
// // //                                                                     currentSlot[
// // //                                                                         "appoinmentConfigId"],
// // //                                                                 day:
// // //                                                                     currentSlot[
// // //                                                                         "day"],
// // //                                                                 fromTime:
// // //                                                                     currentSlot[
// // //                                                                         "fromTime"],
// // //                                                                 toTime:
// // //                                                                     currentSlot[
// // //                                                                         "toTime"],
// // //                                                                 appoinmentFee:
// // //                                                                     currentSlot[
// // //                                                                         "appoinmentFee"],
// // //                                                               );
// // //                                                             });
// // //                                                           },
// // //                                                           child: Card(
// // //                                                             color: selectedSlot
// // //                                                                         .slotId ==
// // //                                                                     currentSlot[
// // //                                                                         "slotId"]
// // //                                                                 ? const Color(
// // //                                                                     0xff325CA2)
// // //                                                                 : Colors.white,
// // //                                                             child: Container(
// // //                                                               height: 200,
// // //                                                               width: 200,
// // //                                                               child: Center(
// // //                                                                 child: Text(
// // //                                                                   "${currentSlot["fromTime"]} - ${currentSlot["toTime"]}",
// // //                                                                   style:
// // //                                                                       TextStyle(
// // //                                                                     color: selectedSlot.slotId ==
// // //                                                                             currentSlot[
// // //                                                                                 "slotId"]
// // //                                                                         ? Colors
// // //                                                                             .white
// // //                                                                         : Colors
// // //                                                                             .black,
// // //                                                                     fontSize:
// // //                                                                         14,
// // //                                                                     fontFamily:
// // //                                                                         'OpenSans',
// // //                                                                     fontWeight:
// // //                                                                         FontWeight
// // //                                                                             .w500,
// // //                                                                   ),
// // //                                                                 ),
// // //                                                               ),
// // //                                                             ),
// // //                                                           ),
// // //                                                         );
// // //                                                       },
// // //                                                       itemCount:
// // //                                                           slotsForTheSelectedDay ==
// // //                                                                   null
// // //                                                               ? 0
// // //                                                               : slotsForTheSelectedDay!
// // //                                                                   .length,
// // //                                                     ),
// // //                                                   ),
// // //                                                 ],
// // //                                               ),
// // //                                             )
// // //                                           : (Row(
// // //                                               mainAxisAlignment:
// // //                                                   MainAxisAlignment.start,
// // //                                               children: const [
// // //                                                 Padding(
// // //                                                   padding: EdgeInsets.symmetric(
// // //                                                     vertical: 6,
// // //                                                     horizontal: 10,
// // //                                                   ),
// // //                                                   child: Text(
// // //                                                     "No slots available for this date",
// // //                                                   ),
// // //                                                 ),
// // //                                               ],
// // //                                             ))
// // //                                       : (Row(
// // //                                           mainAxisAlignment:
// // //                                               MainAxisAlignment.start,
// // //                                           children: const [
// // //                                             Padding(
// // //                                               padding: EdgeInsets.symmetric(
// // //                                                 vertical: 6,
// // //                                                 horizontal: 10,
// // //                                               ),
// // //                                               child: Text(
// // //                                                 "Please select a date",
// // //                                               ),
// // //                                             ),
// // //                                           ],
// // //                                         )),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                             const SizedBox(
// // //                               height: 20,
// // //                             ),
// // //                             stepCount >= 6
// // //                                 ? Column(
// // //                                     crossAxisAlignment:
// // //                                         CrossAxisAlignment.start,
// // //                                     children: [
// // //                                       AppointmentSectionHeading(
// // //                                         title: "Payment Method",
// // //                                       ),
// // //                                       AppointmentFees(
// // //                                         fees: selectedSlot.appoinmentFee!,
// // //                                       ),
// // //                                       Row(
// // //                                         mainAxisAlignment:
// // //                                             MainAxisAlignment.center,
// // //                                         children: [
// // //                                           const Spacer(
// // //                                             flex: 1,
// // //                                           ),
// // //                                           Expanded(
// // //                                             flex: 4,
// // //                                             child: Row(
// // //                                               mainAxisAlignment:
// // //                                                   MainAxisAlignment
// // //                                                       .spaceBetween,
// // //                                               children: [
// // //                                                 Column(
// // //                                                   children: [
// // //                                                     Radio(
// // //                                                       value: PaymentMethod.cod,
// // //                                                       groupValue:
// // //                                                           selectedPaymentMethod,
// // //                                                       onChanged: ((value) {
// // //                                                         setState(() {
// // //                                                           selectedPaymentMethod =
// // //                                                               value
// // //                                                                   as PaymentMethod;
// // //                                                           // print(isDiabetic);
// // //                                                         });
// // //                                                       }),
// // //                                                     ),
// // //                                                     const Text(
// // //                                                       "COD",
// // //                                                       textAlign:
// // //                                                           TextAlign.center,
// // //                                                     ),
// // //                                                   ],
// // //                                                 ),
// // //                                                 Column(
// // //                                                   children: [
// // //                                                     Radio(
// // //                                                       value:
// // //                                                           PaymentMethod.advance,
// // //                                                       groupValue:
// // //                                                           selectedPaymentMethod,
// // //                                                       onChanged: ((value) {
// // //                                                         setState(() {
// // //                                                           selectedPaymentMethod =
// // //                                                               value
// // //                                                                   as PaymentMethod;
// // //                                                           // print(isDiabetic);
// // //                                                         });
// // //                                                       }),
// // //                                                     ),
// // //                                                     const Text(
// // //                                                       "ADVANCE",
// // //                                                       textAlign:
// // //                                                           TextAlign.center,
// // //                                                     ),
// // //                                                   ],
// // //                                                 ),
// // //                                               ],
// // //                                             ),
// // //                                           ),
// // //                                           const Spacer(
// // //                                             flex: 1,
// // //                                           )
// // //                                         ],
// // //                                       ),
// // //                                     ],
// // //                                   )
// // //                                 : const SizedBox(
// // //                                     height: 0,
// // //                                   ),
// // //                             const SizedBox(
// // //                               height: 20,
// // //                             ),
// // //                             stepCount == 7
// // //                                 ? Row(
// // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // //                                     children: [
// // //                                       BlueButton(
// // //                                         onPressed: () async {
// // //                                           SharedPreferences sharedPreferences =
// // //                                               await SharedPreferences
// // //                                                   .getInstance();
// // //                                           bool isPay = await sharedPreferences
// // //                                                   .getBool("isPay") ??
// // //                                               false;
// // //                                           if (isPay) {
// // //                                             saveAppointment(context,
// // //                                                 selectedSlot.appoinmentFee);
// // //                                           } else {
// // //                                             // Navigator.pushNamedAndRemoveUntil(
// // //                                             //     context,
// // //                                             //     homeFirst,
// // //                                             //     (route) => false);
// // //                                             saveAppointment(context,
// // //                                                 selectedSlot.appoinmentFee);
// // //                                           }
// // //                                         },
// // //                                         title: 'Book Appointment',
// // //                                         height: 45,
// // //                                         width: 200,
// // //                                       ),
// // //                                     ],
// // //                                   )
// // //                                 : const SizedBox(
// // //                                     height: 0,
// // //                                   ),
// // //                             const SizedBox(
// // //                               height: 32,
// // //                             ),
// // //                             // const Divider(
// // //                             //   height: 2,
// // //                             //   color: Colors.grey,
// // //                             // ),
// // //                             // const SizedBox(
// // //                             //   height: 32,
// // //                             // ),
// // //                             // SizedBox(
// // //                             //   width: double.infinity,
// // //                             //   child: Padding(
// // //                             //     padding: const EdgeInsets.all(12.0),
// // //                             //     child: ElevatedButton(
// // //                             //       child: Text("View My Appointments"),
// // //                             //       onPressed: () {},
// // //                             //     ),
// // //                             //   ),
// // //                             // ),
// // //                             const SizedBox(
// // //                               height: 32,
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ]),
// // //                   )
// // //                 : Container(
// // //                     height: MediaQuery.of(context).size.height * 0.86,
// // //                     child: Center(
// // //                       child: Wrap(
// // //                         crossAxisAlignment: WrapCrossAlignment.center,
// // //                         direction: Axis.vertical,
// // //                         children: const [
// // //                           CircularProgressIndicator(
// // //                             color: darkBlue,
// // //                           ),
// // //                           SizedBox(
// // //                             height: 24,
// // //                           ),
// // //                           Text("Saving your appointment, Please wait")
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class AppointmentSectionHeading extends StatelessWidget {
// // //   final String title;
// // //   const AppointmentSectionHeading({Key? key, required this.title})
// // //       : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(
// // //         horizontal: 10,
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Container(
// // //             margin: const EdgeInsets.only(
// // //               left: 12,
// // //               top: 12,
// // //               bottom: 10,
// // //             ),
// // //             child: Text(
// // //               title,
// // //               textAlign: TextAlign.start,
// // //               style: const TextStyle(
// // //                 color: darkBlue,
// // //                 fontSize: 18,
// // //                 fontFamily: 'OpenSans',
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // class AppointmentFees extends StatelessWidget {
// // //   final double fees;
// // //   const AppointmentFees({Key? key, required this.fees}) : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         Container(
// // //           margin: const EdgeInsets.symmetric(
// // //             horizontal: 20,
// // //           ),
// // //           child: OutlinedButton(
// // //             onPressed: () {},
// // //             child: Text(
// // //               'Fees : ${fees.toString()} ₹',
// // //               style: const TextStyle(
// // //                 fontSize: 18,
// // //                 fontWeight: FontWeight.w500,
// // //                 color: darkBlue,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }
