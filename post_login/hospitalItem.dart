import 'package:Rakshan/constants/api.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/models/GetHomeModelNested.dart';
import 'package:Rakshan/screens/post_login/appointment.dart';
import 'package:Rakshan/screens/post_login/claim_process_ipd.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalItem extends StatelessWidget {
  final HospitalData hospitalData;

  const HospitalItem(this.hospitalData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Card(
        elevation: 0,
        child: ExpansionTile(
          title: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  // color: Colors.black,
                  padding: const EdgeInsets.only(right: 5),
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: hospitalData.clientLogo != null
                          ? Image.network(
                              '$BASE_URL/${hospitalData.clientLogo}')
                          : const Center(child: Text("No image"))),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    ('${hospitalData.clientName}'),
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // title: Padding(
          //   padding: const EdgeInsets.only(top: 8),
          //   child: Text(
          //     ('${hospitalData.clientName}'),
          //     style: const TextStyle(
          //       fontSize: 17.0,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          subtitle: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      textAlign: TextAlign.justify,
                      ('${hospitalData.address}'),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  await canLaunch('tel: ${hospitalData.contactNumber}')
                      ? await launch('tel: ${hospitalData.contactNumber}')
                      : throw 'Could not launch';
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      ('${hospitalData.contactNumber}'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: <Widget>[
            hospitalData.servicesList!.length == 1
                ? Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * .35,
                      maxWidth: double.infinity,
                    ),
                    width: double.infinity,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: hospitalData.servicesList!.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {},
                            title: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    child: Divider(
                                      color: darkBlue,
                                      thickness: 0.2,
                                    ),
                                  ),
                                  //CLAIM PROCESS AND BOOK APPOINTMENT
                                  const SizedBox(height: 7),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Service Name   ',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.0),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          ('${hospitalData.servicesList![i].serviceName}'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: 14.0),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  hospitalData.servicesList![i]
                                              .instantDiscount ==
                                          0.0
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Instant Discount',
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0),
                                            ),
                                            Text(
                                              '${hospitalData.servicesList![i].instantDiscount} %',
                                              style: const TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                  const SizedBox(height: 7),
                                  hospitalData.servicesList![i]
                                              .cashbackDiscount ==
                                          0.0
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Cashback Discount',
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0),
                                            ),

                                            //  claim button goes here
                                            Row(
                                              children: [
                                                Text(
                                                  'Upto ${hospitalData.servicesList![i].cashbackDiscount} %',
                                                  //instantDis is actually cashback dis and vice versa.
                                                  style: const TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 14.0),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: (() {
                                                    print(
                                                        'Service ID from 1 - ${hospitalData.servicesList![i].serviceId.toString()},');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ClaimProcessIPD(
                                                          sProviderTypeId: int
                                                              .parse(hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .clientTypeId
                                                                  .toString()),
                                                          //in 1st dropdownn
                                                          sClientId: int.parse(
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .clientId
                                                                  .toString()),
                                                          //2nd dropdown
                                                          sServiceNameId: int
                                                              .parse(hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceId
                                                                  .toString()),
                                                          //3rd dropdown
                                                          sClientTypeName:
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .clientType
                                                                  .toString(),
                                                          // in 1st drop hint
                                                          sClientName:
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .clientName
                                                                  .toString(),
                                                          // in 2nd drop hint
                                                          sServiceName:
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceName
                                                                  .toString(),
                                                          //in 3rd dropdown hint
                                                          nInstantDiscount:
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .instantDiscount
                                                                  .toString(),
                                                          nCashbackDiscount:
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .cashbackDiscount
                                                                  .toString(),
                                                          sServiceType:
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceType
                                                                  .toString(),
                                                          nServiceId: int.parse(
                                                              hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceId
                                                                  .toString()),
                                                          sAmount: '',
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                  child: const Text(
                                                    'Claim >',
                                                    style: kBlueTextstyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: (() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Appointment(
                                                sClientTypeName: hospitalData
                                                    .servicesList![i].clientType
                                                    .toString(),
                                                //1st drop hint
                                                sProviderTypeId: int.parse(
                                                    hospitalData
                                                        .servicesList![i]
                                                        .clientTypeId
                                                        .toString()),
                                                //in 1st drop
                                                sClientId: int.parse(
                                                    hospitalData
                                                        .servicesList![i]
                                                        .clientId
                                                        .toString()),
                                                // in 2nd drop
                                                sClientName: hospitalData
                                                    .servicesList![i].clientName
                                                    .toString(),
                                                //2nd drop hint
                                                sServiceNameId: int.parse(
                                                    hospitalData
                                                        .servicesList![i]
                                                        .serviceId
                                                        .toString()), //this will go directly to save appointment api
                                              ),
                                            ),
                                          );
                                        }),
                                        child: const Text(
                                          'Book Appointment',
                                          style: kBlueTextstyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : hospitalData.servicesList!.length == 2
                    ? Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * .25,
                          maxWidth: double.infinity,
                        ),
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: hospitalData.servicesList!.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {},
                                title: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        child: Divider(
                                          color: darkBlue,
                                          thickness: 0.2,
                                        ),
                                      ),
                                      //CLAIM PROCESS AND BOOK APPOINTMENT

                                      const SizedBox(height: 7),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Service Name   ',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.0),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              ('${hospitalData.servicesList![i].serviceName}'),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 7),
                                      hospitalData.servicesList![i]
                                                  .instantDiscount ==
                                              0.0
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Instant Discount',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14.0),
                                                ),
                                                Text(
                                                  '${hospitalData.servicesList![i].instantDiscount} %',
                                                  style: const TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                      const SizedBox(height: 7),
                                      hospitalData.servicesList![i]
                                                  .cashbackDiscount ==
                                              0.0
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Cashback Discount',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14.0),
                                                ),

                                                //  claim button goes here
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Upto ${hospitalData.servicesList![i].cashbackDiscount} %',
                                                      //instantDis is actually cashback dis and vice versa.
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 14.0),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: (() {
                                                        print(
                                                            'Service ID from 2- ${hospitalData.servicesList![i].serviceId},');
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ClaimProcessIPD(
                                                              sProviderTypeId: int
                                                                  .parse(hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .clientTypeId
                                                                      .toString()),
                                                              //in 1st dropdownn
                                                              sClientId: int.parse(
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .clientId
                                                                      .toString()),
                                                              //2nd dropdown
                                                              sServiceNameId: int
                                                                  .parse(hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .serviceId
                                                                      .toString()),
                                                              //3rd dropdown
                                                              sClientTypeName:
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .clientType
                                                                      .toString(),
                                                              // in 1st drop hint
                                                              sClientName: hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .clientName
                                                                  .toString(),
                                                              // in 2nd drop hint
                                                              sServiceName: hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceName
                                                                  .toString(),
                                                              //in 3rd dropdown hint
                                                              nInstantDiscount:
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .instantDiscount
                                                                      .toString(),
                                                              nCashbackDiscount:
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .cashbackDiscount
                                                                      .toString(),
                                                              sServiceType: hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceType
                                                                  .toString(),
                                                              nServiceId: int.parse(
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .serviceId
                                                                      .toString()),
                                                              sAmount: '',
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                      child: const Text(
                                                        'Claim >',
                                                        style: kBlueTextstyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (() {
                                              print(hospitalData
                                                  .servicesList![i].clientType
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].clientTypeId
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].clientId
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].clientName
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].serviceId
                                                  .toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Appointment(
                                                    sClientTypeName:
                                                        hospitalData
                                                            .servicesList![i]
                                                            .clientType
                                                            .toString(),
                                                    //1st drop hint
                                                    sProviderTypeId: int.parse(
                                                        hospitalData
                                                            .servicesList![i]
                                                            .clientTypeId
                                                            .toString()),
                                                    //in 1st drop
                                                    sClientId: int.parse(
                                                        hospitalData
                                                            .servicesList![i]
                                                            .clientId
                                                            .toString()),
                                                    // in 2nd drop
                                                    sClientName: hospitalData
                                                        .servicesList![i]
                                                        .clientName
                                                        .toString(),
                                                    //2nd drop hint
                                                    sServiceNameId: int.parse(
                                                        hospitalData
                                                            .servicesList![i]
                                                            .serviceId
                                                            .toString()), //this will go directly to save appointment api
                                                  ),
                                                ),
                                              );
                                            }),
                                            child: const Text(
                                              'Book Appointment',
                                              style: kBlueTextstyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    : Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * .35,
                          maxWidth: double.infinity,
                        ),
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: hospitalData.servicesList!.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {},
                                title: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        child: Divider(
                                          color: darkBlue,
                                          thickness: 0.2,
                                        ),
                                      ),
                                      //CLAIM PROCESS AND BOOK APPOINTMENT

                                      const SizedBox(height: 7),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Service Name   ',
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.0),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              ('${hospitalData.servicesList![i].serviceName}'),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 14.0),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 7),
                                      hospitalData.servicesList![i]
                                                  .instantDiscount ==
                                              0.0
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Instant Discount',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14.0),
                                                ),
                                                Text(
                                                  '${hospitalData.servicesList![i].instantDiscount} %',
                                                  style: const TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 14.0),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                      const SizedBox(height: 7),
                                      hospitalData.servicesList![i]
                                                  .cashbackDiscount ==
                                              0.0
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Cashback Discount',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14.0),
                                                ),

                                                //  claim button goes here
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Upto ${hospitalData.servicesList![i].cashbackDiscount} %',
                                                      //instantDis is actually cashback dis and vice versa.
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 14.0),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: (() {
                                                        print(
                                                            'Service ID from 3- ${hospitalData.servicesList![i].serviceId.toString()},');
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ClaimProcessIPD(
                                                              sProviderTypeId: int
                                                                  .parse(hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .clientTypeId
                                                                      .toString()),
                                                              //in 1st dropdownn
                                                              sClientId: int.parse(
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .clientId
                                                                      .toString()),
                                                              //2nd dropdown
                                                              sServiceNameId: int
                                                                  .parse(hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .serviceId
                                                                      .toString()),
                                                              //3rd dropdown
                                                              sClientTypeName:
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .clientType
                                                                      .toString(),
                                                              // in 1st drop hint
                                                              sClientName: hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .clientName
                                                                  .toString(),
                                                              // in 2nd drop hint
                                                              sServiceName: hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceName
                                                                  .toString(),
                                                              //in 3rd dropdown hint
                                                              nInstantDiscount:
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .instantDiscount
                                                                      .toString(),
                                                              nCashbackDiscount:
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .cashbackDiscount
                                                                      .toString(),
                                                              sServiceType: hospitalData
                                                                  .servicesList![
                                                                      i]
                                                                  .serviceType
                                                                  .toString(),
                                                              nServiceId: int.parse(
                                                                  hospitalData
                                                                      .servicesList![
                                                                          i]
                                                                      .serviceId
                                                                      .toString()),
                                                              sAmount: '',
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                      child: const Text(
                                                        'Claim >',
                                                        style: kBlueTextstyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (() {
                                              print(hospitalData
                                                  .servicesList![i].clientType
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].clientTypeId
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].clientId
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].clientName
                                                  .toString());
                                              print(hospitalData
                                                  .servicesList![i].serviceId
                                                  .toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Appointment(
                                                    sClientTypeName:
                                                        hospitalData
                                                            .servicesList![i]
                                                            .clientType
                                                            .toString(),
                                                    //1st drop hint
                                                    sProviderTypeId: int.parse(
                                                        hospitalData
                                                            .servicesList![i]
                                                            .clientTypeId
                                                            .toString()),
                                                    //in 1st drop
                                                    sClientId: int.parse(
                                                        hospitalData
                                                            .servicesList![i]
                                                            .clientId
                                                            .toString()),
                                                    // in 2nd drop
                                                    sClientName: hospitalData
                                                        .servicesList![i]
                                                        .clientName
                                                        .toString(),
                                                    //2nd drop hint
                                                    sServiceNameId: int.parse(
                                                        hospitalData
                                                            .servicesList![i]
                                                            .serviceId
                                                            .toString()),
                                                    //this will go directly to save appointment api
                                                  ),
                                                ),
                                              );
                                            }),
                                            child: const Text(
                                              'Book Appointment',
                                              style: kBlueTextstyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
          ],
        ),
      ),
    );
  }
}
