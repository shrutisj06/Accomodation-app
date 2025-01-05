import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
   String id;
   String name;
   String? type;
   String description;
   String? furnishing;
   int? rooms;
   String? sharing;
   String? occupants;
   List<String> amenities;
   String address;
   String? city;
   String? area;
   String? pincode;
   String? ownerName;
   String? ownerPhone;
   String? urlimage;
   String approvalStatus;
   bool isActive;
   DateTime createdAt;


  // Constructor
  Property({
    required this.id,
    required this.name,
    this.type,
    this.furnishing,
    required this.description,
    this.rooms,
    this.sharing,
    this.occupants,
    required this.amenities,
    required this.address,
    this.city,
    this.area,
    this.pincode,
    this.ownerName,
    this.ownerPhone,
    this.urlimage,
    required this.approvalStatus,
    required this.isActive,
    required this.createdAt,
  });

  // Convert object to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'furnishing': furnishing,
      'description': description,
      'rooms': rooms,
      'sharing': sharing,
      'occupants':occupants,
      'amenities': amenities,
      'address': address,
      'city': city,
      'area': area,
      'pincode': pincode,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'urlimage':urlimage,
      'approvalStatus': approvalStatus,
      'isActive': isActive,
      'created_at': createdAt.toIso8601String(),

    };


  }

  // Convert map to object
  factory Property.fromMap(Map<String, dynamic> map, String documentId) {
    return Property(
      id: documentId,
      name: map['name'],
      type: map['type'],
      furnishing: map['furnishing'],
      description: map['description'] ,
      rooms: map['rooms'],
      sharing: map['sharing'],
      occupants: map['occupants'],
      amenities: List<String>.from(map['amenities']),
      address: map['address'] ,
      city: map['city'],
      area: map['area'],
      pincode: map['pincode'] ,
      ownerName: map['ownerName'],
      ownerPhone: map['ownerPhone'] ,
      urlimage: map['urlimage'],
      approvalStatus: map['approvalStatus'] ?? 'pending',
      isActive: map['isActive'] ,
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : DateTime.parse(map['created_at'] ?? DateTime.now().toString()),
    );
  }

}
Future<void> addProperty(Property property) async {
  try {
    final propertyRef = FirebaseFirestore.instance.collection('properties').doc();
    property.id = propertyRef.id;
    print('Generated ID: ${property.id}');

    await propertyRef.set(property.toMap());
    print('Property added with ID: ${property.id}');
  } catch (e) {
    print('Failed to add property: $e');
    throw Exception('Error adding property');
  }


}