import 'package:flutter/material.dart';

/// Flutter code sample for [MouseRegion].

void main() => runApp(const CustomButtonApp());

class CustomButtonApp extends StatelessWidget {
  const CustomButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Реалізація кнопок через Canvas')),
        body: const Center(
          child: CanvasButtonsArea(),
        ),
      ),
    );
  }
}

class CanvasButtonsArea extends StatefulWidget {
  const CanvasButtonsArea({super.key});

  @override
  State<CanvasButtonsArea> createState() => _MouseRegionExampleState();
}

class CustomButton{
  double x = 0;
  double y = 0;
  double width =0;
  double height = 0;
  String text = '';
  bool hovered = false;
  bool pressed = false;
  
  CustomButton(this.x, this.y, this.width, this.height, this.text);
  
  bool pointInside(double px, double py)
  {
    return (x <= px) && (px <= x + width) && (y <= py)  && (py <= y + height);
  }
}

class _MouseRegionExampleState extends State<CanvasButtonsArea> {
  List<CustomButton> buttons = [CustomButton(20, 20, 100, 30, 'Button 1'),
                                CustomButton(20, 120, 100, 30, 'Button 2')
                               ];
  String msg = 'Нічого не натиснуто.';

  void _checkHoverEvent(PointerEvent details) {
    var x = details.localPosition.dx;
    var y = details.localPosition.dy;
    
    for (int i = 0; i < buttons.length; i++)
    {
      var button = buttons[i];
      
      if (!button.hovered && button.pointInside(x, y))
      {
        setState(() {
          button.hovered = true;
        });
        
      }
      else if (button.hovered && !button.pointInside(x, y))
      {
        setState(() {
          button.hovered = false;
        });
      }
    }
  }
  
  void _checkPressEvent(PointerEvent details) {
    var x = details.localPosition.dx;
    var y = details.localPosition.dy;
    
    for (int i = 0; i < buttons.length; i++)
    {
      var button = buttons[i];
      if (!button.pressed && button.pointInside(x, y))
      {
        setState(() {
          button.pressed = true;
          msg = 'Кнопка ${button.text} натиснута';
        });
        
      }
    }
  }
  
  void _checkUnpressEvent(PointerEvent details) {
    for (int i = 0; i < buttons.length; i++)
    {
      var button = buttons[i];
      if (button.pressed)
      {
        setState(() {
          button.pressed = false;
        });
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded (
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(const Size(double.infinity, double.infinity)),
            child: Listener(
              onPointerHover: _checkHoverEvent,
              onPointerDown: _checkPressEvent,
              onPointerUp: _checkUnpressEvent,
              child: CustomPaint(painter: CustomButtonsPainter(buttons))
            ),
          )
        ),
        Text(msg),
      ],
    );
  }
}

class CustomButtonsPainter extends CustomPainter {
  List<CustomButton> buttons;
  CustomButtonsPainter(this.buttons);
  
  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < buttons.length; i++)
    {
      var button = buttons[i];
      var paint = Paint();
      
      paint.style = PaintingStyle.stroke;
      paint.color = Colors.red;
      if (button.pressed)
      {
        paint.strokeWidth = 3.0;
      }
      else
      {
        paint.strokeWidth = 1.0;
      }
      
      canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(button.x, button.y, button.width, button.height), const Radius.circular(5)),
          paint,
        );
      
      if (button.hovered)
      {
        paint.style = PaintingStyle.fill;
        paint.color = Colors.grey;
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(button.x, button.y, button.width, button.height), const Radius.circular(5)),
          paint,
        );
      }
      
      const textStyle = TextStyle(
        color: Colors.black,
        fontSize: 12,
      );
      final textSpan = TextSpan(
        text: button.text,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: button.width,
      );
      final xCenter = button.x + button.width/2 - textPainter.width/2;
      final yCenter = button.y + button.height/2- textPainter.height/2;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CustomButtonsPainter oldDelegate) => true;
