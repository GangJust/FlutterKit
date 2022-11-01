import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class OtherUtil {
  const OtherUtil._();

  /// 抛出一个异常
  static void throwException(String msg) {
    throw Exception(msg);
  }

  /// 将一个 二进制流 转 Uint8List
  static decode(data){
    final List<List<int>> chunks = <List<int>>[];
    chunks.add(data);
    final Uint8List bytes = Uint8List(data.length);
    int offset = 0;
    for (List<int> chunk in chunks) {
      bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return bytes;
  }


  /// 全局context
  static BuildContext? context;
}
