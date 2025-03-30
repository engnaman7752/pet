// pet_monitor.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PetMonitorScreen extends StatefulWidget {
  final String petId;
  final String petName;

  const PetMonitorScreen({
    super.key,
    required this.petId,
    required this.petName,
  });

  @override
  _PetMonitorScreenState createState() => _PetMonitorScreenState();
}

class _PetMonitorScreenState extends State<PetMonitorScreen> {
  final CollectionReference healthData =
  FirebaseFirestore.instance.collection('healthData');

  // Map of weekday (1=Monday, ... 7=Sunday) to aggregated metrics.
  // Each day's data: { 'avgHeartRate': ..., 'avgPulse': ..., 'avgSteps': ... }
  Map<int, Map<String, double>> aggregatedData = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPetHealthData();
  }

  void _fetchPetHealthData() async {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final oneWeekAgoTimestamp = oneWeekAgo.millisecondsSinceEpoch.toDouble();

    // Query healthData for this pet within the last 7 days.
    QuerySnapshot snapshot = await healthData
        .where('petId', isEqualTo: widget.petId)
        .where('timestamp', isGreaterThanOrEqualTo: oneWeekAgoTimestamp)
        .get();

    // Group documents by weekday.
    Map<int, List<Map<String, dynamic>>> dayData = {};
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      double ts = data['timestamp'].toDouble();
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(ts.toInt());
      int weekday = dt.weekday; // Monday = 1 ... Sunday = 7
      dayData.putIfAbsent(weekday, () => []);
      dayData[weekday]!.add(data);
    }

    // Compute average values for each day.
    Map<int, Map<String, double>> agg = {};
    for (int day = 1; day <= 7; day++) {
      if (dayData.containsKey(day)) {
        List<Map<String, dynamic>> docs = dayData[day]!;
        double sumHeartRate = 0;
        double sumPulse = 0;
        double sumSteps = 0;
        int count = docs.length;
        for (var data in docs) {
          sumHeartRate += (data['heartRate'] ?? 0).toDouble();
          sumPulse += (data['pulseCount'] ?? 0).toDouble();
          sumSteps += (data['steps'] ?? 0).toDouble();
        }
        agg[day] = {
          'avgHeartRate': count > 0 ? sumHeartRate / count : 0,
          'avgPulse': count > 0 ? sumPulse / count : 0,
          'avgSteps': count > 0 ? sumSteps / count : 0,
        };
      } else {
        agg[day] = {'avgHeartRate': 0, 'avgPulse': 0, 'avgSteps': 0};
      }
    }

    setState(() {
      aggregatedData = agg;
      loading = false;
    });
  }

  // Convert weekday number to abbreviated name.
  String weekdayToString(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Build a bar chart for a specific metric.
  // If scaleDown is true (for steps), the value is divided by 100.
  Widget _buildBarChartForMetric(String metric, Color barColor,
      {bool scaleDown = false}) {
    List<BarChartGroupData> barGroups = [];
    for (int day = 1; day <= 7; day++) {
      double value = aggregatedData[day]?[metric] ?? 0;
      if (scaleDown) {
        value = value / 100;
      }
      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              toY: value,
              color: barColor,
              width: 16,
            ),
          ],
        ),
      );
    }
    return BarChart(
      BarChartData(
        maxY: 100, // Adjust based on your data range.
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(weekdayToString(value.toInt())),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  // Manually add health data for this pet.
  Future<void> _manualAdd() async {
    final TextEditingController hrController = TextEditingController();
    final TextEditingController stepsController = TextEditingController();
    final TextEditingController pulseController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Health Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: hrController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: 'Heart Rate (bpm)'),
              ),
              TextField(
                controller: stepsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Steps'),
              ),
              TextField(
                controller: pulseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Pulse Count'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                double? hr = double.tryParse(hrController.text);
                int? steps = int.tryParse(stepsController.text);
                int? pulse = int.tryParse(pulseController.text);
                if (hr != null && steps != null && pulse != null) {
                  await healthData.add({
                    'petId': widget.petId,
                    'heartRate': hr,
                    'steps': steps,
                    'pulseCount': pulse,
                    'timestamp':
                    DateTime.now().millisecondsSinceEpoch.toDouble(),
                  });
                  // Refresh data after adding new entry.
                  _fetchPetHealthData();
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Monitor: ${widget.petName}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Heart Rate'),
              Tab(text: 'Pulse'),
              Tab(text: 'Steps'),
            ],
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              _buildBarChartForMetric('avgHeartRate', Colors.redAccent),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildBarChartForMetric('avgPulse', Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildBarChartForMetric('avgSteps', Colors.green,
                  scaleDown: true),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _manualAdd,
          tooltip: 'Add Health Data Manually',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
