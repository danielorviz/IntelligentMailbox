#include "config.h"
#include "Constantes.h"
#include <FirebaseClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
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
WiFiClientSecure ssl_clientGeneral, ssl_clientKeys;
using AsyncClient = AsyncClientClass;
AsyncClient aClientGeneral(ssl_clientGeneral, getNetwork(network)), aClientStreamKeys(ssl_clientKeys, getNetwork(network));

RealtimeDatabase Database;
LegacyToken dbSecret(FIREBASE_DATABASE_SECRET);

// END FIREBASE CONFIGURATION

const int BUFFER_SIZE = 128;     // Tamaño del buffer
char serialBuffer[BUFFER_SIZE];  // Buffer para almacenar datos
int bufferIndex = 0;


bool onetimeTest = false;
bool resetOpen = false;

//TIME
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);



int contador = 0;

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
  ssl_clientGeneral.setInsecure();
  ssl_clientGeneral.setBufferSizes(1024, 512);
  ssl_clientGeneral.setTimeout(150);

  ssl_clientKeys.setInsecure();
  ssl_clientKeys.setBufferSizes(4096, 1024);
  ssl_clientKeys.setTimeout(150);


  initializeApp(aClientGeneral, app, getAuth(dbSecret), asyncCB, "authTask");
  app.getApp<RealtimeDatabase>(Database);
  Database.url(FIREBASE_DATABASE_URL);
  // FIN SETUP FIREBASE

  timeClient.begin();
}


DynamicJsonDocument deserializeFirebaseData(String firebaseData) {
  DynamicJsonDocument doc(1024);
  DeserializationError error = deserializeJson(doc, firebaseData);
  if (error) {
    Serial.print("Error al deserializar el JSON: ");
    Serial.println(error.c_str());
    return DynamicJsonDocument(0);
  }
  return doc;
}

void updateTimeOffset(int offset) {
  timeClient.setTimeOffset(offset);
  timeClient.update();
}

void loop() {
  app.loop();
  Database.loop();
  if (app.ready()) {

    if (!onetimeTest) {
      Database.get(aClientStreamKeys, "mailbox/" + ARDUINO_ID, asyncCB, true, TASK_AUTH_KEYS);
      onetimeTest = true;
    }
    if (Serial.available()) {
      String instructions = Serial.readStringUntil('\n');

      if (instructions.startsWith("DOOR_")) {
        String key = instructions.substring(5);
        key.trim();
        if (checkAccess(key) >= 0) {
          Serial.println("DOOR_OK");
        } else {
          Serial.println("DOOR_KO");
        }
      }
    }
    if (resetOpen) {
      Serial.print("resetResult: ");
      bool result = Database.set<bool>(aClientGeneral, "mailbox/" + ARDUINO_ID + "/instructions/open", false);
      Serial.println(result);
      resetOpen = !result;
    }
  }
  delay(1000);  // Intervalo para verificar Firebase
}

void asyncCB(AsyncResult &aResult) {
  printResult(aResult);
}

void printResult(AsyncResult &aResult) {
  if (aResult.isEvent()) {
    Firebase.printf("Event task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.appEvent().message().c_str(), aResult.appEvent().code());
    Serial.println();
  }

  if (aResult.isDebug()) {
    Firebase.printf("Debug task: %s, msg: %s\n", aResult.uid().c_str(), aResult.debug().c_str());
    Serial.println();
  }

  if (aResult.isError()) {
    if (TASK_AUTH_KEYS == aResult.uid().c_str()) {
      //Database.get(aClient, "mailbox/" + ARDUINO_ID + "/authorizedkeys", asyncCB, false, TASK_AUTH_KEYS);
    } else if (TASK_OFFSET == aResult.uid().c_str()) {
      //Database.get(aClient, "mailbox/" + ARDUINO_ID + "/instructions/offset", asyncCB, true, TASK_OFFSET);
    }
    Firebase.printf("Error task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.error().message().c_str(), aResult.error().code());
    Serial.println();
  }

  if (aResult.available()) {
    RealtimeDatabaseResult &RTDB = aResult.to<RealtimeDatabaseResult>();
    Firebase.printf("task: %s, payload5: %s\n", aResult.uid().c_str(), aResult.c_str());
    Serial.println();

    if (RTDB.isStream()) {
      String eventType = RTDB.event();  // "put", "patch", o "keep-alive"
      Serial.println(eventType);
      if (eventType != "put" && eventType != "patch") {
        // Ignora eventos de keep-alive
        return;
      }
      if (TASK_AUTH_KEYS == aResult.uid().c_str()) {
        DynamicJsonDocument doc = deserializeFirebaseData(RTDB.to<const char *>());
        String path = RTDB.dataPath().c_str();

        if (path == "/") {
          initAuthorizedKeys(doc["authorizedkeys"]);

          initAuthorizedPackages(doc["authorizedPackages"]);

          JsonObject instructions = doc["instructions"];
          onInstructionOpen(instructions["open"].as<bool>());

          onInstructionOffset(instructions["offset"].as<int>());

        } else if (path == "/instructions/open") {
          onInstructionOpen(RTDB.to<bool>());
        } else if (path == "/instructions/offset") {
          onInstructionOffset(RTDB.to<int>());
        } else if (path.startsWith("/authorizedkeys/")) {
          JsonObject root = doc.as<JsonObject>();
          updateKey(path.substring(strlen("/authorizedkeys/")), root);
        }

      } else if (TASK_OFFSET == aResult.uid().c_str()) {
      }
    }
  }
}

void onInstructionOffset(int offset) {
  Serial.print("offset_");
  Serial.println(offset);
  updateTimeOffset(offset);
}

void onInstructionOpen(bool open) {
  if (open) {
    Serial.println("DOOR_OK");
    resetOpen = true;
  }
}
