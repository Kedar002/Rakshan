import 'package:flutter/material.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';

import '../../../widgets/post_login/app_bar.dart';
import '../../../widgets/pre_login/blue_button.dart';

class firstPage extends StatelessWidget {
  static String id = 'first_screen';

  get kScreenPadding => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Whose Health are you Managing ?',
                    style: TextStyle(
                      fontSize: 20,
                    ),
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
                padding: EdgeInsets.only(left: 80, right: 80),
                child: ListView(
                  padding: kScreenPadding,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 24.0,
                        ),
                        TextButton(
                          child: const Text(
                            'My Health',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                decoration: TextDecoration.underline,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, medicineReasonScreen);
                            Navigator.pushNamed(context, prescriptionScreen);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.group_sharp,
                          size: 24.0,
                        ),
                        TextButton(
                          child: const Text(
                            'Family Member\'s Health',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                decoration: TextDecoration.underline,
                                color: Colors.black),
                          ),
                          onPressed: () {
                            //Navigator.pushNamed(context, medicineReasonScreen);
                            Navigator.pushNamed(context, prescriptionScreen);
                          },
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );

    // Scaffold(
    //
    //   appBar: AppBarIndividual(title: 'Rakshan'),
    //   body: Column(children: [
    //     Container(
    //       alignment: Alignment.center,
    //       height: MediaQuery.of(context).size.height * 0.1,
    //       width: MediaQuery.of(context).size.width * 1,
    //       decoration: const BoxDecoration(
    //         color: Color(0xff82B445),
    //       ),
    //       child: Text('Whose health are you Managing ?'),
    //     ),
    //     Container(
    //       color: const Color(0xff82B445),
    //       child: Container(
    //         decoration: const BoxDecoration(
    //             border: Border.symmetric(),
    //             borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
    //             color: Color(0xffFBFBFB)),
    //         padding: const EdgeInsets.only(left: 70, right: 70),
    //         alignment: Alignment.centerLeft,
    //         height: MediaQuery.of(context).size.height * 0.1,
    //         width: MediaQuery.of(context).size.width * 1,
    //         child: Row(
    //           children: [
    //             const Icon(
    //               Icons.person,
    //               size: 24.0,
    //             ),
    //             TextButton(
    //               child: const Text(
    //                 'My Health',
    //                 style: TextStyle(
    //                     fontFamily: 'OpenSans',
    //                     decoration: TextDecoration.underline,
    //                     color: Colors.black),
    //               ),
    //               onPressed: () {
    //                 // Navigator.pushNamed(context, medicineReasonScreen);
    //                 Navigator.pushNamed(context, prescriptionScreen);
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     Container(
    //       // color: Color(0xffffff),
    //       padding: const EdgeInsets.only(left: 70),
    //       alignment: Alignment.centerLeft,
    //       height: MediaQuery.of(context).size.height * 0.1,
    //       width: MediaQuery.of(context).size.width * 1,
    //       child: Row(
    //         children: [
    //           const Icon(
    //             Icons.group_sharp,
    //             size: 24.0,
    //           ),
    //           TextButton(
    //             child: const Text(
    //               'Family Member\'s Health',
    //               style: TextStyle(
    //                   fontFamily: 'OpenSans',
    //                   decoration: TextDecoration.underline,
    //                   color: Colors.black),
    //             ),
    //             onPressed: () {
    //               //Navigator.pushNamed(context, medicineReasonScreen);
    //               Navigator.pushNamed(context, prescriptionScreen);
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ]),
    // );
  }
}
