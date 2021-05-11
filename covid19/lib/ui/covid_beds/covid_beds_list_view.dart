import 'dart:async';

import 'package:covid19/ui/covid_beds/covid_beds_list_view_model.dart';
import 'package:covid19/utils/no_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HospitalBedsView extends StatefulWidget {
  final Map<String, dynamic> district;

  HospitalBedsView({this.district});

  @override
  _HospitalBedsViewState createState() => _HospitalBedsViewState();
}

class _HospitalBedsViewState extends State<HospitalBedsView> {
  Timer _debounce;
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HospitalBedsViewModel>.reactive(
      viewModelBuilder: () => HospitalBedsViewModel(),
      onModelReady: (m) {
        m.district = widget.district;
        m.getHospitals();
      },
      builder: (c, m, w) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Scrollbar(
            hoverThickness: 20,
            isAlwaysShown: true,
            child: ScrollConfiguration(
              behavior: NoScrollGlowBehavior(),
              child: NestedScrollView(
                headerSliverBuilder: (context, b) => [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Image.asset(
                          'assets/images/hospital_beds_banner.png',
                        ),
                      ],
                    ),
                  ),
                ],
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              color: Colors.red,
                            ),
                            Text(
                                "${widget.district["Name"]} (${widget.district["TamilName"]})"),
                            TextButton(
                                onPressed: () {
                                  m.navigateToDistrictSelection();
                                },
                                child: Text("Change")),
                          ],
                        ),
                      ),
                      ...m.isLoaded ? filterView(m) : [],
                      SizedBox(
                        height: 4,
                      ),
                      !m.isBusy
                          ? Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 16, right: 0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        if (_debounce?.isActive ?? false)
                                          _debounce.cancel();
                                        _debounce = Timer(
                                            const Duration(milliseconds: 1000),
                                            () {
                                          m.searchQuery = value;
                                          m.getHospitals();
                                        });
                                      },
                                      decoration: InputDecoration(
                                          hintText:
                                              "Search by hospital / Care Centre Name",
                                          prefixIcon: Icon(Icons.search),
                                          border: InputBorder.none,
                                          suffixIcon: InkWell(
                                              child: Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                _searchController.clear();
                                                m.searchQuery = '';
                                                m.refresh();
                                                m.getHospitals();
                                              })),
                                    ),
                                  ),
                                ),
                                // InkWell(
                                //   borderRadius: BorderRadius.circular(16),
                                //   child: Container(
                                //     padding: EdgeInsets.all(14),
                                //     decoration: BoxDecoration(
                                //         color: Colors.grey.shade100,
                                //         borderRadius:
                                //             BorderRadius.circular(16)),
                                //     child: Icon(
                                //       Icons.filter_list,
                                //     ),
                                //   ),
                                //   onTap: () {
                                //     _filterDialog(m)
                                //   },
                                // ),
                                SizedBox(
                                  width: 16,
                                )
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 8,
                      ),
                      !m.isBusy && m.hospitals.length > 0
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "${m.hospitals.length} hospitals found",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 8,
                      ),
                      ...m.isBusy
                          ? [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            ]
                          : m.hospitals.isEmpty
                              ? [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                          "No hospitals / Health Centers found"),
                                    ),
                                  )
                                ]
                              : m.hospitals.map((h) => _hospitalItem(m, h))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  filterView(m) {
    return <Widget>[
      Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hospital Type",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            ToggleButtons(
              borderRadius: BorderRadius.circular(16),
              children: <Widget>[
                _severityItem("Government", 2),
                _severityItem("Private", 2),
              ],
              onPressed: (int index) {
                setState(() {
                  m.hospitalTypes[index] = !m.hospitalTypes[index];
                });
                m.getHospitals();
              },
              isSelected: m.hospitalTypes,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Severity",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            ToggleButtons(
              borderRadius: BorderRadius.circular(16),
              children: <Widget>[
                _severityItem("Mild", 3),
                _severityItem("Moderate", 3),
                _severityItem("Severe", 3),
              ],
              onPressed: (int index) {
                setState(() {
                  m.severitySelection[index] = !m.severitySelection[index];
                });
                m.getHospitals();
              },
              isSelected: m.severitySelection,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 16,
      ),
      Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Text(
          "Hospitals",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }

  _hospitalItem(HospitalBedsViewModel model, hospital) {
    var bed = hospital["CovidBedDetails"];
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hospital["Name"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.call,
                  color: Colors.blue,
                ),
                onPressed: () {
                  _contactListDialog(context, model, hospital);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.place,
                  color: Colors.red,
                ),
                onPressed: () {
                  model.navigateToHospital(hospital);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.green,
                ),
                onPressed: () {
                  model.shareHospitalDetails(hospital);
                },
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              vacancyItem("Normal", bed["VaccantNonO2Beds"]?.toString() ?? "-"),
              vacancyItem("Oxygen", bed["VaccantO2Beds"]?.toString() ?? "-"),
              vacancyItem("ICU", bed["VaccantICUBeds"]?.toString() ?? "-"),
            ],
          ),
          Divider(),
          Text("Last Updated: ${model.bedsLastUpdatedDateTime(hospital)}"),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  vacancyItem(String title, String count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        )
      ],
    );
  }

  _contactListDialog(
      BuildContext context, HospitalBedsViewModel model, hospital) {
    var contactList = <Map>[];
    var primaryContactPerson = hospital["PrimaryContactPerson"];

    if (primaryContactPerson != null) {
      var landline = hospital["Landline"];
      var mobileNumber = hospital["MobileNumber"];
      if (mobileNumber != null && mobileNumber != "") {
        contactList.add({
          "title": primaryContactPerson,
          "number": mobileNumber,
        });
      }
      if (landline != null && landline != "") {
        contactList.add({
          "title": primaryContactPerson,
          "number": landline,
        });
      }
    }

    List contactDetailsList = hospital["ContactDetails"];
    if (contactDetailsList != null) {
      for (var c in contactDetailsList) {
        contactList.add({
          "title": c["ContactName"],
          "number": c["ContactNumber"],
        });
      }
    }

    showDialog(
        context: context,
        builder: (c) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Select a contact",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                ...contactList.map((e) => InkWell(
                      onTap: () {
                        model.callHospital(e["number"]);
                      },
                      child: ListTile(
                        title: Text(e["title"]),
                        subtitle: Text(e["number"]),
                      ),
                    )),
              ],
            ),
          );
        });
  }

  _severityItem(String title, int count) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 36) / count,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // _filterDialog(HospitalBedsViewModel model) {
  //   showDialog(
  //       context: context,
  //       builder: (c) {
  //         return Dialog(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Text(
  //                   "FILTER",
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               Divider(),
  //               CheckboxListTile(value: model.isPrivateHospital, onChanged: (){

  //               }),
  //               CheckboxListTile(value: model.isGovernmentHospital, onChanged: (){

  //               }),
  //               CheckboxListTile(value: model.isPrivateHospital, onChanged: (){

  //               }),
  //               CheckboxListTile(value: model.isPrivateHospital, onChanged: (){

  //               }),
  //             ],
  //           ),
  //         );
  //       });
  // }
}
