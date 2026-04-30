// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Hello Flutter';

  @override
  String get actionClose => '关闭';

  @override
  String get actionSearch => '搜索';

  @override
  String get actionClear => '清空';

  @override
  String get actionBack => '返回';

  @override
  String get scannerTitle => '扫码';

  @override
  String get scannerHint => '将二维码放入框内，自动识别';

  @override
  String get scannerTorch => '手电';

  @override
  String get contactTabTitle => '通讯';

  @override
  String get contactListTitle => '通讯录';
}
