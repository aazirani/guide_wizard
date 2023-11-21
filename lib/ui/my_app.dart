import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:guide_wizard/constants/app_theme.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/strings.dart';
import 'package:guide_wizard/data/repository.dart';
import 'package:guide_wizard/di/components/service_locator.dart';
import 'package:guide_wizard/providers/internet_connection_state.dart';
import 'package:guide_wizard/providers/question_widget_state/question_widget_state.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/language/language_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/stores/theme/theme_store.dart';
import 'package:guide_wizard/stores/updated_at_times/updated_at_times_store.dart';
import 'package:guide_wizard/ui/home/home.dart';
import 'package:guide_wizard/utils/routes/routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final ThemeStore _themeStore = ThemeStore(getIt<Repository>());
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final DataStore _dataStore = DataStore(getIt<Repository>());
  final TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore = TechnicalNameWithTranslationsStore(getIt<Repository>());
  final UpdatedAtTimesStore _updatedAtTimesStore = UpdatedAtTimesStore(getIt<Repository>());
  final AppSettingsStore _appSettingsStore = AppSettingsStore(getIt<Repository>());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeStore>(create: (_) => _themeStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
        Provider<DataStore>(create: (_) => _dataStore),
        ListenableProvider<QuestionsWidgetState>(create: (_) => QuestionsWidgetState(activeIndex: 0)),
        ListenableProvider<InternetConnectionState>(create: (_) => InternetConnectionState()),
        Provider<TechnicalNameWithTranslationsStore>(create: (_) => _technicalNameWithTranslationsStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
        Provider<UpdatedAtTimesStore>(create: (_) => _updatedAtTimesStore),
        Provider<AppSettingsStore>(create: (_) => _appSettingsStore),
      ],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Determine the minimum dimension (width or height)
          double minDimension =
          constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

          _appSettingsStore.setMinDimension(minDimension);

          return Container(
            color: AppColors.grey200,
            child: Center(
              child: Container(
                constraints: kIsWeb
                    ? BoxConstraints(maxWidth: _appSettingsStore.currentMinDimension)
                    : null,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: Strings.appName,
                  theme: _themeStore.darkMode
                      ? AppThemeData.darkThemeData
                      : AppThemeData.lightThemeData,
                  routes: Routes.routes,
                  locale: Locale(_languageStore.locale),
                  localizationsDelegates: [
                    // Built-in localization of basic text for Material widgets
                    GlobalMaterialLocalizations.delegate,
                    // Built-in localization for text direction LTR/RTL
                    GlobalWidgetsLocalizations.delegate,
                    // Built-in localization of basic text for Cupertino widgets
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  home: HomeScreen(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
