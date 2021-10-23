import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/rest_menu.dart';
import 'package:justorderuser/screens/explore/restaurant/menu_details.dart';
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
    Provider.of<ResaurantsDataProvider>(context, listen: false)
        .menuList
        .forEach((element) {
      if (element['categoryId'] == id) {
        setState(() {
          Provider.of<ResaurantsDataProvider>(context, listen: false)
              .filterMenu
              .add(element);
          filterCategory = id;
        });
      }
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
        debugPrint(
            'Final List :: ${(allMenu['menus'] as List).map((e) => e['options']).toList()}');
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
    // var restaurantDetails = Provider.of<ResaurantsDataProvider>(context)
    //     .restaurantsList
    //     .firstWhere((element) => element.id == );

    String menuImage =
        'https://media.istockphoto.com/photos/hamburger-with-cheese-and-french-fries-picture-id1188412964?k=20&m=1188412964&s=612x612&w=0&h=Ow-uMeygg90_1sxoCz-vh60SQDssmjP06uGXcZ2MzPY=';

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                      color: Colors.grey.shade200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Menu Categories',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w700),
                              ),
                              filterCategory == ''
                                  ? Container(
                                      height: 48,
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        setState(() {
                                          filterCategory = '';
                                        });
                                      },
                                      child: Text(
                                        'Show All',
                                        style: TextStyle(fontSize: 18),
                                      ))
                            ],
                          ),
                          const Divider(
                            thickness: 1.5,
                          ),
                          Container(
                            color: Colors.grey.shade200,
                            height: 135,
                            width: double.infinity,
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _category.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        filterMenuList(_category[index]['_id']);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 35,
                                              backgroundImage:
                                                  NetworkImage(menuImage),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 5),
                                              alignment: Alignment.center,
                                              width: 55,
                                              child: Text(
                                                _category[index]
                                                    ['categoryName'],
                                                overflow: TextOverflow.fade,
                                                softWrap: true,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          Text('All Menu',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.61,
                      child: filterCategory == ''
                          ? ListView.builder(
                              padding: EdgeInsets.all(15),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _menuList.length,
                              itemBuilder: (context, index) => MenuTiles(
                                (_menuList[index]['options'] as List).length <=
                                        0
                                    ? ''
                                    : _menuList[index]['options'][0]
                                            ['optionId'] ??
                                        '',
                                _menuList[index]['restaurantId'],
                                _menuList[index]['_id'],
                                _menuList[index]['imageUrl'],
                                _menuList[index]['name'] ?? '',
                                _menuList[index]['description'],
                                (_menuList[index]['options'] as List).length <=
                                        0
                                    ? 0.0
                                    : double.parse(
                                        _menuList[index]['price'].toString()),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(15),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _filterMenu.length,
                              itemBuilder: (context, index) => MenuTiles(
                                _filterMenu[index]['options'][0]['optionId'] ??
                                    '',
                                _filterMenu[index]['restaurantId'],
                                _filterMenu[index]['_id'],
                                _filterMenu[index]['imageUrl'],
                                _filterMenu[index]['name'] ?? '',
                                _filterMenu[index]['description'],
                                double.parse(
                                    _filterMenu[index]['price'].toString()),
                              ),
                            ),
                    ),
                  ],
                ),
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
  bool _isLoading = false;

  loadOptions(String optId) async {
    print(
        'Option id :: $optId  , RestId :: ${widget.restId}  , MenuId :: ${widget.id}');
    try {
      var optionData =
          await HttpWrapper.sendGetRequest(url: GET_MENU_OPTIONS + '/$optId');

      if (optionData['success'] == true) {
        print(optionData);
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
      var cartResponse = await ResaurantsDataProvider().addtoCart(restId);
      if (cartResponse) {
        var ATCResponst = await HttpWrapper.sendPostRequest(
            url: ADD_TO_CART, body: _thisData);
        if (ATCResponst['success'] == true) {
          CustomToast.showToast('Item Added to Cart');
          Navigator.of(context).pop();
        }
      } else {
        CustomToast.showToast('Please complete previous order first.');
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        tileColor: Colors.white,
        onTap: () {
          loadOptions(widget.id);
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              isScrollControlled: true,
              // expand: true,
              enableDrag: true,
              context: context,
              builder: (ctx) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Image(
                                  image: NetworkImage(widget.image),
                                  fit: BoxFit.cover,
                                ))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('\$${widget.price + 0.0}',
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
                              widget.description,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
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
                            '\$${_quantity * (widget.price + 0.0)}',
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
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (_) => Restaurantcart()));
                                print('Button is working');
                                addItemToCart(widget.restId, widget.id,
                                    widget.title, widget.price.toString(), '2');
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Text(
                                  'Add TO Cart',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
          // Navigator.of(context)
          //     .pushNamed(MenuDetails.menuDetailRoute, arguments: widget.id);
        },
        trailing: Container(
          constraints: BoxConstraints(minWidth: 105, maxWidth: 120),
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(label: Text('\$${widget.price}')),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.orange,
                  ))
            ],
          ),
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
