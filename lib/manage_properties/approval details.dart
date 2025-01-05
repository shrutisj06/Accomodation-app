import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../Models/property model.dart';

class ApprovePropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  ApprovePropertyDetailsPage({required this.propertyId});

  @override
  _ApprovePropertyDetailsPageState createState() =>
      _ApprovePropertyDetailsPageState();
}

class _ApprovePropertyDetailsPageState extends State<ApprovePropertyDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  Property? property;
  bool _checkboxValue = false;
  String? _approvalStatus;

  List<String> cityList = [];
  List<String> areaList = [];
  List<String> allAmenities = [
    "Wifi", "Food", "Housekeeping", "Laundry Service",  "Parking","Television"
  ];
  int? chooseroomavailable;
  List<int> roomsavailable = [1, 2, 3, 4, 5];
  List<String> sharingavailable = [
    '0 person sharing',
    '1 person sharing',
    '2 person sharing',
    '3 person sharing'
  ];
  String? choosesharingavailable;
  List<String> genderavailability=["Only Boys","Only Girls","Both Girls and Boys","Only Family"];
  String? choosegenderavailability;
  List<String> furnishingtype=["Semi-furnished","Fully furnished","Unfurnished"];
  String? choosefurnishingtype;
  String? choosePropertyType;
  List<String> listItems = ['Apartment', 'PG', 'Flat', 'Room'];
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
          property = Property.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          chooseroomavailable = property?.rooms;
          choosesharingavailable=property?.sharing;
          choosefurnishingtype=property?.furnishing;
          choosegenderavailability=property?.occupants;
          choosePropertyType=property?.type;
         // print("Occupants fetched from Firestore: ${property?.occupants}");

          //print("Rooms fetched from Firestore: $chooseroomavailable");
          _checkboxValue = property?.isActive ?? false;
          _fetchCities(property?.city);
        });
      } else {
        print("Property does not exist.");
      }
    } catch (e) {
      print("Error fetching property data: $e");
    }
  }

  Future<void> _fetchCities(String? selectedCity) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('City')
          .get();

      setState(() {
        cityList = snapshot.docs.map((doc) => doc['cityName'] as String).toList();
        if (selectedCity != null && cityList.contains(selectedCity)) {
          property?.city = selectedCity;
        }
      });
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  Future<void> _fetchAreas(String? city) async {
    if (city == null || city.isEmpty) return;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Area')
          .get();

      setState(() {
        areaList = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print("Error fetching areas: $e");
    }
  }

  Future<void> _savePropertyData() async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .update(property!.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property details updated successfully.')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error saving property data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save property data.')),
      );
    }
  }

  Future<void> _approveProperty() async {
    property?.approvalStatus = 'approved';
    property?.isActive = _checkboxValue;
    await _savePropertyData();
  }

  Future<void> _rejectProperty() async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .delete();
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

  @override
  Widget build(BuildContext context) {
    if (property == null) {
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
                  initialValue: property?.name,
                  decoration: InputDecoration(
                    labelText: 'Property Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => property?.name = value),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value:  choosePropertyType!= null && listItems.contains(choosePropertyType)
                      ? choosePropertyType
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Property Type',
                      border: OutlineInputBorder()),
                  onChanged: (newValue) {
                    setState(() {
                     choosePropertyType = newValue;
                      property?.type = newValue;
                    });
                  },
                  items: listItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),);
                  }).toList(),),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: choosefurnishingtype != null && furnishingtype.contains(choosefurnishingtype)
                      ? choosefurnishingtype
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Furnishing type',
                      border: OutlineInputBorder()),
                  onChanged: (newValue) {
                    setState(() {
                      choosefurnishingtype = newValue;
                      property?.furnishing = newValue;
                    });
                  },
                  items: furnishingtype.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),);
                  }).toList(),),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: property?.description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => property?.description = value),
                ),
                SizedBox(height: 20),
                Text('Room Details', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: choosesharingavailable != null && sharingavailable.contains(choosesharingavailable)
                      ? choosesharingavailable
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Sharing available',
                      border: OutlineInputBorder()),
                  onChanged: (newValue) {
                    setState(() {
                      choosesharingavailable = newValue;
                      property?.sharing = newValue;
                    });
                  },
                  items: sharingavailable.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),);
                  }).toList(),),
                SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: chooseroomavailable != null && roomsavailable.contains(chooseroomavailable)
                      ? chooseroomavailable
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Rooms available',
                      border: OutlineInputBorder()),
                  onChanged: (newValue) {
                    setState(() {
                      chooseroomavailable = newValue;
                      property?.rooms = newValue;
                    });
                  },
                  items: roomsavailable.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),);
                  }).toList(),),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: choosegenderavailability != null && genderavailability.contains(choosegenderavailability)
                      ? choosegenderavailability
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Suitable occupants',
                      border: OutlineInputBorder()),
                  onChanged: (newValue) {
                    setState(() {
                      choosegenderavailability = newValue;
                      property?.occupants = newValue;
                    });
                  },
                  items: genderavailability.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),);
                  }).toList()),
                SizedBox(height: 20),
                Text(
                  ' Available Amenities',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  children: allAmenities.map((amenity) {
                    bool isSelected = property?.amenities?.contains(amenity) ?? false;
                    return ChoiceChip(
                      label: Text(amenity),
                      selected: isSelected,
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          property?.amenities?.add(amenity);
                        } else {
                          property?.amenities?.remove(amenity);
                        }
                      }),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text('Property Location Details',
                  style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: cityList.isNotEmpty && cityList.contains(property?.city)
                      ? property?.city
                      : null,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property?.city = value;
                      _fetchAreas(value);
                    });
                  },
                  items: cityList.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: areaList.isNotEmpty && areaList.contains(property?.area)
                      ? property?.area
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => property?.area = value),
                  items: areaList.map((area) {
                    return DropdownMenuItem(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    hintText: 'Enter area pincode',
                    border: OutlineInputBorder(),),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: TextEditingController(text: property?.pincode ?? ''),
                  onChanged: (value) => setState(() => property?.pincode = value),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter address',
                    border: OutlineInputBorder(),),
                  controller: TextEditingController(text: property?.address ?? ''),
                  onChanged: (value) => setState(() => property?.address = value),
                ),
                SizedBox(height: 20),
                Text(
                  'Owner Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Owner Name',
                    hintText: 'Enter owner name',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: property?.ownerName ?? ''),
                  onChanged: (value) => setState(() => property?.ownerName = value),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter phone number',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: property?.ownerPhone ?? ''),
                  onChanged: (value) => setState(() => property?.ownerPhone = value),
                  keyboardType: TextInputType.phone,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _approveProperty,
                      child: Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: _rejectProperty,
                      child: Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
