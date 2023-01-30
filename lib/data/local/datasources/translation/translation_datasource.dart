import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/translation/translation.dart';
import 'package:boilerplate/models/translation/translation_list.dart';
import 'package:sembast/sembast.dart';

class TranslationDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _translationStore = intMapStoreFactory.store(DBConstants.STORE_NAME_TRANSLATION);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  //  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  TranslationDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int?> insert(Translation translation) async {
    return await _translationStore.record(translation.id).add(_db, translation.toMap());
  }

  Future<int> count() async {
    return await _translationStore.count(_db);
  }

  Future<List<Translation>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _translationStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final translation = Translation.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      translation.id = snapshot.key;
      return translation;
    }).toList();
  }

  Future<TranslationList> getTranslationsFromDb() async {

    print('Loading from database');

    // post list
    var translationList;

    // fetching data
    final recordSnapshots = await _translationStore.find(
      _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    if(recordSnapshots.length > 0) {
      translationList = TranslationList(
          translations: recordSnapshots.map((snapshot) {
            final translation = Translation.fromMap(snapshot.value);
            // An ID is a key of a record from the database.
            translation.id = snapshot.key;
            return translation;
          }).toList());
    }

    return translationList;
  }

  Future<int> update(Translation translation) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(translation.id));
    return await _translationStore.update(
      _db,
      translation.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Translation translation) async {
    final finder = Finder(filter: Filter.byKey(translation.id));
    return await _translationStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _translationStore.drop(
      _db,
    );
  }

}
