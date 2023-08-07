import 'package:flutter/material.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';

class BookingConfirmation extends StatelessWidget {
  const BookingConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarIndividual(
        title: 'Booking Confirmation',
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 50, bottom: 100, left: 50, right: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            'assets/images/bookingConfirm.png',
          ),
        ),
      ),
    );
  }
}
