import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/task/task_list.dart';
import 'package:sembast/sembast.dart';

class TaskDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _tasksStore = intMapStoreFactory.store(DBConstants.STORE_NAME_TASK);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Database _db;

  // Constructor
  TaskDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Task task) async {
    return await _tasksStore.add(_db, task.toMap());
  }

  Future<int> count() async {
    return await _tasksStore.count(_db);
  }

  Future<List<Task>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _tasksStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final task = Task.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      task.id = snapshot.key;
      return task;
    }).toList();
  }

  Future<TaskList> getTasksFromDb() async {

    print('Loading from database');

    // post list
    var tasksList;

    // fetching data
    final recordSnapshots = await _tasksStore.find(
      _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      tasksList = TaskList(
          tasks: recordSnapshots.map((snapshot) {
            final task = Task.fromMap(snapshot.value);
            // An ID is a key of a record from the database.
            task.id = snapshot.key;
            return task;
          }).toList());
    }

    return tasksList;
  }

  Future<int> update(Task task) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(task.id));
    return await _tasksStore.update(
      _db,
      task.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Task task) async {
    final finder = Finder(filter: Filter.byKey(task.id));
    return await _tasksStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _tasksStore.drop(
      _db,
    );
  }

}