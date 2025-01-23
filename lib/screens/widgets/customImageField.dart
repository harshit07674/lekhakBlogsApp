import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:lekhk/utils/imagesList.dart';

class CustomImageField extends StatefulWidget {
  File? image;
  CustomImageField({super.key, required this.image});

  @override
  State<CustomImageField> createState() => _CustomImageFieldState();
}

class _CustomImageFieldState extends State<CustomImageField> {
  int count = 0;
  int imageIndex = 0;
  static int cummIndex = -1;
  File? blogImageFile;
  @override
  Widget build(BuildContext context) {
    final dimension = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        final ImageFile = await ImagePicker()
            .pickImage(source: ImageSource.gallery)
            .then((val) {
          setState(() {
            blogImageFile = File(val!.path);
          });
        });
        if (count == 0) {
          imageFiles.add(blogImageFile!);
          cummIndex++;
          imageIndex = cummIndex;
        } else {
          
            imageFiles[imageIndex] = blogImageFile!;
        
        }
        count++;
      },
      child: Container(
        width: dimension.width*0.9,
        height: 200,
        child: blogImageFile != null
            ? Image.file(
                blogImageFile!,
                fit: BoxFit.fill ,
              )
            : Icon(
                Icons.add_a_photo_rounded,
                color: Colors.black,
                size: 40,
              ),
      ),
    );
  }
}
