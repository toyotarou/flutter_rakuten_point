import 'package:isar/isar.dart';

import '../collections/action_name.dart';

class ActionNamesRepository {
  ///
  IsarCollection<ActionName> getCollection({required Isar isar}) => isar.actionNames;

  ///
  Future<ActionName?> getActionName({required Isar isar, required int id}) async {
    final IsarCollection<ActionName> actionNamesCollection = getCollection(isar: isar);
    return actionNamesCollection.get(id);
  }

  ///
  Future<List<ActionName>?> getActionNameList({required Isar isar}) async {
    final IsarCollection<ActionName> actionNamesCollection = getCollection(isar: isar);
    return actionNamesCollection.where().findAll();
  }

  ///
  Future<void> inputActionNameList({required Isar isar, required List<ActionName> actionNameList}) async {
    for (final ActionName element in actionNameList) {
      inputActionName(isar: isar, actionName: element);
    }
  }

  ///
  Future<void> inputActionName({required Isar isar, required ActionName actionName}) async {
    final IsarCollection<ActionName> actionNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => actionNamesCollection.put(actionName));
  }

  ///
  Future<void> updateActionNameList({required Isar isar, required List<ActionName> actionNameList}) async {
    for (final ActionName element in actionNameList) {
      updateActionName(isar: isar, actionName: element);
    }
  }

  ///
  Future<void> updateActionName({required Isar isar, required ActionName actionName}) async {
    final IsarCollection<ActionName> actionNamesCollection = getCollection(isar: isar);
    await actionNamesCollection.put(actionName);
  }

  ///
  Future<void> deleteActionNameList({required Isar isar, required List<ActionName>? actionNameList}) async {
    actionNameList?.forEach((ActionName element) => deleteActionName(isar: isar, id: element.id));
  }

  ///
  Future<void> deleteActionName({required Isar isar, required int id}) async {
    final IsarCollection<ActionName> actionNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => actionNamesCollection.delete(id));
  }
}
