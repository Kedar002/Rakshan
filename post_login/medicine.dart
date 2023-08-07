import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/screens/post_login/cart.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Medicine extends StatelessWidget {
  int yourLocalVariable = 0;
  int localprice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'Medicine/B34'),
      body: Container(
        padding: kScreenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Medicine/B34',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans', fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10, top: 5),
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.share)),
                                  IconButton(
                                    onPressed: () {},
                                    icon:
                                        AdwaitaIcon(AdwaitaIcons.heart_filled),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomIndicator()),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'the science or practice of the diagnosis, treatment, and prevention of disease (in technical use often taken to exclude surgery). A drug or other preparation for the treatment or prevention of disease',
                    style: TextStyle(
                        fontFamily: 'OpenSans', color: Color(0xff75788A)),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, cart);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.shopping_bag_outlined),
                              SizedBox(
                                width: 5,
                              ),
                              Text('My Cart'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NumericStepButton(
                              onChanged: (value) {
                                yourLocalVariable = value;
                              },
                              onChangedprice: (value) {
                                localprice = value;
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//CART ADDING ITEMS AND CHANGING PRICE
class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;

  final ValueChanged<int> onChanged;
  final ValueChanged<int> onChangedprice;

  NumericStepButton(
      {Key? key,
      this.minValue = 0,
      this.maxValue = 100,
      required this.onChangedprice,
      required this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  int counter = 1;
  int price = 580;
  int temp = 580;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: Theme.of(context).accentColor,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                    iconSize: 32.0,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        if (counter > widget.minValue) {
                          counter--;
                          temp = (temp - price) as int;
                        }
                        widget.onChanged(counter);
                        widget.onChangedprice(temp);
                      });
                    },
                  ),
                  Text(
                    '$counter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).accentColor,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                    iconSize: 32.0,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        if (counter < widget.maxValue) {
                          counter++;
                          temp = (temp + price) as int;
                        }
                        widget.onChanged(counter);
                        widget.onChangedprice(temp);
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Card(
                color: Color(0xffC4DFFF),
                child: Row(
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      '\u{20B9} ${temp}',
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      color: Color(0xff215DA5),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//IMAGE SLIDER
class CustomIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomIndicatorState();
  }
}

class CustomIndicatorState extends State<CustomIndicator> {
  int currentPos = 0;
  List<String> listPaths = [
    "assets/images/metierlogo.png",
    "assets/images/metierlogo.png",
    "assets/images/metierlogo.png",
    "assets/images/metierlogo.png",
    "assets/images/metierlogo.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                itemCount: listPaths.length,
                options: CarouselOptions(
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPos = index;
                      });
                    }),
                itemBuilder: (context, index, index2) {
                  return MyImageView(listPaths[index]);
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: listPaths.map(
                  (url) {
                    int index = listPaths.indexOf(url);
                    return Container(
                      width: 7.0,
                      height: 7.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPos == index
                            ? Color.fromRGBO(0, 0, 0, 1)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyImageView extends StatelessWidget {
  String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.asset(imgPath),
        ));
  }
}
