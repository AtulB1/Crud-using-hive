import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildToDoListView()),
          _buildTextEntry(),
        ],
      ),
    );
  }

  Widget _buildToDoListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('todo').listenable(),
      builder: (context, Box box, _) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final todo = box.getAt(index) as String;

            return ListTile(
              title: Text(todo),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  box.deleteAt(index);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextEntry() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter to-do item',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Hive.box('todo').add(_textController.text);
              _textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
