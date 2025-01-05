import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'approval details.dart';


class ApprovePropertiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approve Properties"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('properties')
            .where('approvalStatus', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No properties awaiting approval"));
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => Divider(
              thickness: 1.0,
              color: Colors.grey[300],
            ),
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                leading: Icon(Icons.home, color: Colors.purple),
                title: Text(
                  doc['name'] ?? 'Unnamed Property',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  doc['city'] ?? 'No city selected',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApprovePropertyDetailsPage(
                          propertyId: doc.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
