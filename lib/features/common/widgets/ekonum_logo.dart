import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EkonumLogo extends StatelessWidget {
  final double height;

  const EkonumLogo({super.key, this.height = 30.0});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logos/ekonum_logo.svg',
      height: height,
      placeholderBuilder:
          (context) => Icon(
            Icons.cloud_circle_outlined,
            size: height,
            color: Theme.of(context).primaryColor,
          ),
    );
  }
}
