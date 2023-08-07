import 'package:flutter/material.dart';
import 'package:Rakshan/constants/padding.dart';
import 'package:Rakshan/constants/textfield.dart';
import 'package:Rakshan/constants/theme.dart';
import 'package:Rakshan/routes/app_routes.dart';
import 'package:Rakshan/widgets/post_login/app_bar.dart';
import 'package:Rakshan/widgets/post_login/app_menu.dart';
import 'package:Rakshan/widgets/pre_login/logo.dart';

class Cart extends StatefulWidget {
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int yourLocalVariable = 0;
  int localprice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBarIndividual(title: 'Cart'),
      body: Container(
        padding: kScreenPadding,
        child: Column(
          children: [
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/metierlogo.png'),
                                          height: 70,
                                          width: 70,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Medicine\nB34',
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                          Text('₹895',
                                              //'\u{20B9}${localprice}',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: darkBlue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ))
                                        ],
                                        //Text('\u{20B9}${your amount}'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete),
                                      label: Text('Remove'),
                                    ),
                                    NumericStepButton(
                                      maxValue: 20,
                                      onChanged: (value) {
                                        yourLocalVariable = value;
                                      },
                                      onChangedprice: (value) {
                                        localprice = value;
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ));
                    }),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Quantity',
                        style: kGreyTextstyle,
                      ),
                      Text(
                        '12',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: kGreyTextstyle,
                      ),
                      Text(
                        '₹4689',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Color(0xffC4DFFF),
                    ),
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.pushNamed(context, checkout);
                      }),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Checkout',
                            style:
                                TextStyle(fontFamily: 'OpenSans', fontSize: 20),
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Color(0xff215DA5),
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.shopping_cart_checkout_sharp,
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChangedprice;
  final ValueChanged<int> onChanged;

  NumericStepButton(
      {Key? key,
      this.minValue = 0,
      this.maxValue = 10,
      required this.onChangedprice,
      required this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  int counter = 0;
  int price = 580;
  int temp = 580;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
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
              fontFamily: 'OpenSans',
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
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
            iconSize: 32.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (counter < widget.maxValue) {
                  counter++;
                  temp = (temp - price) as int;
                }
                widget.onChanged(counter);
                widget.onChangedprice(temp);
              });
            },
          ),
        ],
      ),
    );
  }
}

//      return Container(
//               child: NumericStepButton(
//                 maxValue: 20,
//                 onChanged: (value) {
//                   yourLocalVariable = value;
//                 },
//               ),
//             )

// class NumericStepButton extends StatefulWidget {
//   final int minValue;
//   final int maxValue;

//   final ValueChanged<int> onChanged;
//   final ValueChanged<int> onChangedprice;

//   NumericStepButton(
//       {Key? key,
//       this.minValue = 0,
//       this.maxValue = 100,
//       required this.onChangedprice,
//       required this.onChanged})
//       : super(key: key);

//   @override
//   State<NumericStepButton> createState() {
//     return _NumericStepButtonState();
//   }
// }

// class _NumericStepButtonState extends State<NumericStepButton> {
//   int counter = 1;
//   int price = 580;
//   int temp = 580;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.remove,
//                     color: Theme.of(context).accentColor,
//                   ),
//                   padding:
//                       EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
//                   iconSize: 32.0,
//                   color: Theme.of(context).primaryColor,
//                   onPressed: () {
//                     setState(() {
//                       if (counter > widget.minValue) {
//                         counter--;
//                         temp = (temp - price) as int;
//                       }
//                       widget.onChanged(counter);
//                       widget.onChangedprice(temp);
//                     });
//                   },
//                 ),
//                 Text(
//                   '$counter',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.add,
//                     color: Theme.of(context).accentColor,
//                   ),
//                   padding:
//                       EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
//                   iconSize: 32.0,
//                   color: Theme.of(context).primaryColor,
//                   onPressed: () {
//                     setState(() {
//                       if (counter < widget.maxValue) {
//                         counter++;
//                         temp = (temp + price) as int;
//                       }
//                       widget.onChanged(counter);
//                       widget.onChangedprice(temp);
//                     });
//                   },
//                 ),
//               ],
//             ),
//             Card(
//               color: Color(0xffC4DFFF),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Text(
//                     '\u{20B9} ${temp}',
//                     style: TextStyle(fontSize: 24),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Container(
//                       color: Color(0xff215DA5),
//                       child: IconButton(
//                           onPressed: () {},
//                           icon: Icon(
//                             Icons.shopping_bag_outlined,
//                             color: Colors.white,
//                           )))
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
