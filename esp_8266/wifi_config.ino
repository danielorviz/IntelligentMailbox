


IPAddress local_IP(192, 168, 4, 1);  // IP que tendrá el Arduino
IPAddress gateway(192, 168, 4, 1);   // Gateway
IPAddress subnet(255, 255, 255, 0);


const char* apssid = "ardboxmail-7854";
const char* apPassword = "123456789";

void setupWiFiModule() {

  Serial.println("SETUP WIFI");
  //WiFi.disconnect(true);

  if (WiFi.SSID().length() > 0) {

    Serial.println("FIRE_READ");
    while (fireuser == "" || firepass == "") {
      delay(100);
      readSerial();
      delay(1000);
    }
    if (fireuser != "break;" && firepass != "break;") {
      WiFi.mode(WIFI_STA);
      WiFi.begin();
      Serial.println(WiFi.SSID());

      bool conected = connectToWiFi();
      if (conected) {
        return;
      }
    }
  }
  WiFi.mode(WIFI_AP);
  WiFi.begin();
  // Si no están guardadas, iniciar el servidor web para recibir credenciales
  Serial.println("Esperando credenciales...");
  // Configurar el dispositivo como Access Point con IP estática
  if (!WiFi.softAPConfig(local_IP, gateway, subnet)) {
    Serial.println("Configuración de IP estática fallida");
  } else {
    Serial.println("Configuración de IP estática exitosa");
  }

  // Configurar el SSID y contraseña del Access Point
  WiFi.softAP(apssid, apPassword);

  // Mostrar la IP asignada al Access Point
  Serial.print("IP del AP: ");
  Serial.println(WiFi.softAPIP());

  // Configurar el servidor web para recibir las credenciales
  server.on("/wifi", HTTP_POST, handleConfigure);
  server.on("/firebase", HTTP_POST, handleFirebase);

  // Iniciar el servidor
  server.begin();
  while (WiFi.status() != WL_CONNECTED) {
    server.handleClient();
    delay(10);
  }
  Serial.println("Servidor web iniciado.");
}
bool connectToWiFi() {
  int intentos = 10;
  // Espera conexión WiFi
  while (WiFi.status() != WL_CONNECTED && intentos > 0) {
    delay(2000);
    intentos--;
    Serial.println("Conectando a WiFi...");
  }
  if (intentos <= 0) {
    return false;
  }
  Serial.println("Conexión WiFi exitosa");
  return true;
}

void handleConfigure() {
  Serial.println("comprobando");
  if (server.hasArg("ssid") && server.hasArg("password")) {
    String ssid = server.arg("ssid");
    String password = server.arg("password");

    Serial.println("Credenciales recibidas:");
    Serial.println("SSID: " + ssid);
    Serial.println("Contraseña WiFi: " + password);
    WiFi.begin(ssid, password);
    if (connectToWiFi()) {

      // Responder al cliente con un mensaje de éxito
      server.send(200, "text/plain", "Credenciales recibidas. Intentando conectar...");
      delay(4000);

      server.stop();
      WiFi.mode(WIFI_STA);
      WiFi.begin();
    } else {
      server.send(403, "text/plain", "Faltan parámetros: ssid, password, email, accountPassword.");
    }

  } else {
    server.send(400, "text/plain", "Faltan parámetros: ssid, password, email, accountPassword.");
  }
}

void handleFirebase() {
  Serial.println("comprobando");
  if (server.hasArg("user") && server.hasArg("password")) {
    //boolean result = EEPROM.wipe();
    //boolean ok = EEPROM.commitReset();


    fireuser = server.arg("user");
    firepass = server.arg("password");

    Serial.println("FIRE_WRITE_U_"+fireuser);
    delay(1000);
    Serial.println("FIRE_WRITE_P_"+firepass);
    delay(500);
    Serial.println("Credenciales recibidas:");
    Serial.println("user: " + fireuser);
    Serial.println("Contraseña firebase: " + firepass);


    server.send(200, "text/plain", "Credenciales recibidas. Intentando conectar...");

  } else {
    server.send(400, "text/plain", "Faltan parámetros: ssid, password, email, accountPassword.");
  }
}
