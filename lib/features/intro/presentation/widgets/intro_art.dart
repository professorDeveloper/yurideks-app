import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import 'intro_art_color_mapper.dart';

class IntroArt extends StatelessWidget {
  const IntroArt({required this.asset, required this.offset, super.key});

  static const double _parallax = 34;
  static const double _scaleDrop = 0.06;

  final String asset;
  final double offset;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final double distance = offset.abs().clamp(0.0, 1.0);

    return Transform.translate(
      offset: Offset(-offset * _parallax, 0),
      child: Transform.scale(
        scale: 1 - distance * _scaleDrop,
        child: SvgPicture(
          SvgAssetLoader(
            asset,
            colorMapper: IntroArtColorMapper(
              ink: colors.ink,
              line: colors.line,
              surface: colors.surface,
              accent: colors.accent,
            ),
          ),
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
