// threadMode.dart
class ThreatModel {
  final String? indicator;
  final String? type;
  final String? risk;
  final String? riskLevel;
  final String? stampSeen;
  final String? stampUpdated;
  final String? stampAdded;
  final String? description;
  final String? wikisummary;
  final String? threat;
  final String? category;
  final List<String>? othernames;

  ThreatModel({
    this.indicator,
    this.type,
    this.risk,
    this.riskLevel,
    this.stampSeen,
    this.stampUpdated,
    this.stampAdded,
    this.description,
    this.threat,
    this.category,
    this.othernames,
    this.wikisummary,
  });

  factory ThreatModel.fromJson(Map<String, dynamic> json) {
    return ThreatModel(
      indicator: json['indicator'],
      type: json['type'],
      risk: json['risk'],
      riskLevel: json['risk_level'],
      stampSeen: json['stamp_seen'],
      stampUpdated: json['stamp_updated'],
      stampAdded: json['stamp_added'],
      description: json['description'],
      wikisummary: json['wikisummary'],
      threat: json['threat'],
      category: json['category'],
      othernames: json['othernames'] != null
          ? List<String>.from(json['othernames'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'indicator': indicator,
      'type': type,
      'risk': risk,
      'risk_level': riskLevel,
      'stamp_seen': stampSeen,
      'stamp_updated': stampUpdated,
      'stamp_added': stampAdded,
      'description': description,
      'threat': threat,
      'category': category,
      'othernames': othernames,
      'wikisummary': wikisummary,
    };
  }
}

// Basic threat info (from explore endpoint)
class BasicThreat {
  final int tid;
  final String threat;
  final String? category;
  final String? risk;

  BasicThreat({
    required this.tid,
    required this.threat,
    this.category,
    this.risk,
  });

  factory BasicThreat.fromJson(Map<String, dynamic> json) {
    return BasicThreat(
      tid: json['tid'],
      threat: json['threat'],
      category: json['category'],
      risk: json['risk'],
    );
  }
}

// Detailed threat info (from info endpoint)
class DetailedThreat {
  final int tid;
  final String threat;
  final String? category;
  final String? risk;
  final String? description;
  final String? notes;
  final String? wikisummary;
  final List<String>? othernames;
  final String? stampUpdated;

  DetailedThreat({
    required this.tid,
    required this.threat,
    this.category,
    this.risk,
    this.description,
    this.notes,
    this.wikisummary,
    this.othernames,
    this.stampUpdated,
  });

  factory DetailedThreat.fromJson(Map<String, dynamic> json) {
    return DetailedThreat(
      tid: json['tid'],
      threat: json['threat'],
      category: json['category'],
      risk: json['risk'],
      description: json['description'],
      notes: json['notes'],
      wikisummary: json['wikisummary'],
      othernames: json['othernames'] != null
          ? List<String>.from(json['othernames'])
          : null,
      stampUpdated: json['stamp_updated'],
    );
  }
}
