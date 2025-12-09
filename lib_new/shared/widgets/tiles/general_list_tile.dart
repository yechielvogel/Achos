import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/general.dart';

class CustomListTile extends ConsumerStatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool dismissible;
  final VoidCallback? onDismissed;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.onPressed,
    this.dismissible = false,
    this.onDismissed,
  }) : super(key: key);

  @override
  ConsumerState<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends ConsumerState<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    final style = ref.read(styleProvider);

    Widget tileContent = Container(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: style.buttonBorderColor,
          width: 1.5,
        ),
      ),
      child: ClipRect(
        child: ListTile(
          title: Text(
            widget.title,
            style: TextStyle(
              color: style.themeBlack,
              fontSize: style.subtitleFontSize,
              fontWeight: style.subtitleFontWeight,
            ),
          ),
          onTap: widget.onPressed,
        ),
      ),
    );
    if (widget.dismissible) {
      // in the dismissible package i commented this out to make it look nicer
      // clipper: _DismissibleClipper(
      //   axis: _directionIsXAxis ? Axis.horizontal : Axis.vertical,
      //   moveAnimation: _moveAnimation,
      // ),
      tileContent = Dismissible(
        key: Key(widget.title),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart &&
              widget.onDismissed != null) {
            HapticFeedback.heavyImpact();
            widget.onDismissed!();
          }
        },
        background: Container(
          decoration: BoxDecoration(
            color: style.accentColor,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            Icons.check_circle_outlined,
            color: style.themeBlack,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: tileContent,
        ),
      );
    }

    return tileContent;
  }
}
