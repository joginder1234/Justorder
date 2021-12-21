import 'dart:developer';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/rest_menu.dart';
import 'package:justorderuser/screens/explore/restaurant/bottomNavigation.dart';
import 'package:justorderuser/screens/explore/restaurant/food_options.dart';
import 'package:justorderuser/screens/explore/restaurant/menu_details.dart';
import 'package:justorderuser/screens/explore/restaurant/reviews.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantMenuPage extends StatefulWidget {
  const RestaurantMenuPage({Key? key}) : super(key: key);

  static const menupage = '/restaurantmenupage';

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  bool _isLoading = false;
  // List<RestaurantMenu> _menuList = [];

  String filterCategory = '';
  @override
  void initState() {
    super.initState();
    loadCategories();
    loadMenu();
  }

  loadCategories() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      var allCategory = await HttpWrapper.sendGetRequest(
          url: RESTAURANT_MENU_CAT + '/${_prefs.getString('restId')}');
      if (allCategory['success'] == true) {
        setState(() {
          Provider.of<ResaurantsDataProvider>(context, listen: false).category =
              allCategory['categories'];
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  filterMenuList(String id) {
    setState(() {
      Provider.of<ResaurantsDataProvider>(context, listen: false)
          .filterMenu
          .clear();
    });
    var filterData = Provider.of<ResaurantsDataProvider>(context, listen: false)
        .menuList
        .where((element) => element['categoryId'] == id)
        .toList();

    setState(() {
      Provider.of<ResaurantsDataProvider>(context, listen: false).filterMenu =
          filterData;

      filterCategory = id;
    });
  }

  loadMenu() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      var allMenu = await HttpWrapper.sendGetRequest(
          url: RESTAURANT_MENU + '/${_prefs.getString('restId')}');

      if (allMenu['success'] == true) {
        print('All Menu :: $allMenu');
        setState(() {
          Provider.of<ResaurantsDataProvider>(context, listen: false).menuList =
              allMenu['menus'];
          // Provider.of<ResaurantsDataProvider>(context, listen: false)
          //     .restMenuItems
          //     .addAll((allMenu['menus'] as List)
          //         .map((e) => RestaurantMenu.fromJson(allMenu)));
          // _menuList.addAll((allMenu['menus'] as List)
          //     .map((e) => RestaurantMenu.fromJson(allMenu)));
          _isLoading = false;
        });
      }
    } catch (e) {
      log(e.toString());
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _category = Provider.of<ResaurantsDataProvider>(context).category;
    var _filterMenu = Provider.of<ResaurantsDataProvider>(context).filterMenu;
    var _menuList = Provider.of<ResaurantsDataProvider>(context).menuList;
    print('Filter Menu List :: ${_filterMenu.map((e) => e).toList()}');

    String menuImage =
        'https://media.istockphoto.com/photos/hamburger-with-cheese-and-french-fries-picture-id1188412964?k=20&m=1188412964&s=612x612&w=0&h=Ow-uMeygg90_1sxoCz-vh60SQDssmjP06uGXcZ2MzPY=';

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Choose your meal'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: _category.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400, blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/bg.jpg'))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: SingleChildScrollView(
                            child: Center(
                              child: ExpansionTileCard(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 35),
                                baseColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                trailing: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.transparent,
                                ),
                                title: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(_category[i]['categoryName'],
                                      maxLines: 2,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.kaushanScript(
                                          fontSize: 25,
                                          color:
                                              Theme.of(context).buttonColor)),
                                ),
                                children: _menuList
                                    .where((element) =>
                                        element['categoryId'] ==
                                        _category[i]['_id'])
                                    .toList()
                                    .map((e) => MenuTiles(
                                          (e['options'] as List).length <= 0
                                              ? ''
                                              : e['options'][0]['optionId'] ??
                                                  '',
                                          e['restaurantId'],
                                          e['_id'],
                                          e['imageUrl'],
                                          e['name'] ?? '',
                                          e['description'],
                                          e['price'] == null
                                              ? 0.0
                                              : e['price'] + 0.0,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ));
                    },
                  ),
                ],
              ));
  }
}

