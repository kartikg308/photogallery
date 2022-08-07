// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:photogallery/main.dart';

List<Map> images = [];

class AddImage extends StatefulWidget {
  final File image;
  final String path;
  const AddImage({Key? key, required this.image, required this.path})
      : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final _controller = TextEditingController();

  randomId() {
    return Random().nextInt(100000000);
  }

  void addImage() {
    setState(() {
      images.insert(0, {
        'id': randomId(),
        'image': widget.path,
        'title': _controller.text,
        'order': 0,
      });
    });
    setStorage();
  }

  void setStorage() async {
    try {
      final LocalStorage storage = LocalStorage('photogallery.json');
      await storage.setItem('images', jsonEncode(images)).then((value) {
        print('saved');
      });
      setState(() {});
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 300,
              child: Image.file(widget.image),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addImage();
                Future.delayed(const Duration(milliseconds: 500), () {
                  Get.offAll(() => const MyHomePage());
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Add'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
