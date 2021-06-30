import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_provider/providers/counter_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('HomePage build');
    //first
    // final counterModel = Provider.of<CounterModel>(context);
    //first1.1
    // final counterModel = Provider.of<CounterModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: Text('Provider home screen')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //first
              //first1.1
              // Text('Total Number: ${counterModel.count}'),
              //first 1.2
              // Consumer<CounterModel>(builder: (context, counterModel, child) => Text('Total Number: ${counterModel.count}')),
              //second
              // Text('Total Number: ${context.watch<CounterModel>().count}'),
              //second
              CounterWidget(),
              OutlinedButton(
                  onPressed: () => {Navigator.pushNamed(context, '/secondPage')},
                  child: Text('Go to next screen'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) return Theme.of(context).colorScheme.primary.withOpacity(0.7);
                        return Colors.lightGreenAccent;
                      },
                    ),
                  )
              )
            ],
          ),
        ),
        floatingActionButton: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  //first
                  // onPressed: () => {counterModel.decrease()},
                  //second
                  onPressed: () => {context.read<CounterModel>().decrease()},
                  child: Icon(Icons.remove, color: Colors.red),
                  heroTag: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  //first
                  // onPressed: () => {counterModel.reset()},
                  //second
                  onPressed: () => {context.read<CounterModel>().reset()},
                  child: Icon(Icons.replay, color: Colors.white),
                  heroTag: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  //first
                  // onPressed: () => {counterModel.increase()},
                  //second
                  onPressed: () => {context.read<CounterModel>().increase()},
                  child: Icon(Icons.add, color: Colors.green),
                  heroTag: 3,
                ),
              )
            ],
          ),
        ));
  }
}
