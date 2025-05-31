import 'package:isar/isar.dart';

import '../collections/record.dart';

class RecordsRepository {
  ///
  IsarCollection<Record> getCollection({required Isar isar}) => isar.records;

  ///
  Future<Record?> getRecord({required Isar isar, required int id}) async {
    final IsarCollection<Record> recordsCollection = getCollection(isar: isar);
    return recordsCollection.get(id);
  }

  ///
  Future<List<Record>?> getRecordList({required Isar isar}) async {
    final IsarCollection<Record> recordsCollection = getCollection(isar: isar);
    return recordsCollection.where().sortByDate().findAll();
  }

  ///
  Future<void> inputRecordList({required Isar isar, required List<Record> recordList}) async {
    for (final Record element in recordList) {
      inputRecord(isar: isar, record: element);
    }
  }

  ///
  Future<void> inputRecord({required Isar isar, required Record record}) async {
    final IsarCollection<Record> recordsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => recordsCollection.put(record));
  }

  ///
  Future<void> updateRecordList({required Isar isar, required List<Record> recordList}) async {
    for (final Record element in recordList) {
      updateRecord(isar: isar, record: element);
    }
  }

  ///
  Future<void> updateRecord({required Isar isar, required Record record}) async {
    final IsarCollection<Record> recordsCollection = getCollection(isar: isar);
    await recordsCollection.put(record);
  }

  ///
  Future<void> deleteRecordList({required Isar isar, required List<Record>? recordList}) async {
    recordList?.forEach((Record element) => deleteRecord(isar: isar, id: element.id));
  }

  ///
  Future<void> deleteRecord({required Isar isar, required int id}) async {
    final IsarCollection<Record> recordsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => recordsCollection.delete(id));
  }
}
