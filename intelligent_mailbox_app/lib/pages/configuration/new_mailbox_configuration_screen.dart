import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/models/mailbox_initial_config.dart';
import 'package:intelligent_mailbox_app/providers/user_provider.dart';
import 'package:intelligent_mailbox_app/services/auth_service.dart';
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
  // Services
  final MailboxService _mailboxService = MailboxService();
  final AuthService _authService = AuthService();
  late UserProvider _userProvider;

  // Step control
  int _currentStep = 0;
  bool isLoadingPrincipal = false;

  //Step 0
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _accountVerified = false;

  //Step 1
  bool _isWiFiEnabled = false;
  bool isMailboxIdValid = false;
  bool isMailboxConnected = false;
  final TextEditingController mailboxIdController = TextEditingController();
  final TextEditingController mailboxKeyController = TextEditingController();
  MailboxInitialConfig? _mailboxInitialConfig;

  // Step 2
  bool _isConnectedToAP = false;
  bool _credentialsSended = false;

  // Step 3
  List<WiFiAccessPoint> accessPoints = [];
  String selectedSSID = '';
  final TextEditingController ssidPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startScan();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        _emailController.text = _userProvider.user!.email!;
        mailboxIdController.text = 'ardboxmail-7854';
        mailboxKeyController.text = 'abc\$123';
        isMailboxIdValid = true;
      });
    });

    mailboxIdController.addListener(() {
      setState(() {
        isMailboxIdValid =
            mailboxIdController.text.isNotEmpty &&
            mailboxKeyController.text.isNotEmpty;
      });
    });

    mailboxKeyController.addListener(() {
      setState(() {
        isMailboxIdValid =
            mailboxIdController.text.isNotEmpty &&
            mailboxKeyController.text.isNotEmpty;
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
    bool isConnected = await WiFiForIoTPlugin.isConnected();
    String? newSSID = await WiFiForIoTPlugin.getSSID();
    isConnected = isConnected && newSSID == ssid;
    print("SSID: $ssid newssid: $newSSID conectado $isConnected");
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

  void _showConnectionErrorDialog() {
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
                "No se pudo conectar al punto de acceso del Arduino. Verifique de nuevo la conexión y vuelva a intentarlo.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
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
        await WiFiScan.instance.startScan();
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
      accessPoints =
          aps
              .where(
                (ap) =>
                    ap.ssid.isNotEmpty && ap.ssid != mailboxIdController.text,
              )
              .toList();
      isLoadingPrincipal = false;
    });
  }

  Future<void> _verifyAccount() async {
    try {
      setState(() {
        isLoadingPrincipal = true;
      });
      final user = await _authService.getFirebaseUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
        return;
      }
      setState(() {
        _accountVerified = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión')));
    } finally {
      setState(() {
        isLoadingPrincipal = false;
      });
    }
  }

  Future<void> _loadMailboxInitialConfig() async {
    try {
      setState(() {
        isLoadingPrincipal = true;
        _mailboxInitialConfig = null;
      });
      final initialConfig = await _mailboxService.getMailboxInitializer(
        mailboxIdController.text,
        mailboxKeyController.text,
      );
      if (initialConfig == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buzón no encontrado. Verifique el ID y la clave.'),
          ),
        );
        return;
      }
      setState(() {
        _mailboxInitialConfig = initialConfig;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar informacion')));
    } finally {
      setState(() {
        isLoadingPrincipal = false;
      });
    }
  }

  Future<void> _sendFirebaseCredentials(String ssid, String password) async {
    setState(() {
      isLoadingPrincipal = true;
      _credentialsSended = false;
    });
    try {
      final url = Uri.parse('http://${_mailboxInitialConfig!.ip}/firebase');

      final response = await http.post(
        url,
        body: {'user': ssid, 'password': password},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciales enviadas correctamente.')),
        );
        setState(() {
          _credentialsSended = true;
        });
      } 
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar credenciales.')));
    } finally {
      setState(() {
        isLoadingPrincipal = false;
      });
    }
  }

  Future<void> _sendCredentials(String ssid, String password) async {
    bool connected = false;
    setState(() {
      isLoadingPrincipal = true;
      isMailboxConnected = false;
    });
    try {
      final url = Uri.parse(
        'http://${_mailboxInitialConfig!.ip}/wifi',
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
      await _verifyAccount();
      if (!_accountVerified) {
        return;
      }
    }
    if (_currentStep == 1) {
      await _loadMailboxInitialConfig();
      if (_mailboxInitialConfig == null) {
        return;
      }
    }
    if (_currentStep == 2) {
      await _initializeWiFi();
      if (!_isWiFiEnabled) {
        _showWiFiDisabledDialog();
        return;
      }
      await connectToArduinoAP(mailboxIdController.text, ssidPasswordController.text);
      if (!_isConnectedToAP) {
        _showConnectionErrorDialog();
        return;
      }
      await _sendFirebaseCredentials(_emailController.text, _passwordController.text);
      if (!_credentialsSended) {
        return;
      }
    }
    if (_currentStep == 3) {
      await _sendCredentials(selectedSSID, ssidPasswordController.text);
      if (!isMailboxConnected) {
        return;
      }
      await _mailboxService.createMailbox(
        mailboxIdController.text,
        _userProvider.user!.uid,
        3600,
      );
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
                (isMailboxIdValid || _currentStep > 0) && _currentStep != 3
                    ? _nextStep
                    : null,
            onStepCancel:
                _currentStep > 0
                    ? () => setState(() {
                      _currentStep -= 1;
                    })
                    : null,
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              final isLastStep = _currentStep == 4;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isLastStep)
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Continuar'),
                    ),
                  if (isLastStep)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Finalizar'),
                    ),
                  if (_currentStep > 0 && !isLastStep)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Cancelar'),
                    ),
                ],
              );
            },
            steps: [
              Step(
                title: Text('Verifique su cuenta'),
                content: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text('Datos del Buzón'),
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
                        controller: mailboxKeyController,
                        decoration: InputDecoration(
                          labelText: 'Clave del Buzón',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text('Conectar a buzón'),
                content: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Por favor, para conntinuar conéctese manualmente a la red Wi-Fi del buzón:",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            _mailboxInitialConfig?.id ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Contraseña:",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              _mailboxInitialConfig?.wifiPass ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: _mailboxInitialConfig!.wifiPass,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Contraseña copiada al portapapeles",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
                controller: ssidPasswordController,
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
