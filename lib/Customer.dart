import 'package:floor/floor.dart';

// TypeConverter for DateTime
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

@entity
class Customer {
  @primaryKey
  final int id;
  final String firstName;
  final String lastName;
  final String address;

  @TypeConverters([DateTimeConverter])
  final DateTime birthday;

  Customer(this.id, this.firstName, this.lastName, this.address, this.birthday);
}
