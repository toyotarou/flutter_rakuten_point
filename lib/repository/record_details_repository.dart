import 'package:isar/isar.dart';

import '../collections/record_detail.dart';

class RecordDetailsRepository {
  ///
  IsarCollection<RecordDetail> getCollection({required Isar isar}) => isar.recordDetails;

  ///
  Future<RecordDetail?> getRecordDetail({required Isar isar, required int id}) async {
    final IsarCollection<RecordDetail> recordDetailsCollection = getCollection(isar: isar);
    return recordDetailsCollection.get(id);
  }

  ///
  Future<List<RecordDetail>?> getRecordDetailList({required Isar isar}) async {
    final IsarCollection<RecordDetail> recordDetailsCollection = getCollection(isar: isar);
    return recordDetailsCollection.where().sortByDate().findAll();
  }

  ///
  Future<void> inputRecordDetailList({required Isar isar, required List<RecordDetail> recordDetailList}) async {
    for (final RecordDetail element in recordDetailList) {
      inputRecordDetail(isar: isar, recordDetail: element);
    }
  }

  ///
  Future<void> inputRecordDetail({required Isar isar, required RecordDetail recordDetail}) async {
    final IsarCollection<RecordDetail> recordDetailsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => recordDetailsCollection.put(recordDetail));
  }

  ///
  Future<void> updateRecordDetailList({required Isar isar, required List<RecordDetail> recordDetailList}) async {
    for (final RecordDetail element in recordDetailList) {
      updateRecordDetail(isar: isar, recordDetail: element);
    }
  }

  ///
  Future<void> updateRecordDetail({required Isar isar, required RecordDetail recordDetail}) async {
    final IsarCollection<RecordDetail> recordDetailsCollection = getCollection(isar: isar);
    await recordDetailsCollection.put(recordDetail);
  }

  ///
  Future<void> deleteRecordDetailList({required Isar isar, required List<RecordDetail>? recordDetailList}) async {
    recordDetailList?.forEach((RecordDetail element) => deleteRecordDetail(isar: isar, id: element.id));
  }

  ///
  Future<void> deleteRecordDetail({required Isar isar, required int id}) async {
    final IsarCollection<RecordDetail> recordDetailsCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => recordDetailsCollection.delete(id));
  }
}
