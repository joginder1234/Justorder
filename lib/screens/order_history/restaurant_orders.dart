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
        Map<String, dynamic> orderData = {};
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

  @override
  Widget build(BuildContext context) {
    var allOrders = Provider.of<ResaurantsDataProvider>(context).myOrders;
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
                      collapsedBackgroundColor: Colors.white,
                      title: Text(
                        allOrders[index]['restaurantName'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'On : ${allOrders[index]['orderTime']}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Preparing',
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${allOrders[index]['price']}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/order.gif'),
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                            Text(
                              'Preparing Your Order',
                              style: TextStyle(
                                  fontSize: 30,
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
                                    itemCount:
                                        (allOrders[index]['cartItems'] as List)
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
                                                (allOrders[index]['cartItems']
                                                        as List)[i]['quantity']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          title: Text(
                                            (allOrders[index]['cartItems']
                                                as List)[i]['name'],
                                          ),
                                          trailing: Text(
                                              '\$${(allOrders[index]['cartItems'] as List)[i]['price'].toString()}',
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
                                  trailing:
                                      Text(TimeOfDay.now().format(context)),
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
                                      '${allOrders[index]['line1']}\n${allOrders[index]['city']}, ${allOrders[index]['state']}\n${allOrders[index]['phone']}'),
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
