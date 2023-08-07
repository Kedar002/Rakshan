import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:akar_icons_flutter/akar_icons_flutter.dart';

import '../../routes/app_routes.dart';

class OnlineBooking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'Online Booking'),
      body: Container(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: kRoundedTextfield('Search'),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    AkarIcons.settings_horizontal,
                    color: Color(0xff215DA5),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color:
                          (index % 2 == 0) ? Colors.white : Color(0xffF1F7FF),
                      child: tile(
                        title: 'Fortis',
                        off: '15 %',
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, appointment);
      },
      child: Card(
        color: Color(0xffF1F7FF),
        child: tile(
          title: 'Fortis',
          off: '15 %',
        ),
      ),
    );
  }
}

class tile extends StatelessWidget {
  tile({required this.title, required this.off});
  String title;
  String off;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
      ),
      trailing: Text(off),
    );
  }
}

InputDecoration kRoundedTextfield(String hinttext) {
  return InputDecoration(
      hintText: hinttext,
      hintStyle: TextStyle(
        fontFamily: 'OpenSans',
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff325CA2), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff325CA2), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      suffixIcon: Icon(Icons.search));
}
