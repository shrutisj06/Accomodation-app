import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/property_model.dart';

class DatabaseMethods {

  Future<bool> addProperty(Property property) async {
    try {
      await FirebaseFirestore.instance.collection('properties').add(property.toMap());

      print('Property added successfully');
      return true;
    } catch (e) {
      print('Error adding property: $e');
      return false;
    }
  }


  Future<List<Property>> getAllProperties() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('properties').get();
      print('Fetched snapshot data: ${snapshot.docs.map((doc) => doc.data()).toList()}');

      return snapshot.docs
          .map((doc) => Property.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching properties: $e');
      return [];
    }
  }


  // Approve a property
  Future<void> approveProperty(String propertyId, Property property) async {
    try {
      await FirebaseFirestore.instance.collection('properties').doc(propertyId).update({
        'approvalStatus': 'approved',
        ...property.toMap(),
      });
      print('Property approved and updated successfully');
    } catch (e) {
      print('Error approving property: $e');
    }
  }

  // Reject
  Future<void> rejectProperty(String propertyId) async {
    try {
      await FirebaseFirestore.instance.collection('properties').doc(propertyId).delete();
      print('Property rejected and removed from the database');
    } catch (e) {
      print('Error rejecting property: $e');
    }
  }

  // Get city
  Future<Map<String, dynamic>> getCityData(String cityId) async {
    try {
      DocumentSnapshot citySnapshot = await FirebaseFirestore.instance.collection('City').doc(cityId).get();
      if (citySnapshot.exists) {
        return citySnapshot.data() as Map<String, dynamic>;
      } else {
        print('City not found');
        return {};
      }
    } catch (e) {
      print('Error fetching city data: $e');
      return {};
    }
  }

  // Get area
  Future<Map<String, dynamic>> getAreaData(String areaId) async {
    try {
      DocumentSnapshot areaSnapshot = await FirebaseFirestore.instance.collection('Area').doc(areaId).get();
      if (areaSnapshot.exists) {
        return areaSnapshot.data() as Map<String, dynamic>;
      } else {
        print('Area not found');
        return {};
      }
    } catch (e) {
      print('Error fetching area data: $e');
      return {};
    }
  }
}
