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
  Color get deadlineContainerColor => Theme.of(this).colorScheme.tertiaryContainer.withOpacity(0.1);
  Color get containerColor => Theme.of(this).colorScheme.surface;
  Color get tileColor => Theme.of(this).colorScheme.surfaceTint;
  Color get shadowColor => Theme.of(this).shadowColor;
  Color get transparent => Theme.of(this).highlightColor;
  Color get shimmerBaseColor => Theme.of(this).colorScheme.errorContainer;
  Color get shimmerHeighlightColor => Theme.of(this).colorScheme.onErrorContainer;
  Color get errorColor => Theme.of(this).colorScheme.error;
  
  Color get openButtonOverlayColor => primaryColor.withOpacity(0.13);
  Color get closeButtonOverlayColor => shadowColor.withOpacity(0.1);
  Color get doneBadgeColor => secondaryColor.withOpacity(0.3);
  Color get deadlineBadgeColor => deadlineContainerColor.withOpacity(0.8);
  Color get blockQuoteColor => primaryContainerColor.withOpacity(0.2);
  Color get dotColor => lightBackgroundColor.withOpacity(0.7);
  Color get doneStepColor => secondaryColor.withOpacity(0.20);
  Color get unDoneStepColor => secondaryContainerColor.withOpacity(0.10);
  Color get doneButtonColor => lightBackgroundColor.withOpacity(0.1);
  Color get continueButtonColor => lightBackgroundColor.withOpacity(0.5);
  Color get continueOverlayColor => secondaryContainerColor.withOpacity(0.3);
}
