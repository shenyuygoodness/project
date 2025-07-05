class ThreatModel {
  int? count;
  String? next;
  String? previous;
  List<ThreatResult>? results;

  ThreatModel({this.count, this.next, this.previous, this.results});

  ThreatModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ThreatResult>[];
      json['results'].forEach((v) {
        results!.add(ThreatResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ThreatResult {
  int? tid;
  String? threat;
  String? category;
  List<String>? othernames;
  String? risk;
  String? description;
  String? notes;
  String? wikisummary;
  String? wikireference;
  String? retired;
  String? stampAdded;
  String? stampUpdated;
  String? stampSeen;
  String? stampRetired;
  String? updatedLastDomain;
  List<dynamic>? related;
  Map<String, List<String>>? attributes;
  List<dynamic>? ttps;
  List<Map<String, dynamic>>? news;
  List<Map<String, dynamic>>? comments;
  Map<String, dynamic>? summary;

  ThreatResult({
    this.tid,
    this.threat,
    this.category,
    this.othernames,
    this.risk,
    this.description,
    this.notes,
    this.wikisummary,
    this.wikireference,
    this.retired,
    this.stampAdded,
    this.stampUpdated,
    this.stampSeen,
    this.stampRetired,
    this.updatedLastDomain,
    this.related,
    this.attributes,
    this.ttps,
    this.news,
    this.comments,
    this.summary,
  });

  ThreatResult.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    threat = json['threat'];
    category = json['category'];
    othernames = json['othernames'] != null ? List<String>.from(json['othernames']) : [];
    risk = json['risk'];
    description = json['description'];
    notes = json['notes'];
    wikisummary = json['wikisummary'];
    wikireference = json['wikireference'];
    retired = json['retired'];
    stampAdded = json['stamp_added'];
    stampUpdated = json['stamp_updated'];
    stampSeen = json['stamp_seen'];
    stampRetired = json['stamp_retired'];
    updatedLastDomain = json['updated_last_domain'];
    related = json['related'];
    attributes = json['attributes'] != null
        ? Map<String, List<String>>.from(json['attributes'])
        : <String, List<String>>{};
    ttps = json['ttps'];
    news = json['news'] != null ? List<Map<String, dynamic>>.from(json['news']) : [];
    comments = json['comments'] != null ? List<Map<String, dynamic>>.from(json['comments']) : [];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tid'] = this.tid;
    data['threat'] = this.threat;
    data['category'] = this.category;
    data['othernames'] = this.othernames;
    data['risk'] = this.risk;
    data['description'] = this.description;
    data['notes'] = this.notes;
    data['wikisummary'] = this.wikisummary;
    data['wikireference'] = this.wikireference;
    data['retired'] = this.retired;
    data['stamp_added'] = this.stampAdded;
    data['stamp_updated'] = this.stampUpdated;
    data['stamp_seen'] = this.stampSeen;
    data['stamp_retired'] = this.stampRetired;
    data['updated_last_domain'] = this.updatedLastDomain;
    data['related'] = this.related;
    data['attributes'] = this.attributes;
    data['ttps'] = this.ttps;
    data['news'] = this.news;
    data['comments'] = this.comments;
    data['summary'] = this.summary;
    return data;
  }
}