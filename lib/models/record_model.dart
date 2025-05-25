import 'dart:math';

import 'package:flutter/material.dart';

class RecordModel {
  final int? id;
  final int? categoryId;
  final String recordName;
  final String recordPath;
  final Color color;
  Duration? duration;

  RecordModel({
    this.id,
    required this.recordName,
    required this.categoryId,
    required this.recordPath,
    this.color = Colors.white,
    this.duration,
  });

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      recordName: map['record_name'] as String,
      recordPath: map['record_path'] as String,
      color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
    );
  }
}
