import 'package:flutter/material.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/blue_button.dart';

import '../../routes/app_routes.dart';

class WalletMessage extends StatelessWidget {
  const WalletMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: '#101'),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              height: 180,
              width: 305,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("assets/images/walletMessage.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Congratulations!',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'You have saved Rs. 15,000, also Rs. 100 is added to your Metier Wallet.',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 20)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            BlueButton(
                onPressed: () {
                  Navigator.pushNamed(context, wallet);
                },
                title: 'My Wallet',
                height: 45,
                width: 180),
          ],
        ),
      ),
    );
  }
}
