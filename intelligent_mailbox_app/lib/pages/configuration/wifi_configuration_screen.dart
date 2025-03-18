import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:http/http.dart' as http;

class WifiConfigurationScreen extends StatefulWidget {
  const WifiConfigurationScreen({super.key});

  @override
  State<WifiConfigurationScreen> createState() =>
      _WifiConfigurationScreenState();
}

class _WifiConfigurationScreenState extends State<WifiConfigurationScreen> {

  List<WiFiAccessPoint> accessPoints = [];
  String selectedSSID = '';
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    final can = await WiFiScan.instance.canStartScan(askPermissions: true);
    switch (can) {
      case CanStartScan.yes:
        final isScanning = await WiFiScan.instance.startScan();
        _loadAccessPoints();
        break;
      default:
        break;
    }
  }

  Future<void> _loadAccessPoints() async {
    final aps = await WiFiScan.instance.getScannedResults();
    setState(() {
      aps.sort((a, b) => b.level.compareTo(a.level));
      accessPoints = aps;
    });
  }

  Future<void> _sendCredentials(String ssid, String password) async {
    try {
      final url = Uri.parse('http://192.168.4.1/configure'); // IP del Arduino
      final response = await http.post(
        url,
        body: {'ssid': ssid, 'password': password},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciales enviadas correctamente.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar credenciales.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
IconData _getSignalIcon(int level) {
    if (level >= -80) {
      return Icons.signal_wifi_4_bar;
    } else {
      return Icons.signal_wifi_0_bar;
    } 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurar WiFi')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: accessPoints
                  .where((ap) => ap.ssid.isNotEmpty)
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                final ap = accessPoints
                    .where((ap) => ap.ssid.isNotEmpty)
                    .toList()[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getSignalIcon(ap.level), color: Colors.blueAccent),
                        SizedBox(width: 8),
                      ],
                    ),
                    title: Text(
                      ap.ssid,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        selectedSSID = ap.ssid;
                      });
                      _showPasswordDialog(ap.ssid);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _startScan,
              child: Text('Escanear redes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(String ssid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Conectar a $ssid'),
          content: TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final password = passwordController.text;
                _sendCredentials(ssid, password);
                Navigator.pop(context);
              },
              child: Text('Conectar'),
            ),
          ],
        );
      },
    );
  }
}
