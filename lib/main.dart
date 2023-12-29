import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'dart:io';
/// Flutter code sample for [Drawer].

void main() => runApp(const EpubReaderApp());

class EpubReaderApp extends StatelessWidget {
  const EpubReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const DrawerExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DrawerExample extends StatefulWidget {
  const DrawerExample({super.key});

  @override
  State<DrawerExample> createState() => _DrawerExampleState();
}

class _DrawerExampleState extends State<DrawerExample> {
  int _selectedIndex = 0;
  String epubName = '';
  epubx.EpubBook? epubFile;
  List<Widget> contents = [];
  Future<void> openEpub() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      List<int> bytes = await file.readAsBytes();
      epubFile = await epubx.EpubReader.readBook(bytes);
      for (var ch in epubFile!.Chapters!) {
        debugPrint(ch.Title!);
        contents.add( ListTile(
                    title: Text(ch.Title!),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ));
      }
      setState(() {
        epubName = epubFile?.Title ?? '';
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drawer Example'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings),
          color: Colors.black,
          onPressed: () => {},
        ),
      ]),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('目录'),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    selected: _selectedIndex == 0,
                    onTap: () {
                      // Update the state of the app
                      // _onItemTapped(0);
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ] + contents
                ),
      ),
      body: Center(
        child: Text('文件名: $epubName'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openEpub,
        tooltip: 'Open A Epub',
        child: const Icon(Icons.add),
      ),
    );
  }
}
