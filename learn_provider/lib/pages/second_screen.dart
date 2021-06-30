import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_provider/providers/counter_provider.dart';
import 'package:learn_provider/providers/item_provider.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatelessWidget {
  static final List colors = [Colors.red, Colors.green, Colors.yellow];
  static final List itemNames = ['Important', 'Ok', 'Banana'];
  static final Random random = new Random();

  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Second Page build');
    //first
    var itemListModel = Provider.of<ItemListModel>(context, listen: false);
    var randomNb = random.nextInt(3);
    return Scaffold(
        appBar: AppBar(title: Text('Provider Second screen')),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () => context.read<ItemListModel>().addItem(new Item(required, itemNames[randomNb], randomNb, colors[randomNb]))),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20),
                  child: Text(
                    'First screen counter -> ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
                // Text('${counterModel.count}'),
                CounterWidget()
              ],
            ),
            //first
            Expanded(
              child: ListView.builder(
                  itemCount: context.watch<ItemListModel>().totalItems,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Card(
                            elevation: 8,
                            child: ItemWidget(
                              title: itemListModel.items[index].title,
                              number: itemListModel.items[index].number,
                              color: itemListModel.items[index].color,
                            )));
                  }),
            ),
            //first1.1
            // Expanded(
            //   child: ListView.builder(
            //       itemCount: context.watch<ItemListModel>().totalItems,
            //       itemBuilder: (BuildContext context, int index) {
            //         return Container(
            //             padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            //             child: Card(
            //                 elevation: 8,
            //                 child: ItemWidget(
            //                   title: context.watch<ItemListModel>().items[index].title,
            //                   number: context.watch<ItemListModel>().items[index].number,
            //                   color: context.watch<ItemListModel>().items[index].color,
            //                 )));
            //       }),
            // ),
            //second
            // Consumer<ItemListModel>(
            //   builder: (context, itemModel, child) =>
            //       Expanded(
            //         child: ListView.builder(
            //         itemCount: itemModel.totalItems,
            //         itemBuilder: (BuildContext context, int index) {
            //           return Container(
            //               padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            //               child: Card(
            //                   elevation: 8,
            //                   child: ItemWidget(
            //                     title: itemModel.items[index].title,
            //                     number: itemModel.items[index].number,
            //                     color: itemModel.items[index].color,
            //                   )));
            //         }),
            //       ),
            // ),
          ],
        ));
  }
}
