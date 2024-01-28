import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../main.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemPriceController = TextEditingController();

  bool _isUploading = false;

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  List<String> designs = [
    'King Zeeshan',
    'King Aslam',
    'King Surani',
    'King Kashmira',
    'Donigal',
    'Super',
    'Byma',
    'MVK',
  ];

  String? selectedDesign;
  Future<void> _uploadData(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {

      setState(() {
        _isUploading = true;
      });

      final storageRef =
      FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.png');

      final bytes = await _image?.readAsBytes();
      final Uint8List? list = bytes?.buffer.asUint8List();
      await storageRef.putData(list!, SettableMetadata(contentType: 'image/png'),);

      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('items').add({
        'image': imageUrl,
        'design': selectedDesign,
        'price': _itemPriceController.text.trim(),
      });

      _formKey.currentState?.reset();
      setState(() {
        _image = null;
        selectedDesign = null;
        _itemPriceController.clear();
        _isUploading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width= size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Admin Panel',style: TextStyle(fontSize: height/30),),
      ),
      body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _image != null
                        ? Image.file(
                      _image!,
                      height: height/2,
                      width: width/1.08,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: height/2,
                      width: width/1.08,
                      color: Colors.grey,
                         child: const Center(
                          child: Text('No Image Selected', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        elevation: 5,
                      ),
                      onPressed: _getImage,
                      child: Text('Select Image', style: TextStyle(fontSize: height/50,color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              DropdownButton(
                                isExpanded: true,
                                value: selectedDesign,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDesign = newValue;
                                  });
                                },
                                items: designs.map((e) {
                                  return DropdownMenuItem(value: e,
                                      child: Text(e, style: const TextStyle(color: Colors.black)));
                                }).toList(),
                              ),
                              if (selectedDesign == null) const Text('Design:', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _itemPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Price(R.s):',
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                            keyboardType: TextInputType.number,
                            //style: const TextStyle(color: Colors.blue),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter item price';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 5,
                            ),
                            onPressed: (){
                              _uploadData(context).then((value) {
                                Utils().toastMessage("Item uploaded successfully");
                              }).catchError((error) {
                                Utils().toastMessage("Error: $error");
                              });

                            },
                            child: Text('Submit', style: TextStyle(fontSize: height/50,color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isUploading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ]
      ),
    );
  }
}
