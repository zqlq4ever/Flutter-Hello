import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dimens.dart';

/// 间隔
/// 官方做法：https://github.com/flutter/flutter/pull/54394
///
///
class Gaps {
  /// 水平间隔
  static const Widget hGap4 = SizedBox(width: Dimens.gap_dp4);
  static const Widget hGap5 = SizedBox(width: Dimens.gap_dp5);
  static const Widget hGap8 = SizedBox(width: Dimens.gap_dp8);
  static const Widget hGap10 = SizedBox(width: Dimens.gap_dp10);
  static const Widget hGap12 = SizedBox(width: Dimens.gap_dp12);
  static const Widget hGap15 = SizedBox(width: Dimens.gap_dp15);
  static const Widget hGap16 = SizedBox(width: Dimens.gap_dp16);
  static const Widget hGap18 = SizedBox(width: Dimens.gap_dp18);
  static const Widget hGap20 = SizedBox(width: Dimens.gap_dp20);
  static const Widget hGap24 = SizedBox(width: Dimens.gap_dp24);
  static const Widget hGap32 = SizedBox(width: Dimens.gap_dp32);
  static const Widget hGap36 = SizedBox(width: Dimens.gap_dp36);

  /// 垂直间隔
  static const Widget vGap1 = SizedBox(height: Dimens.gap_dp1);
  static const Widget vGap4 = SizedBox(height: Dimens.gap_dp4);
  static const Widget vGap5 = SizedBox(height: Dimens.gap_dp5);
  static const Widget vGap8 = SizedBox(height: Dimens.gap_dp8);
  static const Widget vGap10 = SizedBox(height: Dimens.gap_dp10);
  static const Widget vGap12 = SizedBox(height: Dimens.gap_dp12);
  static const Widget vGap15 = SizedBox(height: Dimens.gap_dp15);
  static const Widget vGap16 = SizedBox(height: Dimens.gap_dp16);
  static const Widget vGap24 = SizedBox(height: Dimens.gap_dp24);
  static const Widget vGap32 = SizedBox(height: Dimens.gap_dp32);
  static const Widget vGap40 = SizedBox(height: Dimens.gap_dp40);
  static const Widget vGap50 = SizedBox(height: Dimens.gap_dp50);

  static const Widget line = SizedBox(height: Dimens.gap_dp1);

  static const Widget line_0_5 = SizedBox(height: 0.5);

  static const Widget vLine = vGap1;

  static const Widget empty = SizedBox.shrink();

  /// 补充一种空Widget实现 https://github.com/letsar/nil
  /// https://github.com/flutter/flutter/issues/78159
}
