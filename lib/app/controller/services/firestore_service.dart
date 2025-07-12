import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/app/model/lesson_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String lessonsCollection = 'lessons';

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Helper method to get user's lessons collection reference
  CollectionReference get _userLessonsCollection {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection(lessonsCollection);
  }

  // Save a lesson to Firestore for current user
  Future<String> saveLesson(LessonModel lesson) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Check if lesson already exists for this threat
      final existingLesson = await getLessonByThreatId(lesson.threatId);
      
      if (existingLesson != null) {
        // Update existing lesson
        // Pass the LessonModel object directly to updateLesson
        await updateLesson(lesson.copyWith(id: existingLesson.id, updatedAt: DateTime.now()));
        log('Lesson updated successfully for threat: ${lesson.threatId}');
        return existingLesson.id!;
      } else {
        // Create new lesson
        final docRef = await _userLessonsCollection.add(lesson.toFirestore());
        log('Lesson saved successfully with ID: ${docRef.id}');
        return docRef.id;
      }
    } catch (e) {
      log('Error saving lesson: $e');
      throw Exception('Failed to save lesson: $e');
    }
  }

  // Get lesson by threat ID for current user
  Future<LessonModel?> getLessonByThreatId(String threatId) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _userLessonsCollection
          .where('threatId', isEqualTo: threatId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error fetching lesson by threat ID: $e');
      throw Exception('Failed to fetch lesson by threat ID: $e');
    }
  }

  // Get all lessons from Firestore for current user
  Future<List<LessonModel>> getAllLessons() async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _userLessonsCollection
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log('Error fetching lessons: $e');
      throw Exception('Failed to fetch lessons: $e');
    }
  }

  // Get a specific lesson by ID for current user
  Future<LessonModel?> getLessonById(String id) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final doc = await _userLessonsCollection.doc(id).get();
      
      if (doc.exists) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error fetching lesson by ID: $e');
      throw Exception('Failed to fetch lesson: $e');
    }
  }

  // Update a lesson for current user
  Future<void> updateLesson(LessonModel lesson) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _userLessonsCollection.doc(lesson.id).update(
        lesson.copyWith(updatedAt: DateTime.now()).toFirestore(),
      );
      log('Lesson updated successfully');
    } catch (e) {
      log('Error updating lesson: $e');
      throw Exception('Failed to update lesson: $e');
    }
  }

  // Delete a lesson for current user
  Future<void> deleteLesson(String id) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _userLessonsCollection.doc(id).delete();
      log('Lesson deleted successfully');
    } catch (e) {
      log('Error deleting lesson: $e');
      throw Exception('Failed to delete lesson: $e');
    }
  }

  // Search lessons by title or content for current user
  Future<List<LessonModel>> searchLessons(String query) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _userLessonsCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + '\uf8ff')
          .orderBy('title')
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log('Error searching lessons: $e');
      throw Exception('Failed to search lessons: $e');
    }
  }

  // Get lessons by threat type for current user
  Future<List<LessonModel>> getLessonsByThreatType(String threatType) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _userLessonsCollection
          .where('threatType', isEqualTo: threatType)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log('Error fetching lessons by threat type: $e');
      throw Exception('Failed to fetch lessons by threat type: $e');
    }
  }

  // Get lessons by risk level for current user
  Future<List<LessonModel>> getLessonsByRiskLevel(String riskLevel) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _userLessonsCollection
          .where('riskLevel', isEqualTo: riskLevel)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log('Error fetching lessons by risk level: $e');
      throw Exception('Failed to fetch lessons by risk level: $e');
    }
  }

  // Get lessons by difficulty for current user
  Future<List<LessonModel>> getLessonsByDifficulty(String difficulty) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _userLessonsCollection
          .where('difficulty', isEqualTo: difficulty)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      log('Error fetching lessons by difficulty: $e');
      throw Exception('Failed to fetch lessons by difficulty: $e');
    }
  }

  // Get lessons stream for real-time updates for current user
  Stream<List<LessonModel>> getLessonsStream() {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    return _userLessonsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get statistics for current user
  Future<Map<String, dynamic>> getLessonStatistics() async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _userLessonsCollection.get();
      final lessons = querySnapshot.docs.map((doc) {
        return LessonModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
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

  // Check if user is authenticated
  bool get isAuthenticated => currentUserId != null;

  // Listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}