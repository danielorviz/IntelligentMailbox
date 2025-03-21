import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/mailbox_service.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter/services.dart';

class NewMailboxConfigurationScreen extends StatefulWidget {
  const NewMailboxConfigurationScreen({super.key});

  @override
  State<NewMailboxConfigurationScreen> createState() =>
      _NewMailboxConfigurationScreenState();
}

class _NewMailboxConfigurationScreenState
    extends State<NewMailboxConfigurationScreen> {
  
  final MailboxService _mailboxService = MailboxService();
  late UserProvider _userProvider;
  List<WiFiAccessPoint> accessPoints = [];
  String selectedSSID = '';
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mailboxIdController = TextEditingController();
  final TextEditingController mailboxIpController = TextEditingController();

  int _currentStep = 0;
  bool isMailboxIdValid = false;
  bool isMailboxConnected = false;
  bool isLoadingPrincipal = false;

  bool _isWiFiEnabled = false;
  bool _isConnectedToAP = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
    });
    setState(() {
      mailboxIdController.text = 'ardboxmail-7854';
      mailboxIpController.text = '192.168.4.1';
      isMailboxIdValid = true;
    });

    mailboxIdController.addListener(() {
      setState(() {
        isMailboxIdValid =
            mailboxIdController.text.isNotEmpty &&
            mailboxIpController.text.isNotEmpty;
      });
    });

    mailboxIpController.addListener(() {
      setState(() {
        isMailboxIdValid =
            mailboxIdController.text.isNotEmpty &&
            mailboxIpController.text.isNotEmpty;
      });
    });
  }

  Future<void> _initializeWiFi() async {
    bool isEnabled = await WiFiForIoTPlugin.isEnabled();
    setState(() {
      _isWiFiEnabled = isEnabled;
    });

    if (!_isWiFiEnabled) {
      bool? enabled = await WiFiForIoTPlugin.setEnabled(true);
      setState(() {
        _isWiFiEnabled = enabled ?? false;
      });
    }
  }

  Future<void> connectToArduinoAP(String ssid, String password) async {
    setState(() {
      _isConnectedToAP = false;
      isLoadingPrincipal = true;
    });
    //bool isConnected = await WiFiForIoTPlugin.connect(
    //  ssid,
    // password: password,
    //  security: NetworkSecurity.WPA,
    //  joinOnce: true,
    //  withInternet: true,
    //);

    bool isConnected = await WiFiForIoTPlugin.isConnected();
    String? newSSID = await WiFiForIoTPlugin.getSSID();
    isConnected = isConnected && newSSID == ssid;

    //while (!isConnected && attempts > 0 && newSSID != ssid) {
    //  attempts--;
    //  isConnected = await WiFiForIoTPlugin.isConnected();
    //  newSSID = await WiFiForIoTPlugin.getSSID();
    //  isConnected = isConnected && newSSID == ssid;
    //  print(newSSID);
    //  await Future.delayed(Duration(seconds: 2));
    //}
    setState(() {
      _isConnectedToAP = isConnected;
      isLoadingPrincipal = false;
    });
  }

  void _showWiFiDisabledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Wi-Fi Desactivado"),
          content: Text(
            "El Wi-Fi está desactivado. Por favor, actívelo para continuar.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showConnectionErrorDialog(String ssid, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error de Conexión"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "No se pudo conectar al punto de acceso del Arduino. Verifique las credenciales e intente de nuevo.",
              ),
              SizedBox(height: 16),
              Text(
                "Conéctese manualmente a la red Wi-Fi:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    ssid,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Contraseña:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      password,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: password));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Contraseña copiada al portapapeles"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startScan() async {
    setState(() {
      isLoadingPrincipal = true;
    });
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
      accessPoints = aps.where((ap) => ap.ssid.isNotEmpty && ap.ssid != mailboxIdController.text).toList();
      isLoadingPrincipal = false;
    });
  }

  Future<void> _sendCredentials(String ssid, String password) async {
    bool connected = false;
    setState(() {
      isLoadingPrincipal = true;
      isMailboxConnected = false;
    });
    try {
      final url = Uri.parse(
        'http://${mailboxIpController.text}/',
      ); // IP del Arduino

      final response = await http.post(
        url,
        body: {'ssid': ssid, 'password': password},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciales enviadas correctamente.')),
        );
        connected = true;
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Credenciales incorrectas.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar credenciales.')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar credenciales.')));
    } finally {
      setState(() {
        isLoadingPrincipal = false;
        isMailboxConnected = connected;
      });
    }
  }

  IconData _getSignalIcon(int level) {
    if (level >= -80) {
      return Icons.signal_wifi_4_bar;
    } else {
      return Icons.signal_wifi_0_bar;
    }
  }

  void _nextStep() async {
    if (_currentStep == 0) {
      await _initializeWiFi();
      if (!_isWiFiEnabled) {
        _showWiFiDisabledDialog();
        return;
      }
      await connectToArduinoAP(mailboxIdController.text, '123456789');
      if (!_isConnectedToAP) {
        _showConnectionErrorDialog(mailboxIdController.text, '123456789');
        return;
      }
      await _startScan();
    }
    if (_currentStep == 1) {
      await _sendCredentials(selectedSSID, passwordController.text);
      if (!isMailboxConnected) {
        return;
      }
      await _mailboxService.createMailbox(mailboxIdController.text, _userProvider.user!.uid, 3600);
    }
    setState(() {
      _currentStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurar Buzón')),
      body: Stack(
        children: [
          Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue:
                (isMailboxIdValid || _currentStep > 0) && _currentStep != 1
                    ? _nextStep
                    : null,
            onStepCancel:
                _currentStep > 0
                    ? () => setState(() {
                      _currentStep -= 1;
                    })
                    : null,
            steps: [
              Step(
                title: Text('Configurar Buzón'),
                content: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: mailboxIdController,
                        decoration: InputDecoration(
                          labelText: 'ID del Buzón',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: mailboxIpController,
                        decoration: InputDecoration(
                          labelText: 'IP del Buzón',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text('Conectar a la red WiFi'),
                content: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount:
                            accessPoints
                                .where((ap) => ap.ssid.isNotEmpty)
                                .length,
                        itemBuilder: (context, index) {
                          final ap =
                              accessPoints
                                  .where((ap) => ap.ssid.isNotEmpty)
                                  .toList()[index];
                          return ListTile(
                            leading: Icon(
                              _getSignalIcon(ap.level),
                              color: Colors.blueAccent,
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
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _startScan,
                      child: Text('Escanear redes'),
                    ),
                  ],
                ),
              ),
              Step(
                title: Text('Finalizar Configuración'),
                content: Text("data"),
              ),
            ],
          ),
          if (isLoadingPrincipal)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: CircularProgressIndicator()),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.pop(context); // Cerrar el diálogo si no se conecta
                }
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nextStep();
              },
              child: Text('Conectar'),
            ),
          ],
        );
      },
    );
  }
}
