#include "AuthorizedKey.h"
#include <vector>

// Variables de teclado
std::vector<AuthorizedKey> authorizedKeys; 

void initAuthorizedKeys(JsonObject data) {
  clearAuthorizedKeys(); 
  for (JsonPair kv : data) {
    JsonObject keyData = kv.value().as<JsonObject>();

    AuthorizedKey k = AuthorizedKey(keyData);
    Serial.println(k.getValue());
    authorizedKeys.push_back(k); 
  }
}

void clearAuthorizedKeys() {
  authorizedKeys.clear();
}

int checkAccess(String clave) {
  for (int i = 0; i < authorizedKeys.size(); i++) {
    AuthorizedKey& key = authorizedKeys[i];

    if (key.isPermanent() && key.getValue().equals(clave)) {
      Serial.println("key valida:" + key.getValue());
      return i;
    } else if (!key.isPermanent() && key.getValue() == clave && key.checkDateInRange(timeClient.getEpochTime())) {
      Serial.println("key invalida:" + key.getValue());
      return i;
    }
  }
  return -1;
}

void updateKey(String id, JsonObject data) {
  for (int i = 0; i < authorizedKeys.size(); i++) {
    AuthorizedKey& key = authorizedKeys[i];
    if (key.getId() == id) {
      if (data.containsKey("value")) {
        key.setValue(data["value"].as<String>());
      }
      if (data.containsKey("finishDate")) {
        key.setFinishDate(data["finishDate"].as<unsigned long>());
      }
      if (data.containsKey("initDate")) {
        key.setInitDate(data["initDate"].as<unsigned long>());
      }
      if (data.containsKey("permanent")) {
        key.setPermanent(data["permanent"].as<bool>());
      }
      if (data.containsKey("name")) {
        key.setName(data["name"].as<String>());
      }
      return;
    }
  }
}