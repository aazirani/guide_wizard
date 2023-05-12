import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/step/step.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:sembast/sembast.dart';

class StepDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _stepsStore = intMapStoreFactory.store(DBConstants.STORE_NAME_STEP);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  StepDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Step step) async {
    return await _stepsStore.add(_db, step.toMap());
  }

  Future<int> count() async {
    return await _stepsStore.count(_db);
  }

  Future<List<Step>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _stepsStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final step = Step.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      step.id = snapshot.key;
      return step;
    }).toList();
  }

  Future<StepList> getStepsFromDb() async {
    print('Loading from database');

    // post list
    StepList stepsList;

    // fetching data
    final recordSnapshots = await _stepsStore.find(
      _db,
    );

    print("snapss: $recordSnapshots");
    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      stepsList = StepList(
          steps: recordSnapshots.map((snapshot) {
        final step = Step.fromMap(snapshot.value);
        // An ID is a key of a record from the database.
        step.id = snapshot.key;
        return step;
      }).toList());
    } else {
      stepsList = StepList(steps: []);
    }

    return stepsList;
  }

  Future<int> update(Step step) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(step.id));
    return await _stepsStore.update(
      _db,
      step.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Step step) async {
    final finder = Finder(filter: Filter.byKey(step.id));
    return await _stepsStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _stepsStore.drop(
      _db,
    );
  }
}
