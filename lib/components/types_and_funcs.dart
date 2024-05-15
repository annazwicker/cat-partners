
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Json = Map<String, dynamic>;

extension DateTimeExtension on DateTime {

  /// Returns a [DateTime] with the same date as this, but with hours, minutes 
  /// and seconds set to zero.
  DateTime equalize() {
    return DateTime(year, month, day);
  }

  /// Returns a [DateTime] of the current date and timezone, but with hours, 
  /// minutes and seconds set to zero.
  static DateTime today() {
    return DateTime.now().equalize();
  }
}

extension TimestampExtension on Timestamp {

  /// Returns a [Timestamp] with the same date as this, but with hours, minutes 
  /// and seconds set to zero.
  Timestamp equalize() {
    return Timestamp.fromDate(toDate().equalize());
  }

  /// Returns a [Timestamp] of the current date and timezone, but with hours, 
  /// minutes and seconds set to zero.
  static Timestamp today() {
    return Timestamp.now().equalize();
  }
}