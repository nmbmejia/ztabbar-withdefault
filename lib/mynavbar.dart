library mynavbar;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ZNavbar extends StatefulWidget {
  const ZNavbar(
      {Key? key,
      required this.tabs,
      this.indexCallback,
      this.backgroundColor = Colors.white,
      this.indicatorColor = Colors.blue,
      this.indicatorSize = 8,
      this.activeColor = Colors.blue,
      this.padding = const EdgeInsets.symmetric(horizontal: 10),
      this.inactiveColor = Colors.grey})
      : super(key: key);
  final List<ZTab> tabs;
  final Color indicatorColor;
  final double indicatorSize;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final Color backgroundColor;
  final ValueChanged<int>? indexCallback;
  @override
  State<ZNavbar> createState() => _ZNavbarState();
}

class _ZNavbarState extends State<ZNavbar> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final double w = c.maxWidth;
        return Material(
          elevation: 1,

          color: widget.backgroundColor,
          // color: Colors.blue,
          child: SafeArea(
            child: Container(
              width: w,
              height: 50,
              padding: widget.padding,
              child: Column(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    alignment: FractionalOffset(
                        1 / (widget.tabs.length - 1) * currentIndex, 0),
                    child: FractionallySizedBox(
                      widthFactor: 1 / widget.tabs.length,
                      child: Container(
                        height: widget.indicatorSize,
                        color: widget.indicatorColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50 - widget.indicatorSize,
                    width: w,
                    child: Row(
                      children: widget.tabs.asMap().entries.map((e) {
                        final ZTab tab = widget.tabs[e.key];
                        return Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              currentIndex = e.key;
                              if (widget.indexCallback != null) {
                                widget.indexCallback!(e.key);
                              }
                              if (mounted) setState(() {});
                            },
                            child: AnimatedScale(
                              scale: currentIndex == e.key ? 1 : .9,
                              duration: const Duration(milliseconds: 500),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: widget.indicatorSize,
                                  ),
                                  Expanded(
                                    child: tab.text != null
                                        ? Tooltip(
                                            message: tab.text,
                                            child: tab.type == ZType.icon
                                                ? IconTheme(
                                                    data: IconThemeData(
                                                      color: currentIndex ==
                                                              e.key
                                                          ? widget.activeColor
                                                          : widget
                                                              .inactiveColor,
                                                    ),
                                                    child: tab.child,
                                                  )
                                                : tab.child,
                                          )
                                        : tab.type == ZType.icon
                                            ? IconTheme(
                                                data: IconThemeData(
                                                  color: currentIndex == e.key
                                                      ? widget.activeColor
                                                      : widget.inactiveColor,
                                                ),
                                                child: tab.child,
                                              )
                                            : tab.child,
                                  ),
                                  if (widget.tabs[e.key].text != null) ...{
                                    AnimatedScale(
                                      scale: currentIndex == e.key ? 1 : .95,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: FittedBox(
                                        child: Text(
                                          widget.tabs[e.key].text!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            // height: 1,
                                            fontSize: (widget.tabs.length > 4
                                                ? 11
                                                : 12),
                                            color: currentIndex == e.key
                                                ? widget.activeColor
                                                : widget.inactiveColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  },
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget imageBuilder(int index,
      {required String path, required ZImageType type}) {
    switch (type) {
      case ZImageType.asset:
        return Image.asset(
          path,
          color:
              currentIndex == index ? widget.activeColor : widget.inactiveColor,
          errorBuilder: (_, __, ___) => Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: widget.inactiveColor,
              valueColor: AlwaysStoppedAnimation<Color>(widget.activeColor),
            ),
          ),
        );
      case ZImageType.network:
        return Image.network(
          path,
          color:
              currentIndex == index ? widget.activeColor : widget.inactiveColor,
          errorBuilder: (_, __, ___) => Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: widget.inactiveColor,
              valueColor: AlwaysStoppedAnimation<Color>(widget.activeColor),
            ),
          ),
        );
      case ZImageType.file:
        // TODO: Handle this case.
        return Image.file(
          File(path),
          color:
              currentIndex == index ? widget.activeColor : widget.inactiveColor,
          errorBuilder: (_, __, ___) => Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: widget.inactiveColor,
              valueColor: AlwaysStoppedAnimation<Color>(widget.activeColor),
            ),
          ),
        );
      case ZImageType.svgAsset:
        return SvgPicture.asset(
          path,
          color:
              currentIndex == index ? widget.activeColor : widget.inactiveColor,
        );
      case ZImageType.svgNetwork:
        return SvgPicture.network(
          path,
          color:
              currentIndex == index ? widget.activeColor : widget.inactiveColor,
        );
    }
  }
}

class ZTab {
  final String? text;
  final ZType type;
  final Widget child;
  const ZTab({this.text, required this.type, required this.child});
}

class ZTabIcon extends ZTab {
  final Icon icon;

  ZTabIcon({required this.icon, String? text})
      : super(
          text: text,
          type: ZType.icon,
          child: icon,
        );
}

class ZTabImage extends ZTab {
  final String path;
  final ZImageType imgType;
  ZTabImage({required this.path, this.imgType = ZImageType.asset, String? text})
      : super(
          text: text,
          type: ZType.image,
          child: Container(),
        );
}

enum ZType {
  icon,
  image,
}

enum ZImageType {
  asset,
  network,
  file,
  svgAsset,
  svgNetwork,
}
