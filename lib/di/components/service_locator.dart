import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:guide_wizard/data/local/datasources/question/question_datasource.dart';
import 'package:guide_wizard/data/local/datasources/step/step_datasource.dart';
import 'package:guide_wizard/data/local/datasources/sub_task/sub_task_datasource.dart';
import 'package:guide_wizard/data/local/datasources/task/task_datasource.dart';
import 'package:guide_wizard/data/local/datasources/technical_name/technical_name_datasource.dart';
import 'package:guide_wizard/data/local/datasources/technical_name/technical_name_with_translations_datasource.dart';
import 'package:guide_wizard/data/local/datasources/updated_at_times/updated_at_times_datasource.dart';
import 'package:guide_wizard/data/network/apis/app_data/app_data_api.dart';
import 'package:guide_wizard/data/network/apis/tranlsation/translation_api.dart';
import 'package:guide_wizard/data/network/apis/updated_at_times/updated_at_times_api.dart';
import 'package:guide_wizard/data/network/dio_client.dart';
import 'package:guide_wizard/data/network/rest_client.dart';
import 'package:guide_wizard/data/repository.dart';
import 'package:guide_wizard/data/sharedpref/shared_preference_helper.dart';
import 'package:guide_wizard/di/module/local_module.dart';
import 'package:guide_wizard/di/module/network_module.dart';
import 'package:guide_wizard/stores/error/error_store.dart';
import 'package:guide_wizard/stores/form/form_store.dart';
import 'package:guide_wizard/stores/language/language_store.dart';
import 'package:guide_wizard/stores/theme/theme_store.dart';
import 'package:guide_wizard/stores/updated_at_times/updated_at_times_store.dart';
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
  getIt.registerSingleton(StepApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(TechnicalNameApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(UpdatedAtTimesApi(getIt<DioClient>(), getIt<RestClient>()));

  // data sources
  getIt.registerSingleton(StepDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(TaskDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(SubTaskDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(QuestionDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(TechnicalNameDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(TechnicalNameWithTranslationsDataSource(await getIt.getAsync<Database>()));
  getIt.registerSingleton(UpdatedAtTimesDataSource(await getIt.getAsync<Database>()));

  // repository:----------------------------------------------------------------
  getIt.registerSingleton(Repository(
    getIt<StepApi>(),
    getIt<UpdatedAtTimesApi>(),
    getIt<SharedPreferenceHelper>(),
    getIt<StepDataSource>(),
    getIt<TaskDataSource>(),
    getIt<SubTaskDataSource>(),
    getIt<QuestionDataSource>(),
    getIt<TechnicalNameApi>(),
    getIt<TechnicalNameWithTranslationsDataSource>(),
    getIt<UpdatedAtTimesDataSource>(),
  ));

  // stores:--------------------------------------------------------------------
  getIt.registerSingleton(LanguageStore(getIt<Repository>()));
  getIt.registerSingleton(ThemeStore(getIt<Repository>()));
  getIt.registerSingleton(UpdatedAtTimesStore(getIt<Repository>()));
}
