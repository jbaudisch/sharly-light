import 'package:freezed_annotation/freezed_annotation.dart';

/// Enum representing the different possible activity index ratings.
@JsonEnum(valueField: "title")
enum ActivityIndex {
  sad("\u{1F641}", "SAD"),
  neutral("\u{1F610}", "NEUTRAL"),
  happy("\u{1F603}", "HAPPY"),
  veryHappy("\u{1F601}", "VERY_HAPPY"),
  undefined("", "UNDEFINED");

  const ActivityIndex(this.emoji, this.title);

  /// A [String] containing an emoji resembling the rating.
  final String emoji;

  /// The title of the rating.
  final String title;

  /// Constructs an [ActivityIndex] from [value]
  factory ActivityIndex.fromValue(String value) => switch (value) {
    "SAD" => ActivityIndex.sad,
    "NEUTRAL" => ActivityIndex.neutral,
    "HAPPY" => ActivityIndex.happy,
    "VERY_HAPPY" => ActivityIndex.veryHappy,
    _ => ActivityIndex.undefined
  };
}