class MenuTiles extends StatefulWidget {
  String optId;
  String restId;
  String id;
  String image;
  String title;
  String description;
  double price;
  // double deliveryCharge;
  // double serviceCharge;
  MenuTiles(
    this.optId,
    this.restId,
    this.id,
    this.image,
    this.title,
    this.description,
    this.price,
  );

  @override
  _MenuTilesState createState() => _MenuTilesState();
}

class _MenuTilesState extends State<MenuTiles> {
  int _quantity = 1;
  String radioValue = '';
  List<String> _itemSize = ['Small', 'Medium', 'Large'];
  String optId = '';

  bool _isLoading = false;

  loadOptions(String optId) async {
    print(
        'Option id :: $optId  , RestId :: ${widget.restId}  , MenuId :: ${widget.id}');
    try {
      var optionData =
          await HttpWrapper.sendGetRequest(url: GET_MENU_OPTIONS + '/$optId');

      if (optionData['success'] == true) {
        print('Option :: ${optionData['options']}');

        Provider.of<ResaurantsDataProvider>(context, listen: false)
            .foodOptions = optionData['options'][0]['opt'];
        setState(() {
          optId = optionData['options'][0]['_id'];
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  addItemToCart(
    String restId,
    String menuId,
    String name,
    String price,
    String qnty,
  ) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    try {
      Map<String, dynamic> _thisData = {
        'restaurantId': restId == null ? '' : restId,
        'userId': _prefs.getString('CurrentUserId') ?? '',
        'menuId': menuId == null ? '' : menuId,
        'name': name == null ? '' : name,
        'isSize': 'true',
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        tileColor: Colors.white,
        onTap: () async {
          await loadOptions(widget.id);
          Navigator.of(context).pushNamed(RestaurantItem.restaurantItemRoute,
              arguments: widget.id);

          // showModalBottomSheet(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(25),
          //             topRight: Radius.circular(25))),
          //     isScrollControlled: true,
          //     // expand: true,
          //     enableDrag: true,
          //     context: context,
          //     builder: (ctx) {
          //       return StatefulBuilder(builder: (BuildContext ctx, setState) {
          //         return Padding(
          //           padding: const EdgeInsets.all(10.0),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.symmetric(vertical: 20),
          //                 child: Container(
          //                     height: 150,
          //                     width: 150,
          //                     decoration: BoxDecoration(shape: BoxShape.circle),
          //                     child: ClipRRect(
          //                         borderRadius: BorderRadius.circular(1000),
          //                         child: Image(
          //                           image: NetworkImage(widget.image),
          //                           fit: BoxFit.cover,
          //                         ))),
          //               ),
          //               Column(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     widget.title,
          //                     style: TextStyle(
          //                         fontSize: 25, fontWeight: FontWeight.bold),
          //                   ),
          //                   SizedBox(height: 10),
          //                   Text('\$${widget.price + 0.0}',
          //                       style: TextStyle(
          //                           fontSize: 25,
          //                           color: Colors.orange.shade800,
          //                           fontWeight: FontWeight.w800)),
          //                 ],
          //               ),
          //               const SizedBox(
          //                 height: 20,
          //               ),
          //               SizedBox(
          //                 width: double.infinity,
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       'Description:',
          //                       style: TextStyle(
          //                           fontSize: 18, fontWeight: FontWeight.bold),
          //                     ),
          //                     const SizedBox(
          //                       height: 5,
          //                     ),
          //                     Text(
          //                       widget.description,
          //                       style:
          //                           TextStyle(color: Colors.grey, fontSize: 16),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(
          //                 height: 20,
          //               ),
          //               Card(
          //                 child: RadioGroup<String>.builder(
          //                     direction: Axis.horizontal,
          //                     groupValue: radioValue,
          //                     onChanged: (value) {
          //                       setState(() {
          //                         radioValue = value.toString();
          //                       });
          //                     },
          //                     items: _itemSize,
          //                     itemBuilder: (i) {
          //                       return RadioButtonBuilder(i.toString(),
          //                           textPosition: RadioButtonTextPosition.left);
          //                     }),
          //               ),
          //               SizedBox(
          //                 height: 30,
          //               ),
          //               Row(
          //                 children: [
          //                   Text(
          //                     'Quantity',
          //                     style: TextStyle(
          //                         fontWeight: FontWeight.w800, fontSize: 17),
          //                   ),
          //                   SizedBox(
          //                     width: 20,
          //                   ),
          //                   Container(
          //                       width: 30,
          //                       height: 30,
          //                       decoration: BoxDecoration(
          //                         shape: BoxShape.circle,
          //                         color: Colors.grey,
          //                       ),
          //                       child: FloatingActionButton(
          //                         child: Icon(
          //                           Icons.remove,
          //                           color: Colors.white,
          //                         ),
          //                         onPressed: () {
          //                           if (_quantity > 1) {
          //                             setState(() {
          //                               _quantity--;
          //                             });
          //                           }
          //                         },
          //                       )),
          //                   Text(
          //                     '  $_quantity  ',
          //                     style: TextStyle(fontSize: 17),
          //                   ),
          //                   Container(
          //                       width: 30,
          //                       height: 30,
          //                       decoration: BoxDecoration(
          //                         shape: BoxShape.circle,
          //                         color: Colors.orange,
          //                       ),
          //                       child: FloatingActionButton(
          //                         child: Icon(
          //                           Icons.add,
          //                           color: Colors.white,
          //                         ),
          //                         onPressed: () {
          //                           setState(() {
          //                             _quantity++;
          //                           });
          //                         },
          //                       ))
          //                 ],
          //               ),
          //               SizedBox(
          //                 height: 20,
          //               ),
          //               Row(
          //                 children: [
          //                   Text(
          //                     'Total Price',
          //                     style: TextStyle(
          //                         fontWeight: FontWeight.w800, fontSize: 17),
          //                   ),
          //                   SizedBox(
          //                     width: 20,
          //                   ),
          //                   Text(
          //                     '\$${_quantity * (widget.price + 0.0)}',
          //                     style: TextStyle(
          //                         fontSize: 20,
          //                         fontWeight: FontWeight.w800,
          //                         color: Colors.orange),
          //                   ),
          //                 ],
          //               ),
          //               SizedBox(
          //                 height: 40,
          //               ),
          //               Row(
          //                 children: [
          //                   Expanded(
          //                     child: _isLoading
          //                         ? Center(
          //                             child: CircularProgressIndicator(
          //                               color: Colors.blue,
          //                               backgroundColor: Colors.transparent,
          //                             ),
          //                           )
          //                         : ElevatedButton(
          //                             style: TextButton.styleFrom(
          //                               backgroundColor: Colors.blue,
          //                             ),
          // onPressed: () async {
          //   setState(() {
          //     _isLoading = true;
          //   });
          //   print('Button is working');
          //   await addItemToCart(
          //       widget.restId,
          //       widget.id,
          //       widget.title,
          //       widget.price.toString(),
          //       _quantity.toString());
          // },
          //                             child: Padding(
          //                               padding: const EdgeInsets.symmetric(
          //                                   vertical: 10),
          //                               child: const Text(
          //                                 'Add TO Cart',
          //                                 style: TextStyle(
          //                                     fontSize: 18,
          //                                     color: Colors.white),
          //                               ),
          //                             ),
          //                           ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         );
          //       });
          //     });
          // Navigator.of(context)
          //     .pushNamed(MenuDetails.menuDetailRoute, arguments: widget.id);
        },
        trailing: Text(
          '\$${widget.price}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.all(10),
        title: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Text(
          widget.description,
          style: TextStyle(color: Colors.grey),
        ),
        leading: CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(widget.image),
        ),
      ),
    );
    ;
  }
}
