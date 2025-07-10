import 'package:project/app/model/threat_model.dart';

class LessonModel {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String threatType;
  final String riskLevel;
  final String sourceIndicator;
  final int sourceThreatId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> keyPoints;
  final List<String> preventionSteps;
  final List<String> detectionMethods;
  final String difficulty; // beginner, intermediate, advanced
  final List<String> tags;

  LessonModel({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.threatType,
    required this.riskLevel,
    required this.sourceIndicator,
    required this.sourceThreatId,
    required this.createdAt,
    required this.updatedAt,
    required this.keyPoints,
    required this.preventionSteps,
    required this.detectionMethods,
    required this.difficulty,
    required this.tags, required List<NewsItem> news,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      threatType: json['threatType'] ?? '',
      riskLevel: json['riskLevel'] ?? '',
      sourceIndicator: json['sourceIndicator'] ?? '',
      sourceThreatId: json['sourceThreatId'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      keyPoints: List<String>.from(json['keyPoints'] ?? []),
      preventionSteps: List<String>.from(json['preventionSteps'] ?? []),
      detectionMethods: List<String>.from(json['detectionMethods'] ?? []),
      difficulty: json['difficulty'] ?? 'beginner',
      tags: List<String>.from(json['tags'] ?? []), news: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'threatType': threatType,
      'riskLevel': riskLevel,
      'sourceIndicator': sourceIndicator,
      'sourceThreatId': sourceThreatId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'keyPoints': keyPoints,
      'preventionSteps': preventionSteps,
      'detectionMethods': detectionMethods,
      'difficulty': difficulty,
      'tags': tags,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'summary': summary,
      'threatType': threatType,
      'riskLevel': riskLevel,
      'sourceIndicator': sourceIndicator,
      'sourceThreatId': sourceThreatId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'keyPoints': keyPoints,
      'preventionSteps': preventionSteps,
      'detectionMethods': detectionMethods,
      'difficulty': difficulty,
      'tags': tags,
    };
  }

  factory LessonModel.fromFirestore(String documentId, Map<String, dynamic> data) {
    return LessonModel(
      id: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      summary: data['summary'] ?? '',
      threatType: data['threatType'] ?? '',
      riskLevel: data['riskLevel'] ?? '',
      sourceIndicator: data['sourceIndicator'] ?? '',
      sourceThreatId: data['sourceThreatId'] ?? 0,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      keyPoints: List<String>.from(data['keyPoints'] ?? []),
      preventionSteps: List<String>.from(data['preventionSteps'] ?? []),
      detectionMethods: List<String>.from(data['detectionMethods'] ?? []),
      difficulty: data['difficulty'] ?? 'beginner',
      tags: List<String>.from(data['tags'] ?? []), news: [],
    );
  }

  // Create a copy with updated fields
  LessonModel copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? threatType,
    String? riskLevel,
    String? sourceIndicator,
    int? sourceThreatId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? keyPoints,
    List<String>? preventionSteps,
    List<String>? detectionMethods,
    String? difficulty,
    List<String>? tags,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      threatType: threatType ?? this.threatType,
      riskLevel: riskLevel ?? this.riskLevel,
      sourceIndicator: sourceIndicator ?? this.sourceIndicator,
      sourceThreatId: sourceThreatId ?? this.sourceThreatId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      keyPoints: keyPoints ?? this.keyPoints,
      preventionSteps: preventionSteps ?? this.preventionSteps,
      detectionMethods: detectionMethods ?? this.detectionMethods,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags, news: [],
    );
  }
}