import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/controller/filtercotroller.dart';
import 'package:Rakshan/controller/homeclasscontroller.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';
import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // final _homekey = HomeClassController();

  final getFilterData = FilterController();
  final _claim = HomeClassController();
  String? valueServiceProvideId; //to home
  String? valueServiceProvideName;
  String? valueServiceName;
  String? valueService;
  var valueCity; //to home
  var valueState; //to home

  List documentTypes = [];
  List clientType = [];
  List serviceType = [];
  List documentTypes1 = [];
  List citi = [];
  List states = [];
  bool _isloading = true;

  @override
  void initState() {
    getStateList();
    getCityList();
    fetchDocumentTypes();

    super.initState();
  }

  getStateList() async {
    final _states = await getFilterData.getState().whenComplete(() {
      setState(() {
        _isloading = false;
      });
    });
    setState(() {
      states = _states;
    });
  }

  getCityList() async {
    final _city = await getFilterData.getCity().whenComplete(() {
      setState(() {
        _isloading = false;
      });
    });
    setState(() {
      citi = _city;
    });
  }

  void fetchDocumentTypes() async {
    final fetchedclientType = await _claim.getClientType().whenComplete(() {
      setState(() {
        _isloading = false;
      });
    });
    setState(() {
      documentTypes1 = documentTypes.toSet().toList();
      clientType = fetchedclientType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIndividual(
        title: 'Filter',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Color(0xfff1f7ff),
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                // create date selector for claim date and also onclick pop for claiment name.
                child: DropdownButton(
                  hint: Text(
                    'Select State',
                    style: kSubheadingTextstyle,
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
                  value: valueState,
                  onChanged: (newValue) {
                    setState(() {
                      valueState = newValue.toString();
                    });
                  },
                  items: states.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem['stateId'].toString(),
                      child: Text(
                        valueItem['stateName'],
                        style: kApiTextstyle,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Color(0xfff1f7ff),
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                // create date selector for claim date and also onclick pop for claiment name.
                child: DropdownButton(
                  hint: Text(
                    'Select City',
                    style: kSubheadingTextstyle,
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
                  value: valueCity,
                  onChanged: (newValue) {
                    setState(() {
                      valueCity = newValue.toString();
                    });
                  },
                  items: citi.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem['cityId'].toString(),
                      child: Text(
                        valueItem['cityName'],
                        style: kApiTextstyle,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            //extract padding to create this repeatative code in one reuseable widget.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.white, width: 1),
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
                      value: valueItem['clientTypeId'].toString(),
                      child: Text(
                        valueItem['clientTypeName'].toString(),
                        style: kApiTextstyle,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    setState(() {
                      valueServiceProvideId = newValue as String?;
                      _isloading = true;
                    });

                    final serviceProviders =
                        await _claim.getFilterService(newValue.toString());

                    setState(() {
                      documentTypes1 = serviceProviders;
                      _isloading = false;
                    });
                  },
                ),
              ),
            ),
            //1st part
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.white, width: 1),
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
                  value: valueServiceName,
                  onChanged: (newValue) async {
                    final discoutPrice = await _claim
                        .getFilterService(newValue.toString())
                        .whenComplete(() {
                      setState(() {
                        _isloading = false;
                      });
                      valueServiceName = newValue as String?;
                      // documentTypes1 =
                    });

                    final services =
                        await _claim.getServices(newValue.toString());
                    setState(() {
                      serviceType = services;
                    });
                  },
                  items: documentTypes1
                      .map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem["clientId"].toString(),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    hint: const Text('Services', style: kSubheadingTextstyle),
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
                      setState(() {
                        valueService = value as String;
                      });
                    }),
                    items: serviceType
                        .map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem["serviceId"].toString(),
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
            //break

            BlueButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, homescreen);
                },
                title: 'Apply Filter',
                height: 50,
                width: 125),
          ],
        ),
      ),
    );
  }
}
