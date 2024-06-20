import 'package:flutter/material.dart';
import 'loadingnebeng_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RidePage extends StatefulWidget {
  final String pickupLocation;
  final String destinationLocation;

  RidePage({required this.pickupLocation, required this.destinationLocation});

  @override
  _RidePageState createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  String paymentMethod = ''; // Variabel untuk menyimpan metode pembayaran
  String qrCodeUrl = ''; // URL QR code yang diambil dari Firebase
  bool isLoadingQR = false; // Status loading QR code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Titik Jemput dan Tujuan'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menambahkan gambar dari URL yang baru
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://i.postimg.cc/Pq8tmQBH/Whats-App-Image-2024-06-02-at-09-37-13-a02e0530.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Inputan titik jemput dengan ikon
              Row(
                children: [
                  Icon(Icons.location_on), // Icon titik jemput
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Titik Jemput',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Inputan titik tujuan dengan ikon
              Row(
                children: [
                  Icon(Icons.location_on), // Icon titik tujuan
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Titik Tujuan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Pilihan metode pembayaran
              Text('Pilih Metode Pembayaran:'),
              Row(
                children: [
                  Radio(
                    value: 'Tunai',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value.toString();
                        qrCodeUrl = ''; // Reset QR code URL
                      });
                    },
                  ),
                  Text('Tunai'),
                  SizedBox(width: 20),
                  Radio(
                    value: 'QRIS',
                    groupValue: paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value.toString();
                        fetchQRCode(); // Fetch QR code from Firebase
                      });
                    },
                  ),
                  Text('QRIS'),
                ],
              ),
              SizedBox(height: 16),
              // Menampilkan harga atau gambar QRIS sesuai dengan metode pembayaran
              if (paymentMethod == 'Tunai')
                Text('Harga: Rp 3000'),
              if (paymentMethod == 'QRIS')
                Center(
                  child: isLoadingQR
                      ? CircularProgressIndicator()
                      : qrCodeUrl.isNotEmpty
                          ? Image.network(
                              qrCodeUrl,
                              height: 200, // Ubah tinggi sesuai kebutuhan
                            )
                          : Text('Gagal memuat QR code'),
                ),
              SizedBox(height: 16),
              // Tombol Pesan
              Center(
                child: SizedBox(
                  width: double.infinity, // Buat button memenuhi lebar layar
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman loading pesanan
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoadingNebengPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Ubah warna latar menjadi hijau
                      padding: EdgeInsets.symmetric(vertical: 16), // Ubah padding vertikal
                    ),
                    child: Text(
                      'Pesan',
                      style: TextStyle(fontSize: 20, color: Colors.white), // Ubah warna teks dan ukuran font
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mengambil QR code dari Firebase
  Future<void> fetchQRCode() async {
    setState(() {
      isLoadingQR = true;
    });

    final response = await http.get(Uri.parse('https://YOUR_FIREBASE_DATABASE_URL/qrCode.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        qrCodeUrl = data['qrCodeUrl'];
        isLoadingQR = false;
      });
    } else {
      setState(() {
        qrCodeUrl = '';
        isLoadingQR = false;
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: RidePage(
      pickupLocation: 'Contoh Jemput',
      destinationLocation: 'Contoh Tujuan',
    ),
  ));
}
