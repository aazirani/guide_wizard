import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/translation/translation.dart';
import 'package:boilerplate/models/translation/translation_list.dart';
import 'package:boilerplate/models/translation/translations_with_step_name.dart';
import 'package:boilerplate/models/translation/translations_with_step_name_list.dart';
import 'package:sembast/sembast.dart';

class TranslationsWithStepNameDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _translationsWithStepNameStore = intMapStoreFactory.store(DBConstants.STORE_NAME_TRANSLATION_WITH_STEP_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  //  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  TranslationsWithStepNameDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int?> insert(TranslationsWithStepName translationsWithStepName) async {
    return await _translationsWithStepNameStore.record(translationsWithStepName.id).add(_db, translationsWithStepName.toMap());
  }

  Future<int> count() async {
    return await _translationsWithStepNameStore.count(_db);
  }

  Future<List<Translation>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _translationsWithStepNameStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final translationsWithStepName = Translation.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      translationsWithStepName.id = snapshot.key;
      return translationsWithStepName;
    }).toList();
  }

  Future<TranslationList> getTranslationsFromDb() async {

    print('Loading from database');

    // post list
    var translationsWithStepNameList;

    // fetching data
    final recordSnapshots = await _translationsWithStepNameStore.find(
      _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    if(recordSnapshots.length > 0) {
      translationsWithStepNameList = TranslationsWithStepNameList(
          translationsWithStepName: recordSnapshots.map((snapshot) {
            final translation = TranslationsWithStepName.fromMap(snapshot.value);
            // An ID is a key of a record from the database.
            translation.id = snapshot.key;
            return translation;
          }).toList());
    }

    return translationsWithStepNameList;
  }

  Future<int> update(TranslationsWithStepName translationWithStepName) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(translationWithStepName.id));
    return await _translationsWithStepNameStore.update(
      _db,
      translationWithStepName.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(TranslationsWithStepName translationWithStepName) async {
    final finder = Finder(filter: Filter.byKey(translationWithStepName.id));
    return await _translationsWithStepNameStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _translationsWithStepNameStore.drop(
      _db,
    );
  }

}
