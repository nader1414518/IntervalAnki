import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Lets the user choose camera or gallery before an [ImagePicker] call —
/// shared by every screen that inserts a photo, so a permission declared
/// once (`NSCameraUsageDescription`/`NSPhotoLibraryUsageDescription`) is
/// actually reachable from all of them rather than only the gallery half.
Future<ImageSource?> pickImageSource(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Take photo'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose from gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}
