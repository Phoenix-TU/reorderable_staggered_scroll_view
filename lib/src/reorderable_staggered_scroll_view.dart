import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'drag_container.dart';
import 'drag_notification.dart';

/// Represents an item in a [ReorderableStaggeredScrollView].
class ReorderableStaggeredScrollViewListItem {
  final Key key;
  final Widget widget;

  /// Creates a [ReorderableStaggeredScrollViewListItem].
  ///
  /// The [key] is a required unique identifier for the item.
  /// The [widget] is the widget content of the item.
  const ReorderableStaggeredScrollViewListItem({
    required this.key,
    required this.widget,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReorderableStaggeredScrollViewListItem &&
        key == other.key &&
        widget == other.widget;
  }

  @override
  int get hashCode => key.hashCode ^ widget.hashCode;
}

/// Represents an item in a grid layout within a [ReorderableStaggeredScrollView].
abstract class ReorderableStaggeredScrollViewGridItem
    extends ReorderableStaggeredScrollViewListItem {
  /// Creates a [ReorderableStaggeredScrollViewGridItem].
  ///
  /// The [key] is a required unique identifier for the item.
  /// The [mainAxisCellCount] specifies the number of cells along the main axis.
  /// The [crossAxisCellCount] specifies the number of cells along the cross axis.
  /// The [widget] is the widget content of the item.
  const ReorderableStaggeredScrollViewGridItem({
    required super.key,
    required super.widget,
  });

  num get mainAxisSize;
  int get crossAxisSize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReorderableStaggeredScrollViewGridItem &&
        key == other.key &&
        mainAxisSize == other.mainAxisSize &&
        crossAxisSize == other.crossAxisSize &&
        widget == other.widget;
  }

  @override
  int get hashCode =>
      super.hashCode ^ mainAxisSize.hashCode ^ crossAxisSize.hashCode;
}

/// Represents an item in a grid layout within a [ReorderableStaggeredScrollView].
class ReorderableStaggeredScrollViewGridCountItem
    extends ReorderableStaggeredScrollViewGridItem {
  final int mainAxisCellCount;
  final int crossAxisCellCount;

  /// Creates a [ReorderableStaggeredScrollViewGridItem].
  ///
  /// The [key] is a required unique identifier for the item.
  /// The [mainAxisCellCount] specifies the number of cells along the main axis.
  /// The [crossAxisCellCount] specifies the number of cells along the cross axis.
  /// The [widget] is the widget content of the item.
  const ReorderableStaggeredScrollViewGridCountItem({
    required super.key,
    required this.mainAxisCellCount,
    required this.crossAxisCellCount,
    required super.widget,
  });

  @override
  int get crossAxisSize => crossAxisCellCount;

  @override
  int get mainAxisSize => mainAxisCellCount;
}

/// Represents an item in a grid layout within a [ReorderableStaggeredScrollView].
class ReorderableStaggeredScrollViewGridExtentItem
    extends ReorderableStaggeredScrollViewGridItem {
  final double mainAxisExtent;
  final int crossAxisCellCount;

  /// Creates a [ReorderableStaggeredScrollViewGridItem].
  ///
  /// The [key] is a required unique identifier for the item.
  /// The [mainAxisExtent] specifies the size extent along the main axis.
  /// The [crossAxisCellCount] specifies the number of cells along the cross axis.
  /// The [widget] is the widget content of the item.
  const ReorderableStaggeredScrollViewGridExtentItem({
    required super.key,
    required this.mainAxisExtent,
    required this.crossAxisCellCount,
    required super.widget,
  });

  @override
  int get crossAxisSize => crossAxisCellCount;

  @override
  double get mainAxisSize => mainAxisExtent;
}

/// A scrollable list or grid with reordering and drag-and-drop support.
class ReorderableStaggeredScrollView extends StatefulWidget {
  /// Whether the reordering and dragging functionality is enabled.
  final bool enable;

  /// Indicates if the children are displayed in a list layout.
  final bool isList;

  /// List of items that can be reordered or dragged.
  final List<ReorderableStaggeredScrollViewListItem> children;

  /// Indicates whether items can be dragged using long press.
  final bool isLongPressDraggable;

  /// A function that builds the feedback widget during dragging.
  final Widget Function(ReorderableStaggeredScrollViewListItem, Widget, Size)?
      buildFeedback;

  /// The axis along which the items can be reordered.
  final Axis? axis;

