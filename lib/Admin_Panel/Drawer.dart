
import 'package:flutter/material.dart';
import '../Get_Orders/Get_total_orders.dart';
import 'Admin_Total_Items.dart';
import 'FeedBack.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});
  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}
class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height/4.5,
            width: double.infinity,
            color: Colors.blue.shade100,
            child: Image.asset('assets/DirhamLogo2.png'),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const GetAdminItems()));
                  },
                  child: Container(
                    height: height/15,
                    width: double.infinity,
                    color: Colors.grey,
                    child: Row(
                      children: [
                        Text(' 1)  ',style: TextStyle(fontSize: height/35),),
                        Icon(Icons.home,size: height/35,),
                        SizedBox(width: 15,),
                        Text('Home',style: TextStyle(fontSize: height/35),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> const GetTotalOrders()));
                  },
                  child: Container(
                    height: height/15,
                    width: double.infinity,
                    color: Colors.grey,
                    child: Row(
                      children: [
                        Text(' 2)  ',style: TextStyle(fontSize: height/35),),
                        Icon(Icons.note,size: height/35,),
                        SizedBox(width: 15,),
                        Text('Orders',style: TextStyle(fontSize: height/35),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> const GetFeedback()));
                  },
                  child: Container(
                    height: height/15,
                    width: double.infinity,
                    color: Colors.grey,
                    child: Row(
                      children: [
                        Text(' 3)  ',style: TextStyle(fontSize: height/35),),
                        Icon(Icons.star,size: height/35,),
                        SizedBox(width: 15,),
                        Text('User Feedbacks',style: TextStyle(fontSize: height/35),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}