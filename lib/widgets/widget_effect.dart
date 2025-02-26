import 'package:flutter/material.dart';

//userinfo5에서만 사용중
class FadeSlideText extends StatefulWidget {
  final String text; // 텍스트
  final double textSize; // 텍스트
  final Duration duration; // 애니메이션 지속 시간

  FadeSlideText({
    required this.text,
    this.textSize = 22.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _FadeSlideTextState createState() => _FadeSlideTextState();
}

class _FadeSlideTextState extends State<FadeSlideText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 아래에서 위로 이동하는 애니메이션
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2), // 처음 위치 (약간 아래)
      end: Offset(0, 0), // 끝 위치 (원래 위치)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // 서서히 불투명해지는 애니메이션
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 애니메이션 시작
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation, // 텍스트의 위치 애니메이션
      child: FadeTransition(
        opacity: _opacityAnimation, // 텍스트의 불투명도 애니메이션
        child: Text(
          widget.text,
          style: TextStyle(fontSize: widget.textSize, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
class FadeSlideWidget extends StatefulWidget {
  final Widget child; // 애니메이션 적용할 위젯
  final Duration duration;

  FadeSlideWidget({
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _FadeSlideWidgetState createState() => _FadeSlideWidgetState();
}

class _FadeSlideWidgetState extends State<FadeSlideWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 아래에서 위로 이동하는 애니메이션
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2), // 처음 위치 (약간 아래)
      end: Offset(0, 0), // 끝 위치 (원래 위치)
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 서서히 불투명해지는 애니메이션
    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 애니메이션 시작
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation, // 텍스트의 위치 애니메이션
      child: FadeTransition(
        opacity: _opacityAnimation, // 텍스트의 불투명도 애니메이션
        child: widget.child,
      ),
    );
  }
}