  /// A callback when an item is accepted during a drag operation.
  final void Function(ReorderableStaggeredScrollViewListItem?,
      ReorderableStaggeredScrollViewListItem, bool, List<Key> list)? onAccept;

  /// A callback to check if an item will be accepted during a drag operation.
  final bool Function(ReorderableStaggeredScrollViewListItem?,
      ReorderableStaggeredScrollViewListItem, bool,List<Key> list)? onWillAccept;

  /// A callback when an item leaves the target area during a drag operation.
  final void Function(ReorderableStaggeredScrollViewListItem?,
      ReorderableStaggeredScrollViewListItem, bool)? onLeave;

  /// A callback that is called when an item is moved during a drag operation.
  final void Function(ReorderableStaggeredScrollViewListItem,
      DragTargetDetails<ReorderableStaggeredScrollViewListItem>, bool)? onMove;

  /// The hit test behavior for draggable items.
  final HitTestBehavior hitTestBehavior;

  /// A callback called when a drag operation starts.
  final void Function(ReorderableStaggeredScrollViewListItem)? onDragStarted;

  /// A callback called when an item is being dragged and updated.
  final void Function(
      DragUpdateDetails, ReorderableStaggeredScrollViewListItem)? onDragUpdate;

  /// A callback called when a draggable item is canceled.
  final void Function(Velocity, Offset, ReorderableStaggeredScrollViewListItem)?
      onDraggableCanceled;

  /// A callback called when a drag operation ends.
  final void Function(DraggableDetails, ReorderableStaggeredScrollViewListItem)?
      onDragEnd;

  /// A callback called when a drag operation is completed.
  final void Function(ReorderableStaggeredScrollViewListItem)? onDragCompleted;

  /// The scroll controller for the scroll view.
  final ScrollController? scrollController;

  /// Indicates whether drag notifications should be used.
  final bool isDragNotification;

  /// The opacity of the widget being dragged.
  final double draggingWidgetOpacity;

  /// The edge scroll coefficient for automatic scrolling.
  final double edgeScroll;

  /// The speed of edge scrolling in milliseconds.
  final int edgeScrollSpeedMilliseconds;

  /// List of items that should not be draggable.
  final List<ReorderableStaggeredScrollViewListItem>? isNotDragList;

  /// The scroll direction of the scroll view.
  final Axis scrollDirection;

  /// Indicates whether the scroll view is in reverse direction.
  final bool reverse;

  /// The scroll controller for the scroll view.
  final ScrollController? controller;

  /// Indicates whether the scroll view is primary.
  final bool? primary;

  /// The physics of the scroll view.
  final ScrollPhysics? physics;

  /// Padding around the scroll view.
  final EdgeInsetsGeometry? padding;

  /// The drag start behavior for gestures.
  final DragStartBehavior dragStartBehavior;

  /// The keyboard dismiss behavior for the scroll view.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// The restoration ID for saving and restoring the scroll position.
  final String? restorationId;

  /// The clip behavior for the scroll view.
  final Clip clipBehavior;

  /// Indicates whether the scroll view should shrink-wrap its contents.
  final bool shrinkWrap;

  /// The number of items in the cross-axis of the grid.
  final int crossAxisCount;

  /// The axis direction of the grid, if applicable.
  final AxisDirection? axisDirection;

  /// Constructor for creating a ReorderableStaggeredScrollView in a list layout.
  const ReorderableStaggeredScrollView.list({
    super.key,
    this.enable = true,
    required this.children,
    this.isLongPressDraggable = true,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.physics,
    this.padding,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.buildFeedback,
    this.axis,
    this.onAccept,
    this.onWillAccept,
    this.onLeave,
    this.onMove,
    this.hitTestBehavior = HitTestBehavior.translucent,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
    this.scrollController,
    this.isDragNotification = false,
    this.draggingWidgetOpacity = 0.5,
    this.edgeScroll = 0.1,
    this.edgeScrollSpeedMilliseconds = 100,
    this.isNotDragList,
  })  : axisDirection = null,
        isList = true,
        crossAxisCount = 1;

