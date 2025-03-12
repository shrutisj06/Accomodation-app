import 'edit_property.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'approval details.dart';
import 'add property.dart';


class ManagePropertiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Manage Properties",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: "Add Property"),
              Tab(icon: Icon(Icons.check), text: "Approve Property"),
            ],
            indicatorColor: Colors.purple,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            AddPropertySection(), // Add Property Section
            ApprovePropertiesSection(), // Approve Property Section
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          elevation: 6.0,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddPropertySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('properties')
          .where('approvalStatus', isEqualTo: 'approved')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            String address = doc['address'] ?? 'N/A';

            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                title: Text(
                  doc['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Address: $address',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>EditProperty(
                          propertyId: doc.id, // Pass the property ID to EditProperty
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ApprovePropertiesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('properties')
          .where('approvalStatus', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];


            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                title: Text(
                  doc['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                    size: 18,
                  ),
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
              ),
            );
          },
        );
      },
    );
  }
}
