import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailPeople extends StatefulWidget {
  const DetailPeople({Key? key}) : super(key: key);

  @override
  State<DetailPeople> createState() => _DetailPeopleState();
}

Future<List<Map<String, dynamic>>> fetchData() async {
  try {
    final response = await http.get(Uri.parse(
        'https://securityappitenas.000webhostapp.com/security-app/motion7hari.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      final List<Map<String, dynamic>> chartData = [];

      for (var i = 0; i < jsonData.length; i++) {
        final String totalPeopleString = jsonData[i]['total motion_detected'];
        chartData.add({
          'index': i.toDouble(),
          'totalPeople': int.parse(totalPeopleString),
          'tanggal': jsonData[i]['tanggal'],
        });
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

class _DetailPeopleState extends State<DetailPeople> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'People Chart',
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
                'Jumlah Orang Masuk dan Tanggal',
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

                    return Column(
                      children: [
                        Table(
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
                                      'Jumlah Orang',
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
                                      child: Text(item['totalPeople'].toString()),
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
                        ),
                        SizedBox(height: 20),
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

