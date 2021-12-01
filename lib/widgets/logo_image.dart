import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      width: 130,
      height: 220,
      image: AssetImage('assets/images/logo.png'),
    );
  }
}
