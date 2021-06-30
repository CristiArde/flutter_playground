import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemListModel with ChangeNotifier {
  List<Item> _items = [];

  int get totalItems => _items.length;

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  List<Item> get items => _items;
}

class ItemModel with ChangeNotifier {
  MaterialColor _color = Colors.indigo;

  MaterialColor get color => _color;

  void setColor(MaterialColor color) {
    _color = color;
    notifyListeners();
  }
}

class Item {
  final String title;
  final int number;
  final MaterialColor color;

  Item(required, this.title, this.number, this.color);
}

class ItemWidget extends StatefulWidget {
  final String title;
  final int number;
  final MaterialColor color;

  ItemWidget({required this.title, required this.number, required this.color});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  int status = 0;

  get tileColor {
    switch(status) {
      case 0: {
        return Colors.white;
      }
      case 1: {
        return Colors.green;
      }
      default: {
        return Colors.red;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tileColor,
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text('Status: $status  Random Number:${widget.number}'),
        onTap: () => setState(() {
          status++;
        }),
      ),
    );
  }
}
