import 'package:flutter/material.dart';

/// 日期处理工具
class DateUtil {
  DateUtil._();

  /// 返回诸如: 1天前，3分钟前，1个月前...; 1分钟后，2个月后，3天后... 等文字代词。
  /// [showDate] 为 [true]是则显示[年/月/日 时:分]
  static String textPronoun({
    DateTime? dateTime,
    bool showDate = false,
  }) {
    dateTime = dateTime ?? DateTime.now();

    if (showDate) {
      var fDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      var diff = fDate.difference(DateTime.now());
      // 一天内，则显示昨天，明天；当天，则显示时间
      if (diff.inDays == -1) {
        return "昨天";
      } else if (diff.inDays == 1) {
        return "明天";
      } else if (diff.inDays == 0) {
        return dateToString(dateTime: dateTime, formattedString: "HH:mm");
      }

      // 超过一年，则显示日期，之所以等于1是因为本年初为1月1日。
      var diffYear = DateTime(DateTime.now().year, 1, 1);
      if (diffYear.difference(fDate).inDays == 1) return dateToString(dateTime: dateTime, formattedString: "yyyy/MM/dd");

      // 否则显示月份
      return dateToString(dateTime: dateTime, formattedString: "MM/dd HH:mm");
    }

    var time = dateTime.difference(DateTime.now());
    if (time.inDays != 0) {
      return _withPronoun(time.inDays, "天");
    } else if (time.inHours != 0) {
      return _withPronoun(time.inHours, "小时");
    } else if (time.inMinutes != 0) {
      return _withPronoun(time.inMinutes, "分钟");
    } else if (time.inSeconds != 0) {
      return _withPronoun(time.inSeconds, "秒");
    } else {
      return "现在";
    }
  }

  static String _withPronoun(int num, String pronoun) {
    return num < 0 ? "${-num}$pronoun前" : "$num$pronoun后";
  }

  /// 日期时间型字符串 转 日期时间型
  static DateTime? tryParse(String formattedString) {
    // 如果出现 +8:00 则表示北京时间
    if (formattedString.contains('+08:00')) {
      return DateTime.tryParse(formattedString)?.add(const Duration(hours: 8));
    }
    return DateTime.tryParse(formattedString);
  }

  /// 日期时间型字符串 转 日期时间型
  static DateTime parse(String formattedString) {
    // 如果出现 +8:00 则表示北京时间
    if (formattedString.contains('+08:00')) {
      return DateTime.parse(formattedString).add(const Duration(hours: 8));
    }
    return DateTime.parse(formattedString);
  }

  /// 自定义解析格式
  /// yy    代表年份后2位
  /// yyyy  代表4位年份
  /// MM    代表2位月份，不足2位用前置0补充
  /// dd    代表2位天数，不足2位用前置0补充
  /// HH    代表2位小时，不足2位用前置0补充
  /// mm    代表2位分钟，不足2位用前置0补充
  /// ss    代表2位秒，不足2位用前置0补充
  /// 其他字符则保持原样输出
  static String dateToString({DateTime? dateTime, String? formattedString}) {
    dateTime = dateTime ?? DateTime.now();
    var strDate = formattedString ?? "yyyy-MM-dd HH:mm:ss";
    final dates = {
      'yyyy': dateTime.year,
      'yy': dateTime.year % 100,
      'MM': dateTime.month,
      'dd': dateTime.day,
      'HH': dateTime.hour,
      'mm': dateTime.minute,
      'ss': dateTime.second,
    };
    final regex = RegExp(r"(yyyy|yy)|(MM)|(dd)|(HH)|(mm)|(ss)");
    final formats = regex.allMatches(strDate);
    for (var e in formats) {
      var key = e.group(0);
      strDate = strDate.replaceRange(e.start, e.end, "${dates[key]}".padLeft(2, "0"));
    }
    return strDate;
  }
}
