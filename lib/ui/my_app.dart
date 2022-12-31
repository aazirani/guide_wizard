import 'package:boilerplate/constants/app_theme.dart';
import 'package:boilerplate/constants/strings.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/post/post_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/tasklist/tasklist.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/ui/blocks/block_page_with_image.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/technical_name/technical_name.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final ThemeStore _themeStore = ThemeStore(getIt<Repository>());
  final PostStore _postStore = PostStore(getIt<Repository>());
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final UserStore _userStore = UserStore(getIt<Repository>());
  final StepStore _stepStore = StepStore();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeStore>(create: (_) => _themeStore),
        Provider<PostStore>(create: (_) => _postStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
        Provider<StepStore>(create: (_) => _stepStore),
      ],
      child: Observer(
        name: 'global-observer',
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: _themeStore.darkMode
                ? AppThemeData.darkThemeData
                : AppThemeData.lightThemeData,
            routes: Routes.routes,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale!, language.code))
                .toList(),
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate,
            ],
            home: BlockPageWithImage(
              task: Task(
                  id: 0,
                  text: TechnicalName(
                      id: 0,
                      technical_name: "AppBar Title",
                      creator_id: 0,
                      created_at: '',
                      updated_at: ''),
                  description: TechnicalName(
                      id: 0,
                      technical_name: "test",
                      creator_id: 0,
                      created_at: '',
                      updated_at: ''),
                  type: 'IMAGE',
                  image1:
                      'https://www.uni-hannover.de/fileadmin/_processed_/6/d/csm_Kuhlmann_HR_Koeln_2ea4756eee.jpg?1672519968312',
                  image2:
                      'https://www.uni-hannover.de/fileadmin/_processed_/d/3/csm_daadpreistraeger_e341ba2401.jpg',
                  fa_icon: '',
                  sub_tasks: [
                    for (int i = 0; i < 10; i++)
                      SubTask(
                          id: 0,
                          task_id: 0,
                          title: TechnicalName(
                              id: 0,
                              technical_name: "test",
                              creator_id: 0,
                              created_at: '',
                              updated_at: ''),
                          markdown: TechnicalName(
                              id: 0,
                              technical_name: "test",
                              creator_id: 0,
                              created_at: '',
                              updated_at: ''),
                          deadline: TechnicalName(
                              id: 0,
                              technical_name: "test",
                              creator_id: 0,
                              created_at: '',
                              updated_at: ''),
                          order: 1,
                          creator_id: '0',
                          created_at: '',
                          updated_at: ''),
                  ],
                  creator_id: '',
                  created_at: '',
                  updated_at: '',
                  quesions: []),
            ),
          );
        },
      ),
    );
  }
}
