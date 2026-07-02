import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HalamanEdit extends StatefulWidget {
  final String teksLama;

  const HalamanEdit({
    super.key,
    required this.teksLama,
  });

  @override
  State<HalamanEdit> createState() => _HalamanEditState();
}

class _HalamanEditState extends State<HalamanEdit> {
  final _controller = TextEditingController();

  File? _image;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.teksLama;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();

        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ImageProvider? _getImageProvider() {
    if (kIsWeb) {
      if (_webImage != null) {
        return MemoryImage(_webImage!);
      }
    } else {
      if (_image != null) {
        return FileImage(_image!);
      }
    }

    return null;
  }

  bool _hasImage() {
    return kIsWeb ? _webImage != null : _image != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _getImageProvider(),
                  child: !_hasImage()
                      ? const Icon(
                          Icons.person,
                          size: 50,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      print("Tombol ditekan");
                      _pickImage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Edit Nama",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  _controller.text,
                );
              },
              child: const Text("SIMPAN & KEMBALI"),
            ),
          ],
        ),
      ),
    );
  }
}