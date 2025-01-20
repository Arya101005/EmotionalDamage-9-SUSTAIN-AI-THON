import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  XFile? _imageFile;
  Uint8List? _webImage;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _checkPermissions(ImageSource source) async {
    if (kIsWeb) return true;

    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      return status.isGranted;
    } else {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
      return true;
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final hasPermission = await _checkPermissions(source);

      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission denied')),
          );
        }
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 90,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _imageFile = pickedFile;
        });

        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _savePost() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String savedPath;
      if (kIsWeb) {
        savedPath = _imageFile!.path;
      } else {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage =
            await File(_imageFile!.path).copy('${appDir.path}/$fileName');
        savedPath = savedImage.path;
      }

      if (mounted) {
        Navigator.pop(context, {
          'imagePath': savedPath,
          'description': _descriptionController.text.trim(),
          'timestamp': DateTime.now().toString(),
          'imageBytes': kIsWeb ? _webImage : null,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) return const SizedBox();

    if (kIsWeb && _webImage != null) {
      return Image.memory(
        _webImage!,
        width: double.infinity,
        height: 400,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb) {
      return Image.file(
        File(_imageFile!.path),
        width: double.infinity,
        height: 400,
        fit: BoxFit.cover,
      );
    }

    return const SizedBox();
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create Post',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.blue),
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.purple),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF40E0D0), Color(0xFF7B68EE)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('New Post', style: TextStyle(color: Colors.black)),
          actions: [
            if (_imageFile != null)
              TextButton(
                onPressed: _isLoading ? null : _savePost,
                child: const Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (_imageFile == null)
                      GestureDetector(
                        onTap: _showImageSourceSheet,
                        child: Container(
                          width: double.infinity,
                          height: 400,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate,
                                  size: 64,
                                  color: Colors.black.withOpacity(0.8)),
                              const SizedBox(height: 16),
                              Text(
                                'Tap to add photo',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: _buildImagePreview(),
                            ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: FloatingActionButton.small(
                                onPressed: _showImageSourceSheet,
                                backgroundColor: Colors.white,
                                child:
                                    const Icon(Icons.edit, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_imageFile != null)
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.2)),
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Write a caption...',
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
