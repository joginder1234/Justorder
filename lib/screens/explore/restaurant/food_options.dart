import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantItem extends StatefulWidget {
  const RestaurantItem({Key? key}) : super(key: key);
  static const restaurantItemRoute = '/restaurantItems';

  @override
  _RestaurantItemState createState() => _RestaurantItemState();
}

class _RestaurantItemState extends State<RestaurantItem> {
  int currentvalue = 1;
  bool ischecked = false;
  List<String> rolltype = ['Hand Roll', 'Regular Roll'];
  String rollname = '';
  String optID = '';
  double price = 0.0;
  String optSize = '';
  bool _isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   setOptType();
  // }

  // setOptType() {
  //   var options = Provider.of<ResaurantsDataProvider>(context).foodOptions;
  //   setState(() {
  //     rollname = options[0]['type'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var options = Provider.of<ResaurantsDataProvider>(context).foodOptions;
    var menuId = ModalRoute.of(context)!.settings.arguments;
    var menu = Provider.of<ResaurantsDataProvider>(context)
        .menuList
        .firstWhere((element) => element['_id'] == menuId);
    log('Options :: $options');
    log('Menu List :: $menu');
    rollname = options[0]['type'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Theme.of(context).buttonColor,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menu['name'].toString().toUpperCase(),
              style: GoogleFonts.oswald(
                  fontSize: 25,
                  color: Theme.of(context).buttonColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              width: 105,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          final newvalue = currentvalue - 1;
                          currentvalue = newvalue.clamp(1, 100);
                        });
                      },
                      icon: const Icon(Icons.remove)),
                  Text('$currentvalue'),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          final newvalue = currentvalue + 1;
                          currentvalue = newvalue.clamp(1, 100);
                        });
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15)),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).buttonColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () async {
                    print('First Size ::' + options[0]['type']);
                    optID.isEmpty
                        ? CustomToast.showToast('Please select your meal size')
                        : _isLoading
                            ? null
                            : await addItemToCart(
                                menu['restaurantId'],
                                menu['_id'],
                                menu['name'],
                                price.toString(),
                                optSize,
                                currentvalue.toString());
                  },
                  child: _isLoading
                      ? const Text(
                          'Please Wait...',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      : Text(
                          'Add to Cart (\$${price * currentvalue})',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
            )
          ],
        ),
      ),
      body: rollname.isEmpty
          ? Center(
              child: Text('PLEASE WAIT...'),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Choose Meal Size',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: options
                        .map((e) => ListTile(
                              onTap: () {
                                setState(() {
                                  optSize = e['type'].toString();
                                  optID = e['_id'].toString();
                                  price = double.parse(e['price'].toString());
                                });
                              },
                              title: Text(
                                e['type'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              trailing: Text(
                                '\$${e['price']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(e['ingradiants']),
                              leading: optID != e['_id']
                                  ? Icon(
                                      Icons.circle_outlined,
                                      color: Theme.of(context).buttonColor,
                                    )
                                  : Icon(
                                      Icons.check_circle,
                                      color: Theme.of(context).buttonColor,
                                    ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }

  addItemToCart(
    String restId,
    String menuId,
    String name,
    String price,
    String size,
    String qnty,
  ) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print(size);
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> _thisData = {
        'restaurantId': restId == null ? '' : restId,
        'userId': _prefs.getString('CurrentUserId') ?? '',
        'menuId': menuId == null ? '' : menuId,
        'name': name == null ? '' : name,
        'size': size,
        'price': price == null ? '0.0' : price,
        'quantity': qnty == null ? '0' : qnty,
      };
      var checkCart = await HttpWrapper.sendGetRequest(url: GET_CART_ITEM);
      if (checkCart['success'] == true) {
        if ((checkCart['carts'] as List).isEmpty) {
          addtoCartaftercheck(_thisData);
        } else {
          if ((checkCart['carts'][0]['cartItems'] as List).isNotEmpty) {
            (checkCart['carts'][0]['cartItems'] as List).firstWhere((element) {
              if (checkCart['carts'][0]['restaurantId'] == restId) {
                addtoCartaftercheck(_thisData);
              } else {
                CustomToast.showToast('Please complete previous order first');
              }
              return true;
            });
          } else {
            addtoCartaftercheck(_thisData);
          }
        }
      } else {
        CustomToast.showToast(
            'Unable to get cart information! try again later');

        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  addtoCartaftercheck(Map<String, dynamic> _thisData) async {
    var ATCResponst =
        await HttpWrapper.sendPostRequest(url: ADD_TO_CART, body: _thisData);
    print(ATCResponst);
    if (ATCResponst['success'] == true) {
      CustomToast.showToast('Item Added to Cart');
      setState(() {
        _isLoading = false;
        Provider.of<ResaurantsDataProvider>(context, listen: false)
            .loadCartItems();
        Provider.of<Quantity>(context, listen: false).increaseQuantity();
      });
      Navigator.of(context).pop();
    }
  }
}
