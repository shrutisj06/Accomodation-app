import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'manage properties.dart';

class ApprovePropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  ApprovePropertyDetailsPage({required this.propertyId});

  @override
  _ApprovePropertyDetailsPageState createState() =>
      _ApprovePropertyDetailsPageState();
}

class _ApprovePropertyDetailsPageState extends State<ApprovePropertyDetailsPage> {
  String? _approvalStatus;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? propertyData;

  String? propertyName;
  String? propertyType;
  String? description;
  String? country;
  String? state;
  String? city;
  String? approvalStatus;
  String? sharingOption;
  String? address;
  String? pincode;
  String? ownerName;
  String? ownerPhone;
  List<String> selectedAmenities = [];

  List<int> roomsAvailable = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int? chosenRoomAvailable;
  List<String> sharingOptions = ['0 person sharing', '1 person sharing', '2 person sharing', '3 person sharing'];
  List<String> amenitiesList = [
    'Wifi',
    'Food',
    'Housekeeping',
    'Laundry Service',
    'Furnished Room',
    'Parking',
    'Television'
  ];

  Map<String, List<String>> countryState = {
    'India': ['Haryana', 'Punjab'],
    'UK': ['London'],
  };

  Map<String, List<String>> stateCity = {
    'Haryana': ['Hisar', 'Bhiwani'],
    'Punjab': ['Amritsar', 'Ludhiana'],
    'London': ['Chelsea', 'Camden'],
  };

  List<String> stateList = [];
  List<String> cityList = [];

  @override
  void initState() {
    super.initState();
    _fetchPropertyData();
  }

  Future<void> _fetchPropertyData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .get();
      if (doc.exists) {
        setState(() {
          propertyData = doc.data() as Map<String, dynamic>?;

          propertyName = propertyData!['name'];
          propertyType = propertyData!['type'];
          description = propertyData!['description'];
          country = propertyData!['country'];
          state = propertyData!['state'];
          city = propertyData!['city'];
          approvalStatus = propertyData!['approvalStatus'];
          chosenRoomAvailable = propertyData!['rooms'];
          sharingOption = propertyData!['sharing'];
          selectedAmenities = List<String>.from(propertyData!['amenities'] ?? []);
          address = propertyData!['address'];
          pincode = propertyData!['pincode'];
          ownerName = propertyData!['ownerName'];
          ownerPhone = propertyData!['ownerPhone'];
          _checkboxValue = propertyData!['isActive'] ?? false;

          if (country != null) {
            stateList = countryState[country] ?? [];
          }
          if (state != null) {
            cityList = stateCity[state] ?? [];
          }
        });
      } else {
        print("Property document does not exist.");
      }
    } catch (e) {
      print("Error fetching property data: $e");
    }
  }

  Future<void> _approveProperty() async {
    try {
      await FirebaseFirestore.instance.collection('properties').doc(widget.propertyId).update({
        'isActive': _checkboxValue,
        'approvalStatus': 'approved',
        'name': propertyName,
        'type': propertyType,
        'description': description,
        'country': country,
        'state': state,
        'city': city,
        'rooms': chosenRoomAvailable,
        'sharing': sharingOption,
        'amenities': selectedAmenities,
        'address': address,
        'pincode': pincode,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property approved successfully.')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error approving property: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve property.')),
      );
    }
  }

  Future<void> _rejectProperty() async {
    try {
      await FirebaseFirestore.instance.collection('properties').doc(widget.propertyId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property rejected and removed.')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error rejecting property: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject property.')),
      );
    }
  }
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    if (propertyData == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Property Approval")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Property Approval")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: propertyName,
                  decoration: InputDecoration(
                    labelText: 'Property Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      propertyName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: propertyType,
                  decoration: InputDecoration(
                    labelText: 'Property Type',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      propertyType = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Room Details',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: chosenRoomAvailable,
                  decoration: InputDecoration(
                    labelText: 'Select number of rooms available',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      chosenRoomAvailable = newValue;
                    });
                  },
                  items: roomsAvailable.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Sharing Option Dropdown
                DropdownButtonFormField<String>(
                  value: sharingOption,
                  decoration: InputDecoration(
                    labelText: 'Select no. of persons sharing allowed',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      sharingOption = value;
                    });
                  },
                  items: sharingOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Amenities Chips
                Text('select available amenities'),
                Wrap(
                  spacing: 8.0,
                  children: amenitiesList.map((amenity) {
                    return ChoiceChip(
                      label: Text(amenity),
                      selected: selectedAmenities.contains(amenity),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedAmenities.add(amenity);
                          } else {
                            selectedAmenities.remove(amenity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  'Property Location Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: country,
                  decoration: InputDecoration(
                    labelText: 'Select Country',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      country = newValue;
                      stateList = countryState[country] ?? [];
                      cityList.clear();
                    });
                  },
                  items: countryState.keys.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // State Dropdown
                DropdownButtonFormField<String>(
                  value: state,
                  decoration: InputDecoration(
                    labelText: 'Select State',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      state = newValue;
                      cityList = stateCity[state] ?? [];
                    });
                  },
                  items: stateList.map((String state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // City Dropdown
                DropdownButtonFormField<String>(
                  value: city,
                  decoration: InputDecoration(
                    labelText: 'Select City',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      city = newValue;
                    });
                  },
                  items: cityList.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: pincode,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      pincode = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: address,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Owner Details',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: ownerName,
                  decoration: InputDecoration(
                    labelText: 'Owner Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      ownerName = value;
                    });
                  },
                ),
                SizedBox(height: 20),

                TextFormField(
                  initialValue: ownerPhone,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      ownerPhone = value;
                    });
                  },
                ),
                SizedBox(height: 20),


                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Approval Status",style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 'approve',
                              groupValue: _approvalStatus,
                              onChanged: (value) {
                                setState(() {
                                  _approvalStatus = value;
                                });
                              },
                            ),
                            Text('Approve '),
                          ],),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Radio(
                              value: 'reject',
                              groupValue: _approvalStatus,
                              onChanged: (value) {
                                setState(() {
                                  _approvalStatus = value;
                                });
                              },
                            ),
                            Text('Reject '),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                if (_approvalStatus=='approve'){
                  _approveProperty();
                }
                else if(_approvalStatus=='reject')
                  {
                    _rejectProperty();
                  }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an approval status')));
                }
              }, child:Text('Save'),),
              SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: _checkboxValue,
                onChanged: (bool? newValue) {
                  setState(() {
                    _checkboxValue = newValue!;
                  });
                },
              ),
              Text('Is Active'),
            ],),
     ] ),
          ))));
  }
}
