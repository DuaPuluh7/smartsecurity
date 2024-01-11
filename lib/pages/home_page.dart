import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iot/components/util.dart';
import 'package:iot/pages/crud_firebase.dart';
import 'package:iot/pages/graph_flame.dart';
import 'package:iot/pages/graph_humidity.dart';
import 'package:iot/pages/graph_people.dart';
import 'package:iot/pages/graph_suhu.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool powerOn = false;
  int _selectedIndex = 0;
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  MqttServerClient client = MqttServerClient.withPort(
    'broker.hivemq.com',
    'e7836b2f-8e6f-4aca-9ee9-f48ccd224bfe',
    1883,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Pindah ke halaman yang sesuai dengan indeks yang dipilih
      if (_selectedIndex == 0) {
        // Halaman Home
        // Tidak perlu melakukan apa-apa karena sudah di halaman Home
      } else if (_selectedIndex == 1) {
        // Halaman Tentang
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CrudDatabase(), // Ganti dengan nama halaman Tentang yang sesuai
        ));
      }
    });
  }

  Stream<List<String>>? mqttDataStream;

  @override
  void initState() {
    super.initState();
    configureMQTT();

    // Inisialisasi stream untuk data MQTT
    mqttDataStream = Stream.periodic(Duration(seconds: 1), (_) {
      // Di sini Anda dapat mengambil data dari MQTT atau menggunakan data palsu untuk menggantinya
      return ['Suhu', 'Humidity', 'People Detect', 'Flame Detect'];
    });
  }

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  void configureMQTT() async {
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;
    client.logging(on: true);
    client.setProtocolV311();

    // Connect to the MQTT broker
    try {
      await client.connect();
    } catch (e) {
      print('MQTT_LOGS:: Connection failed: $e');
    }

    String suhuTopic = 'IOT-SECURITY DD SUHU';
    String kelembapanTopic = 'IOT-SECURITY DD KELEMBAPAN';
    String peopleTopic = 'IOT-SECURITY DD SENSOR PINTU'; 
    String flameTopic = 'IOT-SECURITY DD SENSOR API';
    
    client.subscribe(suhuTopic, MqttQos.atMostOnce);
    client.subscribe(kelembapanTopic, MqttQos.atMostOnce);
    client.subscribe(flameTopic, MqttQos.atMostOnce);
    client.subscribe(peopleTopic, MqttQos.atMostOnce);

    // Set up a message handler
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      if (c != null && c.isNotEmpty) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final String payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);

        handleMqttMessage(c[0].topic, payload);
      }
    });
  }

  void handleMqttMessage(String topic, String message) {
  // You can update your UI here with the received data.
  // For example, if you want to update a variable and trigger a rebuild:
  setState(() {
    if (topic == 'IOT-SECURITY DD SUHU') {
      double temperature = double.tryParse(message) ?? 0.0;
      mySmartDevices[0][2] = temperature; // Assuming "Suhu" is the first device
    } else if (topic == 'IOT-SECURITY DD KELEMBAPAN') {
      double humidity = double.tryParse(message) ?? 0.0;
      mySmartDevices[1][2] = humidity;
    } else if (topic == 'IOT-SECURITY DD SENSOR API') {
      int flameDetect = int.tryParse(message) ?? 0;
      mySmartDevices[3][2] = flameDetect;
      if (flameDetect == 1) {
        mySmartDevices[3][2] = "Tidak Terdeteksi";
      } else {
        mySmartDevices[3][2] = "Terdeteksi Api";
      }
    } else if (topic == 'IOT-SECURITY DD SENSOR PINTU') {
      int peopleDetect = int.tryParse(message) ?? 0;
      mySmartDevices[2][2] = peopleDetect;
      if (peopleDetect == 1 ) {
        mySmartDevices[2][2] = "Pintu Terbuka";
       } else {
        mySmartDevices[2][2] = "Tidak Terdeteksi";
       }
    }
  });
}


  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client callback invoked');
  }

  @override
  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["Suhu", "lib/img/suhu.png", 0,false], // Initialize "Suhu" with 0.0
    ["Humidity", "lib/img/humidity.png", 0,false],
    ["Door Status", "lib/img/door.png", "Tidak Terdeteksi",false],
    ["Flame Status", "lib/img/flame.png", "Tidak Terdeteksi",false],  // Initialize "Humidity" with 0.0
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'CRUD',
          ),
        ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
          // Ganti fontFamily sesuai keinginan Anda
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // app bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu icon
                    Image.asset(
                      'lib/img/menu.png',
                      height: 45,
                      color: Colors.grey[800],
                    ),
        
                    // account icon
                    GestureDetector(
                      onTap: () {
                        signUserOut();
                      },
                      child: Icon(
                        Icons.logout,
                        size: 35,
                        color: Colors.grey[800],
                      ),
                    )
                  ],
                ),
              ),
        
              const SizedBox(height: 20),
        
              // welcome home
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Home,",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade800,
                        fontFamily: 'Poppins', // Menggunakan jenis huruf Poppins
                        fontWeight: FontWeight.normal, // Tidak ada huruf tebal
                      ),
                    ),
                    Text(
                      'Muhammad Farhan',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins', // Menggunakan jenis huruf Poppins
                        fontWeight: FontWeight.bold, // Huruf tebal
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 25),
        
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),
        
              const SizedBox(height: 25),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Smart Devices",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
        
              // grid
              Container(
                height: MediaQuery.of(context).size.height* 2/3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<List<String>>(
                    stream: mqttDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) { 
                        List<String> mqttData = snapshot.data!;
                        return GridView.builder(
                          itemCount: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.3,
                          ),
                          itemBuilder: (context, index) {
                            // Gunakan index untuk membedakan antara suhu dan kelembaban
                            final String deviceName = index == 0 ? 'Suhu' : index ==1 ? 'Humidity' : index ==2 ? 'Door Status' : 'Flame Status';
                            return InkWell(
                                onTap: () {
                                  // Berdasarkan indeks, pindah ke halaman yang sesuai
                                  if (index == 0) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailSuhu(),
                                    ));
                                  } else if (index == 1) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailHumid(),
                                    ));
                                  } else if (index == 3) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailFlame(),
                                    ));
                                  } else if (index == 2) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailPeople(),
                                    ));
                                  }
                                },
                              child: SmartDeviceBox(
                                smartDeviceName: deviceName,
                                iconPath: mySmartDevices[index][1],
                                number: index == 0 || index == 1 ? mySmartDevices[index][2].toDouble() : mySmartDevices[index][2].toString(), // Ubah ke tipe data double
                                fontSize: index == 2 || index == 3 ? 12.0 : 20.0, // Atur ukuran font sesuai dengan indeks
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
