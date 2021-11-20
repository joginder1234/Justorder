import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/service.dart';
import 'package:justorderuser/backend/urls/urls.dart';

class OtherServices extends StatefulWidget {
  OtherServices({Key? key}) : super(key: key);

  @override
  _OtherServicesState createState() => _OtherServicesState();
}

class _OtherServicesState extends State<OtherServices> {
  List services = [];
  List otherServices = [];
  String serviceId = '';
  bool _loading = false;
  String selectedService = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadServices();
  }

  loadServices() async {
    var response = await ServiceProvider.otherServiceList();
    if (response['success'] == true) {
      services = (response['items'] as List).map((e) => e).toList();
      setState(() {
        serviceId = services[0]['_id'];
      });
      loadOtherService(services[0]['_id']);
    }
  }

  loadOtherService(String id) async {
    otherServices.clear();
    setState(() {
      _loading = true;
    });
    try {
      var response =
          await HttpWrapper.sendGetRequest(url: SERVICE_SUBLISTS + '/$id');
      if (response['success'] == true) {
        print(response);
        setState(() {
          otherServices = (response['items'] as List).map((e) => e).toList();
          _loading = false;
        });
      }
    } catch (e) {
      print('Services Error :: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          'Services List',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: ListView.builder(
                itemCount: services.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) => GestureDetector(
                      onTap: () {
                        setState(() {
                          serviceId = services[i]['_id'];
                          selectedService = services[i]['name'];
                        });
                        loadOtherService(services[i]['_id']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                            backgroundColor: services[i]['_id'] == serviceId
                                ? Colors.blue
                                : Colors.black,
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            label: Text(
                              services[i]['name'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 230,
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.transparent,
                    ),
                  )
                : otherServices.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No Service Available for'),
                          Text(
                            selectedService,
                            style: TextStyle(fontSize: 25, color: Colors.grey),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: otherServices.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) => Column(
                              children: [
                                ListTile(
                                  // tileColor: i.isEven
                                  //     ? Colors.blue.shade100
                                  //     : Colors.blue.shade200,
                                  title: Text(
                                    otherServices[i]['name'],
                                    style: GoogleFonts.oswald(fontSize: 20),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      (otherServices[i]['region'] == 'null' ||
                                                  otherServices[i]['region'] ==
                                                      null) &&
                                              (otherServices[i]['city'] ==
                                                      'null' ||
                                                  otherServices[i]['city'] ==
                                                      null)
                                          ? SizedBox()
                                          : Text(
                                              '${otherServices[i]['region'] == 'null' || otherServices[i]['region'] == null ? '' : '${otherServices[i]['region']},'} ${otherServices[i]['city'] == 'null' || otherServices[i]['city'] == null ? '' : '${otherServices[i]['city']}'}'),
                                      Text('${otherServices[i]['country']}'),
                                    ],
                                  ),
                                ),
                                otherServices.length > 1
                                    ? Divider(
                                        thickness: 1.2,
                                      )
                                    : Container()
                              ],
                            )),
          )
        ],
      ),
    );
  }
}