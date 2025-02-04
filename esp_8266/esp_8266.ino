#include "config.h"
#include "Constantes.h"
#include <ESP8266WiFi.h>
#include <FirebaseClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
#include "AuthorizedKey.h"
#include "Notification.h"
#include <WiFiUdp.h>
#include <NTPClient.h>
// Step 2
void asyncCB(AsyncResult &aResult);
void printResult(AsyncResult &aResult);

//FIREBASE CONFIGURATION
DefaultNetwork network;
//UserAuth user_auth(FIREBASE_WEB_KEY, FIREBASE_AUTH_MAIL, FIREBASE_PASS);
FirebaseApp app;
WiFiClientSecure ssl_client;
using AsyncClient = AsyncClientClass;
AsyncClient aClient(ssl_client, getNetwork(network));
RealtimeDatabase Database;
LegacyToken dbSecret(FIREBASE_DATABASE_SECRET);
// END FIREBASE CONFIGURATION

bool onetimeTest = false;

//TIME
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);

// variables teclado
const int MAX_KEYS_SIZE = 10;
AuthorizedKey authorizedKeys[MAX_KEYS_SIZE];
int NUMBER_OF_KEYS = 10;

void setup() {
  Serial.begin(9600);  // Comunicación con ATmega2560
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  // Espera conexión WiFi
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando a WiFi...");
  }
  Serial.println("Conexión WiFi exitosa");

  // SETUP FIREBASE
  ssl_client.setInsecure();
  ssl_client.setTimeout(1000);
  initializeApp(aClient, app, getAuth(dbSecret), asyncCB, "authTask");
  app.getApp<RealtimeDatabase>(Database);
  Database.url(FIREBASE_DATABASE_URL);
  // FIN SETUP FIREBASE
}
void clearAuthorizedKeys() {
  for (int i = 0; i < MAX_KEYS_SIZE; i++) {
    authorizedKeys[i] = AuthorizedKey();
  }
}
void initAuthorizedKeys(String firebaseData) {
  DynamicJsonDocument doc(1024);
  DeserializationError error = deserializeJson(doc, firebaseData);
  if (error) {
    Serial.print("Error al deserializar el JSON: ");
    Serial.println(error.c_str());
    return;
  }
  JsonObject data = doc.as<JsonObject>();
  NUMBER_OF_KEYS = data.size();
  int posicion = 0;
  for (JsonPair kv : data) {
    JsonObject keyData = kv.value().as<JsonObject>();

    AuthorizedKey k = AuthorizedKey(keyData);

    authorizedKeys[posicion] = k;
    posicion++;
  }
}

int checkAccess(String clave) {
  for (int i = 0; i < NUMBER_OF_KEYS; i++) {
    AuthorizedKey key = authorizedKeys[i];
    Serial.println("key:" + key.getValue());
    if (key.isPermanent() && key.getValue() == clave) {
      return i;
    } else if (!key.isPermanent() && key.getValue() == clave && key.checkDateInRange(timeClient.getEpochTime())) {
      return i;
    }
  }
  return -1;
}

void updateTimeOffset(int offset) {
  timeClient.setTimeOffset(offset);
  timeClient.update();
}

void loop() {
  // Lee un nodo en Firebase para verificar si debe abrir la puerta


  // Step 13
  app.loop();

  // Step 14
  Database.loop();

  // Step 15
  if (app.ready()) {

    if (!onetimeTest) {
      // Testing with Realtime Database set and get.

      //Database.set<int>(aClient, "/data", 0, asyncCB, "serialTask");
      // Envía comando a la ATmega2560
      Database.get(aClient, "mailbox/" + ARDUINO_ID + "/authorizedkeys", asyncCB, false, TASK_AUTH_KEYS);
      Database.get(aClient, "mailbox/" + ARDUINO_ID + "/instructions/offset", asyncCB, false, TASK_OFFSET);

      onetimeTest = true;
    }

    if (Serial.available()) {
      //int dataFromESP = Serial.readStringUntil('\n').toInt();
      //Serial.println(dataFromESP);
      //delay(1000);
      //Database.set<int>(aClient, "/data", dataFromESP, asyncCB, "serialTask");
      //delay(1000);
    }
    //Serial.println("abrir"); // Envía comando a la ATmega2560
  }

  delay(1000);  // Intervalo para verificar Firebase
}

void asyncCB(AsyncResult &aResult) {
  printResult(aResult);
}

void printResult(AsyncResult &aResult) {
  if (aResult.isEvent())
    Firebase.printf("Event task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.appEvent().message().c_str(), aResult.appEvent().code());

  if (aResult.isDebug())
    Firebase.printf("Debug task: %s, msg: %s\n", aResult.uid().c_str(), aResult.debug().c_str());

  if (aResult.isError()) {
    if (TASK_AUTH_KEYS == aResult.uid().c_str() ) {
      Database.get(aClient, "mailbox/" + ARDUINO_ID + "/authorizedkeys", asyncCB, false, TASK_AUTH_KEYS);
    } else if (TASK_OFFSET == aResult.uid().c_str()) {
      Database.get(aClient, "mailbox/" + ARDUINO_ID + "/instructions/offset", asyncCB, false, TASK_OFFSET);
    }
    Firebase.printf("Error task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.error().message().c_str(), aResult.error().code());
  }

  if (aResult.available()) {
     if (TASK_AUTH_KEYS == aResult.uid().c_str()) {
      String firebaseData = String(aResult.c_str());
      Serial.println("KEYBOARD_" + firebaseData);

      initAuthorizedKeys(firebaseData);
    } else if (TASK_OFFSET == aResult.uid().c_str()) {
      String offset = String(aResult.c_str());
      Serial.println("offset_" + offset);
      timeClient.begin();
      updateTimeOffset(offset.toInt());
    }


    Firebase.printf("task: %s, payload: %s\n", aResult.uid().c_str(), aResult.c_str());
  }
}
