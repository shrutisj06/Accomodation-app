import 'dart:io';
import 'package:accomodation/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();


}
class _HomePageState extends State<HomePage> {
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? choosePropertyType;
  List<String> listItems = ['Apartment', 'PG', 'Flat', 'Room'];
  List<int> roomsavailable = List.generate(10, (index) => index + 1);
  List<String> sharingavailable = [
    '0 person sharing',
    '1 person sharing',
    '2 person sharing',
    '3 person sharing'
  ];
  String? choosesharingavailable;
  int? chooseroomavailable;
  Map<String, bool> selectedAmenities = {
    'Wifi': false,
    'Food': false,
    'Housekeeping': false,
    'Laundry Service': false,
    'Furnished Room': false,
    'Parking': false,
    'Television': false,
  };

  Future<void> fetchAreas(String cityId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Area')
          .where('cityId', isEqualTo: cityId)
          .get();
      List<String> fetchedAreas = snapshot.docs
          .map((doc) => doc['areaName'] as String)
          .toList();

      setState(() {
        areaList = fetchedAreas;
        selectedArea = null;
      });
      print("Area: $fetchedAreas");
    } catch (e) {
      print('Error fetching area data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch areas')),
      );
    }
  }
  Future<void> fetchCities() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('City').get();
      List<String> fetchedCities = snapshot.docs.map((doc) => doc['cityName'] as String).toList();

      setState(() {
        cityList = fetchedCities;
      });
      print("Cities: $fetchedCities");
    } catch (e) {
      print('Error fetching city data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch cities')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    fetchCities();
  }
  List<String> cityList = [];
  String? selectedCity;
  List<String> areaList = [];
  String? selectedArea;
  bool isLoading = false;

  List<File> _roomImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _roomImages.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Property')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _propertyNameController,
                decoration: InputDecoration(
                  labelText: 'Property Name',
                  hintText: 'ABC apartments',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: choosePropertyType,
                decoration: InputDecoration(
                  labelText: 'Select Property Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    choosePropertyType = newValue;
                  });
                },
                items: listItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'About the property',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text('Room Details', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: chooseroomavailable,
                decoration: InputDecoration(
                    labelText: 'Select no. of rooms available',
                    border: OutlineInputBorder()),
                onChanged: (newValue) {
                  setState(() {
                    chooseroomavailable = newValue;
                  });
                },
                items: roomsavailable.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: choosesharingavailable,
                decoration: InputDecoration(
                    labelText: 'Select no. of persons sharing allowed',
                    border: OutlineInputBorder()),
                onChanged: (newValue) {
                  setState(() {
                    choosesharingavailable = newValue;
                  });
                },
                items: sharingavailable.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Amenities checklist
              Text(
                'Select Available Amenities',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...selectedAmenities.keys.map((amenity) {
                return CheckboxListTile(
                  title: Text(amenity),
                  value: selectedAmenities[amenity],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedAmenities[amenity] = value ?? false;
                    });
                  },
                );
              }).toList(),

              SizedBox(height: 20),
              Text(
                'Property Location Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCity,
                decoration: InputDecoration(
                    labelText: 'Select City', border: OutlineInputBorder()),
                onChanged: (newCityId) {
                  setState(() {
                    selectedCity = newCityId;
                    areaList = [];
                    selectedArea = null;
                  });
                  if (newCityId != null) {
                    fetchAreas(newCityId);
                  }
                },
                items: cityList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedArea,
                decoration: InputDecoration(
                    labelText: 'Select Area', border: OutlineInputBorder()),
                onChanged: (newArea) {
                  setState(() {
                    selectedArea = newArea;
                  });
                },
                items: areaList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _pincodeController,
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  hintText: 'Enter area pincode',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Owner Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _ownerNameController,
                decoration: InputDecoration(
                  labelText: 'Owner Name',
                  hintText: 'Enter owner name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              Text('Room Photos', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Upload Room Photo"),
              ),
              _roomImages.isNotEmpty
                  ? Wrap(
                spacing: 10,
                children: _roomImages.map((image) {
                  return Stack(
                    children: [
                      Image.file(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _roomImages.remove(image);
                            });
                          },
                          child: Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )
                  : Text("No images selected"),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  List<String> selectedAmenitiesList = selectedAmenities.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  Map<String, dynamic> propertyData = {
                    "propertyName": _propertyNameController.text,
                    "propertyType": choosePropertyType,
                    "description": _descriptionController.text,
                    "roomAvailable": chooseroomavailable,
                    "sharingAvailable": choosesharingavailable,
                    "amenities": selectedAmenitiesList,
                    "state": selectedArea,
                    "city": selectedCity,
                    "pincode": _pincodeController.text,
                    "address": _addressController.text,
                    "ownerName": _ownerNameController.text,
                    "phoneNumber": _phoneController.text,
                    "roomImages": _roomImages.map((e) => e.path).toList(),
                  };

                  bool result = await DatabaseMethods().addProperty(propertyData);
                  setState(() {
                    isLoading = false;
                  });

                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Property added successfully!')),
                    );
                    _propertyNameController.clear();
                    _descriptionController.clear();
                    _pincodeController.clear();
                    _addressController.clear();
                    _ownerNameController.clear();
                    _phoneController.clear();
                    setState(() {
                      choosePropertyType = null;
                      chooseroomavailable = null;
                      choosesharingavailable = null;
                      selectedAmenities.updateAll((key, value) => false);
                      selectedArea = null;
                      selectedCity = null;
                      _roomImages.clear();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add property')),
                    );
                  }
                },
                child: isLoading ? CircularProgressIndicator() : Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
