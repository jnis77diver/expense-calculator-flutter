class Todo {
  String _id;
  String _category;
  String _description;
  DateTime _date;
  double _cost;
  String _currency;

  Todo(this._category, this._cost, this._date, this._currency,
      [this._description]);
  Todo.withId(this._id, this._category, this._cost, this._date, this._currency,
      [this._description]);
  String get id => _id;
  String get category => _category;
  String get description => _description;
  double get cost => _cost;
  DateTime get date => _date;
  String get currency => _currency;

  set category(String newCategory) {
    if (newCategory.length <= 255) {
      _category = newCategory;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set currency(String newCurrency) {
    if (newCurrency.length <= 255) {
      _currency = newCurrency;
    }
  }

  set cost(double newCost) {
    _cost = newCost;
  }

  set date(DateTime newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["category"] = _category;
    map["description"] = _description;
    map["cost"] = _cost;
    map["date"] = _date;
    map["currency"] = _currency;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Todo.fromObject(dynamic o, [String id]) {
    this._id = id;
    this._category = o["category"];
    this._description = o["description"];
    this._cost = double.parse(o["cost"].toString());
    this._date = o["date"];
    this._currency = o["currency"];
  }
}
