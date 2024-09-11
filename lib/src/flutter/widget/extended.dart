///
///
/// this file contains:
///
/// [GeneratorOffsetExtension]
///
///
/// [GlobalKeysWidget]
/// [StreamWidget]
///
///
///
/// mix:
/// [CenterSizedBox], [SizedBoxCenter]
/// [RowPadding], [RowPaddingColumn]
/// [ColumnPadding], [ColumnPaddingRow], [ColumnText]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of damath_flutter;

///
///
///
extension GeneratorOffsetExtension on Generator<Offset> {
  List<Widget> yieldingPositionedTranslated(
    int length, {
    required Applier<Offset> translation,
    required Widget child,
    FilterQuality? filterQuality,
    bool transformHitTests = true,
  }) =>
      yieldingToList(
        length,
        (position) => Positioned(
          left: position.dx,
          top: position.dy,
          child: Transform.translate(
            offset: translation(position),
            transformHitTests: transformHitTests,
            filterQuality: filterQuality,
            child: child,
          ),
        ),
      );
}

///
///
///
/// [GlobalKeysWidget]
///
///
///
class GlobalKeysWidget<S extends State<StatefulWidget>> extends StatefulWidget {
  const GlobalKeysWidget({
    super.key,
    required this.keysName,
    required this.builder,
  });

  final Set<String> keysName;
  final WidgetGlobalKeysBuilder<S> builder;

  static GlobalKey<S> toGlobalKey<S extends State<StatefulWidget>>(
    String key,
  ) =>
      GlobalKey<S>(debugLabel: key);

  @override
  State<GlobalKeysWidget<S>> createState() => _GlobalKeysWidgetState<S>();
}

class _GlobalKeysWidgetState<S extends State<StatefulWidget>>
    extends State<GlobalKeysWidget<S>> {
  final Map<String, GlobalKey<S>> keys = {};

  @override
  void initState() {
    final names = widget.keysName;
    keys.addAll(Map.fromIterables(
      names,
      names.map(GlobalKeysWidget.toGlobalKey),
    ));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GlobalKeysWidget<S> oldWidget) {
    keys.migrateInto(widget.keysName, GlobalKeysWidget.toGlobalKey);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, keys);
}

///
///
/// [StreamWidget]
///
///
class StreamWidget<T> extends StatelessWidget {
  const StreamWidget({
    super.key,
    this.initialData,
    this.waitingDataBuilder,
    this.activeBuilder,
    this.doneConnectBuilder,
    this.noneConnectionBuilder,
    required this.stream,
    required this.builder,
    this.child,
  });

  final T? initialData;
  final Stream<T> stream;
  final ValueWidgetBuilder<T?> builder;
  final ValueWidgetBuilder<T?>? activeBuilder;
  final ValueWidgetBuilder<T?>? waitingDataBuilder;
  final ValueWidgetBuilder<T?>? doneConnectBuilder;
  final ValueWidgetBuilder<T?>? noneConnectionBuilder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw UnimplementedError(snapshot.error.toString());
        }
        final status = snapshot.connectionState;
        return (switch (status) {
              ConnectionState.none => noneConnectionBuilder,
              ConnectionState.waiting => waitingDataBuilder,
              ConnectionState.active => activeBuilder,
              ConnectionState.done => doneConnectBuilder,
            } ??
            this.builder)(context, snapshot.data, child);
      },
    );
  }
}


///
///
///
///
///
///
///
///
///
///
/// mix
///
///
///
///
///
///
///
///
///
///
///


///
///
///
class CenterSizedBox extends StatelessWidget {
  const CenterSizedBox({
    super.key,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  const CenterSizedBox.expand({
    super.key,
    this.widthFactor,
    this.heightFactor,
    this.child,
  })  : width = double.infinity,
        height = double.infinity;

  CenterSizedBox.fromSize({
    super.key,
    this.widthFactor,
    this.heightFactor,
    required Size size,
    this.child,
  })  : width = size.width,
        height = size.height;

  final double? width;
  final double? height;
  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class SizedBoxCenter extends StatelessWidget {
  const SizedBoxCenter({
    super.key,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  const SizedBoxCenter.expand({
    super.key,
    this.widthFactor,
    this.heightFactor,
    this.child,
  })  : width = double.infinity,
        height = double.infinity;

  SizedBoxCenter.fromSize({
    super.key,
    this.widthFactor,
    this.heightFactor,
    this.child,
    required Size size,
  })  : width = size.width,
        height = size.height;

  final double? width;
  final double? height;
  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: child,
      ),
    );
  }
}


///
///
/// row
///
///

class RowPadding extends StatelessWidget {
  const RowPadding({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.childCount = 1,
    required this.padding,
    required this.child,
  });

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int childCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: List.generate(childCount, childGenerator),
    );
  }

