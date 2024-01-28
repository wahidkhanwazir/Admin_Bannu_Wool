import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Bannu_Model/bannumodel.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key,
    required this.orderDetails,
  });

  final BanuModel orderDetails;

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Order Details',style: TextStyle(fontSize: height/30),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              children: [
                Text('Order Name: ${widget.orderDetails.name}',style: TextStyle(fontSize: height/47),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text('Contact Number: 0${widget.orderDetails.contactNo}',style: TextStyle(fontSize: height/47),),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    onTap: (){
                      FlutterPhoneDirectCaller.callNumber('0${widget.orderDetails.contactNo}');
                    },
                    child: CircleAvatar(
                        radius: height/45,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.call,color: Colors.white,)
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text('District: ${widget.orderDetails.district}',style: TextStyle(fontSize: height/47),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text('City: ${widget.orderDetails.city}',style: TextStyle(fontSize: height/47),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text('Address: ${widget.orderDetails.address}',style: TextStyle(fontSize: height/47),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text('Total amount: R.s ${widget.orderDetails.totalAmount}.0',style: TextStyle(fontSize: height/47),),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderDetails.items.length,
              itemBuilder: (context, index) {
                final item = widget.orderDetails.items[index];
                return ListTile(
                  title: Text('Item: ${item['title']}',style: TextStyle(fontSize: height/45),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${item['quantity']}',style: TextStyle(fontSize: height/47),),
                    ],
                  ),
                  leading: InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.blue,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          body: Center(
                            child: PhotoView(
                              imageProvider: NetworkImage(item['imageUrl']),
                              minScale: PhotoViewComputedScale.contained * 0.8,
                              maxScale: PhotoViewComputedScale.covered * 2,
                              backgroundDecoration: BoxDecoration(
                                color: Colors.yellow.shade50,
                              ),
                            ),
                          ),
                        ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: item['imageUrl'],
                      width: height/13,
                      height: height/13,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircularProgressIndicator(color: Colors.blue,),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}