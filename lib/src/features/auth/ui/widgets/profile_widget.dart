import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  
  const ProfileWidget({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(imagePath: imagePath),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon( ),
          ),
        ],
      ),
    );
  }

  Widget buildImage({required String imagePath}) {
    
    ImageProvider image = NetworkImage(imagePath);
    if (imagePath.isEmpty) {
    image = const AssetImage('assets/images/profile_image.png');
    }

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: () { },
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon() {
    return buildCircle(
      all: 3,
      child: buildCircle(
        all: 8,
        child: const Icon(
          Icons.edit,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildCircle({required Widget child, required double all}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        child: child,
      ),
    );
  }
}