  ReorderableStaggeredScrollView.grid({
    super.key,
    this.enable = true,
    required List<ReorderableStaggeredScrollViewGridItem> this.children,
    this.isLongPressDraggable = true,
    required this.crossAxisCount,
    this.axisDirection,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.padding,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.axis,
    this.hitTestBehavior = HitTestBehavior.translucent,

    /// A function that builds the feedback widget during dragging.
    Widget Function(ReorderableStaggeredScrollViewGridItem, Widget, Size)?
        buildFeedback,
    void Function(ReorderableStaggeredScrollViewGridItem?,
            ReorderableStaggeredScrollViewGridItem, bool, List<Key> list)?
        onAccept,
    bool Function(ReorderableStaggeredScrollViewGridItem?,
            ReorderableStaggeredScrollViewGridItem, bool, List<Key> list)?
        onWillAccept,
    void Function(ReorderableStaggeredScrollViewGridItem?,
            ReorderableStaggeredScrollViewGridItem, bool)?
        onLeave,
    void Function(ReorderableStaggeredScrollViewGridItem,
            DragTargetDetails<ReorderableStaggeredScrollViewGridItem>, bool)?
        onMove,
    void Function(ReorderableStaggeredScrollViewGridItem)? onDragStarted,
    void Function(DragUpdateDetails, ReorderableStaggeredScrollViewGridItem)?
        onDragUpdate,
    void Function(Velocity, Offset, ReorderableStaggeredScrollViewGridItem)?
        onDraggableCanceled,
    void Function(DraggableDetails, ReorderableStaggeredScrollViewGridItem)?
        onDragEnd,
    void Function(ReorderableStaggeredScrollViewGridItem)? onDragCompleted,
    this.scrollController,
    this.isDragNotification = false,
    this.draggingWidgetOpacity = 0.5,
    this.edgeScroll = 0.1,
    this.edgeScrollSpeedMilliseconds = 100,
    List<ReorderableStaggeredScrollViewGridItem>? this.isNotDragList,
  })  : isList = false,
        shrinkWrap = false,
        buildFeedback = (buildFeedback == null
            ? null
            : (ReorderableStaggeredScrollViewListItem item, Widget widget,
                    Size size) =>
                buildFeedback(
                  item as ReorderableStaggeredScrollViewGridItem,
                  widget,
                  size,
                )),
        onAccept = (onAccept == null
            ? null
            : (ReorderableStaggeredScrollViewListItem? item1,
                    ReorderableStaggeredScrollViewListItem? item2,
                    bool value, List<Key> list) =>
                onAccept(
                  item1 as ReorderableStaggeredScrollViewGridItem?,
                  item2 as ReorderableStaggeredScrollViewGridItem,
                  value, list
                )),
        onLeave = (onLeave == null
            ? null
            : (ReorderableStaggeredScrollViewListItem? item1,
                    ReorderableStaggeredScrollViewListItem? item2,
                    bool value) =>
                onLeave(
                  item1 as ReorderableStaggeredScrollViewGridItem?,
                  item2 as ReorderableStaggeredScrollViewGridItem,
                  value,
                )),
        onWillAccept = (onWillAccept == null
            ? null
            : (ReorderableStaggeredScrollViewListItem? item1,
                    ReorderableStaggeredScrollViewListItem? item2,
                    bool value,List<Key> list) =>
                onWillAccept(
                  item1 as ReorderableStaggeredScrollViewGridItem?,
                  item2 as ReorderableStaggeredScrollViewGridItem,
                  value, list,
                )),
        onMove = (onMove == null
            ? null
            : (ReorderableStaggeredScrollViewListItem item,
                    DragTargetDetails<ReorderableStaggeredScrollViewListItem>
                        details,
                    bool value) =>
                onMove(
                  item as ReorderableStaggeredScrollViewGridItem,
                  DragTargetDetails<ReorderableStaggeredScrollViewGridItem>(
                    data:
                        details.data as ReorderableStaggeredScrollViewGridItem,
                    offset: details.offset,
                  ),
                  value,
                )),
        onDragStarted = (onDragStarted == null
            ? null
            : (ReorderableStaggeredScrollViewListItem item) =>
                onDragStarted(item as ReorderableStaggeredScrollViewGridItem)),
        onDragUpdate = (onDragUpdate == null
            ? null
            : (DragUpdateDetails details,
                    ReorderableStaggeredScrollViewListItem item) =>
                onDragUpdate(
                  details,
                  item as ReorderableStaggeredScrollViewGridItem,
                )),
        onDraggableCanceled = (onDraggableCanceled == null
            ? null
            : (Velocity velocity, Offset offset,
                    ReorderableStaggeredScrollViewListItem item) =>
                onDraggableCanceled(
                  velocity,
                  offset,
                  item as ReorderableStaggeredScrollViewGridItem,
                )),
        onDragEnd = (onDragEnd == null
            ? null
            : (DraggableDetails details,
                    ReorderableStaggeredScrollViewListItem item) =>
                onDragEnd(
                    details, item as ReorderableStaggeredScrollViewGridItem)),
        onDragCompleted = (onDragCompleted == null
            ? null
            : (ReorderableStaggeredScrollViewListItem item) => onDragCompleted(
                item as ReorderableStaggeredScrollViewGridItem));

