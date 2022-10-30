import 'package:flutter/material.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';

class DogsLiveryIndicatorTabBar extends Decoration {
  
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _DogsLiveryPainterIndicator(this, onChanged);

}



class _DogsLiveryPainterIndicator extends BoxPainter {

  final DogsLiveryIndicatorTabBar decoration;

  _DogsLiveryPainterIndicator(this.decoration, VoidCallback? onChanged) : super(onChanged);
  

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {

    Rect rect;

    rect = Offset(offset.dx + 6, ( configuration.size!.height - 3 )) & Size(configuration.size!.width - 12, 3);

    final paint = Paint()
      ..color = ColorsDogsLivery.primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndCorners(rect, topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)), paint);


  }



}