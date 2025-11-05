import 'dart:io';
import 'package:equatable/equatable.dart';

class UploadRequest extends Equatable {
  final File file;
  final String type; // 'image' or 'video'

  const UploadRequest({
    required this.file,
    required this.type,
  });

  // Get file name
  String get fileName => file.path.split('/').last;

  // Get file size in bytes
  int get fileSizeBytes => file.lengthSync();

  // Get file size formatted
  String get fileSizeFormatted {
    final bytes = fileSizeBytes;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [file, type];
}