import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/services/firestorecrud.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/util/helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:money/money.dart';

DbHelper helper = DbHelper();
final List<String> choices = const <String>[
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  crudMedthods crudObj = new crudMedthods();
  final _categories = [
    "Home & Utilities",
    "Transportation & Gas",
    "Groceries",
    "Personal & Family Care",
    "Health",
    "Insurance",
    "Restaurants & Cafe",
    "Entertainment & Shopping",
    "Travel",
    "Giving",
    "Education"
  ];
  String _category = "Home & Utilities";
  final _currencies = ["COP", "USD"];
  String _currency = "COP";
  DateTime _date = new DateTime.now();
  //TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MoneyMaskedTextController costController = new MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',');

  @override
  Widget build(BuildContext context) {
    //categoryController.text = todo.category;
    descriptionController.text = todo.description;
    costController.text = todo.cost.toStringAsFixed(2);
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // so we don't see the back button
          title: Text("Expense"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ListTile(
                      title: DropdownButton<String>(
                        items: _categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: textStyle,
                        value: todo.category == null || todo.category.isEmpty
                            ? _category
                            : todo.category,
                        onChanged: (value) => updateCategory(value),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: descriptionController,
                        style: textStyle,
                        onChanged: (value) => this.updateDescription(),
                        decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: costController,
                        style: textStyle,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => this.updateCost(),
                        decoration: InputDecoration(
                            labelText: "Cost",
                            hintText: "e.g. 100,000 or 1.60",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                    ListTile(
                      title: DropdownButton<String>(
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: textStyle,
                        value: todo.currency == null || todo.category.isEmpty
                            ? _currency
                            : todo.currency,
                        onChanged: (value) => updateCurrency(value),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          children: <Widget>[
                            new Text(dateFormatter.format(_date),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: GestureDetector(
                                onTap: _selectDate,
                                child:
                                    Icon(FontAwesomeIcons.calendar, size: 70.0),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: new RaisedButton(
                          onPressed: save,
                          color: Colors.blue,
                          padding: EdgeInsets.only(
                              top: 30.0,
                              bottom: 30.0,
                              right: 100.0,
                              left: 100.0),
                          child: new Text('Save',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ))
                  ],
                ),
              ],
            )));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (todo.id == null) {
          return;
        }
        result = await crudObj.deleteData(todo.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save() {
    //todo.date = new DateTime.now();
    if (todo.id != null) {
      crudObj.updateData(todo.id, todo.toMap());
    } else {
      crudObj.addData(todo.toMap());
    }
    Navigator.pop(context, true);
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(DateTime.now().year + 5));
    if (picked != null) setState(() => _date = picked);
  }

  void updateCategory(String value) {
    setState(() {
      _category = value;
    });
  }

  void updateCurrency(String value) {
    setState(() {
      _currency = value;
    });
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }

  void updateCost() {
    todo.cost = costController.numberValue;
  }
}
