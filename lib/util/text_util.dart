/// 文本工具类
/// 替代 flustars 的 TextUtil
class TextUtil {
  /// 判断字符串是否为空
  static bool isEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  /// 判断字符串是否不为空
  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }

  /// 判断字符串是否为空白字符
  static bool isBlank(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// 判断字符串是否不为空白字符
  static bool isNotBlank(String? str) {
    return !isBlank(str);
  }

  /// 隐藏手机号中间四位
  static String hideNumber(String? phone) {
    if (isEmpty(phone) || phone!.length < 7) {
      return phone ?? '';
    }
    return phone.replaceRange(3, 7, '****');
  }

  /// 格式化银行卡号（每4位加空格）
  static String formatBankCard(String? cardNo) {
    if (isEmpty(cardNo)) {
      return '';
    }
    final String card = cardNo!.replaceAll(' ', '');
    final StringBuffer result = StringBuffer();
    for (int i = 0; i < card.length; i++) {
      if (i > 0 && i % 4 == 0) {
        result.write(' ');
      }
      result.write(card[i]);
    }
    return result.toString();
  }

  /// 隐藏银行卡号（只显示后四位）
  static String hideBankCard(String? cardNo) {
    if (isEmpty(cardNo) || cardNo!.length < 4) {
      return cardNo ?? '';
    }
    return '**** **** **** ${cardNo.substring(cardNo.length - 4)}';
  }

  /// 将字符串转换为安全字符串（处理 null）
  static String safeString(String? str, {String defaultValue = ''}) {
    return str ?? defaultValue;
  }

  /// 截取字符串（支持中文）
  static String substring(String? str, int start, int end) {
    if (isEmpty(str)) {
      return '';
    }
    final int len = str!.length;
    if (start < 0) start = 0;
    if (end > len) end = len;
    if (start >= end) return '';
    return str.substring(start, end);
  }
}
