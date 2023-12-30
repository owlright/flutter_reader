import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'dart:io';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
  String bookTitle = '';
  epubx.EpubBook? epubFile;
  List<Widget> contents = [];

  List<Widget> buildContentList(epubx.EpubBook? book, int index) {
    if (book == null) {
      return [];
    } else {
      var chapters = book.Chapters!;
      return List.generate(chapters.length, (index) {
        return ListTile(
          title: Text(chapters[index].Title!),
          selected: _selectedIndex == index,
          onTap: () {
            Navigator.pop(context);
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      });
    }
  }

  Future<void> openEpub() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      List<int> bytes = await file.readAsBytes();
      epubFile = await epubx.EpubReader.readBook(bytes);
      setState(() {
        bookTitle = epubFile?.Title ?? '';
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
                ] +
                buildContentList(epubFile, _selectedIndex)),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child:
              HtmlWidget(epubFile?.Chapters?[_selectedIndex].HtmlContent ?? ''),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openEpub,
        tooltip: 'Open A Epub',
        child: const Icon(Icons.add),
      ),
    );
  }
}
