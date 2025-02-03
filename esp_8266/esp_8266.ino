#include "config.h"
#include <ESP8266WiFi.h>
#include <FirebaseClient.h>
#include <WiFiClientSecure.h>


// Step 2
void asyncCB(AsyncResult &aResult);
void printResult(AsyncResult &aResult);

// Step 3
DefaultNetwork network;

// Step 4
UserAuth user_auth(FIREBASE_WEB_KEY, FIREBASE_AUTH_MAIL, FIREBASE_PASS);

// Step 5
FirebaseApp app;

// Step 6
WiFiClientSecure ssl_client;

// Step 7
using AsyncClient = AsyncClientClass;
AsyncClient aClient(ssl_client, getNetwork(network));

// Step 8
RealtimeDatabase Database;

bool onetimeTest = false;

void setup() {
  Serial.begin(9600); // Comunicación con ATmega2560
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  
  // Espera conexión WiFi
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando a WiFi...");
  }
  Serial.println("Conexión WiFi exitosa");
  
   // Skip certificate verification
    ssl_client.setInsecure();

    // Set timeout
    ssl_client.setTimeout(1000);

    // Step 10
    initializeApp(aClient, app, getAuth(user_auth), asyncCB, "authTask");

    // Step 11
    app.getApp<RealtimeDatabase>(Database);

    // Step 12
    Database.url(FIREBASE_DATABASE_URL);

}

void loop() {
  // Lee un nodo en Firebase para verificar si debe abrir la puerta

    
     // Step 13
    app.loop();

    // Step 14
    Database.loop();

    // Step 15
    if (app.ready())
    {

      if(!onetimeTest){
          // Testing with Realtime Database set and get.
          
          Database.set<int>(aClient, "/data", 0, asyncCB, "serialTask");
          // Envía comando a la ATmega2560
          Database.get(aClient, "/data", asyncCB, false, "getTask");

          onetimeTest = true;

      }

      if (Serial.available()) {
        int dataFromESP = Serial.readStringUntil('\n').toInt();
        Serial.println(dataFromESP);
        delay(1000);
        Database.set<int>(aClient, "/data", dataFromESP, asyncCB, "serialTask");
        delay(1000);
       

        }
        //Serial.println("abrir"); // Envía comando a la ATmega2560

    }
  
  delay(1000); // Intervalo para verificar Firebase
}

void asyncCB(AsyncResult &aResult) { printResult(aResult); }

void printResult(AsyncResult &aResult)
{
    if (aResult.isEvent())
        Firebase.printf("Event task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.appEvent().message().c_str(), aResult.appEvent().code());

    if (aResult.isDebug())
        Firebase.printf("Debug task: %s, msg: %s\n", aResult.uid().c_str(), aResult.debug().c_str());

    if (aResult.isError())
        Firebase.printf("Error task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.error().message().c_str(), aResult.error().code());

    if (aResult.available()){
      if(strcmp("serialTask", aResult.uid().c_str()) == 0){
         String dataForESP = String(aResult.c_str());  // Convertir el c_str a String
        dataForESP.replace("\"", "");  // Eliminar las comillas
        Serial.println("TO_"+ dataForESP); 
      }

      
      Firebase.printf("task: %s, payload: %s\n", aResult.uid().c_str(), aResult.c_str());
    }
        
      
}

