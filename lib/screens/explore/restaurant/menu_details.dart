import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDetails extends StatefulWidget {
  const MenuDetails({Key? key}) : super(key: key);
  static const menuDetailRoute = '/MenuDetails';

  @override
  State<MenuDetails> createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  bool _isLoading = false;
  int _quantity = 1;
  String radioValue = '';
  List<String> _itemSize = ['Small', 'Medium', 'Large'];

  addItemToCart(
    String restId,
    String menuId,
    String name,
    double price,
    int qnty,
  ) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> _thisData = {
        'resturantId': restId,
        'userId': _prefs.getString('CurrentUserId'),
        'menuId': menuId,
        'name': name,
        'price': price,
        'quantity': qnty,
      };
      var cartResponse =
          await HttpWrapper.sendPostRequest(url: ADD_TO_CART, body: _thisData)
              .whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
      print('Item Added to Cart : $cartResponse');
    } catch (e) {
      log(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _menuId = ModalRoute.of(context)?.settings.arguments;
    var _menuDetail = Provider.of<ResaurantsDataProvider>(context)
        .menuList
        .firstWhere((element) => element['_id'] == _menuId);

    Color primary = Color(0xff161A01);

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Stack(
        children: [
          Container(
            color: Colors.amber,
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 1.0,
            child: Stack(fit: StackFit.expand, children: [
              Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(_menuDetail['imageUrl']))
            ]),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 30),
            transform: Matrix4.translationValues(
                0, MediaQuery.of(context).size.height * 0.4, 1),
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1.0 - 100,
                        child: Text(
                          _menuDetail['name'],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text('\$${_menuDetail['price']}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          _menuDetail['description'],
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: radioValue,
                        onChanged: (value) {
                          setState(() {
                            radioValue = value.toString();
                          });
                        },
                        items: _itemSize,
                        itemBuilder: (i) {
                          return RadioButtonBuilder(i.toString(),
                              textPosition: RadioButtonTextPosition.left);
                        }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: FloatingActionButton(
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            },
                          )),
                      Text(
                        '  $_quantity  ',
                        style: TextStyle(fontSize: 17),
                      ),
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: FloatingActionButton(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '\$${_quantity * (_menuDetail['price'] + 0.0)}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'ADD TO CART',
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    ])));
  }
}
