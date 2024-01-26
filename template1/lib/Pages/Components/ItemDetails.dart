import 'package:flutter/material.dart';

import '../../Models/item.dart';

class ItemDetails extends StatefulWidget {
  final Item item;

  const ItemDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditItemState();
}

class _EditItemState extends State<ItemDetails> {
  //late TextEditingController priceController;

  @override
  void initState() {
    //priceController = TextEditingController(text: widget.item.price.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Price'),
      ),
      body: ListView(
        children: [
          Text('Name: ${widget.item.name}'),
          Text('Team: ${widget.item.team}'),
          Text('Details: ${widget.item.details}'),
          Text('Status: ${widget.item.status}'),
          Text('Members: ${widget.item.members.toString()}'),
          Text('Type: ${widget.item.type}'),
        ],
      ),
    );
  }
}
