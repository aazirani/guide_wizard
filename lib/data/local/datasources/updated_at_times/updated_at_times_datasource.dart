import 'package:guide_wizard/data/local/constants/db_constants.dart';
import 'package:guide_wizard/models/updated_at_times/updated_at_times.dart';
import 'package:sembast/sembast.dart';

class UpdatedAtTimesDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _updatedAtTimesStore =
  intMapStoreFactory.store(DBConstants.STORE_NAME_UPDATED_AT_TIMES);

  // database instance
  final Database _db;

  // Constructor
  UpdatedAtTimesDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(UpdatedAtTimes updatedAtTimes) async {
    return await _updatedAtTimesStore.add(_db, updatedAtTimes.toMap());
  }

  Future<int> count() async {
    return await _updatedAtTimesStore.count(_db);
  }

  Future<List<UpdatedAtTimes>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _updatedAtTimesStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final updatedAtTimes = UpdatedAtTimes.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      // updatedAtTimes.id = snapshot.key;
      return updatedAtTimes;
    }).toList();
  }

  Future<UpdatedAtTimes> getUpdatedAtTimesFromDb() async {
    print('Loading from database');

    // post list
    var updatedAtTimes;

    // fetching data
    final recordSnapshots = await _updatedAtTimesStore.find(
      _db,
    );
    List listOfUpdatedAtTimes = recordSnapshots.map((snapshot) {
      updatedAtTimes = UpdatedAtTimes.fromMap(snapshot.value);
      return updatedAtTimes;
    }).toList();

    return listOfUpdatedAtTimes[0];
  }

  Future<int> update(UpdatedAtTimes updatedAtTimes) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    return await _updatedAtTimesStore.update(
      _db,
      updatedAtTimes.toMap(),
    );
  }

  Future<int> delete(UpdatedAtTimes updatedAtTimes) async {
    return await _updatedAtTimesStore.delete(
      _db,
    );
  }

  Future deleteAll() async {
    await _updatedAtTimesStore.drop(
      _db,
    );
  }
}
