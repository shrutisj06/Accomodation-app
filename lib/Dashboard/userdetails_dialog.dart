import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserdetailsDialog extends StatefulWidget {
  final String propertyId;
  const UserdetailsDialog({super.key,required this.propertyId});


  @override
  State<UserdetailsDialog> createState() => _UserdetailsDialogState();
}

class _UserdetailsDialogState extends State<UserdetailsDialog> {
  @override
  void initState() {
    super.initState();
    print('Received propertyId in dialog: ${widget.propertyId}');  // Debugging
  }
  @override
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 450,
        height: 250,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Enter your Details",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),

            TextField( controller: nameController,
              decoration: InputDecoration(labelText: "Name"),),
            TextField(controller: contactController,
              decoration: InputDecoration(labelText: "Contact no."),
              keyboardType: TextInputType.phone,),

            SizedBox(height: 25,),
            Row(
              children: [
                ElevatedButton(onPressed:()async {
                  await saveUserDetails(nameController.text,
                    contactController.text,
                    widget.propertyId,);

            },
                    child: Text("Save",style: TextStyle(color: Colors.black),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                Spacer(),
                ElevatedButton(onPressed:(){
                  Navigator.pop(context);
                },
                    child: Text("Cancel",style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),


              ],
            )
          ],
        ),
      ),
    );
  }

  Future <void> saveUserDetails(String name,String contact,String propertyId) async{
    print('Property ID before saving: $propertyId');
    if(nameController.text.isEmpty || contactController.text.isEmpty)
  {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kindly fill details")));
  return;
  }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("Interested_Users").add(
  {
    "userName": nameController.text,
    "userContact":contactController.text,
    "propertyId":widget.propertyId,
    "timestamp": FieldValue.serverTimestamp(),
  });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Details saved successfully.")));
Navigator.pop(context);
}

}

