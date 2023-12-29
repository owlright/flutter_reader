import 'dart:io';
import 'dart:core';
import 'package:path/path.dart' as path;
import 'package:epubx/epubx.dart';
import 'package:html/parser.dart';

//Get the epub into memory somehow
Future<void> main() async {
  String fileName = 'accessible_epub_3.epub';
  String fullPath = path.join(Directory.current.path, fileName);

  var targetFile = File(fullPath);
  List<int> bytes = await targetFile.readAsBytes();
// Opens a book and reads all of its content into memory
  EpubBook epubBook = await EpubReader.readBook(bytes);

// COMMON PROPERTIES

// Book's title
  var title = epubBook.Title;

// Book's authors (comma separated list)
  var author = epubBook.Author;

// Book's authors (list of authors names)
  var authors = epubBook.AuthorList;

// Book's cover image (null if there is no cover)
  var coverImage = epubBook.CoverImage;

// CHAPTERS
  if (epubBook.Chapters != null) {
    EpubChapter chapter = epubBook.Chapters![1];
    // Title of chapter
    var chapterTitle = chapter.Title;
    print(chapter.toString());
// HTML content of current chapter
    var chapterHtmlContent = chapter.HtmlContent;
    var document = parseFragment(chapterHtmlContent);
    for (var x in document.querySelectorAll('p')) {
      print(x.outerHtml);
    }
  }

// CONTENT

// Book's content (HTML files, stylesheets, images, fonts, etc.)
  var bookContent = epubBook.Content!;

// IMAGES

// All images in the book (file name is the key)
  var images = bookContent.Images;

  var firstImage = images?.values.first;

// Content type (e.g. EpubContentType.IMAGE_JPEG, EpubContentType.IMAGE_PNG)
  var contentType = firstImage?.ContentType;

// MIME type (e.g. "image/jpeg", "image/png")
  var mimeContentType = firstImage?.ContentMimeType;

// HTML & CSS

// All XHTML files in the book (file name is the key)
  var htmlFiles = bookContent.Html;

// All CSS files in the book (file name is the key)
  var cssFiles = bookContent.Css;

// Entire HTML content of the book
  htmlFiles?.values.forEach((EpubTextContentFile htmlFile) {
    var htmlContent = htmlFile.Content;
  });

// // All CSS content in the book
//   cssFiles.values.forEach((EpubTextContentFile cssFile){
//     String cssContent = cssFile.Content;
//   });
//
//
// // OTHER CONTENT
//
// // All fonts in the book (file name is the key)
//   var fonts = bookContent.Fonts;
//
// // All files in the book (including HTML, CSS, images, fonts, and other types of files)
//   var allFiles = bookContent.AllFiles;
//
//
// // ACCESSING RAW SCHEMA INFORMATION
//
// // EPUB OPF data
//   var package = epubBook.Schema.Package;
//
// // Enumerating book's contributors
//   package.Metadata.Contributors.forEach((EpubMetadataContributor contributor){
//     String contributorName = contributor.Contributor;
//     String contributorRole = contributor.Role;
//   });
//
// // EPUB NCX data
//   var navigation = epubBook.Schema.Navigation;
//
// // Enumerating NCX metadata
//   navigation.Head.Metadata.forEach((EpubNavigationHeadMeta meta){
//     String metadataItemName = meta.Name;
//     String metadataItemContent = meta.Content;
//   });
//
// // Writing Data
//   var written = await EpubWriter.writeBook(epubBook);
//
// // You can even re-read the book into a new object!
//   var bookRoundTrip = await EpubReader.readBook(written);
}
