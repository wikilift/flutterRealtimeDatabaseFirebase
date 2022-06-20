import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({Key? key, required this.path}) : super(key: key);
  final String? path;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
          decoration: _BoxDecoration(),
          width: double.infinity,
          height: 400,
          child: Opacity(
            opacity: 0.9,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: _GetImage(path)),
          ),
        ));
  }

  BoxDecoration _BoxDecoration() => const BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, offset: Offset(0, 6), blurRadius: 10),
          ]);

  Widget _GetImage(String? picture) {
    if (picture == null) {
      return const Image(
        fit: BoxFit.cover,
        image: AssetImage('assets/no-image.png'),
      );
    } else if (picture.startsWith('http')) {
      return FadeInImage(
        fit: BoxFit.cover,
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(path.toString()),
      );
    }
    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
