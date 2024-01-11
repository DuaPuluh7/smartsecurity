import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailFlame extends StatefulWidget {
  const DetailFlame({super.key});

  @override
  State<DetailFlame> createState() => _DetailFlameState();
}

Future<List<FlSpot>> fetchData() async {
  try {
    final response = await http.get(Uri.parse(
        'https://securityappitenas.000webhostapp.com/security-app/flame7hari.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      final List<FlSpot> chartData = [];

      for (var i = 0; i < jsonData.length; i++) {
        // Assuming each item in jsonData is a Map with 'rata-rata suhu' key
        final String temperatureString = jsonData[i]['rata-rata suhu'];

        // Convert string to double assuming it represents temperature
        chartData.add(FlSpot(i.toDouble(), double.parse(temperatureString)));
      }

      return chartData;
    } else {
      print('API Request Error - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      return []; // Return an empty list when there is an error
    }
  } catch (error) {
    print('Error: $error');
    return []; // Return an empty list when there is an exception
  }
}

class _DetailFlameState extends State<DetailFlame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flame Chart',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF1C2321),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ChartWidget(),
      ),
    );
  }
}

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error: Failed to load data');
        } else {
          return LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: const Color(0xff37434d),
                  width: 1,
                ),
              ),
              minX: 0,
              maxX: snapshot.data!.length.toDouble() - 1,
              minY: 0,
              maxY: 40,
              lineBarsData: [
              LineChartBarData(
                spots: snapshot.data!,
                isCurved: true,// Menggunakan warna hitam // Ubah warna garis menjadi hitam
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
],
            ),
          );
        }
      },
    );
  }
}