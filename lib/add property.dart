import 'dart:io';
import 'package:accomodation/Models/property%20model.dart';
import 'package:accomodation/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  List<String> genderavailability=["Only Boys","Only Girls","Both Girls and Boys","Only Family"];
  String? choosegenderavailability;
  List<String> furnishingtype=["Semi-furnished","Fully furnished","Unfurnished"];
  String? choosefurnishingtype;
  String? choosesharingavailable;
  int? chooseroomavailable;
  Map<String, bool> selectedAmenities = {
    'Wifi': false,
    'Food': false,
    'Housekeeping': false,
    'Laundry Service': false,
    'Parking': false,
    'Television': false,
  };

  Future<void> fetchAreas(String cityId) async {
    try {
      print('Querying Firestore with cityId: $cityId');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Area')
          .where('cityId', isEqualTo: cityId)
          .get();
      print('Snapshot size: ${snapshot.size}');
      snapshot.docs.forEach((doc) {
        print('Doc data: ${doc.data()}');
      });

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
  String imageurl='';

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
              //property details
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
              DropdownButtonFormField<String>(
                value: choosefurnishingtype,
                decoration: InputDecoration(
                  labelText: 'Select Furnishing Type',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    choosefurnishingtype = newValue;
                  });
                },
                items: furnishingtype.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              //room details
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
              DropdownButtonFormField<String>(
                value:choosegenderavailability,
                decoration: InputDecoration(
                    labelText: 'Select suitable occupants',
                    border: OutlineInputBorder()),
                onChanged: (newValue) {
                  setState(() {
                    choosegenderavailability= newValue;
                  });
                },
                items: genderavailability.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              //amenities
              Text(
                'Select Available Amenities',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                children: selectedAmenities.keys.map((amenity) {
                  return ChoiceChip(
                    label: Text(amenity),
                    selected: selectedAmenities[amenity] ?? false,
                    onSelected: (selected) {
                      setState(() {
                        selectedAmenities[amenity] = selected;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

           //property location details
           Text('Property Location Details',
            style: TextStyle(fontWeight: FontWeight.bold),),
           SizedBox(height: 20),
           DropdownButtonFormField<String>(
           value: selectedCity,
           decoration: InputDecoration(labelText: 'Select City', border: OutlineInputBorder()),
           onChanged: (newCityId) {
          setState(() {
            selectedCity = newCityId;
            areaList = [];
            selectedArea = null;});
          if (newCityId != null) {
            fetchAreas(newCityId);
          }},
           items: cityList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );}).toList(),),
           SizedBox(height: 20),
           DropdownButtonFormField<String>(
            value: selectedArea,
            decoration: InputDecoration(
            labelText: 'Select Area', border: OutlineInputBorder()),
            onChanged: (newArea) {
            setState(() {
            selectedArea = newArea;
          });},
           items: areaList.map<DropdownMenuItem<String>>((String value) {
           return DropdownMenuItem<String>(
           value: value,
           child: Text(value),);
           }).toList(),),
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
              //owner details
              Text(
                'Owner Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              //owner section
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
              //upload photo
              Text('Room Photos', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: ()async{
                ImagePicker imagepicker=ImagePicker();
                XFile? file= await imagepicker.pickImage(source: ImageSource.gallery);
                print('image path = ${file?.path}');

                if(file==null)return;
                String filename=DateTime.now().millisecondsSinceEpoch.toString();
                final storageRef = FirebaseStorage.instanceFor(
                    bucket: "hdc-dev-9202b.appspot.com").ref();
                Reference referenceDirimage=storageRef.child('Property Images');
                Reference referenceimagetoupload=referenceDirimage.child(filename);

                try {
                  await referenceimagetoupload.putFile(File(file!.path));
                  imageurl= await referenceimagetoupload.getDownloadURL();
                  print('Download URL: $imageurl');
                }
                catch(error){}
              },
               child: Text("Upload Room Photo"),),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  List<String> selectedAmenitiesList = selectedAmenities.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();
                  final docRef = FirebaseFirestore.instance.collection('properties').doc();
                  Property property = Property(
                    id: docRef.id,
                    name: _propertyNameController.text,
                    type: choosePropertyType ?? '',
                    description: _descriptionController.text,
                    furnishing: choosefurnishingtype ?? '',
                    rooms: chooseroomavailable ?? 0,
                    sharing: choosesharingavailable ?? '',
                    occupants: choosegenderavailability ?? '',
                    amenities: selectedAmenitiesList,
                    area: selectedArea ?? '',
                    city: selectedCity ?? '',
                    pincode: _pincodeController.text,
                    address: _addressController.text,
                    ownerName: _ownerNameController.text,
                    ownerPhone: _phoneController.text,
                    urlimage: imageurl,
                    approvalStatus: 'pending',
                    isActive: true,
                    createdAt: DateTime.timestamp(),
                    //roomImages: _roomImages.map((e) => e.path).toList(),
                  );


                  bool result = await DatabaseMethods().addProperty(property);
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
                      choosegenderavailability=null;
                      choosefurnishingtype=null;
                      selectedAmenities.updateAll((key, value) => false);
                      selectedArea = null;
                      selectedCity = null;
                      //_roomImages.clear();
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
