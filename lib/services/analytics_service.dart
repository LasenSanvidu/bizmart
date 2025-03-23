import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch summary analytics data
  Future<Map<String, dynamic>> getSummaryData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('analytics').doc('summary').get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting summary data: $e');
      return {};
    }
  }

// Fetch chart data based on timeframe
  Future<List<Map<String, dynamic>>> getChartData(String timeframe) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('analytics')
          .doc('charts')
          .collection(timeframe.toLowerCase())
          .orderBy('timestamp')
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting chart data: $e');
      return [];
    }
  }

  // Update analytics data (for admin or scheduled updates)
  Future<void> updateAnalytics(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('analytics')
          .doc('summary')
          .set(data, SetOptions(merge: true));

      return;
    } catch (e) {
      print('Error updating analytics: $e');
      throw e;
    }
  }

  // Add a data point to chart data
  Future<void> addChartDataPoint(
      String timeframe, double value, DateTime timestamp) async {
    try {
      await _firestore
          .collection('analytics')
          .doc('charts')
          .collection(timeframe.toLowerCase())
          .add({
        'value': value,
        'timestamp': Timestamp.fromDate(timestamp),
      });

      return;
    } catch (e) {
      print('Error adding chart data point: $e');
      throw e;
    }
  }

  // Clear all chart data for a timeframe
  Future<void> clearChartData(String timeframe) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('analytics')
          .doc('charts')
          .collection(timeframe.toLowerCase())
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      return;
    } catch (e) {
      print('Error clearing chart data: $e');
      throw e;
    }
  }
}
