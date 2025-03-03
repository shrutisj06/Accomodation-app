import 'manage_properties.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/property_model.dart';

class EditProperty extends StatefulWidget {
  final String propertyId;

  EditProperty({required this.propertyId});

  @override
  EditPropertyState createState() => EditPropertyState();
}

class EditPropertyState extends State<EditProperty> {
  final _formKey = GlobalKey<FormState>();
  Property? property;
  List<String> cities = [];
  List<String> areas = [];
  String? selectedCity;
  String? selectedArea;
  String? approvalStatus;



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
          selectedCity = property!.city;
          selectedArea = property!.area;
        });
      } else {
        print("Property document does not exist.");}
    } catch (e) {
      print("Error fetching property data: $e");}
  }
  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('properties')
            .doc(widget.propertyId)
            .update({
          'name': property!.name,
          'type': property!.type,
          'description': property!.description,
          'furnishing': property!.furnishing,
          'rooms': property!.rooms,
          'sharing': property!.sharing,
          'occupants':property!.occupants,
          'amenities': property!.amenities,
          'address': property!.address,
          'city':property!.city,
          'area':property!.area,
          'pincode': property!.pincode,
          'ownerName': property!.ownerName,
          'ownerPhone': property!.ownerPhone,
          'approvalStatus':property!.approvalStatus,
          'isActive': property!.isActive,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Changes saved successfully.')),
        );
      } catch (e) {
        print("Error saving changes: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes.')),
        );}
    }}

  Future<void> _fetchCitiesAndAreas() async {
    try {
      QuerySnapshot citySnapshot = await FirebaseFirestore.instance
          .collection('cities')
          .get();
      setState(() {
        cities = citySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
      if (selectedCity != null) {
        QuerySnapshot areaSnapshot = await FirebaseFirestore.instance
            .collection('areas')
            .where('city', isEqualTo: selectedCity)
            .get();
        setState(() {
          areas = areaSnapshot.docs.map((doc) => doc['name'] as String).toList();
        });
      }
    } catch (e) {print("Error fetching city and area data: $e");}
  }

  @override
  Widget build(BuildContext context) {
    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Edit Property")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text("Edit Property")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //propery details
                TextFormField(
                  initialValue: property!.name,
                  decoration: InputDecoration(
                    labelText: 'Property Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.name = value;
                    });},
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: property!.type,
                  decoration: InputDecoration(
                    labelText: 'Property Type',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.type = value!;
                    });
                  },
                  items: ['Apartment','PG','Flat','Room'].map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),);}).toList(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: property!.furnishing,
                  decoration: InputDecoration(
                    labelText: 'Furnishing Type',
                    border: OutlineInputBorder(),),
                  onChanged: (value) {
                    setState(() {
                      property!.furnishing= value!;
                    });
                  },
                  items: ['Semi-furnished','Fully furnished','Unfurnished'].map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),);}).toList(),),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: property!.description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.description = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                //room details
                DropdownButtonFormField<int>(
                  value: property!.rooms,
                  decoration: InputDecoration(
                    labelText: 'Select number of rooms available',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      property!.rooms = newValue!;
                    });
                  },
                  items: List.generate(10, (index) => index + 1).map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: property!.sharing,
                  decoration: InputDecoration(
                    labelText: 'Select sharing option',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.sharing = value!;
                    });
                  },
                  items: [
                    '0 person sharing', '1 person sharing', '2 person sharing', '3 person sharing'
                  ].map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: property!.occupants,
                  decoration: InputDecoration(
                    labelText: 'Suitable Occupants',
                    border: OutlineInputBorder(),),
                  onChanged: (value) {
                    setState(() {
                      property!.occupants= value!;});
                  },
                  items: ['Only Boys','Only Girls','Both Girls and Boys','Only Family'].map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),);}).toList(),),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  children: ['Wifi', 'Food', 'Housekeeping', 'Laundry Service', 'Parking', 'Television']
                      .map((amenity) {
                    return ChoiceChip(
                      label: Text(amenity),
                      selected: property!.amenities.contains(amenity),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            property!.amenities.add(amenity);
                          } else {
                            property!.amenities.remove(amenity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                //property location details
                SizedBox(height: 20),
                // DropdownButtonFormField<String>(
                //   value: selectedCity,
                //   decoration: InputDecoration(
                //     labelText: 'City',
                //     border: OutlineInputBorder(),),
                //   onChanged: (value) {
                //     setState(() {
                //       selectedCity = value;
                //       _fetchCitiesAndAreas();});
                //   },
                //   items: cities.isEmpty ? [
                //     DropdownMenuItem<String>(value: null,
                //         child: Text("Loading cities..."))] :
                //   cities.map((city) {
                //     return DropdownMenuItem<String>(
                //       value: city,
                //       child: Text(city),
                //     );
                //   }).toList(),),
                SizedBox(height: 20),
                // DropdownButtonFormField<String>(
                //   value: selectedArea,
                //   decoration: InputDecoration(
                //     labelText: 'Area',
                //     border: OutlineInputBorder(),),
                //   onChanged: (value) {
                //     setState(() {
                //       selectedArea = value;});
                //   },
                //   items: areas.isEmpty ? [
                //     DropdownMenuItem<String>(value: null,
                //         child: Text("Loading cities..."))] :
                //   areas.map((area) {
                //     return DropdownMenuItem<String>(
                //       value: area,
                //       child: Text(area),);}).toList(),
                // ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: property!.pincode,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.pincode = value;});},
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: property!.address,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.address = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                //owner details
                Text(
                  'Owner Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: property!.ownerName,
                  decoration: InputDecoration(
                    labelText: 'Owner Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.ownerName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: property!.ownerPhone,
                  decoration: InputDecoration(
                    labelText: 'Owner Phone',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      property!.ownerPhone = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: property!.isActive,
                      onChanged: (bool? newValue) {
                        setState(() {
                          property!.isActive = newValue!;
                        });
                      },
                    ),
                    Text('Is Active'),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [ Text('Approval Status: '),
                //     Radio<String>(
                //       value: 'approved',
                //       groupValue: approvalStatus,
                //       onChanged: (value) {
                //         setState(() {
                //           approvalStatus = value;});},
                //     ),
                //     Text('Approve'),
                //     Radio<String>(
                //       value: 'rejected',
                //       groupValue: approvalStatus,
                //       onChanged: (value) {
                //         setState(() {approvalStatus = value;
                //         });
                //       },),
                //     Text('Reject'),],
                // ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveChanges();
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ManagePropertiesPage()),);
                    },
                    child: Text('Save Changes'),
                  ),
                ),]
            ))),),
          );
  }
}
