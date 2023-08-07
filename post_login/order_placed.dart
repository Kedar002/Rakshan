import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/wallet.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';

class OrderPlaced extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'Order Placed'),
      body: Container(
        padding: kScreenPadding,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 20.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 40,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Order Placed Sucesesfully',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        color: darkBlue,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 25),
                            Text(
                              'Order ID: ',
                              style: kGreyTextcolor(),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '#OTA5684214',
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ), //1st part
                        Row(
                          children: [
                            SizedBox(width: 25),
                            Text(
                              'Order Amount: ',
                              style: kGreyTextcolor(),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '₹4689',
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          thickness: 0.6, // thickness of the line.
                          indent:
                              20, // empty space to the leading edge of divider.
                          endIndent:
                              20, // empty space to the trailing edge of the divider.
                          color: Color(0xff75788a),
                          height: 20, // The divider's height extent.
                        ),
                      ],
                    ),
                    Text(
                      'A confirmation message has been sent to',
                      style: kGreyTextcolor(),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      '+91 9999888811',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 160,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, wallet);
                  },
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  label: Text("Wallet"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    primary: darkBlue,
                    textStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 15),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  TextStyle kGreyTextcolor() => TextStyle(color: Color(0xff75788a));
}
