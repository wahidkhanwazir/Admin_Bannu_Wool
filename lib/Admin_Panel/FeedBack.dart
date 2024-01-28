import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetFeedback extends StatefulWidget {
  const GetFeedback({super.key});

  @override
  State<GetFeedback> createState() => _GetFeedbackState();
}

class _GetFeedbackState extends State<GetFeedback> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Feedback',style: TextStyle(fontSize: height/30),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No feedback available'));
          }

          var feedbackDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              var feedbackData = feedbackDocs[index].data() as Map<String, dynamic>;
              var email = feedbackData['email'];
              var feedback = feedbackData['feedback'];
              var deviceInfo = feedbackData['deviceInfo'];

              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text('Are you sure you want to delete this feedback?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Cancel deletion
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Confirm deletion
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async {
                  await FirebaseFirestore.instance.collection('feedback').doc(feedbackDocs[index].id).delete();
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                          children: [
                            Text('${index + 1}) ''Email: $email',
                                style: TextStyle(fontSize: width/23, fontWeight: FontWeight.bold))]),
                      Wrap(
                          children: [
                            Text('Device: $deviceInfo', style: TextStyle(fontSize: width/25))]),
                      Wrap(
                          children: [
                            Text('Feedback: $feedback', style: TextStyle(fontSize: width/25))]),
                      const Divider(color: Colors.blue, indent: 10, endIndent: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}