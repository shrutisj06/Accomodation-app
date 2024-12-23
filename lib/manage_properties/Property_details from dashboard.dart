import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsScreen({required this.propertyId, super.key, required Map<String, dynamic> property});

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  Map<String, dynamic>? property;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
  }

  Future<void> fetchPropertyDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .get();

      if (snapshot.exists) {
        setState(() {
          property = snapshot.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Property not found')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching property: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (property == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Property Details'),
        ),
        body: Center(
          child: Text('Property not found'),
        ),
      );
    }

    final fields = {
      'Name': property!['name'] ?? 'Null',
      'Location': property!['Country'] ?? 'Null',
      'Description': property!['description'] ?? 'No description available',
      'Rooms Available' : property!['roomAvailable'] ?? '1',
      'Room Sharing' : property!['sharingAvailable'] ?? '0',
      'Owner': property!['owner'] ?? 'Owner information not available',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(property!['name'] ?? 'Property Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: fields.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    entry.value,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
