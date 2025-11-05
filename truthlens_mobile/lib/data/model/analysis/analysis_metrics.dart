import 'package:equatable/equatable.dart';

class AnalysisMetrics extends Equatable {
  final int faceDetection;
  final int skinTextureAnalysis;
  final int eyeMovement;
  final int lightingConsistency;
  final int? blinkDetection;
  final int? audioSync;
  final int? frameConsistency;

  const AnalysisMetrics({
    required this.faceDetection,
    required this.skinTextureAnalysis,
    required this.eyeMovement,
    required this.lightingConsistency,
    this.blinkDetection,
    this.audioSync,
    this.frameConsistency,
  });

  factory AnalysisMetrics.fromJson(Map<String, dynamic> json) {
    return AnalysisMetrics(
      faceDetection: json['face_detection'] ?? 0,
      skinTextureAnalysis: json['skin_texture_analysis'] ?? 0,
      eyeMovement: json['eye_movement'] ?? 0,
      lightingConsistency: json['lighting_consistency'] ?? 0,
      blinkDetection: json['blink_detection'],
      audioSync: json['audio_sync'],
      frameConsistency: json['frame_consistency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'face_detection': faceDetection,
      'skin_texture_analysis': skinTextureAnalysis,
      'eye_movement': eyeMovement,
      'lighting_consistency': lightingConsistency,
      'blink_detection': blinkDetection,
      'audio_sync': audioSync,
      'frame_consistency': frameConsistency,
    };
  }

  // Get all metrics as a map for display
  Map<String, int> get allMetrics {
    final metrics = {
      'Face Detection': faceDetection,
      'Skin Texture Analysis': skinTextureAnalysis,
      'Eye Movement': eyeMovement,
      'Lighting Consistency': lightingConsistency,
    };

    if (blinkDetection != null) {
      metrics['Blink Detection'] = blinkDetection!;
    }
    if (audioSync != null) {
      metrics['Audio Sync'] = audioSync!;
    }
    if (frameConsistency != null) {
      metrics['Frame Consistency'] = frameConsistency!;
    }

    return metrics;
  }

  // Calculate average score
  double get averageScore {
    final scores = [
      faceDetection,
      skinTextureAnalysis,
      eyeMovement,
      lightingConsistency,
      if (blinkDetection != null) blinkDetection!,
      if (audioSync != null) audioSync!,
      if (frameConsistency != null) frameConsistency!,
    ];

    if (scores.isEmpty) return 0.0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  @override
  List<Object?> get props => [
        faceDetection,
        skinTextureAnalysis,
        eyeMovement,
        lightingConsistency,
        blinkDetection,
        audioSync,
        frameConsistency,
      ];
}

