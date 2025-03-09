// lib/views/auth/image_crop_view.dart

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';

class ImageCropScreen extends StatefulWidget {
  final String imagePath;

  const ImageCropScreen({
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  _ImageCropScreenState createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  late CustomImageCropController controller;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.imagePath);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomImageCrop(
              cropController: controller,
              image: FileImage(file),
              maskShape: CustomCropShape.Circle, // 혹은 Square
              shape: CustomCropShape.Square,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () => controller.addTransition(CropImageData(scale: 1.33)),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () => controller.addTransition(CropImageData(scale: 0.75)),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_left),
                onPressed: () => controller.addTransition(CropImageData(angle: -pi / 4)),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: () => controller.addTransition(CropImageData(angle: pi / 4)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final image = await controller.onCropImage();
                  if (image != null) {
                    // crop 결과: MemoryImage
                    // Uint8List 가져오기
                    final bytes = image.bytes;
                    Navigator.pop<Uint8List>(context, bytes);
                  }
                },
                child: const Text("자르기"),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
