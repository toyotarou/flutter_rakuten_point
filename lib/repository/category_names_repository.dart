import 'package:isar/isar.dart';

import '../collections/category_name.dart';

class CategoryNamesRepository {
  ///
  IsarCollection<CategoryName> getCollection({required Isar isar}) => isar.categoryNames;

  ///
  Future<CategoryName?> getCategoryName({required Isar isar, required int id}) async {
    final IsarCollection<CategoryName> categoryNamesCollection = getCollection(isar: isar);
    return categoryNamesCollection.get(id);
  }

  ///
  Future<List<CategoryName>?> getCategoryNameList({required Isar isar}) async {
    final IsarCollection<CategoryName> categoryNamesCollection = getCollection(isar: isar);
    return categoryNamesCollection.where().findAll();
  }

  ///
  Future<void> inputCategoryNameList({required Isar isar, required List<CategoryName> categoryNameList}) async {
    for (final CategoryName element in categoryNameList) {
      inputCategoryName(isar: isar, categoryName: element);
    }
  }

  ///
  Future<void> inputCategoryName({required Isar isar, required CategoryName categoryName}) async {
    final IsarCollection<CategoryName> categoryNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => categoryNamesCollection.put(categoryName));
  }

  ///
  Future<void> updateCategoryNameList({required Isar isar, required List<CategoryName> categoryNameList}) async {
    for (final CategoryName element in categoryNameList) {
      updateCategoryName(isar: isar, categoryName: element);
    }
  }

  ///
  Future<void> updateCategoryName({required Isar isar, required CategoryName categoryName}) async {
    final IsarCollection<CategoryName> categoryNamesCollection = getCollection(isar: isar);
    await categoryNamesCollection.put(categoryName);
  }

  ///
  Future<void> deleteCategoryNameList({required Isar isar, required List<CategoryName>? categoryNameList}) async {
    categoryNameList?.forEach((CategoryName element) => deleteCategoryName(isar: isar, id: element.id));
  }

  ///
  Future<void> deleteCategoryName({required Isar isar, required int id}) async {
    final IsarCollection<CategoryName> categoryNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => categoryNamesCollection.delete(id));
  }
}
