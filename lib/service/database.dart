import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future<bool> addProperty(Map<String, dynamic> propertyData) async {
    try {
      await FirebaseFirestore.instance.collection('properties').add({
        'name': propertyData['propertyName'],
        'type': propertyData['propertyType'],
        'description': propertyData['description'],
        'rooms': propertyData['roomAvailable'],
        'sharing': propertyData['sharingAvailable'],
        'amenities': propertyData['amenities'],
        'address': propertyData['address'],
        'pincode': propertyData['pincode'],
        'ownerName': propertyData['ownerName'],
        'ownerPhone': propertyData['phoneNumber'],
        'approvalStatus': 'pending',
        'isActive': false,
        'created_at': Timestamp.now(),
      });

      print('Property added successfully');
      return true;
    } catch (e) {
      print('Error adding property: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllCities() async {
    try {
      QuerySnapshot citySnapshot = await FirebaseFirestore.instance.collection('City').get();
      return citySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllAreas() async {
    try {
      QuerySnapshot areaSnapshot = await FirebaseFirestore.instance.collection('Area').get();
      return areaSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching areas: $e');
      return [];
    }
  }


  Future<void> approveProperty(
      String propertyId,
      String name,
      String type,
      String description,
      int rooms,
      String sharing,
      List<String> amenities,
      String address,
      String pincode,
      String ownerName,
      String ownerPhone,
      bool isActive,
      ) async {
    try {
      await FirebaseFirestore.instance.collection('properties').doc(propertyId).update({
        'approvalStatus': 'approved',
        'name': name,
        'type': type,
        'description': description,
        'rooms': rooms,
        'sharing': sharing,
        'amenities': amenities,
        'address': address,
        'pincode': pincode,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'isActive':isActive,

      });
      print('Property approved and updated successfully');
    } catch (e) {
      print('Error approving property: $e');
    }
  }


  Future<void> rejectProperty(String propertyId) async {
    try {
      await FirebaseFirestore.instance.collection('properties').doc(propertyId).delete();
      print('Property rejected and removed from the database');
    } catch (e) {
      print('Error rejecting property: $e');
    }
  }

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