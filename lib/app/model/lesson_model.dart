import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/app/model/threat_model.dart';

class LessonModel {
  final String? id;
  final String title;
  final String summary;
  final String content;
  final String threatType;
  final String riskLevel;
  final String difficulty;
  final List<String> keyPoints;
  final List<String> preventionSteps;
  final List<String> detectionMethods;
  final List<String> tags;
  final String threatId; // Added threatId field
  final DateTime createdAt;
  final DateTime updatedAt;

  LessonModel({
    this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.threatType,
    required this.riskLevel,
    required this.difficulty,
    required this.keyPoints,
    required this.preventionSteps,
    required this.detectionMethods,
    required this.tags,
    required this.threatId, // Added threatId parameter
    required this.createdAt,
    required this.updatedAt,
    //  required List<NewsItem> news,
  });

  // Factory constructor from Firestore
  factory LessonModel.fromFirestore(String id, Map<String, dynamic> data) {
    return LessonModel(
      id: id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      content: data['content'] ?? '',
      threatType: data['threatType'] ?? '',
      riskLevel: data['riskLevel'] ?? '',
      difficulty: data['difficulty'] ?? '',
      keyPoints: List<String>.from(data['keyPoints'] ?? []),
      preventionSteps: List<String>.from(data['preventionSteps'] ?? []),
      detectionMethods: List<String>.from(data['detectionMethods'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      threatId: data['threatId'] ?? '', // Added threatId from Firestore
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(), 
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'summary': summary,
      'content': content,
      'threatType': threatType,
      'riskLevel': riskLevel,
      'difficulty': difficulty,
      'keyPoints': keyPoints,
      'preventionSteps': preventionSteps,
      'detectionMethods': detectionMethods,
      'tags': tags,
      'threatId': threatId, // Added threatId to Firestore
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // CopyWith method for updating fields
  LessonModel copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? threatType,
    String? riskLevel,
    String? difficulty,
    List<String>? keyPoints,
    List<String>? preventionSteps,
    List<String>? detectionMethods,
    List<String>? tags,
    String? threatId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      threatType: threatType ?? this.threatType,
      riskLevel: riskLevel ?? this.riskLevel,
      difficulty: difficulty ?? this.difficulty,
      keyPoints: keyPoints ?? this.keyPoints,
      preventionSteps: preventionSteps ?? this.preventionSteps,
      detectionMethods: detectionMethods ?? this.detectionMethods,
      tags: tags ?? this.tags,
      threatId: threatId ?? this.threatId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'LessonModel(id: $id, title: $title, threatId: $threatId, threatType: $threatType, riskLevel: $riskLevel, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonModel &&
        other.id == id &&
        other.title == title &&
        other.threatId == threatId &&
        other.threatType == threatType &&
        other.riskLevel == riskLevel &&
        other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        threatId.hashCode ^
        threatType.hashCode ^
        riskLevel.hashCode ^
        difficulty.hashCode;
  }
}