// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hello Flutter';

  @override
  String get actionClose => 'Close';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionBack => 'Back';

  @override
  String get scannerTitle => 'Scan';

  @override
  String get scannerHint => 'Align the QR code within the frame';

  @override
  String get scannerTorch => 'Torch';

  @override
  String get contactTabTitle => 'Contacts';

  @override
  String get contactListTitle => 'Contacts';
}
