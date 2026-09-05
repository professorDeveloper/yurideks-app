import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/theme/app_theme.dart';
import 'package:yurideks_app/core/widgets/mystery_box.dart';

Future<void> _capture(
  WidgetTester tester,
  Widget child,
  String path,
) async {
  final GlobalKey key = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFAF6EF),
        body: Center(
          child: RepaintBoundary(key: key, child: child),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.runAsync(() async {
    final RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3);
    final ByteData? data = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    File(path).writeAsBytesSync(data!.buffer.asUint8List());
  });
}

void main() {
  const String out = String.fromEnvironment('RENDER_OUT');

  testWidgets('renders the mystery box in its closed and open states', (
    WidgetTester tester,
  ) async {
    await _capture(
      tester,
      const MysteryBox(size: 220, bob: 0.25),
      '$out/box_closed.png',
    );
    await _capture(
      tester,
      const MysteryBox(size: 220, lift: 1, bob: 0.25),
      '$out/box_open.png',
    );
    await _capture(
      tester,
      const MysteryBox(size: 220, lift: 1, bob: 0.25, reveal: 1),
      '$out/box_reveal.png',
    );
    await _capture(
      tester,
      const MysteryBox(size: 72, bob: 0.25),
      '$out/box_small.png',
    );
  }, skip: out.isEmpty);
}
