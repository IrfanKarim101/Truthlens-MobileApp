// lib/presentation/screens/upload/video_upload.dart
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/upload/bloc/upload_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:truthlens_mobile/presentation/routes/app_router.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen>
    with TickerProviderStateMixin {
  File? _selectedVideo;
  bool _isAnalyzing = false;
  String? _videoDuration;
  String? _videoSize;

  // Face detector
  late final FaceDetector _faceDetector;

  // For preventing multiple subscriptions
  bool _listeningToBloc = false;

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableLandmarks: false,
        enableClassification: false,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // obtain size/duration if you want (platform-specific). For now we keep what you had.
      setState(() {
        _selectedVideo = File(video.path);
        _videoDuration = "0:45";
        _videoSize = _readableFileSize(File(video.path).lengthSync());
      });
    }
  }

  String _readableFileSize(int bytes, [int decimals = 1]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (Math.log(bytes) / Math.log(1024)).floor();
    final size = bytes / Math.pow(1024, i);
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  // Generate a thumbnail image file from the video path (returns File or null)
  Future<File?> _generateVideoThumbnail(File videoFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbData = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512,
        quality: 75,
      );

      if (thumbData == null) return null;

      final thumbFile = File(
        '${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await thumbFile.writeAsBytes(thumbData);
      return thumbFile;
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
      return null;
    }
  }

  // Run face detection on an image file
  Future<bool> _detectFaceInImageFile(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final faces = await _faceDetector.processImage(inputImage);
      return faces.isNotEmpty;
    } catch (e) {
      debugPrint('Face detection error: $e');
      return false;
    }
  }

  // The main analyze/upload flow:
  // 1) Generate thumbnail from selected video
  // 2) Run face detection on thumbnail
  // 3) If face present -> dispatch upload event to your UploadBloc
  // 4) If face absent -> show SnackBar and abort
  Future<void> _analyzeVideo() async {
    if (_selectedVideo == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Step 1: create thumbnail
    File? thumbnailFile = await _generateVideoThumbnail(_selectedVideo!);

    // Step 2: run face detection on thumbnail if available
    bool hasFace = false;
    if (thumbnailFile != null) {
      hasFace = await _detectFaceInImageFile(thumbnailFile);
      // optionally delete thumbnail after use
      try {
        await thumbnailFile.delete();
      } catch (_) {}
    } else {
      // If thumbnail generation failed, we can attempt to proceed (or block).
      // Safer UX: warn user, then proceed with upload if they confirm.
      hasFace = false;
    }

    if (!hasFace) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No face detected in the selected video.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Step 3: Dispatch upload event
    try {
      final uploadBloc = context.read<UploadBloc>();

      // Ensure we listen once (BlocListener below will handle states globally)
      if (!_listeningToBloc) {
        _listeningToBloc = true;
        // We rely on BlocListener widget to react — don't add manual stream.listen here
      }

      uploadBloc.add(UploadVideoRequested(_selectedVideo!));
      // Do not await bloc; the BlocListener will navigate on success/failure
    } catch (e) {
      // If UploadBloc is not available or event name differs, show message
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed to start: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap UI with BlocListener to catch upload states and update UI / navigate
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadInProgress) {
          // show progress (we keep your UI unchanged, but ensure spinner state)
          setState(() {
            _isAnalyzing = true;
          });
        } else if (state is UploadSuccess) {
          setState(() {
            _isAnalyzing = false;
          });

          // replace with your route and expected argument
          Navigator.pushNamed(
            context,
            AppRoutes.analysisReport,
            arguments: state.result,
          );
        } else if (state is UploadFailure) {
          setState(() {
            _isAnalyzing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exception.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/img3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.3),
                  Colors.purple.withOpacity(0.1),
                  Colors.purple.withOpacity(0.3),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Back Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Upload Video',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Analyze video content',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Upload Area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            child: _selectedVideo == null
                                ? _buildUploadPrompt()
                                : _buildVideoPreview(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Analyze Button (shown when video is selected)
                  if (_selectedVideo != null)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purpleAccent.shade100,
                                  Colors.lightBlueAccent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isAnalyzing ? null : _analyzeVideo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isAnalyzing
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.analytics_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Analyze Video',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedVideo = null;
                                _videoDuration = null;
                                _videoSize = null;
                              });
                            },
                            child: Text(
                              'Choose Different Video',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPrompt() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickVideo,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Upload Icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.purpleAccent.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.upload_outlined,
                  size: 64,
                  color: Colors.purpleAccent.shade100,
                ),
              ),

              const SizedBox(height: 32),

              // Tap to select text
              const Text(
                'Tap to select video',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // Supported formats
              Text(
                'Supports MP4, MOV, AVI',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 24),

              // Additional info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Max file size: 100MB',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      children: [
        // Video Preview Placeholder
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.withOpacity(0.3),
                Colors.blue.withOpacity(0.3),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Video Preview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Overlay gradient for better visibility
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),

        // Video info badge
        Positioned(
          top: 16,
          right: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Video Selected',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Video details at bottom
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildVideoStat(
                      icon: Icons.videocam_outlined,
                      label: 'Format',
                      value: 'MP4',
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    _buildVideoStat(
                      icon: Icons.timer_outlined,
                      label: 'Duration',
                      value: _videoDuration ?? '0:45',
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    _buildVideoStat(
                      icon: Icons.folder_outlined,
                      label: 'Size',
                      value: _videoSize ?? '12.5 MB',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
