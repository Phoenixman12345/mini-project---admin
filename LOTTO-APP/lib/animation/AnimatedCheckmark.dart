import 'package:flutter/material.dart';

class AnimatedCheckmark extends StatefulWidget {
  final bool isSuccess;

  AnimatedCheckmark({required this.isSuccess});

  @override
  _AnimatedCheckmarkState createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.isSuccess
          ? const Duration(milliseconds: 500)
          : const Duration(milliseconds: 60),
      vsync: this,
    );

    if (widget.isSuccess) {
      _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )..addListener(() {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else if (_controller.isDismissed) {
            _controller.forward();
          }
        });
      _controller.forward();
    } else {
      // สร้างแอนิเมชันแบบการสั่นซ้ายขวา
      _animation = Tween<double>(begin: -2, end: 2).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      )..addListener(() {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else if (_controller.isDismissed) {
            _controller.forward();
          }
        });
      _controller.forward();
    }
    Future.delayed(Duration(milliseconds: 400), () {
      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: widget.isSuccess
              ? Offset.zero // สำหรับการแอนิเมชันแบบ ease-in-out
              : Offset(_animation.value, 0), // การเคลื่อนไหวไปซ้ายและขวา
          child: Icon(
            widget.isSuccess
                ? Icons.check_circle
                : Icons.cancel, // เปลี่ยนเป็น Icons.cancel สำหรับ error
            color: widget.isSuccess ? Colors.green : Colors.red,
            size: 60,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
