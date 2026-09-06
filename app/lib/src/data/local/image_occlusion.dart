import 'dart:convert';

/// One occlusion rectangle over an Image Occlusion note's image, positioned
/// as percentages (0-100) of the image's own width/height so it stays
/// aligned regardless of how large the image renders.
class ImageOcclusionMask {
  const ImageOcclusionMask({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  factory ImageOcclusionMask.fromJson(Map<String, dynamic> json) {
    return ImageOcclusionMask(
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }

  final double left;
  final double top;
  final double width;
  final double height;

  Map<String, double> toJson() => {
    'left': left,
    'top': top,
    'width': width,
    'height': height,
  };
}

/// Decodes the JSON stored in an Image Occlusion note's "Masks" field.
List<ImageOcclusionMask> decodeMasks(String json) {
  if (json.trim().isEmpty) return const [];
  return (jsonDecode(json) as List)
      .map((m) => ImageOcclusionMask.fromJson(m as Map<String, dynamic>))
      .toList();
}

/// Encodes masks back to the JSON stored in the "Masks" field.
String encodeMasks(List<ImageOcclusionMask> masks) {
  return jsonEncode(masks.map((m) => m.toJson()).toList());
}
