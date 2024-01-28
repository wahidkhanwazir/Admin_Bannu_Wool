import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Bannu_Model/bannumodel.dart';
import 'Order_Detail.dart';

class GetPaidOrders extends StatefulWidget {
  const GetPaidOrders({super.key});

  @override
  State<GetPaidOrders> createState() => _Page4State();
}

class _Page4State extends State<GetPaidOrders> {
  late Future<QuerySnapshot<BanuModel>> information =
  BanuModel.collection().where("orderComplete", isEqualTo: true).get();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Paid orders", style: TextStyle(fontSize: height/30),),
      ),
      body: FutureBuilder<QuerySnapshot<BanuModel>>(
        future: information,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              BanuModel custumerInfo = snapshot.data!.docs[index].data();
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetail(orderDetails: custumerInfo),
                      ),
                    );
                  },
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 2),
                    ),
                    title: Text(custumerInfo.name.toString(),
                      style: TextStyle(fontSize: height/40, fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(custumerInfo.currentDate as DateTime),
                      style: TextStyle(fontSize: height/50),),
                    leading: CircleAvatar(
                      radius: height/23,
                      child: Text('${index + 1}',
                        style: TextStyle(fontSize: height/30),
                      ),
                    ),
                    trailing: ElevatedButton(
                      child: Icon(Icons.delete,
                        color: Colors.redAccent.shade200,
                        size: height/25,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text("Are you really want to delete this order"),
                              title: const Text('Delete order:'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection("Banu_Wool").doc(snapshot.data!.docs[index].id).delete();
                                    setState(() {
                                      information = BanuModel.collection().where("orderComplete", isEqualTo: true).get();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
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
