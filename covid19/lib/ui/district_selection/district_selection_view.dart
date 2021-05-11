import 'package:covid19/ui/district_selection/district_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DistrictSelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DistrictSelectionViewModel>.reactive(
      viewModelBuilder: () => DistrictSelectionViewModel(),
      onModelReady: (m) {
        m.getDistricts();
      },
      builder: (c, m, w) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 40,
              ),
              Image.asset(
                'assets/images/tn_covid19.png',
              ),
              SizedBox(
                height: 100,
              ),
              m.isBusy
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Please select district",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton<String>(
                                  value: m.selectedDistrict["id"],
                                  items: m.districts.map((district) {
                                    return DropdownMenuItem<String>(
                                      value: district["id"],
                                      child: Text(
                                          "${district["Name"]} - ${district["TamilName"]}"),
                                    );
                                  }).toList(),
                                  underline: Container(),
                                  onChanged: (id) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    var selected = m.districts
                                        .where((d) => d["id"] == id)
                                        .first;
                                    m.selectedDistrict = selected;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    m.proceed();
                                  },
                                  child: Text(
                                    "Proceed",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
