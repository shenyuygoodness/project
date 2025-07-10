import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/app/model/lesson_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String lessonsCollection = 'lessons';

  // Save a lesson to Firestore
  Future<String> saveLesson(LessonModel lesson) async {
    try {
      final docRef = await _firestore.collection(lessonsCollection).add(lesson.toFirestore());
      log('Lesson saved successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      log('Error saving lesson: $e');
      throw Exception('Failed to save lesson: $e');
    }
  }

  // Get all lessons from Firestore
  Future<List<LessonModel>> getAllLessons() async {
    try {
      final querySnapshot = await _firestore
          .collection(lessonsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      log('Error fetching lessons: $e');
      throw Exception('Failed to fetch lessons: $e');
    }
  }

  // Get a specific lesson by ID
  Future<LessonModel?> getLessonById(String id) async {
    try {
      final doc = await _firestore.collection(lessonsCollection).doc(id).get();
      
      if (doc.exists) {
        return LessonModel.fromFirestore(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      log('Error fetching lesson by ID: $e');
      throw Exception('Failed to fetch lesson: $e');
    }
  }

  // Update a lesson
  Future<void> updateLesson(LessonModel lesson) async {
    try {
      await _firestore.collection(lessonsCollection).doc(lesson.id).update(
        lesson.copyWith(updatedAt: DateTime.now()).toFirestore(),
      );
      log('Lesson updated successfully');
    } catch (e) {
      log('Error updating lesson: $e');
      throw Exception('Failed to update lesson: $e');
    }
  }

  // Delete a lesson
  Future<void> deleteLesson(String id) async {
    try {
      await _firestore.collection(lessonsCollection).doc(id).delete();
      log('Lesson deleted successfully');
    } catch (e) {
      log('Error deleting lesson: $e');
      throw Exception('Failed to delete lesson: $e');
    }
  }

  // Search lessons by title or content
  Future<List<LessonModel>> searchLessons(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(lessonsCollection)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + '\uf8ff')
          .orderBy('title')
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      log('Error searching lessons: $e');
      throw Exception('Failed to search lessons: $e');
    }
  }

  // Get lessons by threat type
  Future<List<LessonModel>> getLessonsByThreatType(String threatType) async {
    try {
      final querySnapshot = await _firestore
          .collection(lessonsCollection)
          .where('threatType', isEqualTo: threatType)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      log('Error fetching lessons by threat type: $e');
      throw Exception('Failed to fetch lessons by threat type: $e');
    }
  }

  // Get lessons by risk level
  Future<List<LessonModel>> getLessonsByRiskLevel(String riskLevel) async {
    try {
      final querySnapshot = await _firestore
          .collection(lessonsCollection)
          .where('riskLevel', isEqualTo: riskLevel)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      log('Error fetching lessons by risk level: $e');
      throw Exception('Failed to fetch lessons by risk level: $e');
    }
  }

  // Get lessons by difficulty
  Future<List<LessonModel>> getLessonsByDifficulty(String difficulty) async {
    try {
      final querySnapshot = await _firestore
          .collection(lessonsCollection)
          .where('difficulty', isEqualTo: difficulty)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      log('Error fetching lessons by difficulty: $e');
      throw Exception('Failed to fetch lessons by difficulty: $e');
    }
  }

  // Get lessons stream for real-time updates
  Stream<List<LessonModel>> getLessonsStream() {
    return _firestore
        .collection(lessonsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  // Get statistics
  Future<Map<String, dynamic>> getLessonStatistics() async {
    try {
      final querySnapshot = await _firestore.collection(lessonsCollection).get();
      final lessons = querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data());
      }).toList();

      final stats = <String, dynamic>{
        'totalLessons': lessons.length,
        'byThreatType': <String, int>{},
        'byRiskLevel': <String, int>{},
        'byDifficulty': <String, int>{},
      };

      for (final lesson in lessons) {
        // Count by threat type
        stats['byThreatType'][lesson.threatType] = 
            (stats['byThreatType'][lesson.threatType] ?? 0) + 1;

        // Count by risk level
        stats['byRiskLevel'][lesson.riskLevel] = 
            (stats['byRiskLevel'][lesson.riskLevel] ?? 0) + 1;

        // Count by difficulty
        stats['byDifficulty'][lesson.difficulty] = 
            (stats['byDifficulty'][lesson.difficulty] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      log('Error fetching lesson statistics: $e');
      throw Exception('Failed to fetch lesson statistics: $e');
    }
  }
}