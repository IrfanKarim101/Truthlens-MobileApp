import 'package:equatable/equatable.dart';

class FileInfo extends Equatable {
  final String name;
  final String size;
  final String? resolution;
  final String? duration;
  final String? format;
  final String type; // 'image' or 'video'

  const FileInfo({
    required this.name,
    required this.size,
    this.resolution,
    this.duration,
    this.format,
    required this.type,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      name: json['name'] ?? '',
      size: json['size'] ?? '',
      resolution: json['resolution'],
      duration: json['duration'],
      format: json['format'],
      type: json['type'] ?? 'image',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
      'resolution': resolution,
      'duration': duration,
      'format': format,
      'type': type,
    };
  }

  // Check if it's an image
  bool get isImage => type.toLowerCase() == 'image';

  // Check if it's a video
  bool get isVideo => type.toLowerCase() == 'video';

  // Get file extension
  String get extension {
    final parts = name.split('.');
    return parts.isNotEmpty ? parts.last.toUpperCase() : '';
  }

  @override
  List<Object?> get props => [
        name,
        size,
        resolution,
        duration,
        format,
        type,
      ];
}