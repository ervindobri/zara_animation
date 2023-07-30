library navigation_dot_bar;

import 'package:flutter/material.dart';

class DotBottomNavigation extends StatefulWidget {
  final List<DotBottomNavigationItem> items;
  final Color? activeColor;
  final Color? color;
  final Color? backgroundColor;

  const DotBottomNavigation(
      {Key? key,
      required this.items,
      this.activeColor,
      this.color,
      this.backgroundColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DotBottomNavigationState();
}

class _DotBottomNavigationState extends State<DotBottomNavigation> {
  final GlobalKey _keyBottomBar = GlobalKey();

  double? _numPositionBase, _numDifferenceBase, _positionLeftIndicatorDot;
  int _indexPageSelected = 0;
  Color? _activeColor;

  late Color _backgroundColor;

  @override
  void initState() {
    _backgroundColor = widget.backgroundColor ?? Colors.black;
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(_) {
    _activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final sizeBottomBar =
        (_keyBottomBar.currentContext?.findRenderObject() as RenderBox).size;
    _numPositionBase = ((sizeBottomBar.width / widget.items.length));
    _numDifferenceBase = (_numPositionBase! - (_numPositionBase! / 2));
    setState(() {
      _positionLeftIndicatorDot = _numPositionBase! - _numDifferenceBase!;
    });
  }

  @override
  Widget build(BuildContext context) => Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: _backgroundColor,
          child: Stack(
            key: _keyBottomBar,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _createNavigationIconButtonList(
                    widget.items.asMap(),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceInOut,
                left: _positionLeftIndicatorDot,
                bottom: 0,
                child: CircleAvatar(
                  radius: 2.5,
                  backgroundColor: _activeColor,
                ),
              ),
            ],
          ),
        ),
      );

  List<_NavigationIconButton> _createNavigationIconButtonList(
      Map<int, DotBottomNavigationItem> mapItem) {
    List<_NavigationIconButton> children = <_NavigationIconButton>[];
    mapItem.forEach(
      (index, item) => children.add(
        _NavigationIconButton(item.icon, item.onTap, () {
          _changeOptionBottomBar(index);
        }),
      ),
    );
    return children;
  }

  void _changeOptionBottomBar(int indexPageSelected) {
    if (indexPageSelected != _indexPageSelected) {
      setState(() {
        _positionLeftIndicatorDot =
            (_numPositionBase! * (indexPageSelected + 1)) - _numDifferenceBase!;
      });
      _indexPageSelected = indexPageSelected;
    }
  }
}

class DotBottomNavigationItem {
  final Widget icon;
  final NavigationIconButtonTapCallback onTap;
  const DotBottomNavigationItem({required this.icon, required this.onTap});
}

typedef NavigationIconButtonTapCallback = void Function();

class _NavigationIconButton extends StatefulWidget {
  final Widget widget;
  final NavigationIconButtonTapCallback _onTapInternalButton;
  final NavigationIconButtonTapCallback _onTapExternalButton;

  const _NavigationIconButton(
      this.widget, this._onTapInternalButton, this._onTapExternalButton,
      {Key? key})
      : super(key: key);

  @override
  _NavigationIconButtonState createState() => _NavigationIconButtonState();
}

class _NavigationIconButtonState extends State<_NavigationIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  double _opacityIcon = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.93).animate(_controller);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) {
          _controller.forward();
          setState(() => _opacityIcon = 0.7);
        },
        onTapUp: (_) {
          _controller.reverse();
          setState(() => _opacityIcon = 1);
        },
        onTapCancel: () {
          _controller.reverse();
          setState(() => _opacityIcon = 1);
        },
        onTap: () {
          widget._onTapInternalButton();
          widget._onTapExternalButton();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedOpacity(
            opacity: _opacityIcon,
            duration: const Duration(milliseconds: 200),
            child: widget.widget,
          ),
        ),
      );
}
