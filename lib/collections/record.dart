import 'package:isar/isar.dart';

part 'record.g.dart';

@collection
class Record {
  Id id = Isar.autoIncrement;

  @Index()
  late String date;

  late int price;
}
