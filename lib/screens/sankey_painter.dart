import 'package:flutter/material.dart';

class SankeyPainter extends CustomPainter {
  final List<SankeyNode> nodes;
  final List<SankeyLink> links;
  final Map<String, Color> linkColors;

  SankeyPainter({required this.nodes, required this.links, required this.linkColors});

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Find the maximum value to normalize the link thickness
    double maxValue = links.map((link) => link.value).reduce((a, b) => a > b ? a : b);

    // Draw links
    for (var link in links) {
      final linkPaint = Paint()
        ..color = linkColors[link.label]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = (link.value / maxValue) * 10.0; // Normalize and scale the strokeWidth

      final path = Path()
        ..moveTo(link.source.x + link.source.width / 2, link.source.y + link.source.height)
        ..cubicTo(
          link.source.x + link.source.width / 2,
          link.source.y + link.source.height + 50,
          link.target.x + link.target.width / 2,
          link.target.y - 50,
          link.target.x + link.target.width / 2,
          link.target.y,
        );
      canvas.drawPath(path, linkPaint);

      // Draw link quantities
      textPainter.text = TextSpan(
        text: link.value.toStringAsFixed(2),
        style: TextStyle(color: Colors.black, fontSize: 12),
      );
      textPainter.layout();
      final offset = path.computeMetrics().first.getTangentForOffset(path.computeMetrics().first.length / 2)!.position;
      textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    // Draw nodes
    for (var node in nodes) {
      final rect = Rect.fromLTWH(node.x, node.y, node.width, node.height);
      canvas.drawRect(rect, nodePaint);

      // Draw node labels
      textPainter.text = TextSpan(
        text: node.label,
        style: TextStyle(color: Colors.white, fontSize: 14),
      );
      textPainter.layout(minWidth: node.width, maxWidth: node.width);
      textPainter.paint(
        canvas,
        Offset(node.x + (node.width - textPainter.width) / 2, node.y + (node.height - textPainter.height) / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SankeyNode {
  double x;
  final double y;
  final double width;
  final double height;
  final String label;

  SankeyNode({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.label,
  });
}

class SankeyLink {
  final SankeyNode source;
  final SankeyNode target;
  final double value;
  final String label;

  SankeyLink({
    required this.source,
    required this.target,
    required this.value,
    required this.label,
  });
}