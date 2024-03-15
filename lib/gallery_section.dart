import 'package:flutter/material.dart';

class GallerySection extends StatelessWidget {
  final List<String> galleryImages;

  GallerySection({required this.galleryImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: ListView.builder(
        itemCount: galleryImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(galleryImages[index]),
          );
        },
      ),
    );
  }
}
