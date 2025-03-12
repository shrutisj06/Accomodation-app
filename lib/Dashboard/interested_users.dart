import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InterestedUsers extends StatelessWidget {
  final String propertyId;
  const InterestedUsers({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Interested People")),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchInterestedUsers(propertyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No interested users found"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8),
                elevation: 3,
                child: ListTile(
                  title: Text(user['userName'] ?? 'No Name'),
                  subtitle: Text(user['userContact'] ?? 'No Contact'),
                  leading: Icon(Icons.person),
                ),
              );
            },
          );
        },
      ),
    );
  }
  

 Stream <QuerySnapshot> fetchInterestedUsers(String propertyId){
    return FirebaseFirestore.instance
        .collection('Interested_Users')
        .where('propertyId',isEqualTo: propertyId)
        .snapshots();
 }
}
