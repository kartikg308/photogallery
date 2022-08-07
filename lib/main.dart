// ignore_for_file: invalid_use_of_visible_for_testing_member, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogallery/addimage.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:localstorage/localstorage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int n = 4;
  int m = 1;

  // List<String> imagePaths = [
  //   'https://images.unsplash.com/photo-1524024973431-2ad916746881?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  //   'https://images.unsplash.com/photo-1444845026749-81acc3926736?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=864&q=80',
  //   'https://images.unsplash.com/photo-1535591273668-578e31182c4f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  //   'https://images.unsplash.com/photo-1504472478235-9bc48ba4d60f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
  //   'https://images.unsplash.com/photo-1520301255226-bf5f144451c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80',
  //   'https://images.unsplash.com/photo-1514503612056-e3f673b3f3bd?ixlib=rb-1.2.1&ixid=MnwxMjA3fD',
  //   'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  //   'https://images.unsplash.com/photo-1580777187326-d45ec82084d3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
  //   'https://images.unsplash.com/photo-1531804226530-70f8004aa44e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80',
  //   'https://images.unsplash.com/photo-1465056836041-7f43ac27dcb5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
  //   'https://images.unsplash.com/photo-1573553256520-d7c529344d67?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  // ];

  @override
  void initState() {
    super.initState();
    getStorage();
  }

  getStorage() async {
    try {
      final LocalStorage storage = LocalStorage('photogallery.json');
      final value = await storage.getItem('images').then((value) {
        if (value == null) {
          return [];
        }
        return jsonDecode(value);
      });
      log('images');
      log(value.toString());
      setState(() {
        images = value;
      });
      m = (images.length / 4).floor() > 0 ? (images.length / 4).floor() : 1;
      setState(() {});
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  setStorage() async {
    final LocalStorage storage = LocalStorage('photogallery.json');
    await storage.setItem('images', images).then((value) {
      log("value saved");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(images.toString());
    }
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Photo Gallery"),
      ),
      body: ReorderableGridView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) => buildItem(index),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            setState(() {
              final element = images.removeAt(oldIndex);
              images.insert(newIndex, element);
            });
          });
        },
        dragWidgetBuilder: (index, child) {
          return Card(
            color: Colors.blue,
            child: Text(index.toString()),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 4,
          childAspectRatio: 0.6,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () async {
                await ImagePicker.platform
                    .getImage(source: ImageSource.camera)
                    .then((image) {
                  Get.to(() => AddImage(
                        image: File(image!.path),
                        path: image.path,
                      ));
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.photo_album),
              onPressed: () async {
                await ImagePicker.platform
                    .getImage(source: ImageSource.gallery)
                    .then((image) {
                  Get.to(() => AddImage(
                        image: File(image!.path),
                        path: image.path,
                      ));
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(int index) {
    return Card(
      key: ValueKey(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Image.file(File(images[index]['image'])),
          ),
          Text(images[index]['title']),
        ],
      ),
    );
  }
}
