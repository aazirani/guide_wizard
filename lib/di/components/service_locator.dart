import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/local/datasources/step/step_datasource.dart';
import 'package:boilerplate/data/local/datasources/question/question_datasource.dart';
import 'package:boilerplate/data/local/datasources/task/task_datasource.dart';
import 'package:boilerplate/data/local/datasources/sub_task/sub_task_datasource.dart';
import 'package:boilerplate/data/local/datasources/technical_name/technical_name_datasource.dart';
import 'package:boilerplate/data/local/datasources/technical_name/technical_name_with_translations_datasource.dart';
import 'package:boilerplate/data/local/datasources/updated_at_times/updated_at_times_datasource.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/network/apis/app_data/app_data_api.dart';
import 'package:boilerplate/data/network/apis/tranlsation/translation_api.dart';
import 'package:boilerplate/data/network/apis/updated_at_times/updated_at_times_api.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/di/module/local_module.dart';
import 'package:boilerplate/di/module/network_module.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/updated_at_times/updated_at_times_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';


final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // factories:-----------------------------------------------------------------
  getIt.registerFactory(() => ErrorStore());
  getIt.registerFactory(() => FormStore());

  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<Database>(() => LocalModule.provideDatabase());
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(
      NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(RestClient());

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(PostApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(StepApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(TechnicalNameApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(UpdatedAtTimesApi(getIt<DioClient>(), getIt<RestClient>()));

  // data sources
  getIt.registerSingleton(PostDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(StepDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(TaskDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(SubTaskDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(QuestionDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(TechnicalNameDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(TechnicalNameWithTranslationsDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(UpdatedAtTimesDataSource(await getIt.getAsync<Database>()));

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(Repository(
    getIt<PostApi>(),
    getIt<StepApi>(),
    getIt<UpdatedAtTimesApi>(),
    getIt<SharedPreferenceHelper>(),
    getIt<PostDataSource>(),
    getIt<StepDataSource>(),
    getIt<TaskDataSource>(),
    getIt<SubTaskDataSource>(),
    getIt<QuestionDataSource>(),
    getIt<TechnicalNameApi>(),
    getIt<TechnicalNameDataSource>(),
    getIt<TechnicalNameWithTranslationsDataSource>(),
    getIt<UpdatedAtTimesDataSource>(),
  ));

  // stores:--------------------------------------------------------------------
  getIt.registerSingleton(LanguageStore(getIt<Repository>()));
  getIt.registerSingleton(PostStore(getIt<Repository>()));
  getIt.registerSingleton(ThemeStore(getIt<Repository>()));
  getIt.registerSingleton(UserStore(getIt<Repository>()));
  getIt.registerSingleton(UpdatedAtTimesStore(getIt<Repository>()));
}
