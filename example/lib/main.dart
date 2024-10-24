import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reorderable_staggered_scroll_view/reorderable_staggered_scroll_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Example'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (final type in GridType.values)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(type: type),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(switch (type) {
                          GridType.list => "List",
                          GridType.count => "Grid Count",
                          GridType.extent => "Grid Extent",
                        }),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

enum GridType {
  list,
  count,
  extent,
}

class HomePage extends StatefulWidget {
  final GridType type;

  const HomePage({Key? key, required this.type}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _dragEnabled = true;

  @override
  Widget build(BuildContext context) {
    final nonDraggable = ReorderableStaggeredScrollViewGridCountItem(
      key: ValueKey(10.toString()),
      mainAxisCellCount: 1,
      crossAxisCellCount: Random().nextInt(2) + 1,
      widget: const Card(
          child: Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: Text('Non Draggable')),
      )),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (widget.type) {
          // TODO: Handle this case.
          GridType.list => "List Example",
          GridType.count => "Grid Count Example",
          GridType.extent => "Grid Extent Example",
        }),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _dragEnabled = !_dragEnabled;
                });
              },
              icon: Icon(
                _dragEnabled ? Icons.pause : Icons.play_arrow,
              ))
        ],
      ),
      body: widget.type == GridType.list
          ? ReorderableStaggeredScrollView.list(
              enable: _dragEnabled,
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              axis: Axis.vertical,
              shrinkWrap: true,
              isLongPressDraggable: false,
              onDragEnd: (details, item) {
                debugPrint('onDragEnd: $details ${item.key}');
              },
              isNotDragList: [
                  nonDraggable
                ],
              children: [
                  ...List.generate(
                    5,
                    (index) => ReorderableStaggeredScrollViewListItem(
                      key: ValueKey(index.toString()),
                      widget: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(child: Text('Item $index')),
                      )),
                    ),
                  ),
                  nonDraggable,
                  ...List.generate(
                    5,
                    (index) => ReorderableStaggeredScrollViewListItem(
                      key: ValueKey('${index + 5}'),
                      widget: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(child: Text('Item ${index + 5}')),
                      )),
                    ),
                  )
                ])
          : ReorderableStaggeredScrollView.grid(
              enable: _dragEnabled,
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 4,
              isLongPressDraggable: false,
              onAccept: (item1, item2, value, list) {
                print('item1 $item1 item2 $item2 value $value');
                print(list.map((e)=>e.toString()));
              },
              onDragEnd: (details, item) {
                print('onDragEnd: $details ${item.key}');
              },
              onMove: (item, item2, value) {
                print('onMove: item $item item2 $item2 value $value');
              },
              onDragUpdate: (details, item) {
                print('onDragUpdate: details $details item $item');
              },
              isNotDragList: [
                  nonDraggable
                ],
              children: [
                  ...List.generate(
                    5,
                    (index) => widget.type == GridType.count
                        ? ReorderableStaggeredScrollViewGridCountItem(
                            key: ValueKey(index.toString()),
                            mainAxisCellCount: 1,
                            crossAxisCellCount: Random().nextInt(2) + 1,
                            widget:
                                Card(child: Center(child: Text('Item $index'))),
                          )
                        : ReorderableStaggeredScrollViewGridExtentItem(
                            key: ValueKey(index.toString()),
                            mainAxisExtent: Random().nextInt(200) + 100,
                            crossAxisCellCount: Random().nextInt(2) + 1,
                            widget:
                                Card(child: Center(child: Text('Item $index'))),
                          ),
                  ),
                  nonDraggable,
                  ...List.generate(
                    5,
                    (index) => widget.type == GridType.count
                        ? ReorderableStaggeredScrollViewGridCountItem(
                            key: ValueKey((index + 5).toString()),
                            mainAxisCellCount: 1,
                            crossAxisCellCount: Random().nextInt(2) + 1,
                            widget: Card(
                                child:
                                    Center(child: Text('Item ${index + 5}'))),
                          )
                        : ReorderableStaggeredScrollViewGridExtentItem(
                            key: ValueKey((index + 5).toString()),
                            mainAxisExtent: Random().nextInt(200) + 100,
                            crossAxisCellCount: Random().nextInt(2) + 1,
                            widget:
                                Card(child: Center(child: Text('Item ${index + 5}'))),
                          ),
                  )
                ]), // Provide the list of reorderable items
    );
  }
}
