import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Reduces the amount of code that needs to be written to access a
/// String from the localization files.
AppLocalizations s(BuildContext context) {
  return AppLocalizations.of(context)!;
}

Future<AppLocalizations> sFromLocale(Locale locale) {
  return AppLocalizations.delegate.load(locale);
}