  Widget childGenerator(int index) => Padding(padding: padding, child: child);
}

class RowPaddingColumn extends StatelessWidget {
  const RowPaddingColumn({
    super.key,
    this.mainAxisAlignmentRow = MainAxisAlignment.center,
    this.mainAxisAlignmentColumn = MainAxisAlignment.center,
    this.mainAxisSizeRow = MainAxisSize.max,
    this.mainAxisSizeColumn = MainAxisSize.max,
    this.crossAxisAlignmentRow = CrossAxisAlignment.center,
    this.crossAxisAlignmentColumn = CrossAxisAlignment.center,
    this.verticalDirectionRow = VerticalDirection.down,
    this.verticalDirectionColumn = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.columnCount = 1,
    required this.padding,
    required this.children,
  });

  final MainAxisAlignment mainAxisAlignmentRow;
  final MainAxisAlignment mainAxisAlignmentColumn;
  final MainAxisSize mainAxisSizeRow;
  final MainAxisSize mainAxisSizeColumn;
  final CrossAxisAlignment crossAxisAlignmentRow;
  final CrossAxisAlignment crossAxisAlignmentColumn;
  final VerticalDirection verticalDirectionRow;
  final VerticalDirection verticalDirectionColumn;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int columnCount;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RowPadding(
      mainAxisAlignment: mainAxisAlignmentRow,
      mainAxisSize: mainAxisSizeRow,
      crossAxisAlignment: crossAxisAlignmentRow,
      textDirection: textDirection,
      verticalDirection: verticalDirectionRow,
      textBaseline: textBaseline,
      childCount: columnCount,
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignmentColumn,
        mainAxisSize: mainAxisSizeColumn,
        crossAxisAlignment: crossAxisAlignmentColumn,
        textDirection: textDirection,
        verticalDirection: verticalDirectionColumn,
        textBaseline: textBaseline,
        children: children,
      ),
    );
  }
}

///
///
/// column
///
///

class ColumnPadding extends StatelessWidget {
  const ColumnPadding({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.childCount = 1,
    required this.padding,
    required this.child,
  });

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int childCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: List.generate(childCount, childGenerator),
    );
  }

  Widget childGenerator(int index) => Padding(padding: padding, child: child);
}

class ColumnPaddingRow extends StatelessWidget {
  const ColumnPaddingRow({
    super.key,
    this.textDirection,
    this.textBaseline,
    this.rowCount = 1,
    this.mainAxisAlignmentRow = MainAxisAlignment.center,
    this.mainAxisAlignmentColumn = MainAxisAlignment.center,
    this.mainAxisSizeRow = MainAxisSize.max,
    this.mainAxisSizeColumn = MainAxisSize.max,
    this.crossAxisAlignmentRow = CrossAxisAlignment.center,
    this.crossAxisAlignmentColumn = CrossAxisAlignment.center,
    this.verticalDirectionRow = VerticalDirection.down,
    this.verticalDirectionColumn = VerticalDirection.down,
    required this.padding,
    required this.children,
  });

  final MainAxisAlignment mainAxisAlignmentRow;
  final MainAxisAlignment mainAxisAlignmentColumn;
  final MainAxisSize mainAxisSizeRow;
  final MainAxisSize mainAxisSizeColumn;
  final CrossAxisAlignment crossAxisAlignmentRow;
  final CrossAxisAlignment crossAxisAlignmentColumn;
  final VerticalDirection verticalDirectionRow;
  final VerticalDirection verticalDirectionColumn;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final EdgeInsetsGeometry padding;
  final int rowCount;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ColumnPadding(
      mainAxisAlignment: mainAxisAlignmentColumn,
      mainAxisSize: mainAxisSizeColumn,
      crossAxisAlignment: crossAxisAlignmentColumn,
      textDirection: textDirection,
      verticalDirection: verticalDirectionColumn,
      textBaseline: textBaseline,
      childCount: rowCount,
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignmentRow,
        mainAxisSize: mainAxisSizeRow,
        crossAxisAlignment: crossAxisAlignmentRow,
        textDirection: textDirection,
        verticalDirection: verticalDirectionRow,
        textBaseline: textBaseline,
        children: children,
      ),
    );
  }
}

///
///
///
class ColumnText extends StatelessWidget {
  const ColumnText(
      this.text, {
        super.key,
        this.interval = WSizedBox.none,
        this.lineBuilder = none,
        this.alignment = MainAxisAlignment.center,
      });

  static Text none(String line) => Text(line);

  final String text;
  final Widget interval;
  final Text Function(String line) lineBuilder;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: alignment,
      children: text.split('\n').fold(
        [],
            (list, line) => list
          ..add(lineBuilder(line))
          ..add(interval),
      )..removeLast(),
    );
  }
}
