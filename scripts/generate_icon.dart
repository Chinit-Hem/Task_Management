import 'dart:io';
import 'dart:ui' as ui;

void main() async {
  // Create a simple app icon with a checkmark
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(1024, 1024);

  // Background - Primary color #4A6CF7
  final paint = ui.Paint()..color = const ui.Color(0xFF4A6CF7);
  canvas.drawRect(ui.Rect.fromLTWH(0, 0, size.width, size.height), paint);

  // White circle background for icon
  final circlePaint = ui.Paint()..color = const ui.Color(0xFFFFFFFF);

  canvas.drawCircle(
    ui.Offset(size.width / 2, size.height / 2),
    size.width * 0.35,
    circlePaint,
  );

  // Checkmark icon
  final checkPaint = ui.Paint()
    ..color = const ui.Color(0xFF4A6CF7)
    ..strokeWidth = 80
    ..strokeCap = ui.StrokeCap.round
    ..style = ui.PaintingStyle.stroke;

  final path = ui.Path();
  path.moveTo(size.width * 0.3, size.height * 0.5);
  path.lineTo(size.width * 0.45, size.height * 0.65);
  path.lineTo(size.width * 0.7, size.height * 0.35);
  canvas.drawPath(path, checkPaint);

  final picture = recorder.endRecording();
  final image = await picture.toImage(1024, 1024);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  if (byteData != null) {
    final buffer = byteData.buffer.asUint8List();
    final file = File('assets/images/app_icon.png');
    await file.writeAsBytes(buffer);
    print('Icon generated: ${file.path}');
  }
}
