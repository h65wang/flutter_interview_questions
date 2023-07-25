import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/style/color.dart';

class LoveLoveGesture extends StatefulWidget {
  const LoveLoveGesture({
    Key? key,
    required this.child,
    this.onAddFavorite,
    this.onSingleTap,
  }) : super(key: key);

  final Function? onAddFavorite;
  final Function? onSingleTap;
  final Widget child;

  @override
  _LoveLoveGestureState createState() => _LoveLoveGestureState();
}

class _LoveLoveGestureState extends State<LoveLoveGesture> {
  GlobalKey _key = GlobalKey();

  // 内部转换坐标点
  Offset _p(Offset p) {
    RenderBox getBox = _key.currentContext?.findRenderObject() as RenderBox;
    return getBox.globalToLocal(p);
  }

  List<TapDownDetails> icons = [];

  bool canAddFavorite = false;
  bool justAddFavorite = false;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    var iconStack = Stack(
      children: icons
          .map<Widget>(
            (p) => LoveLoveFavoriteAnimationIcon(
              key: ValueKey(p.hashCode),
              position: _p(p.globalPosition),
              onAnimationComplete: () {
                icons.remove(p);
              },
            ),
          )
          .toList(),
    );
    return GestureDetector(
      key: _key,
      onTapDown: (detail) {
        setState(() {
          if (canAddFavorite) {
            // print('添加爱心，当前爱心数量:${icons.length}');
            icons.add(detail);
            widget.onAddFavorite?.call();
            justAddFavorite = true;
          } else {
            justAddFavorite = false;
          }
        });
      },
      onTapUp: (detail) {
        timer?.cancel();
        var delay = canAddFavorite ? 1200 : 600;
        timer = Timer(Duration(milliseconds: delay), () {
          canAddFavorite = false;
          timer = null;
          if (!justAddFavorite) {
            widget.onSingleTap?.call();
          }
        });
        canAddFavorite = true;
      },
      child: Stack(
        children: <Widget>[
          widget.child,
          iconStack,
        ],
      ),
    );
  }
}

class LoveLoveFavoriteAnimationIcon extends StatefulWidget {
  final Offset position;
  final double size;
  final Function? onAnimationComplete;

  const LoveLoveFavoriteAnimationIcon({
    Key? key,
    this.onAnimationComplete,
    required this.position,
    this.size = 100,
  }) : super(key: key);

  @override
  _LoveLoveFavoriteAnimationIconState createState() =>
      _LoveLoveFavoriteAnimationIconState();
}

class _LoveLoveFavoriteAnimationIconState
    extends State<LoveLoveFavoriteAnimationIcon> with TickerProviderStateMixin {
  AnimationController? _animationController;
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: Duration(milliseconds: 1600),
      vsync: this,
    );

    _animationController?.addListener(() {
      setState(() {});
    });
    startAnimation();
    super.initState();
  }

  void startAnimation() async {
    await _animationController?.forward();
    widget.onAnimationComplete?.call();
  }

  double rotate = pi / 10.0 * (2 * Random().nextDouble() - 1);

  double get value => _animationController?.value ?? 0;

  double appearDuration = 0.1;
  double dismissDuration = 0.8;

  double get opa {
    if (value < appearDuration) {
      return 0.99 / appearDuration * value;
    }
    if (value < dismissDuration) {
      return 0.99;
    }
    var res = 0.99 - (value - dismissDuration) / (1 - dismissDuration);
    return res < 0 ? 0 : res;
  }

  double get scale {
    if (value < appearDuration) {
      return 1 + appearDuration - value;
    }
    if (value < dismissDuration) {
      return 1;
    }
    return (value - dismissDuration) / (1 - dismissDuration) + 1;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Icon(
      Icons.favorite,
      size: widget.size,
      color: ColorPlate.primaryPink,
    );
    content = ShaderMask(
      child: content,
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) => RadialGradient(
        center: Alignment.topLeft.add(Alignment(0.66, 0.66)),
        colors: [
          Color.lerp(ColorPlate.primaryPink, ColorPlate.white, 0.4) ??
              ColorPlate.primaryPink,
          ColorPlate.primaryPink,
        ],
      ).createShader(bounds),
    );
    Widget body = Transform.rotate(
      angle: rotate,
      child: Opacity(
        opacity: opa,
        child: Transform.scale(
          alignment: Alignment.bottomCenter,
          scale: scale,
          child: content,
        ),
      ),
    );
    return Positioned(
      left: widget.position.dx - widget.size / 2,
      top: widget.position.dy - widget.size / 2,
      child: body,
    );
  }
}
