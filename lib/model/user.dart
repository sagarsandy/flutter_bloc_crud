class User {
  String name;
  int age;

  User(
    this.name,
    this.age,
  );

  // Creating a map object to insert/update in database
  Map<dynamic, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'age': age,
    };

    return map;
  }

  // Creating student object from database map object
  User.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    age = map['age'];
  }
}
