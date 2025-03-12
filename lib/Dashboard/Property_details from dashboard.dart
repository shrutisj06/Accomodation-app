import 'package:accomodation/Dashboard/userdetails_dialog.dart';
import 'package:flutter/material.dart';

import '../Models/property_model.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Property property;
  final String propertyId;

  const PropertyDetailsScreen({
    Key? key,
    required this.property,
    required this.propertyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Property Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Name
                    Text(
                      property.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Property Type",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.type ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Furnishing Type ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.furnishing ?? 'Not mentioned',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    //room details
                    Text(
                      "Description: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Number of rooms available ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                       property.rooms!= null
                          ? property.rooms.toString()
                          : 'Not available',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sharing available ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.sharing?? 'Not available',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Suitable occupants ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.occupants ?? 'Not available',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    // Property Location
                    Text(
                      "City: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.city ?? 'Not specified',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Area: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.area ?? 'Not specified',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Pincode: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.pincode ?? 'Not specified',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Address: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.address ?? 'Not specified',
                      style: TextStyle(fontSize: 16),
                    ),
                    //amenities
                    SizedBox(height: 10),
                    Text(
                      "Amenities Provided: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      children: List.generate(
                        (property.amenities as List<dynamic>?)?.length ?? 0,
                            (index) => Chip(
                          label: Text(property.amenities[index]),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //owmer details
                    Text(
                      "Owner Information: ",
                      style: TextStyle(
                        fontSize:22 ,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Owner name ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.ownerName ?? 'Not specified',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Owner Phone number ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      property.ownerPhone ?? 'Not specified',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed:(){
                     // print("Opening dialog with propertyId: $propertyId");
                     showDialog(context:context, builder: (context)=>UserdetailsDialog(propertyId: propertyId),
                     );
                    },
                      child: Text("Interested",style: TextStyle(color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green
                        ),

                    )


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
