import 'dart:math';

extension DoubleExtension on double {
  double roundFixed(int decimalPlaces) {
    final mod = pow(10, decimalPlaces);
    return (this * mod).roundToDouble() / mod;
  }
}

typedef KeyExtractor<T> = Comparable Function(T);

/// Extension of [List] providing useful additions
extension ListExtension<Type> on List<Type> {
  /// Works like [List.map] but also gives the index of each element
  List<T> mapWithIndex<T>(T Function(int i, Type e) f) {
    return List.generate(length, (index) => f(index, this[index]));
  }

  void sortByKey(KeyExtractor<Type> f, [bool ascending = true]) {
    if (ascending) {
      sort((a, b) => f(a).compareTo(f(b)));
    } else {
      sort((a, b) => f(b).compareTo(f(a)));
    }
  }

  List<(Type, B)> zip<B>(List<B> other) =>
      [for (int i = 0; i < min(length, other.length); i++) (this[i], other[i])];
}