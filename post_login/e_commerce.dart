import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'online_booking.dart';

class ECommerece extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'E commerce'),
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
                    Icons.shopping_cart_sharp,
                    color: Color(0xff215DA5),
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
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: card(
                        title: 255,
                        description:
                            'Lorem ipsum dolor sit amet consectetuer Lorem ipsum dolor sit amet consectetuer',
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
  card({required this.title, required this.description});

  late final int title;
  late final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.94,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, medicine);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.25,
                  maxHeight: MediaQuery.of(context).size.width * 0.25,
                ),
                child: Image.asset('assets/images/metierlogo.png',
                    fit: BoxFit.fill),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Text(
                      '\u{20B9} ${title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Text(off),
    );
  }
}
