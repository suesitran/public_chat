import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({
    super.key,
    required this.photoUrl,
    required this.iconSize,
  });
  final String? photoUrl;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(iconSize),
        child: photoUrl == null
            ? const _DefaultPersonWidget()
            : ImageNetwork(
                image: photoUrl!,
                width: iconSize,
                height: iconSize,
                fitAndroidIos: BoxFit.fitWidth,
                fitWeb: BoxFitWeb.contain,
                onError: const _DefaultPersonWidget(),
                onLoading: const _DefaultPersonWidget(),
              ),
      ),
    );
  }
}

class _DefaultPersonWidget extends StatelessWidget {
  const _DefaultPersonWidget();

  @override
  Widget build(BuildContext context) => const Icon(
        Icons.person,
        color: Colors.black,
        size: 20,
      );
}
