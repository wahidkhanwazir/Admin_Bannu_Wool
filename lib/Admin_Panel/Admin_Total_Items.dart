
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Add_Items.dart';
import 'Drawer.dart';
import 'Total_Colors.dart';

class GetAdminItems extends StatefulWidget {
  const GetAdminItems({super.key});

  @override
  State<GetAdminItems> createState() => _GetAdminItemsState();
}

class _GetAdminItemsState extends State<GetAdminItems> {
  int getColorsCount(String design, List<QueryDocumentSnapshot> items) {
    return items.where((item) => item['design'] == design).length;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      floatingActionButton: InkWell(
        highlightColor: Colors.white,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminPanel()),
          );
        },
        child: Container(
          height: height/15,
          width: width/3.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white, size: height/23),
              SizedBox(width: 5),
              Text('Add', style: TextStyle(fontSize: height/29, color: Colors.white)),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Admin Items',style: TextStyle(fontSize: height/29),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data!.docs;

          // Extract unique designs
          Set<String> uniqueDesigns = Set<String>();
          for (var item in items) {
            uniqueDesigns.add(item['design'] as String? ?? '');
          }

          List<String> uniqueDesignList = uniqueDesigns.toList();

          return uniqueDesignList.isEmpty
              ? const Center(child: Text('Please check your internet connection'))
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 8 / 11,
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: uniqueDesignList.length,
              itemBuilder: (context, index) {
                final design = uniqueDesignList[index];

                var firstItem = items.firstWhere((item) => item['design'] == design);

                final imageUrl = firstItem['image'] as String?;
                final price = firstItem['price'] as String?;
                int colors = getColorsCount(design, items);

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ColorsPage(design: design, colors: colors,),),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: height/5,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              Text('Design: $design', style: TextStyle(fontSize: width/30, fontWeight: FontWeight.bold),),
                              Text('Price: $price/-', style: TextStyle(fontSize: width/30)),
                              Text('Colors: $colors', style: TextStyle(fontSize: width/30)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      drawer: const Drawer(
        child: AdminDrawer(),
      ),
    );
  }
}