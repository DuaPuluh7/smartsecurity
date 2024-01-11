import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailSuhu extends StatefulWidget {
  const DetailSuhu({Key? key}) : super(key: key);

  @override
  State<DetailSuhu> createState() => _DetailSuhuState();
}

Future<List<Map<String, dynamic>>> fetchData() async {
  try {
    final response = await http.get(Uri.parse(
        'https://securityappitenas.000webhostapp.com/security-app/suhu7hari.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      print('API Request Error - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      return [];
    }
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

class _DetailSuhuState extends State<DetailSuhu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Temperature Chart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF1C2321),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Rata-rata Suhu dan Tanggal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Text('Error: Failed to load data');
                  } else {
                    final List<Map<String, dynamic>> data = snapshot.data!;

                    return Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                      },
                      border: TableBorder.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Suhu (°C)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Tanggal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var item in data)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['rata-rata suhu'].toString()),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['tanggal']),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ChartWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: fetchData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError || snapshot.data == null) {
//           return Text('Error: Failed to load data');
//         } else {
//           final List<FlSpot> chartData = [];

//           for (var i = 0; i < snapshot.data!.length; i++) {
//             final String temperature =
//                 snapshot.data![i]['rata-rata suhu'].toString();
//             chartData.add(FlSpot(i.toDouble(), double.parse(temperature)));
//           }

//           return LineChart(
//             LineChartData(
//               gridData: FlGridData(show: true),
//               titlesData: FlTitlesData(show: true),
//               borderData: FlBorderData(
//                 show: true,
//                 border: Border.all(
//                   color: const Color(0xff37434d),
//                   width: 1,
//                 ),
//               ),
//               minX: 0,
//               maxX: chartData.length.toDouble() - 1,
//               minY: 0,
//               maxY: 40,
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: chartData,
//                   isCurved: true,
//                   dotData: FlDotData(show: false),
//                   belowBarData: BarAreaData(show: false),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }