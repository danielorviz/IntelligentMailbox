import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/l10n/app_localizations.dart';
import 'package:intelligent_mailbox_app/models/mailbox_initial_config.dart';
import 'package:intelligent_mailbox_app/providers/mailbox_provider.dart';
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
  final _formStep1 = GlobalKey<FormState>();
  bool _isWiFiEnabled = false;
  bool isMailboxIdValid = false;
  bool isMailboxConnected = false;
  final TextEditingController mailboxIdController = TextEditingController();
  final TextEditingController mailboxKeyController = TextEditingController();
  final TextEditingController mailboxNameController = TextEditingController();
  String _selectedLanguage = PlatformDispatcher.instance.locale.languageCode;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        _emailController.text = _userProvider.user!.email!;
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
          title: Text(AppLocalizations.of(context)!.wifiDisabled),
          content: Text(AppLocalizations.of(context)!.wifiDisabledMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.confirm),
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
          title: Text(AppLocalizations.of(context)!.connectionError),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.arduinoAPConnectionError,
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
              child: Text(AppLocalizations.of(context)!.confirm),
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
        _showMessage(_getAppLocalizations()?.incorrectCredentials ?? '');
        return;
      }
      setState(() {
        _accountVerified = true;
      });
    } catch (e) {
      _showMessage(_getAppLocalizations()?.accountVerificationError ?? '');
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
      if (!_formStep1.currentState!.validate()) {
        return;
      }
      final initialConfig = await _mailboxService.getMailboxInitializer(
        mailboxIdController.text,
        mailboxKeyController.text,
      );
      if (initialConfig == null) {
        _showMessage(_getAppLocalizations()?.mailboxNotFound ?? '');
        return;
      }
      setState(() {
        _mailboxInitialConfig = initialConfig;
      });
    } catch (e) {
      _showMessage(_getAppLocalizations()?.informationVerificationError ?? '');
    } finally {
      setState(() {
        isLoadingPrincipal = false;
      });
    }
  }

  Future<void> _sendFirebaseCredentials(String user, String password) async {
    setState(() {
      isLoadingPrincipal = true;
      _credentialsSended = false;
    });
    try {
      final url = Uri.parse('http://${_mailboxInitialConfig!.ip}/firebase');

      final response = await http.post(
        url,
        body: {'user': user, 'password': password},
      );

      if (response.statusCode == 200) {
        setState(() {
          _credentialsSended = true;
        });
      } else if (response.statusCode == 400) {
        _showMessage(_getAppLocalizations()?.mailboxConnectionError ?? '');
      }
    } catch (e) {
      _showMessage(_getAppLocalizations()?.mailboxConnectionError ?? '');
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
      final url = Uri.parse('http://${_mailboxInitialConfig!.ip}/wifi');

      final response = await http.post(
        url,
        body: {'ssid': ssid, 'password': password},
      );

      if (response.statusCode == 200) {
        _showMessage(_getAppLocalizations()?.mailboxConnectedWiFi ?? '');
        connected = true;
      } else if (response.statusCode == 403) {
        _showMessage(_getAppLocalizations()?.wifiCredentialsError ?? '');
      } else {
        _showMessage(_getAppLocalizations()?.mailboxConnectionError ?? '');
      }
    } catch (e) {
      _showMessage(_getAppLocalizations()?.mailboxConnectionError ?? '');
    } finally {
      setState(() {
        isLoadingPrincipal = false;
        isMailboxConnected = connected;
      });
    }
  }

  Future<void> _registerMailbox() async {
    setState(() {
      isLoadingPrincipal = true;
    });
    try {
      await _mailboxService.createMailbox(
        mailboxIdController.text,
        _userProvider.user!.uid,
        mailboxNameController.text,
        _selectedLanguage,
      );
      Provider.of<MailboxProvider>(context, listen: false).loadMailboxes();
    } catch (e) {
      print('Error registering mailbox: $e');
      _showMessage(_getAppLocalizations()?.mailboxRegistrationError ?? '');
    } finally {
      setState(() {
        isLoadingPrincipal = false;
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
    } else if (_currentStep == 1) {
      await _loadMailboxInitialConfig();
      _startScan();
      if (_mailboxInitialConfig == null) {
        return;
      }
    } else if (_currentStep == 2) {
      await _initializeWiFi();
      if (!_isWiFiEnabled) {
        _showWiFiDisabledDialog();
        return;
      }
      await connectToArduinoAP(
        mailboxIdController.text,
        ssidPasswordController.text,
      );
      if (!_isConnectedToAP) {
        _showConnectionErrorDialog();
        return;
      }
      await _sendFirebaseCredentials(
        _emailController.text,
        _passwordController.text,
      );
      if (!_credentialsSended) {
        return;
      }
    } else if (_currentStep == 3) {
      await _sendCredentials(selectedSSID, ssidPasswordController.text);
      if (!isMailboxConnected) {
        return;
      }
      setState(() {
        _currentStep += 1;
      });
      await _registerMailbox();
    } else if (_currentStep == 5) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _currentStep += 1;
    });
  }

  String _getTextNextButton() {
    if (_currentStep == 0 || _currentStep == 1) {
      return AppLocalizations.of(context)!.verify;
    } else if (_currentStep == 2) {
      return AppLocalizations.of(context)!.connect;
    } else if (_currentStep == 3) {
      return AppLocalizations.of(context)!.send;
    }else if (_currentStep == 4) {
      return AppLocalizations.of(context)!.send;
    } else {
      return AppLocalizations.of(context)!.finish;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.connectNewMailbox),
      ),
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(_getTextNextButton()),
                    ),
                  ),
                  if (_currentStep == 2) ...{
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextButton(
                        onPressed: details.onStepCancel,
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                    ),
                  },
                ],
              );
            },
            steps: [
              Step(
                title: Text(
                  AppLocalizations.of(context)!.verifyYourAccount,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
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
                          labelText: AppLocalizations.of(context)!.email,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password,
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
                title: Text(
                  AppLocalizations.of(context)!.mailboxDetails,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                content: Form(
                  key: _formStep1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.enterMailboxDetails,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: mailboxIdController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.mailboxId,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: mailboxKeyController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.mailboxKey,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: mailboxNameController,
                        maxLength: 10,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.chooseMailboxName,
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? AppLocalizations.of(
                                      context,
                                    )!.mailboxNameHint
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(
                                context,
                              )!.notificationLanguageLabel,
                          border: OutlineInputBorder(),
                        ),
                        items:
                            AppLocalizations.supportedLocales.map((language) {
                              return DropdownMenuItem<String>(
                                value: language.languageCode,
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.language(language.languageCode),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          ;
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text(
                  AppLocalizations.of(context)!.connectToMailbox,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pleaseConnectManually,
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
                      '${AppLocalizations.of(context)!.password}:',
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
                            _showMessage(
                              _getAppLocalizations()?.passwordCopied ?? '',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Step(
                title: Text(
                  AppLocalizations.of(context)!.connectMailboxToWiFi,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                content: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.selectWiFiNetwork,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
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
                      child: Text(AppLocalizations.of(context)!.scanNetworks),
                    ),
                  ],
                ),
              ),
              Step(
                title: Text(
                  AppLocalizations.of(context)!.registeringMailbox,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.registeringMailboxDetails,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Step(
                title: Text(
                  AppLocalizations.of(context)!.finishSetup,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.congratulationsSetupCompleted,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
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
          title: Text('${AppLocalizations.of(context)!.connectTo} $ssid'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ssidPasswordController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nextStep();
              },
              child: Text(AppLocalizations.of(context)!.connect),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  AppLocalizations? _getAppLocalizations() {
    if (context.mounted) {
      return AppLocalizations.of(context);
    }
    return null;
  }
}
