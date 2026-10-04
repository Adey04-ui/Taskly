// lib/widgets/custom_glass_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'nav_item.dart';

class CustomGlassNavBar extends StatefulWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;

  const CustomGlassNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.activeColor = const Color(0xFF3134DE),
  });

  @override
  State<CustomGlassNavBar> createState() => _CustomGlassNavBarState();
}

class _CustomGlassNavBarState extends State<CustomGlassNavBar>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceScale;

  late final AnimationController _expandController;
  late final Animation<double> _expandScale;

  bool _isDragging = false;
  double _dragX = 0;
  int _dragIndex = 0;

  // Remembers which tab we were pressing DOWN on when the hold started,
  // so we can correctly offset localPosition back into full-bar coordinates.
  int _pressStartIndex = 0;

  @override
  void initState() {
    super.initState();
    _dragIndex = widget.selectedIndex;

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_bounceController);

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandScale = Tween<double>(begin: 1.0, end: 1.65).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant CustomGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex && !_isDragging) {
      _dragIndex = widget.selectedIndex;
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SizedBox(
        height: 64,
        child: LiquidGlassLayer(
          settings: const LiquidGlassSettings(
            thickness: 12,
            blur: 2,
          ), 
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / widget.items.length;

              // Indicator is now bigger than the item's own icon area.
              const double indicatorHeight = 49;
              final double indicatorWidth = itemWidth - 10; // was itemWidth - 16
              const double indicatorTop = 8; // was 8, re-centered for new height

              final activeIndex =
                  _isDragging ? _dragIndex : widget.selectedIndex;

              // Horizontal inset needed to keep the (now bigger) indicator centered.
              final double centerInset = (itemWidth - indicatorWidth) / 2;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: LiquidGlass(
                      shape: LiquidRoundedSuperellipse(borderRadius: 32),
                      child: const SizedBox.expand(),
                    ),
                  ),


                  // Icons are painted BEFORE (below) the indicator, so the
                  // glass lens refracts the slivers of tab icons at its edges.
                  Row(
                    children: List.generate(widget.items.length, (index) {
                      // Icon colors follow ONLY the actual selected tab —
                      // sliding the indicator over an icon must not activate it.
                      final isSelected = index == widget.selectedIndex;
                      final item = widget.items[index];
                      final isActiveTab = index == widget.selectedIndex;

                      return Expanded(
                        child: RawGestureDetector(
                          behavior: HitTestBehavior.translucent,
                          gestures: <Type, GestureRecognizerFactory<GestureRecognizer>>{
                            TapGestureRecognizer:
                                GestureRecognizerFactoryWithHandlers
                                    <TapGestureRecognizer>(
                              () => TapGestureRecognizer(),
                              (recognizer) {
                                recognizer.onTap = () => widget.onTap(index);
                              },
                            ),
                            // Only give the ACTIVE tab a long-press recognizer,
                            // and use a much shorter custom duration than the
                            // 500ms Flutter default.
                            if (isActiveTab)
                              LongPressGestureRecognizer:
                                  GestureRecognizerFactoryWithHandlers
                                      <LongPressGestureRecognizer>(
                                () => LongPressGestureRecognizer(
                                  duration: const Duration(milliseconds: 50),
                                ),
                                (recognizer) {
                                  recognizer.onLongPressStart = (details) {
                                    setState(() {
                                      _isDragging = true;
                                      _pressStartIndex = widget.selectedIndex;
                                      _dragIndex = widget.selectedIndex;
                                      _dragX = itemWidth * widget.selectedIndex +
                                          centerInset;
                                    });
                                    _expandController.forward();
                                  };
                                  recognizer.onLongPressMoveUpdate = (details) {
                                    setState(() {
                                      // Convert from "relative to the pressed
                                      // item" back into full-bar coordinates by
                                      // adding that item's own left offset.
                                      final absoluteX =
                                          _pressStartIndex * itemWidth +
                                              details.localPosition.dx;

                                      final maxX =
                                          constraints.maxWidth - indicatorWidth;
                                      _dragX = (absoluteX - indicatorWidth / 2)
                                          .clamp(0.0, maxX);

                                      _dragIndex = (_dragX / itemWidth)
                                          .round()
                                          .clamp(0, widget.items.length - 1);
                                    });
                                  };
                                  recognizer.onLongPressEnd = (details) {
                                    setState(() {
                                      _isDragging = false;
                                    });
                                    _expandController.reverse();
                                    if (_dragIndex != widget.selectedIndex) {
                                      widget.onTap(_dragIndex);
                                    }
                                  };
                                },
                              ),
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSelected ? item.activeIcon : item.icon,
                                  color: isSelected
                                      ? widget.activeColor
                                      : Colors.grey,
                                  size: 24,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? widget.activeColor
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  _isDragging
                      ? Positioned(
                          left: _dragX,
                          top: indicatorTop,
                          child: _buildIndicator(indicatorWidth, indicatorHeight),
                        )
                      : AnimatedPositioned(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          left: itemWidth * activeIndex + centerInset,
                          top: indicatorTop,
                          child: _buildIndicator(indicatorWidth, indicatorHeight),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(double width, double height) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceScale, _expandScale]),
      builder: (context, child) {
        final scale = _isDragging ? _expandScale.value : _bounceScale.value;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: LiquidGlass.withOwnLayer(
        // Lens is OFF at rest (refractiveIndex 1.0 = light passes straight
        // through, no bending) and turns ON while dragging — only then do
        // the indicator's edges bend the tab icons slivering underneath.
        settings: LiquidGlassSettings(
          thickness: 18,
          blur: 0,                    // NO blur — we bend light, we don't frost
          // The ONLY thing that changes between rest and drag:
          // refractiveIndex 1.0 = light passes straight through (no edge
          // bending) but the glass look itself stays fully intact.
          refractiveIndex: _isDragging ? 1.5 : 1.0,
          chromaticAberration: _isDragging ? 0.04 : 0.0,
          lightAngle: 0.6 * 3.14159,
          lightIntensity: 0.8,
          ambientStrength: 0.25,
          saturation: 1.8,
        ),
        shape: LiquidRoundedSuperellipse(borderRadius: 24),
        child: SizedBox(
          width: width,
          height: height,
        ),
      ),
    );
  }
}