import 'dart:math' as math;

class MathUtil {
  const MathUtil._();

  /// 角度转弧度
  static double angleToRadian(double angle) {
    return (math.pi / 180) * angle;
  }

  /// 弧度转角度
  static double radianToAngle(double radian) {
    return (180 / math.pi) * radian;
  }

  /// 随机数
  static int randInt([int max = 10]) {
    return math.Random().nextInt(max);
  }
}
