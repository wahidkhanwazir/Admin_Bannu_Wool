import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Bannu_Model/bannumodel.dart';
import 'Order_Detail.dart';
import 'Paid_Orders.dart';

class GetTotalOrders extends StatefulWidget {
  const GetTotalOrders({super.key});

  @override
  State<GetTotalOrders> createState() => _Page4State();
}

class _Page4State extends State<GetTotalOrders> {
  late Future<QuerySnapshot<BanuModel>> information =
  BanuModel.collection().where("orderComplete", isEqualTo: false).get();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Non paid orders",style: TextStyle(fontSize: height/30),),
      ),
      body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot<BanuModel>>(
                  stream: information.asStream(),
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
                              child: ListTile(
                                shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.blue, width: 2)),
                                title: Text(custumerInfo.name.toString(),
                                  style: TextStyle(fontSize: height/40, fontWeight: FontWeight.bold),),
                                subtitle: Text(DateFormat('yyyy-MM-dd').format(custumerInfo.currentDate as DateTime),
                                  style: TextStyle(fontSize: height/48),),
                                leading:  CircleAvatar(
                                  radius: height/25,
                                  backgroundColor: Colors.blue,
                                  child: Text('${index + 1}',style: TextStyle(fontSize: height/35),),
                                ),
                                trailing: ElevatedButton(
                                  child: Icon(
                                    Icons.transfer_within_a_station,
                                    color: Colors.redAccent.shade200,
                                    size: height/25,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: const Text("Transfer file:"),
                                            title: const Text('Are you really want to transfer this order?????'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    DocumentReference orderRef = snapshot.data!.docs[index].reference;
                                                    await orderRef.update({'orderComplete': true});
                                                    setState(() {
                                                      information =
                                                          BanuModel.collection().where("orderComplete", isEqualTo: false).get();
                                                    });
                                                    Navigator.pop(context); // Close the dialog
                                                  },
                                                  child: const Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No')),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetail(orderDetails: custumerInfo,)));
                              },
                            ),
                          );
                        });
                  }),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>const GetPaidOrders()));
                },
                child: Container(
                  height: height/14,
                  width: height/5,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Paid Orders',style: TextStyle(fontSize: height/40),),
                      Icon(Icons.forward)
                    ],
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }
}