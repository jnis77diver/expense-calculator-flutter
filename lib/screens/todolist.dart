import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/tododetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/util/helpers.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo("", 0.00, new DateTime.now(), "COP", ""));
        },
        tooltip: "Add new Todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  // ListView todoListItems() {
  StreamBuilder todoListItems() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('expenses')
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                    leading: CircleAvatar(
                      //backgroundColor: getColor(this.todos[position].priority),
                      backgroundColor: Colors.red,
                      child: Text(snapshot.data.documents[index]['currency']),
                    ),
                    title: Text(snapshot.data.documents[index]['description']),
                    subtitle: Text(snapshot.data.documents[index]['category']),
                    trailing: Column(
                      children: <Widget>[
                        Text(
                          currencyFormater
                              .format(snapshot.data.documents[index]['cost']),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(dateFormatter
                            .format(snapshot.data.documents[index]['date'])),
                      ],
                    ),
                    onTap: () {
                      debugPrint("Tapped on " +
                          snapshot.data.documents[index].documentID);
                      navigateToDetail(Todo.fromObject(
                          snapshot.data.documents[index].data,
                          snapshot.data.documents[index].documentID));
                    }),
              );
            },
          );
        });
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          //debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items " + count.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),
    );
    if (result == true) {
      getData();
    }
  }
}
