// health_monitor.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthMonitorScreen extends StatefulWidget {
  const HealthMonitorScreen({super.key});

  @override
  _HealthMonitorScreenState createState() => _HealthMonitorScreenState();
}

class _HealthMonitorScreenState extends State<HealthMonitorScreen> {
  final CollectionReference healthData =
  FirebaseFirestore.instance.collection('healthData');

  // List for plotting heart rate data on a line chart.
  List<FlSpot> dataPoints = [];
  // Summary variables for the day's health metrics.
  double _avgHeartRate = 0;
  int _totalSteps = 0;
  int _totalPulse = 0;

  @override
  void initState() {
    super.initState();
    _fetchHealthData();
  }

  void _fetchHealthData() {
    healthData.snapshots().listen((snapshot) {
      List<FlSpot> points = [];
      double totalHeartRate = 0;
      int count = 0;
      dynamic stepsSum = 0;
      dynamic pulseSum = 0;
      for (var doc in snapshot.docs) {
        // Expecting the document to have fields: 'heartRate', 'steps', 'pulseCount', and 'timestamp'
        double heartRate = doc['heartRate'].toDouble();
        double timestamp = doc['timestamp'].toDouble();
        points.add(FlSpot(timestamp, heartRate));
        totalHeartRate += heartRate;
        count++;
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('steps')) {
          stepsSum += data['steps']!;
        }
        if (data.containsKey('pulseCount')) {
          pulseSum += data['pulseCount'];
        }
      }
      setState(() {
        dataPoints = points;
        _avgHeartRate = count > 0 ? totalHeartRate / count : 0;
        _totalSteps = stepsSum;
        _totalPulse = pulseSum;
      });
    });
  }

  Future<void> _manualAdd() async {
    // Create controllers for heart rate, steps, and pulse count
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
                decoration: const InputDecoration(labelText: 'Heart Rate (bpm)'),
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
                  // Use current timestamp (milliseconds since epoch) as x-axis value.
                  await healthData.add({
                    'heartRate': hr,
                    'steps': steps,
                    'pulseCount': pulse,
                    'timestamp': DateTime.now().millisecondsSinceEpoch.toDouble(),
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Average Heart Rate: ${_avgHeartRate.toStringAsFixed(1)} bpm',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Steps: $_totalSteps',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Pulse Count: $_totalPulse',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return dataPoints.isEmpty
        ? const Center(child: Text('No health data available.'))
        : LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Monitor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            Expanded(child: _buildLineChart()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _manualAdd,
        tooltip: 'Add Health Data Manually',
        child: const Icon(Icons.add),
      ),
    );
  }
}
