// threat_model.dart
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
  final List<NewsItem>? news;

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
    this.news,
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
      news: json['news'] != null
          ? (json['news'] as List)
              .map((item) => NewsItem.fromJson(item))
              .toList()
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
      'news': news?.map((item) => item.toJson()).toList(),
    };
  }

  // Helper method to get the latest 4 news items sorted by timestamp
  List<NewsItem> getLatestNews() {
    if (news == null || news!.isEmpty) return [];
    
    // Sort by timestamp in descending order (newest first)
    List<NewsItem> sortedNews = List.from(news!);
    sortedNews.sort((a, b) => b.stamp.compareTo(a.stamp));
    
    // Return only the latest 4
    return sortedNews.take(4).toList();
  }
}

// News item model
class NewsItem {
  final String title;
  final String channel;
  final String icon;
  final String link;
  final String stamp;
  final int primary;

  NewsItem({
    required this.title,
    required this.channel,
    required this.icon,
    required this.link,
    required this.stamp,
    required this.primary,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      channel: json['channel'] ?? '',
      icon: json['icon'] ?? '',
      link: json['link'] ?? '',
      stamp: json['stamp'] ?? '',
      primary: json['primary'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'channel': channel,
      'icon': icon,
      'link': link,
      'stamp': stamp,
      'primary': primary,
    };
  }
}

// Search result model for search functionality
class SearchResult {
  final int id;
  final String indicator;
  final String type;
  final String riskLevel;

  SearchResult({
    required this.id,
    required this.indicator,
    required this.type,
    required this.riskLevel,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] ?? 0,
      indicator: json['indicator'] ?? '',
      type: json['type'] ?? '',
      riskLevel: json['risk_level'] ?? 'low',
    );
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