  @override
  State<ReorderableStaggeredScrollView> createState() =>
      _ReorderableStaggeredScrollViewState();
}

class _ReorderableStaggeredScrollViewState
    extends State<ReorderableStaggeredScrollView> {
  List<ReorderableStaggeredScrollViewListItem> _children = const [];

  @override
  void initState() {
    super.initState();

    _children = widget.children;
  }

  Widget buildContainer({
    required Widget Function(List<Widget>) buildItems,
  }) {
    return DragContainer(
      isDrag: widget.enable,
      scrollDirection: widget.scrollDirection,
      isLongPressDraggable: widget.isLongPressDraggable,
      buildItems: buildItems,
      buildFeedback: widget.buildFeedback,
      axis: widget.axis,
      onAccept: widget.onAccept,
      onWillAccept: widget.onWillAccept,
      onLeave: widget.onLeave,
      onMove: widget.onMove,
      hitTestBehavior: widget.hitTestBehavior,
      onDragStarted: widget.onDragStarted,
      onDragUpdate: widget.onDragUpdate,
      onDraggableCanceled: widget.onDraggableCanceled,
      onDragEnd: widget.onDragEnd,
      onDragCompleted: widget.onDragCompleted,
      scrollController: widget.scrollController,
      isDragNotification: widget.isDragNotification,
      draggingWidgetOpacity: widget.draggingWidgetOpacity,
      edgeScroll: widget.edgeScroll,
      edgeScrollSpeedMilliseconds: widget.edgeScrollSpeedMilliseconds,
      isNotDragList: widget.isNotDragList,
      items: (ReorderableStaggeredScrollViewListItem element,
          DraggableWidget draggableWidget) {
        if (widget.isList) {
          return Container(
            key: ValueKey(element.key.toString()),
            child: draggableWidget(element.widget),
          );
        }

        if (element is ReorderableStaggeredScrollViewGridCountItem) {
          return StaggeredGridTile.count(
            key: ValueKey(element.key.toString()),
            mainAxisCellCount: element.mainAxisCellCount,
            crossAxisCellCount: element.crossAxisCellCount,
            child: draggableWidget(element.widget),
          );
        } else if (element is ReorderableStaggeredScrollViewGridExtentItem) {
          return StaggeredGridTile.extent(
            key: ValueKey(element.key.toString()),
            mainAxisExtent: element.mainAxisExtent,
            crossAxisCellCount: element.crossAxisCellCount,
            child: draggableWidget(element.widget),
          );
        } else {
          throw (
            FlutterError(
              "Item should be one of ReorderableStaggeredScrollViewGridItem or ReorderableStaggeredScrollViewGridExtentItem but it was ${element.runtimeType}",
            ),
          );
        }
      },
      dataList: _children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragNotification(
      child: (widget.isList
          ? SingleChildScrollView(
              scrollDirection: widget.scrollDirection,
              physics: widget.physics,
              child: buildContainer(
                buildItems: (List<Widget> children) {
                  return ListView(
                    scrollDirection: widget.scrollDirection,
                    reverse: widget.reverse,
                    controller: widget.controller,
                    primary: widget.primary,
                    physics: widget.physics,
                    shrinkWrap: widget.shrinkWrap,
                    padding: widget.padding,
                    dragStartBehavior: widget.dragStartBehavior,
                    keyboardDismissBehavior: widget.keyboardDismissBehavior,
                    restorationId: widget.restorationId,
                    clipBehavior: widget.clipBehavior,
                    children: children,
                  );
                },
              ),
            )
          : SingleChildScrollView(
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              padding: widget.padding,
              dragStartBehavior: widget.dragStartBehavior,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
              child: buildContainer(
                buildItems: (List<Widget> children) {
                  return StaggeredGrid.count(
                    crossAxisCount: widget.crossAxisCount,
                    axisDirection: widget.axisDirection,
                    children: children,
                  );
                },
              ),
            )),
    );
  }
}
