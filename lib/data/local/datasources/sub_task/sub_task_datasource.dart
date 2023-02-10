import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/sub_task/sub_task_list.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:sembast/sembast.dart';

class SubTaskDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _subTasksStore =
      intMapStoreFactory.store(DBConstants.STORE_NAME_SUB_TASK);

  // database instance
  final Database _db;

  // Constructor
  SubTaskDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(SubTask subTask) async {
    return await _subTasksStore.add(_db, subTask.toMap());
  }

  Future<int> count() async {
    return await _subTasksStore.count(_db);
  }

  Future<List<SubTask>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _subTasksStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final subTask = SubTask.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      subTask.id = snapshot.key;
      return subTask;
    }).toList();
  }

  Future<SubTaskList> getSubTasksFromDb() async {
    print('Loading from database');

    // post list
    var subTasksList;

    // fetching data
    final recordSnapshots = await _subTasksStore.find(
      _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      subTasksList = SubTaskList(
          subTasks: recordSnapshots.map((snapshot) {
        final subTask = SubTask.fromMap(snapshot.value);
        // An ID is a key of a record from the database.
        subTask.id = snapshot.key;
        return subTask;
      }).toList());
    }

    return subTasksList;
  }

  Future<int> update(SubTask subTask) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(subTask.id));
    return await _subTasksStore.update(
      _db,
      subTask.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(SubTask subTask) async {
    final finder = Finder(filter: Filter.byKey(subTask.id));
    return await _subTasksStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _subTasksStore.drop(
      _db,
    );
  }
}
