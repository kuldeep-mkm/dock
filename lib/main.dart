import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dock(),
    );
  }
}

class Dock extends StatefulWidget {
  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> {
  // Initial list of icons
  List<IconData> dockIcons = [
    Icons.home,
    Icons.search,
    Icons.settings,
    Icons.camera,
    Icons.phone,
  ];

  // Tracking the dragged index
  int? draggedIndex;

  // Reorders icons when an item is dragged
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final icon = dockIcons.removeAt(oldIndex);
      dockIcons.insert(newIndex, icon);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: dockIcons.asMap().entries.map((entry) {
              int index = entry.key;
              IconData icon = entry.value;
              return _buildDraggableIcon(icon, index);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableIcon(IconData icon, int index) {
    return LongPressDraggable<int>(
      data: index,
      axis: Axis.horizontal,
      feedback: Material(
        color: Colors.transparent,
        child: Icon(icon, size: 30, color: Colors.white),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildDockItem(icon),
      ),
      onDragStarted: () {
        setState(() {
          draggedIndex = index;
        });
      },
      onDraggableCanceled: (_, __) {
        setState(() {
          draggedIndex = null;
        });
      },
      onDragEnd: (details) {
        setState(() {
          draggedIndex = null;
        });
      },
      child: DragTarget<int>(
        onWillAccept: (incomingIndex) {
          return incomingIndex != index;
        },
        onAccept: (incomingIndex) {
          _onReorder(incomingIndex!, index);
        },
        builder: (context, candidateData, rejectedData) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: _buildDockItem(icon),
          );
        },
      ),
    );
  }

  Widget _buildDockItem(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: Icon(icon, size: 25, color: Colors.white),
      ),
    );
  }
}
