import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class listItem extends StatefulWidget {

  const listItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
}) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  _listItemState createState() => _listItemState();
}
class _listItemState extends State<listItem> {
  Color? _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.purple,
      Colors.blue
    ];

    _bgColor = availableColors[Random().nextInt(4)];

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                child: Text('\$${widget.transaction.amount}'),
              )
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
            DateFormat.yMMMEd().format(widget.transaction.date)
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
          icon: const Icon(Icons.delete_forever_outlined),
          label: const Text('Delete'),
          style: TextButton.styleFrom( primary: Theme.of(context).errorColor,
          ),
          onPressed: () => widget.deleteTx(widget.transaction.id),
        )
            : IconButton(
          icon: const Icon(Icons.delete_forever_outlined),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.deleteTx(widget.transaction.id),
        ),
      ),
    );
  }
}
