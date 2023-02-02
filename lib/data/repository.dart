import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/local/datasources/translation/translation_datasource.dart';
import 'package:boilerplate/data/local/datasources/translation/translations_with_step_name_datasource.dart';
import 'package:boilerplate/data/network/apis/tranlsation/translation_api.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/translation/translation.dart';
import 'package:boilerplate/models/translation/translation_list.dart';
import 'package:boilerplate/models/translation/translations_with_step_name.dart';
import 'package:boilerplate/models/translation/translations_with_step_name_list.dart';
import 'package:sembast/sembast.dart';

import 'local/constants/db_constants.dart';
import 'network/apis/posts/post_api.dart';

class Repository {
  // data source object
  final PostDataSource _postDataSource;
  final TranslationDataSource _translationDataSource;
  final TranslationsWithStepNameDataSource _translationsWithStepNameDataSource;

  // api objects
  final PostApi _postApi;
  final TranslationApi _translationApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(this._postApi, this._sharedPrefsHelper, this._postDataSource, this._translationApi, this._translationDataSource, this._translationsWithStepNameDataSource);

  // Post: ---------------------------------------------------------------------
  Future<PostList> getPosts() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getPosts().then((postsList) {
      postsList.posts?.forEach((post) {
        _postDataSource.insert(post);
      });

      return postsList;
    }).catchError((error) => throw error);
  }

  Future<List<Post>> findPostById(int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _postDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future<int> insert(Post post) => _postDataSource
      .insert(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> update(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> delete(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);


//   // Translation: ---------------------------------------------------------------------
//   Future<TranslationList> getTranslations() async {
//     // check to see if posts are present in database, then fetch from database
//     // else make a network call to get all posts, store them into database for
//     // later use
//     return await _translationApi.getTranslations().then((translationsList) {
//       translationsList.translations?.forEach((translation) {
//         _translationDataSource.insert(translation);
//       });
//
//       return translationsList;
//     }).catchError((error) => throw error);
//   }
//
//   Future<List<Translation>> findTranslationById(int id) {
//     //creating filter
//     List<Filter> filters = [];
//
//     //check to see if dataLogsType is not null
//     Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
//     filters.add(dataLogTypeFilter);
//
//     //making db call
//     return _translationDataSource
//         .getAllSortedByFilter(filters: filters)
//         .then((translations) => translations)
//         .catchError((error) => throw error);
//   }
//
//   Future<int?> insertTranslation(Translation translation) => _translationDataSource
//       .insert(translation)
//       .then((id) => id)
//       .catchError((error) => throw error);
//
//   Future<int> updateTranslation(Translation translation) => _translationDataSource
//       .update(translation)
//       .then((id) => id)
//       .catchError((error) => throw error);
//
//   Future<int> deleteTranslation(Translation translation) => _translationDataSource
//       .update(translation)
//       .then((id) => id)
//       .catchError((error) => throw error);
//
//   // Login:---------------------------------------------------------------------
//   Future<bool> login(String email, String password) async {
//     return await Future.delayed(Duration(seconds: 2), ()=> true);
//   }
//
//   Future<void> saveIsLoggedIn(bool value) =>
//       _sharedPrefsHelper.saveIsLoggedIn(value);
//
//   Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;
//
//   // Theme: --------------------------------------------------------------------
//   Future<void> changeBrightnessToDark(bool value) =>
//       _sharedPrefsHelper.changeBrightnessToDark(value);
//
//   bool get isDarkMode => _sharedPrefsHelper.isDarkMode;
//
//   // Language: -----------------------------------------------------------------
//   Future<void> changeLanguage(String value) =>
//       _sharedPrefsHelper.changeLanguage(value);
//
//   String? get currentLanguage => _sharedPrefsHelper.currentLanguage;
// }

  // TranslationsWithTechnicalName: ---------------------------------------------------------------------
  Future<TranslationsWithStepNameList> getTranslationsWithTechnicalName() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _translationApi.getTranslationsWithStepName().then((t) {
      t.translationsWithStepName?.forEach((translation) {
        _translationsWithStepNameDataSource.insert(translation);
      });

      return t;
    }).catchError((error) => throw error);
  }

  Future<List<Translation>> findTranslationWithStepNameById(int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _translationsWithStepNameDataSource
        .getAllSortedByFilter(filters: filters)
        .then((translations) => translations)
        .catchError((error) => throw error);
  }

  Future<int?> insertTranslationWithStepName(TranslationsWithStepName translation) => _translationsWithStepNameDataSource
      .insert(translation)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateTranslationWithStepName(TranslationsWithStepName translation) => _translationsWithStepNameDataSource
      .update(translation)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteTranslationWithStepName(TranslationsWithStepName translation) => _translationsWithStepNameDataSource
      .update(translation)
      .then((id) => id)
      .catchError((error) => throw error);

  // Login:---------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    return await Future.delayed(Duration(seconds: 2), ()=> true);
  }

  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPrefsHelper.currentLanguage;
}