import 'package:guide_wizard/data/local/constants/db_constants.dart';
import 'package:guide_wizard/models/technical_name/technical_name.dart';
import 'package:guide_wizard/models/technical_name/technical_name_list.dart';
import 'package:sembast/sembast.dart';


class TechnicalNameDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _technicalNameStore =
      intMapStoreFactory.store(DBConstants.STORE_NAME_TECHNICAL_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  //  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  TechnicalNameDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int?> insert(TechnicalName technicalName) async {
    return await _technicalNameStore
        .record(technicalName.id)
        .add(_db, technicalName.toMap());
  }

  Future<int> count() async {
    return await _technicalNameStore.count(_db);
  }

  Future<List<TechnicalName>> getAllSortedByFilter(
      {List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _technicalNameStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final technicalName = TechnicalName.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      technicalName.id = snapshot.key;
      return technicalName;
    }).toList();
  }

  Future<TechnicalNameList> getTranslationsFromDb() async {
    print('Loading from database');

    // post list
    var technicalNameList;

    // fetching data
    final recordSnapshots = await _technicalNameStore.find(
      _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      technicalNameList = TechnicalNameList(
          technicalNames: recordSnapshots.map((snapshot) {
        final technicalName = TechnicalName.fromMap(snapshot.value);
        // An ID is a key of a record from the database.
        technicalName.id = snapshot.key;
        return technicalName;
      }).toList());
    }

    return technicalNameList;
  }

  Future<int> update(TechnicalName technicalName) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(technicalName.id));
    return await _technicalNameStore.update(
      _db,
      technicalName.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(TechnicalName technicalName) async {
    final finder = Finder(filter: Filter.byKey(technicalName.id));
    return await _technicalNameStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _technicalNameStore.drop(
      _db,
    );
  }
}
