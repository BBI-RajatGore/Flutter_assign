import 'package:counter_app/provider/counter_provider.dart';
import 'package:counter_app/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final counterProvider = Provider.of<MyCounter>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            counterProvider.getCounter().toString(),
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.w500, fontSize: 30),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonWidget(
                function: () => counterProvider.decrementCounter(),
                text: "Decrement",
              ),
              ButtonWidget(
                function: () => counterProvider.resetCounter(),
                text: "Reset",
              ),
              ButtonWidget(
                function: () => counterProvider.incrementCounter(),
                text: "Increment",
              ),
            ],
          )
        ],
      ),
    );
  }
}
