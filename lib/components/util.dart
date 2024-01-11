import 'package:flutter/material.dart';

class SmartDeviceBox extends StatelessWidget {
  final String smartDeviceName;
  final String iconPath; // Tambahkan properti iconPath
  var number; // Mengubah tipe data menjadi double
  final double fontSize;

  SmartDeviceBox({
    Key? key,
    required this.smartDeviceName,
    required this.iconPath,
    required this.number,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
             const SizedBox(height: 20,),
            Image.asset(
              iconPath, // Menggunakan properti iconPath
              height: 60, // Sesuaikan dengan tinggi yang Anda inginkan
              color: Colors.white, // Sesuaikan warna jika diperlukan
            ),

            // Smart device name
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 2.0, top: 10.0),
              child: Text(
                smartDeviceName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            // Number (0.0)
            const SizedBox(height: 12),
            Text(
              smartDeviceName == 'Suhu' || smartDeviceName == 'Humidity' ?  number.toStringAsFixed(2) : number.toString(), // Menampilkan suhu dengan 2 desimal
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

