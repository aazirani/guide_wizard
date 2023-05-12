import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/question/question_list.dart';
import 'package:sembast/sembast.dart';

class QuestionDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _questionsStore =
      intMapStoreFactory.store(DBConstants.STORE_NAME_QUESTION);

  // database instance
  final Database _db;

  // Constructor
  QuestionDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Question question) async {
    return await _questionsStore.add(_db, question.toMap());
  }

  Future<int> count() async {
    return await _questionsStore.count(_db);
  }

  Future<List<Question>> getAllSortedByFilter({List<Filter>? filters}) async {
    //creating finder
    final finder = Finder(
        filter: filters != null ? Filter.and(filters) : null,
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _questionsStore.find(
      _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final question = Question.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      question.id = snapshot.key;
      return question;
    }).toList();
  }

  Future<QuestionList> getQuestionsFromDb() async {
    print('Loading from database');

    // post list
    var questionsList;

    // fetching data
    final recordSnapshots = await _questionsStore.find(
      _db,
    );
    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      questionsList = QuestionList(
          questions: recordSnapshots.map((snapshot) {
        final question = Question.fromMap(snapshot.value);
        // An ID is a key of a record from the database.
        question.id = snapshot.key;
        return question;
      }).toList());
    }

    return questionsList;
  }

  Future<int> update(Question question) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(question.id));
    print("here is the map: " + question.toMap().toString());
    return await _questionsStore.update(
      _db,
      question.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Question question) async {
    final finder = Finder(filter: Filter.byKey(question.id));
    return await _questionsStore.delete(
      _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _questionsStore.drop(
      _db,
    );
  }
}
