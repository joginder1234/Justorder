import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/screens/base_widget.dart';
import 'package:provider/provider.dart';

class RestaurantOrders extends StatefulWidget {
  RestaurantOrders({Key? key}) : super(key: key);
  static const restOrderRoute = '/restOrders';

  @override
  _RestaurantOrdersState createState() => _RestaurantOrdersState();
}

class _RestaurantOrdersState extends State<RestaurantOrders> {
  getOrderList() async {
    try {
      await HttpWrapper.sendGetRequest(url: REST_ORDER_LIST).then((orders) {
        if (orders['success'] == true) {
          setState(() {
            Provider.of<ResaurantsDataProvider>(context, listen: false)
                .myOrders = orders['orders'];
          });
        }

        log(orders.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderList();
  }

  List<String> orderId = [];

  @override
  Widget build(BuildContext context) {
    var allOrders = Provider.of<ResaurantsDataProvider>(context).myOrders;
    var restList = Provider.of<ResaurantsDataProvider>(context).allRestaurants;
    print('My Orders :: $allOrders');
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => BaseWidget()), (route) => false);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: Text('Food Orders'),
            centerTitle: true,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: allOrders.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                      backgroundColor: Colors.white,
                      onExpansionChanged: (value) {
                        if (value) {
                          setState(() {
                            orderId.add(allOrders[index]['_id']);
                          });
                        } else {
                          setState(() {
                            orderId.removeWhere((element) =>
                                element == allOrders[index]['_id']);
                          });
                        }
                        print(orderId);
                      },
                      collapsedBackgroundColor: Colors.white,
                      leading: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            restList
                                .firstWhere((element) =>
                                    element.id ==
                                    allOrders[index]['restaurantId'])
                                .image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        restList
                            .firstWhere((element) =>
                                element.id == allOrders[index]['restaurantId'])
                            .restaurantName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'On : ${DateFormat('yMMMd').format(DateTime.parse(allOrders[index]['orderDate']))} / ${allOrders[index]['orderTime']}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          orderId.any((element) => element
                                  .contains(allOrders[index]['_id'].toString()))
                              ? SizedBox()
                              : Text(
                                  allOrders[index]['status'],
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 16),
                                ),
                        ],
                      ),
                      trailing: Text(
                        '\$${allOrders[index]['totalPrice']}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: allOrders[index]['status'] == 'preparing'
                                  ? AssetImage('assets/order.gif')
                                  : allOrders[index]['status'] == 'on_delivery'
                                      ? AssetImage('assets/deliveryboy.gif')
                                      : AssetImage('assets/order.gif'),
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                            Text(
                              allOrders[index]['status'] == 'preparing'
                                  ? 'Preparing Your Order'
                                  : 'Out for delivery',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ExpansionTile(
                              title: Text(
                                'Delivery in',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Tap for details'),
                              trailing: Text(
                                '40 Min',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              children: [
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: (allOrders[index]['cart'][0]
                                            ['cartItems'] as List)
                                        .length,
                                    shrinkWrap: true,
                                    itemBuilder: (ctx, i) => ListTile(
                                          leading: Container(
                                            alignment: Alignment.center,
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.orange),
                                            child: Text(
                                                (allOrders[index]['cart'][0]
                                                            ['cartItems']
                                                        as List)[i]['quantity']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          title: Text(
                                            (allOrders[index]['cart'][0]
                                                    ['cartItems'] as List)[i]
                                                ['name'],
                                          ),
                                          trailing: Text(
                                              '\$${(allOrders[index]['cart'][0]['cartItems'] as List)[i]['price'].toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ))
                              ],
                            ),
                            ExpansionTile(
                              title: Text('Payment Details'),
                              children: [
                                ListTile(
                                    title: Text('Payment Method'),
                                    subtitle: Text('by Card')),
                                ListTile(
                                  title: Text('Order Time'),
                                  trailing: Text(allOrders[index]['orderTime']),
                                ),
                                ListTile(
                                  title: Text('Payment Details'),
                                  subtitle: Text(
                                      'Transaction Id : \nPayment Status : Paid'),
                                )
                              ],
                            ),
                            ExpansionTile(
                              title: Text('Delivery Address'),
                              children: [
                                ListTile(
                                  title: Text(allOrders[index]['userId']),
                                  subtitle: Text(
                                      '${allOrders[index]['shipping_address']['line1']}\n${allOrders[index]['shipping_address']['city']}, ${allOrders[index]['shipping_address']['state']}\n${allOrders[index]['shipping_address']['phone']}'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ]),
                );
              },
            ),
          )),
    );
  }
}
