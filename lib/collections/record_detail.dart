import 'package:isar/isar.dart';

part 'record_detail.g.dart';

@collection
class RecordDetail {
  Id id = Isar.autoIncrement;

  late String date;

  late String category;
  late String action;

  late int price;
}
