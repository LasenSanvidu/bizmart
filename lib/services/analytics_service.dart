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
