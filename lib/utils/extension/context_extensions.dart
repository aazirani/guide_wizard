import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get primaryContainerColor => Theme.of(this).colorScheme.primaryContainer;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get lightBackgroundColor => Theme.of(this).colorScheme.background;
  Color get textOnLightBackgroundColor => Theme.of(this).colorScheme.onBackground;
  Color get textOnDarkBackgroundColor => Theme.of(this).colorScheme.onPrimary;
  Color get secondaryContainerColor => Theme.of(this).colorScheme.secondaryContainer;
  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
  Color get onSecondaryColor => Theme.of(this).colorScheme.onSecondary;
  Color get deadlineColor => Theme.of(this).colorScheme.tertiary;
  Color get deadlineContainerColor => Theme.of(this).colorScheme.tertiaryContainer;
  Color get containerColor => Theme.of(this).colorScheme.surface;
  Color get tileColor => Theme.of(this).colorScheme.surfaceTint;
  Color get shadowColor => Theme.of(this).shadowColor;
  Color get transparent => Theme.of(this).highlightColor;
  Color get shimmerBaseColor => Theme.of(this).colorScheme.errorContainer;
  Color get shimmerHeighlightColor => Theme.of(this).colorScheme.onErrorContainer;
  Color get errorColor => Theme.of(this).colorScheme.error;

}
