import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/theme/app_theme.dart';
import 'package:yurideks_app/core/widgets/bird_mark.dart';

const String _out = String.fromEnvironment('RENDER_OUT');

void main() {
  testWidgets('renders the app icon master', (WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1024, 1024)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final GlobalKey key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        debugShowCheckedModeBanner: false,
        home: RepaintBoundary(
          key: key,
          child: const ColoredBox(
            color: Color(0xFF141210),
            child: Center(child: BirdMark(height: 470)),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.runAsync(() async {
      final RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? data = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      File('$_out/app_icon_master.png').writeAsBytesSync(
        data!.buffer.asUint8List(),
      );
    });
  }, skip: _out.isEmpty);
}
